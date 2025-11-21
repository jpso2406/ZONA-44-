import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable, catchError, of, map } from 'rxjs';

export interface OverviewStatistics {
  total_orders: number;
  total_revenue: number;
  average_order_value: number;
  pending_orders: number;
  processing_orders: number;
  completed_orders: number;
  failed_orders: number;
  cancelled_orders: number;
  conversion_rate: number;
  customer_retention_rate: number;
}

export interface RevenueTrendItem {
  period: string;
  revenue: number;
  order_count: number;
  avg_order_value: number;
}

export interface OrderStatusItem {
  status: string;
  count: number;
  label: string;
  percentage: number;
}

export interface TopProduct {
  name: string;
  quantity_sold: number;
  revenue: number;
  order_count: number;
}

export interface SalesByCategory {
  category: string;
  revenue: number;
  item_count: number;
}

export interface DeliveryTypeDistribution {
  type: string;
  count: number;
  revenue: number;
  avg_value: number;
}

export interface RecentOrder {
  id: number;
  order_number: string;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  total_amount: number;
  status: string;
  delivery_type: string;
  payment_method: string;
  created_at: string;
  items_count: number;
  user_id?: number;
}

export interface PerformanceMetrics {
  avg_order_processing_time: number;
  order_fulfillment_rate: number;
  revenue_growth: number;
  customer_satisfaction_score: number;
  peak_hours: Array<{ hour: number; orders: number }>;
  busiest_days: Array<{ day: string; orders: number }>;
}

export interface SystemAlert {
  type: string;
  severity: string;
  message: string;
  action: string;
}

export interface ComparisonData {
  revenue_change: number;
  orders_change: number;
  current_period: {
    revenue: number;
    orders: number;
  };
  previous_period: {
    revenue: number;
    orders: number;
  };
}

export interface ChartsData {
  revenue_trend: RevenueTrendItem[];
  orders_by_status: OrderStatusItem[];
  top_products: TopProduct[];
  sales_by_category: SalesByCategory[];
  delivery_type_distribution: DeliveryTypeDistribution[];
}

export interface DashboardData {
  overview: OverviewStatistics;
  charts: ChartsData;
  recent_orders: RecentOrder[];
  performance_metrics: PerformanceMetrics;
  alerts: SystemAlert[];
  comparison?: ComparisonData;
}

export interface DashboardResponse {
  success: boolean;
  data: DashboardData;
  meta: {
    period: string;
    generated_at: string;
    cache_expires_in: string;
  };
}

export interface AnalyticsData {
  sales_analytics: {
    total_sales: number;
    sales_by_hour: Array<{ hour: number; revenue: number }>;
    sales_by_day_of_week: Array<{ day: number; revenue: number }>;
    sales_forecast: Array<{ date: string; forecast: number }>;
  };
  customer_analytics: {
    total_customers: number;
    new_customers: number;
    repeat_customers: number;
    customer_lifetime_value: number;
    top_customers: Array<{
      id: number;
      email: string;
      name: string;
      total_spent: number;
      order_count: number;
    }>;
  };
  product_analytics: {
    total_products_sold: number;
    product_performance: Array<{
      id: number;
      name: string;
      quantity_sold: number;
      revenue: number;
      avg_price: number;
    }>;
    trending_products: Array<{
      name: string;
      recent_sales: number;
      trend: string;
    }>;
  };
  time_analytics: {
    peak_ordering_times: Array<{ hour: number; orders: number }>;
    average_order_time: number;
    time_to_completion: number;
  };
}

export interface RealtimeData {
  active_orders: number;
  online_users: number;
  pending_alerts: number;
  system_health: {
    database: string;
    cache: string;
    api: string;
    payment_gateway: string;
    status: string;
  };
  recent_activity: Array<{
    type: string;
    action: string;
    order_number?: string;
    amount?: number;
    timestamp: string;
  }>;
}

export interface DailySalesItem {
  date: string;
  revenue: number;
  order_count: number;
  avg_order_value: number;
  min_order?: number;
  max_order?: number;
  unique_customers: number;
  day_of_week?: string;
}

export interface DailySalesSummary {
  total_revenue: number;
  total_orders: number;
  average_daily_revenue: number;
  best_day?: {
    date: string;
    revenue: number;
    day_name: string;
  };
  worst_day?: {
    date: string;
    revenue: number;
    day_name: string;
  };
}

export interface DailySalesComparison {
  current: {
    revenue: number;
    orders: number;
  };
  previous: {
    revenue: number;
    orders: number;
  };
  change: {
    revenue_percentage: number;
    orders_percentage: number;
  };
}

export interface DailySalesData {
  sales_by_period: DailySalesItem[];
  summary: DailySalesSummary;
  comparison: {
    vs_previous_period: DailySalesComparison;
  };
}

@Injectable({
  providedIn: 'root'
})
export class AdminDashboardService {
  private apiUrl = 'http://localhost:3000/api/v1/admin/dashboard';

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('auth_token');
    return new HttpHeaders({
      'Authorization': token || '',
      'Content-Type': 'application/json'
    });
  }

  getDashboardStats(period: string = '30d', compare: boolean = false): Observable<DashboardResponse> {
    let params = new HttpParams()
      .set('period', period);
    
    if (compare) {
      params = params.set('compare', 'true');
    }

    return this.http.get<DashboardResponse>(this.apiUrl, { 
      headers: this.getHeaders(),
      params 
    }).pipe(
      map(response => {
        // Si la respuesta tiene la estructura correcta, devolverla directamente
        if (response && response.success && response.data) {
          return response;
        }
        // Fallback si la estructura es diferente (por compatibilidad)
        if (response && (response as any).data) {
          return {
            success: true,
            data: (response as any).data,
            meta: (response as any).meta || {
              period: period,
              generated_at: new Date().toISOString(),
              cache_expires_in: new Date(Date.now() + 5 * 60 * 1000).toISOString()
            }
          };
        }
        // Si no hay datos, usar mock
        return this.getMockStats(period);
      }),
      catchError(error => {
        console.error('Error fetching dashboard stats:', error);
        return of(this.getMockStats(period));
      })
    );
  }

  getAnalytics(startDate?: string, endDate?: string): Observable<AnalyticsData> {
    let params = new HttpParams();
    
    if (startDate) {
      params = params.set('start_date', startDate);
    }
    if (endDate) {
      params = params.set('end_date', endDate);
    }

    return this.http.get<{ success: boolean; data: AnalyticsData }>(
      `${this.apiUrl}/analytics`, 
      { headers: this.getHeaders(), params }
    ).pipe(
      map(response => response.data),
      catchError(error => {
        console.error('Error fetching analytics:', error);
        throw error;
      })
    );
  }

  getRealtimeData(): Observable<RealtimeData> {
    return this.http.get<{ success: boolean; data: RealtimeData; timestamp: string }>(
      `${this.apiUrl}/realtime`,
      { headers: this.getHeaders() }
    ).pipe(
      map(response => response.data),
      catchError(error => {
        console.error('Error fetching realtime data:', error);
        throw error;
      })
    );
  }

  getDailySales(startDate?: string, endDate?: string, groupBy: string = 'day'): Observable<{ success: boolean; data: DailySalesData; meta: any }> {
    let params = new HttpParams().set('group_by', groupBy);
    
    if (startDate) {
      params = params.set('start_date', startDate);
    }
    if (endDate) {
      params = params.set('end_date', endDate);
    }

    return this.http.get<{ success: boolean; data: DailySalesData; meta: any }>(
      `${this.apiUrl}/daily_sales`,
      { headers: this.getHeaders(), params }
    ).pipe(
      catchError(error => {
        console.error('Error fetching daily sales:', error);
        throw error;
      })
    );
  }

  private getMockStats(period: string = '30d'): DashboardResponse {
    return {
      success: true,
      data: {
        overview: {
          total_orders: 156,
          total_revenue: 2340000,
          average_order_value: 15000,
          pending_orders: 5,
          processing_orders: 12,
          completed_orders: 144,
          failed_orders: 2,
          cancelled_orders: 3,
          conversion_rate: 92.3,
          customer_retention_rate: 45.5
        },
        charts: {
          revenue_trend: [
            { period: '2024-11-01', revenue: 800000, order_count: 50, avg_order_value: 16000 },
            { period: '2024-11-02', revenue: 850000, order_count: 52, avg_order_value: 16346 },
            { period: '2024-11-03', revenue: 920000, order_count: 54, avg_order_value: 17037 }
          ],
          orders_by_status: [
            { status: 'pending', count: 5, label: 'Pendiente', percentage: 3.2 },
            { status: 'processing', count: 12, label: 'En Proceso', percentage: 7.7 },
            { status: 'paid', count: 144, label: 'Finalizado', percentage: 92.3 }
          ],
          top_products: [
            { name: 'Hamburguesa Clásica', quantity_sold: 120, revenue: 480000, order_count: 80 },
            { name: 'Pizza Familiar', quantity_sold: 95, revenue: 570000, order_count: 65 }
          ],
          sales_by_category: [
            { category: 'Hamburguesas', revenue: 1200000, item_count: 300 },
            { category: 'Pizzas', revenue: 950000, item_count: 250 }
          ],
          delivery_type_distribution: [
            { type: 'delivery', count: 80, revenue: 1200000, avg_value: 15000 },
            { type: 'pickup', count: 76, revenue: 1140000, avg_value: 15000 }
          ]
        },
        recent_orders: [
          {
            id: 1,
            order_number: 'ORD-20241201-A1B2',
            customer_name: 'Juan Pérez',
            customer_email: 'juan@example.com',
            customer_phone: '3001234567',
            total_amount: 45000,
            status: 'processing',
            delivery_type: 'delivery',
            payment_method: 'card',
            created_at: '2024-12-01T10:30:00Z',
            items_count: 3
          }
        ],
        performance_metrics: {
          avg_order_processing_time: 45.5,
          order_fulfillment_rate: 92.3,
          revenue_growth: 15.5,
          customer_satisfaction_score: 0,
          peak_hours: [{ hour: 12, orders: 25 }, { hour: 19, orders: 30 }],
          busiest_days: [{ day: 'Friday', orders: 35 }, { day: 'Saturday', orders: 40 }]
        },
        alerts: [
          {
            type: 'warning',
            severity: 'medium',
            message: '5 pedidos pendientes con más de 1 hora',
            action: 'review_pending_orders'
          }
        ]
      },
      meta: {
        period: period,
        generated_at: new Date().toISOString(),
        cache_expires_in: new Date(Date.now() + 5 * 60 * 1000).toISOString()
      }
    };
  }
}
