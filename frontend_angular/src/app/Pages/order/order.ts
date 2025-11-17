import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { OrdersService, CreateOrderRequest } from './orders.service';
import { CarritoItem } from '../../Components/shared/carrito/carrito';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../Components/shared/footer/footer";
import { AuthService } from '../auth/auth.service';
import * as L from 'leaflet';
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-order',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent, FooterComponent, TranslateModule],
  templateUrl: './order.html',
  styleUrl: './order.css'
})
export class OrderComponent implements OnInit {
  @Input() cartItems: CarritoItem[] = [];
  @Input() total: number = 0;
  @Output() orderCreated = new EventEmitter<any>();
  @Output() goBack = new EventEmitter<void>();

  customer = { name: '', email: '', phone: '' };
  deliveryType: 'domicilio' | 'recoger' = 'recoger';
  deliveryAddress = '';

  center: { lat: number, lng: number } = { lat: 4.60971, lng: -74.08175 }; // Bogotá
  markerPosition: { lat: number, lng: number } | null = null;

  showMapModal = false;
  leafletMap: L.Map | null = null;
  leafletMarker: L.Marker | null = null;
  modalCenter: { lat: number, lng: number } | null = null;
  modalMarkerPosition: { lat: number, lng: number } | null = null;

  loading = false;
  error = '';
  success = false;

  constructor(
    private ordersService: OrdersService,
    private router: Router,
    private route: ActivatedRoute,
    private authService: AuthService,
    private translate: TranslateService
  ) {}

  ngOnInit(): void {
    this.loadCartFromParams();
    this.prefillCustomerData();
  }

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

  private prefillCustomerData(): void {
    const user = this.authService.getCurrentUser();
    if (user) {
      this.customer.name = `${user.first_name} ${user.last_name}`.trim();
      this.customer.email = user.email;
      this.customer.phone = user.phone || '';
    }
  }

  async openMapModal(evt?: Event): Promise<void> {
    evt?.preventDefault();
    this.showMapModal = true;

    setTimeout(() => {
      if (this.leafletMap) {
        this.leafletMap.remove();
        this.leafletMap = null;
      }
      this.leafletMap = L.map('leafletMap').setView(
        this.modalCenter ?? { lat: 4.60971, lng: -74.08175 },
        13
      );

      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
      }).addTo(this.leafletMap);

      // Marker
      if (this.modalMarkerPosition) {
        this.leafletMarker = L.marker(this.modalMarkerPosition, { draggable: true }).addTo(this.leafletMap);
        this.leafletMarker.on('dragend', (e: any) => {
          const pos = e.target.getLatLng();
          this.modalMarkerPosition = { lat: pos.lat, lng: pos.lng };
          this.reverseGeocode(pos.lat, pos.lng);
        });
      }

      // Click on map
      this.leafletMap.on('click', (e: any) => {
        const pos = e.latlng;
        this.modalMarkerPosition = { lat: pos.lat, lng: pos.lng };
        if (this.leafletMarker && this.modalMarkerPosition) {
          this.leafletMarker.setLatLng(this.modalMarkerPosition);
        } else if (this.leafletMap && this.modalMarkerPosition) {
          this.leafletMarker = L.marker(this.modalMarkerPosition, { draggable: true }).addTo(this.leafletMap);
          this.leafletMarker.on('dragend', (ev: any) => {
            const p = ev.target.getLatLng();
            this.modalMarkerPosition = { lat: p.lat, lng: p.lng };
            this.reverseGeocode(p.lat, p.lng);
          });
        }
        this.reverseGeocode(pos.lat, pos.lng);
      });
    }, 150);
  }

  closeMapModal(): void {
    this.showMapModal = false;
    if (this.leafletMap) {
      this.leafletMap.remove();
      this.leafletMap = null;
    }
    this.leafletMarker = null;
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
        if (this.leafletMap) {
          this.leafletMap.setView([lat, lng], 15);
          if (this.leafletMarker && this.modalMarkerPosition) {
            this.leafletMarker.setLatLng(this.modalMarkerPosition);
          } else if (this.leafletMap && this.modalMarkerPosition) {
            this.leafletMarker = L.marker(this.modalMarkerPosition, { draggable: true }).addTo(this.leafletMap);
          }
        }
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
      this.deliveryAddress = this.deliveryAddress;
    }
    this.closeMapModal();
  }

  onlyNumbers(event: KeyboardEvent): boolean {
    const charCode = event.which ? event.which : event.keyCode;

    if (
      [8, 9, 27, 13, 46, 35, 36, 37, 38, 39, 40].includes(charCode) ||
      (charCode === 65 && event.ctrlKey) ||
      (charCode === 67 && event.ctrlKey) ||
      (charCode === 86 && event.ctrlKey) ||
      (charCode === 88 && event.ctrlKey)
    ) {
      return true;
    }

    if (charCode < 48 || charCode > 57) {
      event.preventDefault();
      return false;
    }

    return true;
  }

  private reverseGeocode(lat: number, lng: number): void {
    fetch(`https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}`)
      .then(res => res.json())
      .then(data => {
        this.deliveryAddress = data.display_name || '';
      })
      .catch(() => {
        this.deliveryAddress = '';
      });
  }

  onSubmit(): void {
    if (!this.validateForm()) return;

    this.loading = true;
    this.error = '';

    // Extraer ciudad de la dirección (puedes mejorar este parseo según tu formato)
    let city = '';
    if (this.deliveryAddress) {
      const parts = this.deliveryAddress.split(',');
      city = parts.length > 2 ? parts[2].trim() : '';
    }

    const payload: CreateOrderRequest = {
      customer: {
        name: this.customer.name,
        email: this.customer.email,
        phone: this.customer.phone,
        address: this.deliveryAddress,
        city: city
      },
      delivery_type: this.deliveryType,
      total_amount: this.total,
      cart: this.cartItems.map(i => ({
        producto_id: i.id,
        cantidad: i.cantidad,
        ...(i.promocion_id && { promocion_id: i.promocion_id })  // Solo incluir si existe
      })),
      user_id: this.authService.getCurrentUser()?.id,
      location: this.markerPosition || undefined
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
        this.error = err.error?.message || this.translate.instant('ORDER.ERRORS.CREATE');
        console.error('Error creating order:', err);
      }
    });
  }

  private validateForm(): boolean {
    if (!this.customer.name.trim()) return this.setError(this.translate.instant('ORDER.ERRORS.NAME_REQUIRED'));
    if (!this.customer.email.trim()) return this.setError(this.translate.instant('ORDER.ERRORS.EMAIL_REQUIRED'));
    if (!this.customer.phone.trim()) return this.setError(this.translate.instant('ORDER.ERRORS.PHONE_REQUIRED'));
    if (this.deliveryType === 'domicilio' && !this.deliveryAddress.trim())
      return this.setError(this.translate.instant('ORDER.ERRORS.ADDRESS_REQUIRED'));
    if (this.cartItems.length === 0) return this.setError(this.translate.instant('ORDER.ERRORS.CART_EMPTY'));
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