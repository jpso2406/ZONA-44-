import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AdminOrdersService, Order } from '../services/admin-orders.service';

// Alias para mantener compatibilidad con el template
type Pedido = Order & any;

@Component({
  selector: 'app-admin-pedidos',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-pedidos.html',
  styleUrls: ['./admin-pedidos.css']
})
export class AdminPedidosComponent implements OnInit {
  pedidos: Pedido[] = [];
  filteredPedidos: Pedido[] = [];
  loading = false;
  error: string | null = null;
  selectedPedido: Pedido | null = null;

  // Filtros
  statusFilter = '';
  deliveryFilter = '';
  dateFilter = '';

  // Dropdowns (acepta id number o string)
  openDropdowns = new Set<number | string>();

  get hasActiveFilters(): boolean {
    return !!(this.statusFilter || this.deliveryFilter || this.dateFilter);
  }

  constructor(private adminOrdersService: AdminOrdersService) {}

  ngOnInit() {
    this.loadPedidos();
  }

  // Normaliza valores de estado a 'pending' | 'processing' | 'paid'
  private normalizeStatus(value: any): string {
    if (value == null) return 'pending';
    const s = String(value).toLowerCase().trim();

    const pendingKeys = ['pending', 'pendiente', 'created', 'new', 'awaiting', 'waiting', 'pending_payment', 'to_pay'];
    const processingKeys = ['processing', 'in_progress', 'en_proceso', 'proceso', 'inprogress', 'in-progress'];
    const paidKeys = ['paid', 'completed', 'finalizado', 'finished', 'paid_success', 'paid_completed'];

    if (pendingKeys.includes(s)) return 'pending';
    if (processingKeys.includes(s)) return 'processing';
    if (paidKeys.includes(s)) return 'paid';
    return s;
  }

  loadPedidos() {
    this.loading = true;
    this.error = null;

    this.adminOrdersService.getOrders().subscribe({
      next: (resp: any) => {
        // aceptar varios formatos de respuesta: array directo, { orders: [...] }, { data: [...] }
        let orders: any[] = [];
        if (Array.isArray(resp)) {
          orders = resp;
        } else if (resp && Array.isArray(resp.orders)) {
          orders = resp.orders;
        } else if (resp && Array.isArray(resp.data)) {
          orders = resp.data;
        } else if (resp && Array.isArray(resp.result)) {
          orders = resp.result;
        } else {
          orders = [];
        }

        this.pedidos = (orders || []).map((o: any) => {
          const normalizedStatus = this.normalizeStatus(o.status ?? o.state ?? null);
          const customer = o.customer ?? o.customer_name ?? o.client_name ?? o.name ?? '';
          const address = o.customer_address ?? o.address ?? o.delivery_address ?? o.shipping_address ?? '';
          const delivery_type = o.delivery_type ?? o.type ?? o.order_type ?? '';
          const total = Number(o.total_amount ?? o.total ?? o.amount ?? o.price ?? 0) || 0;
          const created_at = (o.created_at ?? o.createdAt ?? o.date ?? o.created) || new Date().toISOString();
          const id = o.id ?? o.order_id ?? o.orderNumber ?? o.order_number;

          return {
            ...o,
            id,
            status: normalizedStatus,
            customer,
            address,
            delivery_type,
            total,
            amount: total,
            created_at
          } as Pedido;
        });

        this.applyFilters();
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading orders:', error);
        this.error = 'Error al cargar los pedidos';
        this.loading = false;
      }
    });
  }

  // método público para añadir un pedido nuevo (p.e. después de create)
  addNewPedido(raw: any) {
    const o = raw || {};
    const normalizedStatus = this.normalizeStatus(o.status ?? o.state ?? null);
    const customer = o.customer ?? o.customer_name ?? o.client_name ?? o.name ?? '';
    const address = o.customer_address ?? o.address ?? o.delivery_address ?? o.shipping_address ?? '';
    const delivery_type = o.delivery_type ?? o.type ?? o.order_type ?? '';
    const total = Number(o.total_amount ?? o.total ?? o.amount ?? o.price ?? 0) || 0;
    const created_at = (o.created_at ?? o.createdAt ?? o.date ?? o.created) || new Date().toISOString();
    const id = o.id ?? o.order_id ?? o.orderNumber ?? o.order_number;

    const pedido: Pedido = {
      ...o,
      id,
      status: normalizedStatus,
      customer,
      address,
      delivery_type,
      total,
      amount: total,
      created_at
    };

    this.pedidos.unshift(pedido);
    this.applyFilters();
  }

  applyFilters() {
    this.filteredPedidos = this.pedidos.filter(pedido => {
      let matches = true;

      if (this.statusFilter && pedido.status !== this.statusFilter) {
        matches = false;
      }

      if (this.deliveryFilter && (pedido.delivery_type ?? pedido.deliveryType) !== this.deliveryFilter) {
        matches = false;
      }

      if (this.dateFilter) {
        const pedidoDate = new Date(pedido.created_at).toDateString();
        const filterDate = new Date(this.dateFilter).toDateString();
        if (pedidoDate !== filterDate) {
          matches = false;
        }
      }

      return matches;
    });
  }

  clearFilters() {
    this.statusFilter = '';
    this.deliveryFilter = '';
    this.dateFilter = '';
    this.applyFilters();
  }

  viewPedido(pedido: Pedido) {
    this.selectedPedido = pedido;
  }

  closeModal() {
    this.selectedPedido = null;
  }

  markAsPaid(pedidoId: number | string) {
    if (!confirm('¿Marcar este pedido como finalizado?')) {
      return;
    }

    this.adminOrdersService.updateOrderStatus(Number(pedidoId), 'paid').subscribe({
      next: (response: any) => {
        const newStatusFromResp = this.normalizeStatus(response?.order?.status ?? response?.status ?? 'paid');
        if (response.success) {
          const pedido = this.pedidos.find(p => String(p.id) === String(pedidoId));
          if (pedido) {
            pedido.status = newStatusFromResp;
            this.applyFilters();
          }
        }
      },
      error: (error) => {
        console.error('Error updating order status:', error);
        alert('Error al actualizar el estado del pedido');
      }
    });
  }

  updateOrderStatus(pedidoId: number | string, newStatus: string) {
    const statusText = this.getStatusText(newStatus);
    if (!confirm(`¿Cambiar el estado a "${statusText}"?`)) {
      return;
    }

    this.closeAllDropdowns();

    this.adminOrdersService.updateOrderStatus(Number(pedidoId), newStatus).subscribe({
      next: (response: any) => {
        const normalized = this.normalizeStatus(response?.order?.status ?? newStatus);
        if (response.success) {
          const pedido = this.pedidos.find(p => String(p.id) === String(pedidoId));
          if (pedido) {
            pedido.status = normalized;
            this.applyFilters();
          }
          alert(`Estado actualizado a "${statusText}"`);
        }
      },
      error: (error) => {
        console.error('Error updating order status:', error);
        alert('Error al actualizar el estado del pedido');
      }
    });
  }

  getStatusText(status: string): string {
    const statusMap: { [key: string]: string } = {
      'pending': 'Pendiente',
      'processing': 'En Proceso',
      'paid': 'Finalizado'
    };
    return statusMap[status] || status;
  }

  getDeliveryTypeText(deliveryType: string): string {
    const typeMap: { [key: string]: string } = {
      'domicilio': 'Domicilio',
      'recoger': 'Recoger en tienda'
    };
    return typeMap[deliveryType] || deliveryType;
  }

  getStatusClass(status: string): string {
    const classMap: { [key: string]: string } = {
      'pending': 'status-pending',
      'processing': 'status-processing',
      'paid': 'status-paid'
    };
    return classMap[status] || 'status-default';
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-CO', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  formatPrice(amount: number): string {
    return new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP',
      minimumFractionDigits: 0
    }).format(amount);
  }

  getAvailableStatuses(currentStatus: string): string[] {
    const statusFlow: { [key: string]: string[] } = {
      'pending': ['processing'],
      'processing': ['paid'],
      'paid': []
    };
    return statusFlow[currentStatus] || [];
  }

  refreshOrders() {
    this.loadPedidos();
  }

  toggleDropdown(pedidoId: number | string) {
    if (this.openDropdowns.has(pedidoId)) {
      this.openDropdowns.delete(pedidoId);
    } else {
      this.openDropdowns.clear();
      this.openDropdowns.add(pedidoId);
    }
  }

  getStatusIcon(status: string): string {
    const iconMap: { [key: string]: string } = {
      'pending': 'fas fa-hourglass-start',
      'processing': 'fas fa-clock',
      'paid': 'fas fa-check-circle'
    };
    return iconMap[status] || 'fas fa-circle';
  }

  closeAllDropdowns() {
    this.openDropdowns.clear();
  }

  // Auxiliares para plantilla
  getCustomerName(p: Pedido): string {
    return (p.customer ?? p.customer_name ?? p.client_name ?? 'Cliente').toString();
  }

  getAddress(p: Pedido): string {
    return (p.address ?? p.delivery_address ?? p.shipping_address ?? '').toString();
  }

  getOrderTotalValue(p: Pedido): number {
    return Number(p.total ?? p.amount ?? 0) || 0;
  }
}
