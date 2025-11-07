import { Injectable } from '@angular/core';
import { Observable, map, catchError, of } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { PromocionPublica } from './promociones.service';

export interface PromocionAdmin {
  id: number;
  nombre: string;
  precio_total: number;
  precio_original: number;
  descuento: number;
  producto_id: number;
  imagen_url?: string;
  created_at: string;
  updated_at: string;
  activo: boolean;
  producto?: {
    id: number;
    name: string;
    precio: number;
    descripcion: string;
  };
}

@Injectable({
  providedIn: 'root'
})
export class PromocionesPublicService {
  private apiUrl = 'http://localhost:3000/api/v1';
  
  constructor(private http: HttpClient) {}

  /**
   * Obtiene las promociones públicas (no requiere autenticación)
   */
  getPromocionesPublicas(): Observable<PromocionPublica[]> {
    return this.http.get<PromocionAdmin[]>(`${this.apiUrl}/promociones/public`).pipe(
      map(adminPromociones => this.transformToPublicPromociones(adminPromociones)),
      catchError(error => {
        console.error('Error obteniendo promociones públicas:', error);
        // Retornar promociones de ejemplo si falla la conexión
        return of(this.getDefaultPromociones());
      })
    );
  }

  /**
   * Transforma las promociones del admin al formato público
   */
  private transformToPublicPromociones(adminPromociones: PromocionAdmin[]): PromocionPublica[] {
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
      isActive: promo.activo,
      producto_id: promo.producto_id  // Incluir el ID del producto
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
        title: 'Combo Familiar Especial',
        description: '4 hamburguesas + papas grandes + 4 bebidas',
        image: 'assets/burger.png',
        oldPrice: 45.99,
        newPrice: 35.99,
        discount: 22,
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
        discount: 21,
        isNew: false,
        validUntil: new Date('2025-11-30'),
        isActive: true
      },
      {
        id: 3,
        title: 'Miércoles de Alitas',
        description: '12 alitas + papas + salsa extra',
        image: 'assets/burger.png',
        oldPrice: 25.99,
        newPrice: 19.99,
        discount: 23,
        isNew: false,
        validUntil: new Date('2025-12-31'),
        isActive: true
      }
    ];
  }
}