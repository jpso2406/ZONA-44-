import { Component, OnInit, OnDestroy, Inject } from '@angular/core';
import { GlobalCartService } from '../../../Services/global-cart.service';
import { CarritoItem } from '../carrito/carrito';
import { CommonModule } from '@angular/common';
import { TranslateModule } from '@ngx-translate/core';
import { Subscription } from 'rxjs';
import { PromocionesService, PromocionPublica } from '../../../Services/promociones.service';
import { PromocionesPublicService } from '../../../Services/promociones-public.service';

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
  private subscription = new Subscription();

  constructor(
    private promocionesService: PromocionesService,
    private promocionesPublicService: PromocionesPublicService,
    private cartService: GlobalCartService
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

    // Intentar cargar desde el admin primero, luego desde el servicio local
    const promoSub = this.promocionesPublicService.getPromocionesPublicas().subscribe({
      next: (promociones) => {
        this.promociones = promociones;
        this.loading = false;
        console.log('Promociones cargadas:', promociones);
      },
      error: (error) => {
        console.warn('Error loading promociones from admin, using local service:', error);
        
        // Fallback al servicio local
        const fallbackSub = this.promocionesService.getPromociones().subscribe({
          next: (promociones) => {
            this.promociones = promociones;
            this.loading = false;
            console.log('Promociones cargadas desde servicio local:', promociones);
          },
          error: (fallbackError) => {
            console.error('Error loading promociones from local service:', fallbackError);
            this.error = 'Error al cargar las promociones';
            this.loading = false;
          }
        });
        
        this.subscription.add(fallbackSub);
      }
    });

    this.subscription.add(promoSub);
  }

  selectPromo(promo: PromocionPublica) {
    const item: CarritoItem = {
      id: promo.id,
      name: promo.title,
      precio: promo.newPrice,
      cantidad: 1,
      foto_url: promo.image
    };
  this.cartService.addItem(item);
  // Promoción agregada al carrito sin mostrar alert
  }

  // TrackBy function para mejorar el rendimiento del *ngFor
  trackByPromoId(index: number, promo: PromocionPublica): number {
    return promo.id;
  }

  // Manejar errores de carga de imagen
  onImageError(event: any) {
    console.log('Error cargando imagen:', event.target.src);
    // Usar imagen por defecto
    event.target.src = 'assets/burger.png';
  }
}
