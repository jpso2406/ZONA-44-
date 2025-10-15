import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, catchError, of } from 'rxjs';

export interface DashboardStats {
  total_orders: number;
  total_revenue: number;
  processing_orders: number;
  paid_orders: number;
  recent_orders: Array<{
    id: number;
    order_number: string;
    customer_name: string;
    total_amount: number;
    status: string;
    created_at: string;
  }>;
  monthly_revenue: Array<{
    month: string;
    revenue: number;
  }>;
  orders_by_status: Array<{
    status: string;
    count: number;
  }>;
}

@Injectable({
  providedIn: 'root'
})
export class AdminDashboardService {
  private apiUrl = 'http://localhost:3000/api/v1/admin';

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('auth_token');
    return new HttpHeaders({
      'Authorization': token || '',
      'Content-Type': 'application/json'
    });
  }

  getDashboardStats(): Observable<DashboardStats> {
    return this.http.get<DashboardStats>(`${this.apiUrl}/dashboard`, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error fetching dashboard stats:', error);
          // Retornar datos mock en caso de error
          return of(this.getMockStats());
        })
      );
  }

  private getMockStats(): DashboardStats {
    return {
      total_orders: 156,
      total_revenue: 2340000,
      processing_orders: 12,
      paid_orders: 144,
      recent_orders: [
        {
          id: 1,
          order_number: 'ORD-20241201-A1B2',
          customer_name: 'Juan Pérez',
          total_amount: 45000,
          status: 'processing',
          created_at: '2024-12-01T10:30:00Z'
        },
        {
          id: 2,
          order_number: 'ORD-20241201-C3D4',
          customer_name: 'María García',
          total_amount: 32000,
          status: 'paid',
          created_at: '2024-12-01T14:15:00Z'
        },
        {
          id: 3,
          order_number: 'ORD-20241130-E5F6',
          customer_name: 'Carlos López',
          total_amount: 28000,
          status: 'paid',
          created_at: '2024-11-30T18:45:00Z'
        }
      ],
      monthly_revenue: [
        { month: 'Ene', revenue: 1800000 },
        { month: 'Feb', revenue: 2100000 },
        { month: 'Mar', revenue: 1950000 },
        { month: 'Abr', revenue: 2300000 },
        { month: 'May', revenue: 2200000 },
        { month: 'Jun', revenue: 2340000 }
      ],
      orders_by_status: [
        { status: 'processing', count: 12 },
        { status: 'paid', count: 144 }
      ]
    };
  }
}
