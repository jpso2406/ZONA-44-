import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { OrdersService, CreateOrderRequest } from './orders.service';
import { CarritoItem } from '../../Components/shared/carrito/carrito';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { AuthService } from '../auth/auth.service';
import { FooterComponent } from "../../Components/shared/footer/footer";

@Component({
  selector: 'app-order',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent, FooterComponent],
  templateUrl: './order.html',
  styleUrl: './order.css'
})
export class OrderComponent implements OnInit {
  @Input() cartItems: CarritoItem[] = [];
  @Input() total: number = 0;
  @Output() orderCreated = new EventEmitter<any>();
  @Output() goBack = new EventEmitter<void>();

  // Form data
  customer = {
    name: '',
    email: '',
    phone: ''
  };
  deliveryType: 'domicilio' | 'recoger' = 'recoger';
  deliveryAddress = '';
  
  // UI state
  loading = false;
  error = '';
  success = false;

  constructor(
    private ordersService: OrdersService,
    private router: Router,
    private route: ActivatedRoute,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    // Obtener datos del carrito desde query parameters
    this.route.queryParams.subscribe(params => {
      if (params['cart']) {
        try {
          this.cartItems = JSON.parse(params['cart']);
        } catch (e) {
          console.error('Error parsing cart data:', e);
          this.cartItems = [];
        }
      }
      if (params['total']) {
        this.total = parseFloat(params['total']);
      }
    });

    // Si no hay items en el carrito, redirigir al menú
    if (this.cartItems.length === 0) {
      this.router.navigate(['/menu']);
    }

    // Precargar datos del usuario si está autenticado
    const currentUser = this.authService.getCurrentUser();
    if (currentUser) {
      this.customer.name = `${currentUser.first_name} ${currentUser.last_name}`.trim();
      this.customer.email = currentUser.email;
      this.customer.phone = currentUser.phone || '';
    }
  }

  onSubmit(): void {
    if (!this.validateForm()) {
      return;
    }

    this.loading = true;
    this.error = '';

    const payload: CreateOrderRequest = {
      customer: this.customer,
      delivery_type: this.deliveryType,
      total_amount: this.total,
      cart: this.cartItems.map(item => ({
        producto_id: item.id,
        cantidad: item.cantidad
      })),
      user_id: this.authService.getCurrentUser()?.id // Agregar user_id si está autenticado
    };

    console.log('Creating order with payload:', payload);
    console.log('Current user:', this.authService.getCurrentUser());
    console.log('User ID being sent:', this.authService.getCurrentUser()?.id);

    // Si es domicilio, agregar dirección
    if (this.deliveryType === 'domicilio' && this.deliveryAddress) {
      
    }

    this.ordersService.createOrder(payload).subscribe({
      next: (response) => {
        this.loading = false;
        this.success = true;
        this.orderCreated.emit(response);
        
        // Redirigir al pago con el order_id
        this.router.navigate(['/pago'], {
          queryParams: {
            order_id: response.order_id,
            total: this.total
          }
        });
      },
      error: (error) => {
        this.loading = false;
        this.error = error.error?.message || 'Error al crear la orden';
        console.error('Error creating order:', error);
      }
    });
  }

  private validateForm(): boolean {
    if (!this.customer.name.trim()) {
      this.error = 'El nombre es requerido';
      return false;
    }
    if (!this.customer.email.trim()) {
      this.error = 'El email es requerido';
      return false;
    }
    if (!this.customer.phone.trim()) {
      this.error = 'El teléfono es requerido';
      return false;
    }
    if (this.deliveryType === 'domicilio' && !this.deliveryAddress.trim()) {
      this.error = 'La dirección de entrega es requerida';
      return false;
    }
    if (this.cartItems.length === 0) {
      this.error = 'El carrito está vacío';
      return false;
    }
    return true;
  }

  onGoBack(): void {
    this.router.navigate(['/menu']);
  }

  getTotalItems(): number {
    return this.cartItems.reduce((total, item) => total + item.cantidad, 0);
  }
}
