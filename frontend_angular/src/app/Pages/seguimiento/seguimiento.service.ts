import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../config/environment';

export interface OrderItem {
  id: number;
  quantity: number;
  unit_price: string;
  total_price: string;
  producto: {
    id: number;
    nombre: string;
    descripcion: string;
    precio: string;
    imagen_url: string;
  };
}

export interface OrderTracking {
  id: number;
  order_number: string;
  status: string;
  total_amount: string;
  customer_email: string;
  customer_name: string;
  customer_phone: string;
  customer_address: string;
  customer_city: string;
  special_instructions?: string;
  delivery_type: string;
  created_at: string;
  updated_at: string;
  order_items: OrderItem[];
  user?: {
    id: number;
    first_name: string;
    last_name: string;
    email: string;
  };
}

@Injectable({
  providedIn: 'root'
})
export class SeguimientoService {
  private apiUrl = `${environment.apiUrl}/orders`;

  constructor(private http: HttpClient) { }

  trackOrder(orderNumber: string, email: string): Observable<OrderTracking> {
    return this.http.post<OrderTracking>(`${this.apiUrl}/track`, {
      order_number: orderNumber,
      email: email
    });
  }
}
