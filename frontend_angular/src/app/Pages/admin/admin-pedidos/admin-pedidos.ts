import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AdminOrdersService, Order, OrderItem } from '../services/admin-orders.service';

// Alias para mantener compatibilidad con el template
type Pedido = Order;

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

  // Dropdowns
  openDropdowns = new Set<number>();

  get hasActiveFilters(): boolean {
    return !!(this.statusFilter || this.deliveryFilter || this.dateFilter);
  }

  constructor(private adminOrdersService: AdminOrdersService) {}

  ngOnInit() {
    this.loadPedidos();
  }

  loadPedidos() {
    this.loading = true;
    this.error = null;
    
    this.adminOrdersService.getOrders().subscribe({
      next: (orders) => {
        this.pedidos = orders;
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

  applyFilters() {
    this.filteredPedidos = this.pedidos.filter(pedido => {
      let matches = true;

      if (this.statusFilter && pedido.status !== this.statusFilter) {
        matches = false;
      }

      if (this.deliveryFilter && pedido.delivery_type !== this.deliveryFilter) {
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

  markAsPaid(pedidoId: number) {
    if (!confirm('¿Marcar este pedido como pagado?')) {
      return;
    }

    this.adminOrdersService.updateOrderStatus(pedidoId, 'paid').subscribe({
      next: (response) => {
        if (response.success) {
          // Actualizar el estado local
          const pedido = this.pedidos.find(p => p.id === pedidoId);
          if (pedido) {
            pedido.status = 'paid';
            this.applyFilters();
          }
          alert('Pedido marcado como pagado');
        }
      },
      error: (error) => {
        console.error('Error updating order status:', error);
        alert('Error al actualizar el estado del pedido');
      }
    });
  }

  updateOrderStatus(pedidoId: number, newStatus: string) {
    const statusText = this.getStatusText(newStatus);
    if (!confirm(`¿Cambiar el estado a "${statusText}"?`)) {
      return;
    }

    this.closeAllDropdowns();

    this.adminOrdersService.updateOrderStatus(pedidoId, newStatus).subscribe({
      next: (response) => {
        if (response.success) {
          // Actualizar el estado local
          const pedido = this.pedidos.find(p => p.id === pedidoId);
          if (pedido) {
            pedido.status = newStatus;
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
      'processing': 'En Proceso',
      'paid': 'Pagado'
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
      'processing': ['paid'],
      'paid': [] // No se puede cambiar desde pagado
    };
    return statusFlow[currentStatus] || [];
  }

  refreshOrders() {
    this.loadPedidos();
  }

  toggleDropdown(pedidoId: number) {
    if (this.openDropdowns.has(pedidoId)) {
      this.openDropdowns.delete(pedidoId);
    } else {
      this.openDropdowns.clear();
      this.openDropdowns.add(pedidoId);
    }
  }

  getStatusIcon(status: string): string {
    const iconMap: { [key: string]: string } = {
      'processing': 'fas fa-clock',
      'paid': 'fas fa-check-circle'
    };
    return iconMap[status] || 'fas fa-circle';
  }

  closeAllDropdowns() {
    this.openDropdowns.clear();
  }
}