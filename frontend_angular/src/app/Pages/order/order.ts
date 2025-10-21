import { Component, Input, Output, EventEmitter, OnInit, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { environment } from '../../../environments/environment';
import { OrdersService, CreateOrderRequest } from './orders.service';
import { CarritoItem } from '../../Components/shared/carrito/carrito';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../Components/shared/footer/footer";
import { AuthService } from '../auth/auth.service';
import { GoogleMapsModule, MapMarker } from '@angular/google-maps';

@Component({
  selector: 'app-order',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent, FooterComponent, GoogleMapsModule],
  templateUrl: './order.html',
  styleUrl: './order.css'
})
export class OrderComponent implements OnInit {
  /* =======================
   * 📦 Inputs y Outputs
   * ======================= */
  @Input() cartItems: CarritoItem[] = [];
  @Input() total: number = 0;
  @Output() orderCreated = new EventEmitter<any>();
  @Output() goBack = new EventEmitter<void>();

  /* =======================
   * 👤 Datos del cliente
   * ======================= */
  customer = { name: '', email: '', phone: '' };
  deliveryType: 'domicilio' | 'recoger' = 'recoger';
  deliveryAddress = '';

  /* =======================
   * 🗺️ Mapa y ubicación
   * ======================= */
  center: google.maps.LatLngLiteral = { lat: 4.60971, lng: -74.08175 }; // Bogotá
  zoom = 13;
  markerPosition: google.maps.LatLngLiteral | null = null;
  @ViewChild(MapMarker) marker!: MapMarker;

  mapOptions: google.maps.MapOptions = {
    disableDoubleClickZoom: true,
    zoomControl: true,
  };

  // Modal temporal
  showMapModal = false;
  modalCenter: google.maps.LatLngLiteral | null = null;
  modalMarkerPosition: google.maps.LatLngLiteral | null = null;

  /* =======================
   * ⚙️ Estado de la UI
   * ======================= */
  loading = false;
  error = '';
  success = false;

  constructor(
    private ordersService: OrdersService,
    private router: Router,
    private route: ActivatedRoute,
    private authService: AuthService
  ) {}

  /* =======================
   * 🚀 Ciclo de vida
   * ======================= */
  async ngOnInit(): Promise<void> {
    await this.ensureGoogleMapsLoaded();
    this.loadCartFromParams();
    this.prefillCustomerData();
  }

  /* =======================
   * 🌐 Carga dinámica de Google Maps
   * ======================= */
  private loadGoogleMapsApi(): Promise<void> {
    const win = window as any;
    if (win.google?.maps) return Promise.resolve();

    const existing = document.getElementById('google-maps-script');
    if (existing) {
      return new Promise((resolve) => {
        const check = () => {
          if (win.google?.maps) resolve();
          else setTimeout(check, 100);
        };
        check();
      });
    }

    return new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.id = 'google-maps-script';
      script.src = `https://maps.googleapis.com/maps/api/js?key=${environment.googleMapsApiKey}&libraries=places`;
      script.async = true;
      script.defer = true;
      script.onload = () => win.google?.maps ? resolve() : reject('Google Maps no disponible');
      script.onerror = (err) => reject(err);
      document.head.appendChild(script);
    });
  }

  private async ensureGoogleMapsLoaded(): Promise<void> {
    try {
      await this.loadGoogleMapsApi();
    } catch (err) {
      console.error('Error al cargar Google Maps API', err);
    }
  }

 
  /** Convierte coordenadas en una dirección legible usando Geocoder */
  private reverseGeocode(lat: number, lng: number): void {
    const win = window as any;
    if (!win.google?.maps?.Geocoder) {
      console.warn('Google Maps Geocoder no disponible');
      return;
    }

    const geocoder = new win.google.maps.Geocoder();
    geocoder.geocode({ location: { lat, lng } }, (results: any, status: string) => {
      if (status === 'OK' && results && results[0]) {
        // Actualiza la dirección visible en el formulario
        this.deliveryAddress = results[0].formatted_address || this.deliveryAddress;
      } else {
        console.error('reverseGeocode error:', status, results);
      }
    });
  }


  /* =======================
   * 🛒 Cargar carrito
   * ======================= */
  private loadCartFromParams(): void {
    this.route.queryParams.subscribe(params => {
      if (params['cart']) {
        try {
          this.cartItems = JSON.parse(params['cart']);
        } catch {
          this.cartItems = [];
        }
      }
      if (params['total']) this.total = parseFloat(params['total']);
    });

    if (this.cartItems.length === 0) this.router.navigate(['/menu']);
  }

  /* =======================
   * 👤 Prefill de usuario logueado
   * ======================= */
  private prefillCustomerData(): void {
    const user = this.authService.getCurrentUser();
    if (user) {
      this.customer.name = `${user.first_name} ${user.last_name}`.trim();
      this.customer.email = user.email;
      this.customer.phone = user.phone || '';
    }
  }
  /* =======================
   * 🗺️ Interacción con mapa principal
   * ======================= */
// ...existing code...
  onModalMapClick(event: Event | google.maps.MapMouseEvent): void {
    const mapEvent = event as google.maps.MapMouseEvent;
    if (mapEvent && mapEvent.latLng) {
      this.modalMarkerPosition = mapEvent.latLng.toJSON();
    } else {
      // si viene un Event DOM, intentar obtener coords desde target (fallback)
      const ev = event as any;
      if (ev?.coords) {
        this.modalMarkerPosition = { lat: ev.coords.lat, lng: ev.coords.lng };
      }
    }
  }

  onModalMarkerDragEnd(event: Event | google.maps.MapMouseEvent): void {
    const mapEvent = event as google.maps.MapMouseEvent;
    if (mapEvent && mapEvent.latLng) {
      this.modalMarkerPosition = mapEvent.latLng.toJSON();
    }
  }

  onMapClick(event: Event | google.maps.MapMouseEvent): void {
    const mapEvent = event as google.maps.MapMouseEvent;
    if (mapEvent && mapEvent.latLng) {
      this.markerPosition = mapEvent.latLng.toJSON();
      this.reverseGeocode(this.markerPosition.lat, this.markerPosition.lng);
    }
  }

  onMarkerDragEnd(event: Event | google.maps.MapMouseEvent): void {
    const mapEvent = event as google.maps.MapMouseEvent;
    if (mapEvent && mapEvent.latLng) {
      this.markerPosition = mapEvent.latLng.toJSON();
      this.reverseGeocode(this.markerPosition.lat, this.markerPosition.lng);
    }
  }
// ...existing code...


  /* =======================
   * 📍 Modal de selección de ubicación
   * ======================= */
  async openMapModal(evt?: Event): Promise<void> {
    evt?.preventDefault();
    this.showMapModal = true;
    await this.ensureGoogleMapsLoaded();

    this.modalCenter = this.markerPosition ?? this.center;
    this.modalMarkerPosition = this.markerPosition ?? null;

    // Autocomplete en input de búsqueda
    setTimeout(() => {
      const input = document.getElementById('modalSearchBox') as HTMLInputElement | null;
      const win = window as any;
      if (input && win.google?.maps?.places) {
        const autocomplete = new win.google.maps.places.Autocomplete(input);
        autocomplete.setFields(['geometry', 'formatted_address']);
        autocomplete.addListener('place_changed', () => {
          const place = autocomplete.getPlace();
          if (place?.geometry?.location) {
            const loc = place.geometry.location;
            this.modalCenter = { lat: loc.lat(), lng: loc.lng() };
            this.modalMarkerPosition = { lat: loc.lat(), lng: loc.lng() };
          }
        });
      }
    }, 150);
  }

  closeMapModal(): void {
    this.showMapModal = false;
  }


  useCurrentLocation(): void {
    if (!navigator.geolocation) {
      console.error('Geolocation no soportada');
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (pos) => {
        const { latitude: lat, longitude: lng } = pos.coords;
        this.modalCenter = { lat, lng };
        this.modalMarkerPosition = { lat, lng };
        this.reverseGeocode(lat, lng);
      },
      (err) => console.error('Error al obtener ubicación:', err),
      { enableHighAccuracy: true, timeout: 10000 }
    );
  }

  confirmLocation(): void {
    if (this.modalMarkerPosition) {
      this.markerPosition = { ...this.modalMarkerPosition };
      this.center = { ...this.modalMarkerPosition };
      this.reverseGeocode(this.markerPosition.lat, this.markerPosition.lng);
    }
    this.closeMapModal();
  }

  /* =======================
   * 🧾 Envío de orden
   * ======================= */
  onSubmit(): void {
    if (!this.validateForm()) return;

    this.loading = true;
    this.error = '';

    const payload: CreateOrderRequest = {
      customer: this.customer,
      delivery_type: this.deliveryType,
      total_amount: this.total,
      cart: this.cartItems.map(i => ({ producto_id: i.id, cantidad: i.cantidad })),
      user_id: this.authService.getCurrentUser()?.id,
      address: this.deliveryAddress,
      ...(this.markerPosition && { location: this.markerPosition })
    };

    console.log('Creating order with payload:', payload);

    this.ordersService.createOrder(payload).subscribe({
      next: (res) => {
        this.loading = false;
        this.success = true;
        this.orderCreated.emit(res);
        this.router.navigate(['/pago'], {
          queryParams: { order_id: res.order_id, total: this.total }
        });
      },
      error: (err) => {
        this.loading = false;
        this.error = err.error?.message || 'Error al crear la orden';
        console.error('Error creating order:', err);
      }
    });
  }

  /* =======================
   * 🧩 Validaciones
   * ======================= */
  private validateForm(): boolean {
    if (!this.customer.name.trim()) return this.setError('El nombre es requerido');
    if (!this.customer.email.trim()) return this.setError('El email es requerido');
    if (!this.customer.phone.trim()) return this.setError('El teléfono es requerido');
    if (this.deliveryType === 'domicilio' && !this.deliveryAddress.trim())
      return this.setError('La dirección de entrega es requerida');
    if (this.cartItems.length === 0) return this.setError('El carrito está vacío');
    return true;
  }

  private setError(msg: string): boolean {
    this.error = msg;
    return false;
  }

  onGoBack(): void {
    this.router.navigate(['/menu']);
  }

  getTotalItems(): number {
    return this.cartItems.reduce((t, i) => t + i.cantidad, 0);
  }
}
