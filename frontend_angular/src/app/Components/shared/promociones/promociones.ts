import { Component, OnInit, OnDestroy } from '@angular/core';
import { GlobalCartService } from '../../../Services/global-cart.service';
import { CarritoItem } from '../carrito/carrito';
import { CommonModule } from '@angular/common';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
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
    private cartService: GlobalCartService,
    private translate: TranslateService
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

    console.log('Cargando promociones públicas...');

    // Usar SOLO el servicio público que no requiere autenticación
    const promoSub = this.promocionesPublicService.getPromocionesPublicas().subscribe({
      next: (promociones) => {
        this.promociones = promociones;
        this.loading = false;
        console.log('Promociones públicas cargadas:', promociones);
      },
      error: (error) => {
        console.warn('Error loading promociones públicas:', error);
        
        // Fallback al servicio local SOLO si es necesario
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
            
            // Como último recurso, mostrar promociones por defecto
            this.promociones = this.getEmergencyPromociones();
          }
        });
        
        this.subscription.add(fallbackSub);
      }
    });

    this.subscription.add(promoSub);
  }

  selectPromo(promo: PromocionPublica) {
    const item: CarritoItem = {
      id: promo.producto_id || promo.id,  // Usar producto_id si existe, sino el id de la promo
      name: promo.title,
      precio: promo.newPrice,
      cantidad: 1,
      foto_url: promo.image,
      promocion_id: promo.id,  // Guardar el ID de la promoción
      is_promocion: true  // Marcar como promoción
    };
    
    this.cartService.addItem(item);
    console.log('Promoción agregada al carrito:', item);
  }

  // TrackBy function para mejorar el rendimiento del *ngFor
  trackByPromoId(index: number, promo: PromocionPublica): number {
    return promo.id;
  }

  // Manejar errores de carga de imagen
  onImageError(event: any) {
    console.log('Error cargando imagen:', event.target.src);
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
}