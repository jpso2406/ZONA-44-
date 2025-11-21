import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { GlobalCartService } from '../../../Services/global-cart.service';
import { CarritoItem } from '../carrito/carrito';
import { CommonModule } from '@angular/common';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { Subscription } from 'rxjs';
import { PromocionesService, PromocionPublica } from '../../../Services/promociones.service';
import { PromocionesPublicService } from '../../../Services/promociones-public.service';
import { AuthService } from '../../../Pages/auth/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-promociones',
  imports: [CommonModule, TranslateModule],
  templateUrl: './promociones.html',
  styleUrl: './promociones.css'
})
export class Promociones implements OnInit, OnDestroy {
  promociones: PromocionPublica[] = [];
  loading = false;
  error: string | null = null;
  showAuthModal = false; // Nueva propiedad
  private subscription = new Subscription();

  private authService = inject(AuthService);

  constructor(
    private promocionesService: PromocionesService,
    private promocionesPublicService: PromocionesPublicService,
    private cartService: GlobalCartService,
    private translate: TranslateService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loadPromociones();
  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
  }

  loadPromociones() {
    this.loading = true;
    this.error = null;

    const promoSub = this.promocionesPublicService.getPromocionesPublicas().subscribe({
      next: (promociones) => {
        this.promociones = promociones;
        this.loading = false;
      },
      error: (error) => {
        const fallbackSub = this.promocionesService.getPromociones().subscribe({
          next: (promociones) => {
            this.promociones = promociones;
            this.loading = false;
          },
          error: (fallbackError) => {
            this.error = 'Error al cargar las promociones';
            this.loading = false;
            this.promociones = this.getEmergencyPromociones();
          }
        });
        
        this.subscription.add(fallbackSub);
      }
    });

    this.subscription.add(promoSub);
  }

  // Modificar el método selectPromo
  selectPromo(promo: PromocionPublica): void {
    // Verificar si el usuario está autenticado
    if (!this.authService.isAuthenticated()) {
      this.showAuthModal = true;
      return;
    }

    // Si está autenticado, proceder a agregar al carrito
    this.agregarAlCarrito(promo);
  }

  // Nuevo método para cerrar el modal
  closeAuthModal(): void {
    this.showAuthModal = false;
  }

  // Modificar navigateToLogin para cerrar el modal
  navigateToLogin(): void {
    this.showAuthModal = false;
    this.router.navigate(['/login']);
  }

  // Modificar navigateToRegister para cerrar el modal
  navigateToRegister(): void {
    this.showAuthModal = false;
    this.router.navigate(['/register']);
  }

  // Método principal para agregar al carrito
  agregarAlCarrito(promo: PromocionPublica): void {
    // Verificar si el usuario está autenticado
    if (!this.authService.isAuthenticated()) {
      this.showAuthModal = true;
      return;
    }

    // Si está autenticado, proceder a agregar al carrito
    const item: CarritoItem = {
      id: promo.producto_id || promo.id,
      name: promo.title,
      precio: promo.newPrice,
      cantidad: 1,
      foto_url: promo.image,
      promocion_id: promo.id,
      is_promocion: true
    };
    
    this.cartService.addItem(item);
    
    // Efecto de pulso en el botón del carrito
    const cartButton = document.querySelector('.cart-fab') as HTMLElement;
    if (cartButton) {
      cartButton.classList.add('cart-pulse');
      setTimeout(() => {
        cartButton.classList.remove('cart-pulse');
      }, 600);
    }
  }

  // TrackBy function para mejorar el rendimiento del *ngFor
  trackByPromoId(index: number, promo: PromocionPublica): number {
    return promo.id;
  }

  // Manejar errores de carga de imagen
  onImageError(event: any) {
    event.target.src = 'assets/burger.png';
  }

  // Promociones de emergencia si todo falla
  private getEmergencyPromociones(): PromocionPublica[] {
    return [
      {
        id: 999,
        title: 'Promoción Especial',
        description: 'Oferta disponible en tienda',
        image: 'assets/burger.png',
        newPrice: 19.99,
        isNew: false,
        validUntil: new Date('2025-12-31'),
        isActive: true
      }
    ];
  }

  isUserAuthenticated(): boolean {
    return this.authService.isAuthenticated();
  }

  getCurrentUser() {
    return this.authService.getCurrentUser();
  }
}
