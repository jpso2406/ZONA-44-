import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface CreateOrderRequest {
  customer: { name?: string; email?: string; phone?: string };
  cart: Array<{ producto_id: number; cantidad: number }>;
  delivery_type: 'domicilio' | 'recoger';
  total_amount: number;
  user_id?: number;
}

export interface CreateOrderResponse {
  success: boolean;
  order_id?: number;
  message?: string;
  errors?: string[];
}

@Injectable({ providedIn: 'root' })
export class OrdersService {
  // Backend local
  private baseUrl = 'http://localhost:3000/api/v1';

  constructor(private http: HttpClient) {}

  createOrder(payload: CreateOrderRequest): Observable<CreateOrderResponse> {
    return this.http.post<CreateOrderResponse>(`${this.baseUrl}/orders`, payload);
  }
}


