import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { CarritoItem } from '../Components/shared/carrito/carrito';

@Injectable({ providedIn: 'root' })
export class GlobalCartService {
  private cartItemsSubject = new BehaviorSubject<CarritoItem[]>(this.loadCart());
  cartItems$ = this.cartItemsSubject.asObservable();

  private loadCart(): CarritoItem[] {
    const data = localStorage.getItem('global_cart');
    return data ? JSON.parse(data) : [];
  }

  private saveCart(items: CarritoItem[]): void {
    localStorage.setItem('global_cart', JSON.stringify(items));
  }

  getItems(): CarritoItem[] {
    return this.cartItemsSubject.value;
  }

  addItem(item: CarritoItem): void {
    const items = [...this.cartItemsSubject.value];
    const idx = items.findIndex(i => i.id === item.id);
    if (idx > -1) {
      items[idx].cantidad += item.cantidad;
    } else {
      items.push(item);
    }
    this.cartItemsSubject.next(items);
    this.saveCart(items);
  }

  updateItem(id: number, cantidad: number): void {
    const items = [...this.cartItemsSubject.value];
    const idx = items.findIndex(i => i.id === id);
    if (idx > -1) {
      items[idx].cantidad = cantidad;
      if (cantidad <= 0) items.splice(idx, 1);
      this.cartItemsSubject.next(items);
      this.saveCart(items);
    }
  }

  removeItem(id: number): void {
    const items = this.cartItemsSubject.value.filter(i => i.id !== id);
    this.cartItemsSubject.next(items);
    this.saveCart(items);
  }

  clearCart(): void {
    this.cartItemsSubject.next([]);
    this.saveCart([]);
  }

  getTotal(): number {
    return this.cartItemsSubject.value.reduce((total, item) => total + item.precio * item.cantidad, 0);
  }
}
