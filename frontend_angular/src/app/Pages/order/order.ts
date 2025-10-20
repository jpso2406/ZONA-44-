import { environment } from '../../../environments/environment';
import { Component, Input, Output, EventEmitter, OnInit, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { OrdersService, CreateOrderRequest } from './orders.service';
import { CarritoItem } from '../../Components/shared/carrito/carrito';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { AuthService } from '../auth/auth.service';
import { FooterComponent } from "../../Components/shared/footer/footer";
import { GoogleMapsModule, MapMarker } from '@angular/google-maps';

@Component({
  selector: 'app-order',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent, FooterComponent, GoogleMapsModule],
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

  // Mapa
  center = { lat: 4.60971, lng: -74.08175 }; // Bogotá por defecto
  zoom = 13;
  markerPosition: google.maps.LatLngLiteral | null = null;
  @ViewChild(MapMarker) marker!: MapMarker;
  mapOptions: google.maps.MapOptions = {
    disableDoubleClickZoom: true,
    zoomControl: true,
  };

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
    /** Carga dinámica de la librería Google Maps JS si no está presente */
  private loadGoogleMapsApi(): Promise<void> {
    const win = window as any;
    if (win.google && win.google.maps) {
      return Promise.resolve();
    }

    const existing = document.getElementById('google-maps-script');
    if (existing) {
      return new Promise((resolve, reject) => {
        const check = () => {
          if ((window as any).google && (window as any).google.maps) resolve();
          else setTimeout(check, 100);
        };
        check();
      });
    }

    return new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.id = 'google-maps-script';
      script.type = 'text/javascript';
      script.async = true;
      script.defer = true;
      script.src = `https://maps.googleapis.com/maps/api/js?key=${environment.googleMapsApiKey}&libraries=places`;
      script.onload = () => {
        if ((window as any).google && (window as any).google.maps) resolve();
        else reject(new Error('google.maps no disponible tras carga'));
      };
      script.onerror = (err) => reject(err);
      document.head.appendChild(script);
    });
  }

  async ngOnInit(): Promise<void> {
    // Esperar a que la librería de Google Maps esté disponible
    try {
      await this.loadGoogleMapsApi();
    } catch (err) {
      console.error('Error al cargar Google Maps API', err);
      // Opcional: continuar igualmente o redirigir/mostrar mensaje
    }

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

    if (this.cartItems.length === 0) {
      this.router.navigate(['/menu']);
    }

    const currentUser = this.authService.getCurrentUser();
    if (currentUser) {
      this.customer.name = `${currentUser.first_name} ${currentUser.last_name}`.trim();
      this.customer.email = currentUser.email;
      this.customer.phone = currentUser.phone || '';
    }
  }

  /** Captura clic en el mapa y actualiza el marcador */
  onMapClick(event: google.maps.MapMouseEvent): void {
    if (event.latLng) {
      this.markerPosition = event.latLng.toJSON();
      // Llamada a la API de geocodificación inversa
      this.reverseGeocode(this.markerPosition.lat, this.markerPosition.lng);
    }
  }

  /** Convierte coordenadas en dirección */
  private reverseGeocode(lat: number, lng: number): void {
    const geocoder = new google.maps.Geocoder();
    geocoder.geocode({ location: { lat, lng } }, (results, status) => {
      if (status === 'OK' && results && results[0]) {
        this.deliveryAddress = results[0].formatted_address;
      } else {
        console.error('No se pudo obtener dirección:', status);
      }
    });
  }
  onMarkerDragEnd(event: Event | google.maps.MapMouseEvent): void {
    const mapEvent = event as google.maps.MapMouseEvent;
    if (mapEvent.latLng) {
      this.markerPosition = mapEvent.latLng.toJSON();
      // Actualizar dirección por geocodificación inversa
      this.reverseGeocode(this.markerPosition.lat, this.markerPosition.lng);
    }
  }

  /** Envío del formulario */
  onSubmit(): void {
    if (!this.validateForm()) return;

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
      user_id: this.authService.getCurrentUser()?.id,
      address: this.deliveryAddress // Dirección del mapa o manual
    };

    // Agregar location solo si existe (evita null/type mismatch)
    if (this.markerPosition) {
      (payload as any).location = {
        lat: this.markerPosition.lat,
        lng: this.markerPosition.lng
      };
    }

    console.log('Creating order with payload:', payload);

    this.ordersService.createOrder(payload).subscribe({
      next: (response) => {
        this.loading = false;
        this.success = true;
        this.orderCreated.emit(response);

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
