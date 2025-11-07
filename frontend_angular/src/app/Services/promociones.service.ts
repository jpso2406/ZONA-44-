import { Injectable } from '@angular/core';
import { Observable, of, BehaviorSubject } from 'rxjs';

export interface PromocionPublica {
  id: number;
  title: string;
  description: string;
  image: string;
  oldPrice?: number;
  newPrice: number;
  discount?: number;
  isNew: boolean;
  validUntil: Date;
  isActive: boolean;
  producto_id?: number;  // ID del producto asociado a la promoción
}

@Injectable({
  providedIn: 'root'
})
export class PromocionesService {
  private promocionesSubject = new BehaviorSubject<PromocionPublica[]>([]);
  public promociones$ = this.promocionesSubject.asObservable();

  private mockPromociones: PromocionPublica[] = [
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
      isNew: false,  // Añadido
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

  constructor() {
    this.promocionesSubject.next(this.mockPromociones);
  }

  getPromociones(): Observable<PromocionPublica[]> {
    // Filtramos solo las promociones activas
    const activePromociones = this.mockPromociones.filter(promo => promo.isActive);
    return of(activePromociones);
  }

  getPromocionById(id: number): Observable<PromocionPublica | null> {
    const promocion = this.mockPromociones.find(p => p.id === id && p.isActive);
    return of(promocion || null);
  }

  // Método para agregar promoción al carrito (placeholder)
  addToCart(promoId: number): Observable<boolean> {
    console.log(`Promoción ${promoId} agregada al carrito`);
    // Aquí puedes integrar con el servicio de carrito
    return of(true);
  }

  // Método para actualizar promociones desde el admin
  updatePromociones(nuevasPromociones: PromocionPublica[]): void {
    this.mockPromociones = nuevasPromociones;
    this.promocionesSubject.next(nuevasPromociones.filter(p => p.isActive));
  }
}