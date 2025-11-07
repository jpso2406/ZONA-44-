import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface CreateOrderRequest {
  customer: {
    name?: string;
    email?: string;
    phone?: string;
    address?: string; // <-- ahora permitido
    city?: string;    // <-- ahora permitido
  };
  cart: Array<{ 
    producto_id: number; 
    cantidad: number;
    promocion_id?: number;  // ID de la promoción si aplica
  }>;
  delivery_type: 'domicilio' | 'recoger';
  total_amount: number;
  user_id?: number;
  location?: { lat: number; lng: number };
}

export interface CreateOrderResponse {
  success: boolean;
  order_id?: number;
  message?: string;
  errors?: string[];
}

@Injectable({ providedIn: 'root' })
export class OrdersService {
  private baseUrl = 'http://localhost:3000/api/v1';

  constructor(private http: HttpClient) {}

  createOrder(payload: CreateOrderRequest): Observable<CreateOrderResponse> {
    return this.http.post<CreateOrderResponse>(`${this.baseUrl}/orders`, payload);
  }
}