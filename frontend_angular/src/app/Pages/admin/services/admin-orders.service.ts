import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, catchError, of } from 'rxjs';

export interface OrderItem {
  id: number;
  quantity: number;
  unit_price: number;
  total_price: number;
  producto: {
    id: number;
    name: string;
    precio: number;
    descripcion?: string;
  };
}

export interface Order {
  id: number;
  order_number: string;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  total_amount: number;
  status: string;
  delivery_type: string;
  created_at: string;
  user?: {
    id: number;
    email: string;
    first_name: string;
    last_name: string;
  };
  order_items: OrderItem[];
}

@Injectable({
  providedIn: 'root'
})
export class AdminOrdersService {
  private apiUrl = 'http://localhost:3000/api/v1/admin';

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('auth_token');
    return new HttpHeaders({
      'Authorization': token || '',
      'Content-Type': 'application/json'
    });
  }

  getOrders(): Observable<Order[]> {
    return this.http.get<Order[]>(`${this.apiUrl}/orders`, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error fetching orders:', error);
          return of([]);
        })
      );
  }

  updateOrderStatus(orderId: number, status: string): Observable<any> {
    return this.http.patch(`${this.apiUrl}/orders/${orderId}`, 
      { status }, 
      { headers: this.getHeaders() }
    ).pipe(
      catchError(error => {
        console.error('Error updating order:', error);
        throw error;
      })
    );
  }
}
