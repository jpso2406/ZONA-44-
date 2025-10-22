import { Injectable } from '@angular/core';
import { Observable, map, catchError, of } from 'rxjs';
import { AdminPromocionesService, Promocion } from '../Pages/admin/services/admin-promociones.service';
import { PromocionPublica } from './promociones.service';

@Injectable({
  providedIn: 'root'
})
export class PromocionesPublicService {
  
  constructor(private adminService: AdminPromocionesService) {}

  /**
   * Obtiene las promociones del admin y las convierte al formato público
   */
  getPromocionesPublicas(): Observable<PromocionPublica[]> {
    return this.adminService.getPromociones().pipe(
      map(adminPromociones => this.transformToPublicPromociones(adminPromociones)),
      catchError(error => {
        console.error('Error obteniendo promociones del admin:', error);
        // Retornar promociones de ejemplo si falla la conexión con el admin
        return of(this.getDefaultPromociones());
      })
    );
  }

  /**
   * Transforma las promociones del admin al formato público
   */
  private transformToPublicPromociones(adminPromociones: Promocion[]): PromocionPublica[] {
    return adminPromociones.map(promo => ({
      id: promo.id,
      title: promo.nombre,
      description: promo.producto?.descripcion || 'Promoción especial',
      image: promo.imagen_url || 'assets/burger.png',
      oldPrice: promo.precio_original,
      newPrice: promo.precio_total,
      discount: promo.descuento,
      isNew: this.isNewPromocion(promo.created_at),
      validUntil: this.calculateValidUntil(),
      isActive: true
    }));
  }

  /**
   * Determina si una promoción es nueva (creada en los últimos 7 días)
   */
  private isNewPromocion(createdAt: string): boolean {
    const createdDate = new Date(createdAt);
    const now = new Date();
    const diffTime = Math.abs(now.getTime() - createdDate.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays <= 7;
  }

  /**
   * Calcula fecha de validez (por defecto 30 días desde hoy)
   */
  private calculateValidUntil(): Date {
    const date = new Date();
    date.setDate(date.getDate() + 30);
    return date;
  }

  /**
   * Promociones por defecto cuando no hay conexión con el admin
   */
  private getDefaultPromociones(): PromocionPublica[] {
    return [
      {
        id: 1,
        title: 'Combo Familiar',
        description: '4 hamburguesas + papas grandes + 4 bebidas',
        image: 'assets/burger.png',
        oldPrice: 45.99,
        newPrice: 35.99,
        discount: 20,
        isNew: true,
        validUntil: new Date('2025-12-31'),
        isActive: true
      },
      {
        id: 2,
        title: 'Pizza + Bebida',
        description: 'Pizza mediana + bebida de 500ml',
        image: 'assets/burger.png',
        oldPrice: 18.99,
        newPrice: 14.99,
        discount: 15,
        validUntil: new Date('2025-11-30'),
        isActive: true
      },
      {
        id: 3,
        title: 'Miércoles de Alitas',
        description: '12 alitas + papas + salsa extra',
        image: 'assets/burger.png',
        newPrice: 12.99,
        isNew: false,
        validUntil: new Date('2025-12-31'),
        isActive: true
      }
    ];
  }
}