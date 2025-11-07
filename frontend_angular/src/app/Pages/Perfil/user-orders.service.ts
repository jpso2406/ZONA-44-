import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { TranslateService } from '@ngx-translate/core';

export interface Producto {
  id: number;
  name: string;
  precio: number;
  descripcion: string;
}

export interface OrderItem {
  id: number;
  quantity: number;
  unit_price: number;
  total_price: number;
  producto: Producto;
}

export interface Order {
  id: number;
  order_number: string;
  status: string;
  delivery_type: string;
  total_amount: number;
  created_at: string;
  order_items: OrderItem[];
}

@Injectable({
  providedIn: 'root'
})
export class UserOrdersService {
  private apiUrl = 'http://localhost:3000/api/v1';

  constructor(
    private http: HttpClient,
    private translate: TranslateService
  ) {}

  getUserOrders(): Observable<Order[]> {
    const token = localStorage.getItem('auth_token');
    if (!token) {
      return of([]);
    }

    const headers = new HttpHeaders({
      'Authorization': token,
      'Content-Type': 'application/json'
    });

    return this.http.get<Order[]>(`${this.apiUrl}/user_orders`, { headers }).pipe(
      catchError(error => {
        console.error('Error al cargar órdenes:', error);
        return of([]);
      })
    );
  }

  getOrderStatusText(status: string): string {
    const key = `PROFILE.ORDERS.STATUS.${status}`;
    return this.translate.instant(key);
  }

  getOrderStatusClass(status: string): string {
    const statusClassMap: { [key: string]: string } = {
      'pending': 'status-pending',
      'paid': 'status-delivered',
      'processing': 'status-processing',
      'preparing': 'status-processing',
      'ready': 'status-ready',
      'delivered': 'status-delivered',
      'cancelled': 'status-cancelled',
      'failed': 'status-failed'
    };
    return statusClassMap[status] || 'status-pending';
  }

  getDeliveryTypeText(deliveryType: string): string {
    const key = `PROFILE.ORDERS.DELIVERY_TYPE.${deliveryType}`;
    return this.translate.instant(key);
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-CO', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }
}
