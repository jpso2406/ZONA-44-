import { Component, OnInit, OnDestroy } from '@angular/core'; 
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService, User } from '../auth/auth.service';
import { UserOrdersService, Order } from './user-orders.service';
import { Subscription } from 'rxjs';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../Components/shared/footer/footer";

@Component({
    selector: 'app-perfil',
    standalone: true,
    imports: [CommonModule, FormsModule, NavbarComponent, FooterComponent],
    templateUrl: './perfil.html',
    styleUrl: './perfil.css'
})
export class PerfilComponent implements OnInit, OnDestroy {
  currentUser: User | null = null;
  isEditing = false;
  loading = false;
  error = '';
  success = '';
  
  // Orders data
  orders: Order[] = [];
  filteredOrders: Order[] = [];
  ordersLoading = false;
  ordersError = '';
  selectedOrder: Order | null = null;
  showOrderDetails = false;
  showOrdersView = false;
  
  // Filtros
  searchTerm: string = '';
  selectedStatus: string = 'all';
  sortBy: string = 'date';

  // 🔹 añadido para paginación
  currentPage = 1;
  itemsPerPage = 6; // Ajustado a 6 para mostrar grid de 3x2
  get totalPages(): number {
    return Math.ceil(this.orders.length / this.itemsPerPage);
  }
  get paginatedOrders(): Order[] {
    const start = (this.currentPage - 1) * this.itemsPerPage;
    return this.orders.slice(start, start + this.itemsPerPage);
  }
  changePage(page: number): void {
    if (page >= 1 && page <= this.totalPages) {
      this.currentPage = page;
    }
  }
  // 🔹 fin añadido

  // Form data for editing
  editForm = {
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    department: ''
  };

  private authSubscription: Subscription = new Subscription();

  constructor(
    private authService: AuthService,
    private userOrdersService: UserOrdersService,
    private router: Router
  ) {}

  ngOnInit(): void {
    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/login']);
      return;
    }

    this.authSubscription.add(
      this.authService.currentUser$.subscribe(user => {
        this.currentUser = user;
        if (user) {
          this.populateEditForm(user);
        }
      })
    );

    if (!this.currentUser) {
      this.loadUserProfile();
    }

    this.loadUserOrders();
  }

  ngOnDestroy(): void {
    this.authSubscription.unsubscribe();
  }

  private loadUserProfile(): void {
    this.loading = true;
    this.authService.loadUserProfile().subscribe({
      next: (user) => {
        this.loading = false;
        if (!user) {
          this.router.navigate(['/login']);
        }
      },
      error: (error) => {
        this.loading = false;
        this.error = 'Error al cargar el perfil';
        console.error('Profile load error:', error);
        this.router.navigate(['/login']);
      }
    });
  }

  private populateEditForm(user: User): void {
    this.editForm = {
      first_name: user.first_name || '',
      last_name: user.last_name || '',
      email: user.email || '',
      phone: user.phone || '',
      address: user.address || '',
      city: user.city || '',
      department: user.department || ''
    };
  }

  toggleEdit(): void {
    this.isEditing = !this.isEditing;
    this.error = '';
    this.success = '';
    
    if (this.isEditing && this.currentUser) {
      this.populateEditForm(this.currentUser);
    }
  }

 saveProfile(): void { 
  if (!this.validateForm()) {
    return;
  }

  this.loading = true;
  this.error = '';
  this.success = '';

  const startTime = Date.now(); // Guardamos el tiempo de inicio

  this.authService.updateProfile(this.editForm).subscribe({
    next: (res) => {
      const elapsed = Date.now() - startTime; // Tiempo que tomó la respuesta
      const remaining = 5000 - elapsed; // Calculamos cuánto falta para los 5s
      setTimeout(() => { // Esperamos lo que falte para completar 5s
        this.loading = false;
        if (res.success) {
          this.success = res.message || 'Perfil actualizado exitosamente';
          this.isEditing = false;
        } else {
          this.error = (res as any).errors?.join(', ') || res.message || 'No se pudo actualizar el perfil';
        }
      }, remaining > 0 ? remaining : 0);
    },
    error: (err) => {
      const elapsed = Date.now() - startTime;
      const remaining = 5000 - elapsed;
      setTimeout(() => {
        this.loading = false;
        this.error = err?.message || 'Error de conexión al actualizar el perfil';
      }, remaining > 0 ? remaining : 0);
    }
  });
}

  cancelEdit(): void {
    this.isEditing = false;
    this.error = '';
    this.success = '';
    if (this.currentUser) {
      this.populateEditForm(this.currentUser);
    }
  }

  private validateForm(): boolean {
    if (!this.editForm.first_name.trim()) {
      this.error = 'El nombre es requerido';
      return false;
    }
    if (!this.editForm.last_name.trim()) {
      this.error = 'El apellido es requerido';
      return false;
    }
    if (!this.editForm.email.trim()) {
      this.error = 'El email es requerido';
      return false;
    }
    if (!this.isValidEmail(this.editForm.email)) {
      this.error = 'Ingresa un email válido';
      return false;
    }
    if (!this.editForm.phone.trim()) {
      this.error = 'El teléfono es requerido';
      return false;
    }
    if (!this.editForm.address.trim()) {
      this.error = 'La dirección es requerida';
      return false;
    }
    if (!this.editForm.city.trim()) {
      this.error = 'La ciudad es requerida';
      return false;
    }
    if (!this.editForm.department.trim()) {
      this.error = 'El departamento es requerido';
      return false;
    }
    return true;
  }

  private isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/']);
  }

  confirmDelete(): void {
    const confirmed = window.confirm(
      '¿Seguro que deseas eliminar tu cuenta? Esta acción es irreversible.'
    );
    
    if (!confirmed) return;

    this.loading = true;
    this.error = '';
    this.success = '';

    this.authService.deleteProfile().subscribe({
      next: (res) => {
        this.loading = false;
        if (res.success) {
          this.router.navigate(['/']);
        } else {
          this.error = res.message || 'No se pudo eliminar el perfil';
        }
      },
      error: (err) => {
        this.loading = false;
        this.error = err?.message || 'Error de conexión al eliminar el perfil';
      }
    });
  }

  goToHome(): void {
    this.router.navigate(['/']);
  }

  goToMenu(): void {
    this.router.navigate(['/menu']);
  }

  goToAdmin(): void {
    this.router.navigate(['/admin']);
  }

  // Orders methods
  private loadUserOrders(): void {
    this.ordersLoading = true;
    this.ordersError = '';

    this.userOrdersService.getUserOrders().subscribe({
      next: (orders) => {
        this.orders = orders;
        this.filteredOrders = [...orders]; // Inicializar órdenes filtradas
        this.ordersLoading = false;
      },
      error: (error) => {
        this.ordersError = 'Error al cargar el historial de órdenes';
        this.ordersLoading = false;
        console.error('Orders load error:', error);
      }
    });
  }

  viewOrderDetails(order: Order): void {
    this.selectedOrder = order;
    this.showOrderDetails = true;
  }

  closeOrderDetails(): void {
    this.showOrderDetails = false;
    this.selectedOrder = null;
  }

  getOrderStatusText(status: string): string {
    return this.userOrdersService.getOrderStatusText(status);
  }

  getOrderStatusClass(status: string): string {
    return this.userOrdersService.getOrderStatusClass(status);
  }

  getDeliveryTypeText(deliveryType: string): string {
    return this.userOrdersService.getDeliveryTypeText(deliveryType);
  }

  formatDate(dateString: string): string {
    return this.userOrdersService.formatDate(dateString);
  }

  toggleOrdersView(): void {
    this.showOrdersView = !this.showOrdersView;
    this.isEditing = false;
    this.error = '';
    this.success = '';
  }

  goToProfileView(): void {
    this.showOrdersView = false;
    this.isEditing = false;
    this.error = '';
    this.success = '';
  }

  // 🔹 NUEVAS FUNCIONES PARA VALIDAR INPUTS
  filterText(event: Event): void {
    const input = event.target as HTMLInputElement;
    input.value = input.value.replace(/[0-9]/g, '');
  }

  filterNumber(event: Event): void {
    const input = event.target as HTMLInputElement;
    input.value = input.value.replace(/\D/g, '').slice(0, 10);
  }

  // Métodos de filtrado
  filterOrders(): void {
    this.filteredOrders = this.orders.filter(order => {
      const matchesSearch = this.searchTerm ?
        (order.order_number.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
         this.formatDate(order.created_at).toLowerCase().includes(this.searchTerm.toLowerCase())) 
        : true;
      
      // Filtrar por estado
      const matchesStatus = this.selectedStatus === 'all' || 
        order.status === this.selectedStatus;
      return matchesSearch && matchesStatus;
    });

    // Ordenar
    this.filteredOrders.sort((a, b) => {
      if (this.sortBy === 'date') {
        return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
      } else if (this.sortBy === 'amount') {
        return b.total_amount - a.total_amount;
      }
      return 0;
    });

    this.currentPage = 1; // Reset a la primera página cuando se filtran los resultados
  }

  onSearchChange(): void {
    this.filterOrders();
  }

  onStatusChange(): void {
    this.filterOrders();
  }

  onSortChange(): void {
    this.filterOrders();
  }

  get filteredAndPaginatedOrders(): Order[] {
    const start = (this.currentPage - 1) * this.itemsPerPage;
    return this.filteredOrders.slice(start, start + this.itemsPerPage);
  }

  get totalFilteredPages(): number {
    return Math.ceil(this.filteredOrders.length / this.itemsPerPage);
  }
}
