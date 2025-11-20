import { Component, OnInit, ViewChild, ElementRef, AfterViewInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { 
  AdminDashboardService, 
  DashboardData, 
  DashboardResponse,
  RevenueTrendItem,
  OrderStatusItem,
  TopProduct,
  SalesByCategory,
  DeliveryTypeDistribution,
  SystemAlert,
  DailySalesData,
  DailySalesItem
} from '../services/admin-dashboard.service';
import { Chart, ChartConfiguration, registerables } from 'chart.js';

Chart.register(...registerables);

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-dashboard.html',
  styleUrls: ['./admin-dashboard.css']
})
export class AdminDashboardComponent implements OnInit, AfterViewInit, OnDestroy {
  @ViewChild('revenueChart', { static: false }) revenueChartRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('statusChart', { static: false }) statusChartRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('topProductsChart', { static: false }) topProductsChartRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('categoryChart', { static: false }) categoryChartRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('deliveryChart', { static: false }) deliveryChartRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('dailySalesChart', { static: false }) dailySalesChartRef!: ElementRef<HTMLCanvasElement>;

  dashboardData: DashboardData | null = null;
  dailySalesData: DailySalesData | null = null;
  loading = true;
  loadingDailySales = false;
  error: string | null = null;

  // Controls
  selectedPeriod: string = '30d';

  // Charts
  revenueChart: Chart | null = null;
  statusChart: Chart | null = null;
  topProductsChart: Chart | null = null;
  categoryChart: Chart | null = null;
  deliveryChart: Chart | null = null;
  dailySalesChart: Chart | null = null;

  periodOptions = [
    { value: '7d', label: 'Últimos 7 días' },
    { value: '30d', label: 'Últimos 30 días' },
    { value: '90d', label: 'Últimos 90 días' },
    { value: '1y', label: 'Último año' }
  ];

  constructor(private dashboardService: AdminDashboardService) {}

  ngOnInit() {
    this.loadDashboardData();
    this.loadDailySales();
  }

  ngAfterViewInit() {
    // Los gráficos se crearán después de cargar los datos
  }

  loadDashboardData() {
    this.loading = true;
    this.error = null;

    this.dashboardService.getDashboardStats(this.selectedPeriod, false).subscribe({
      next: (response: DashboardResponse) => {
        this.dashboardData = response.data;
        this.loading = false;
        
        // Crear gráficos después de cargar los datos
        setTimeout(() => {
          this.createAllCharts();
        }, 100);
      },
      error: (error) => {
        console.error('Error loading dashboard:', error);
        this.error = error?.error?.error || 'Error al cargar los datos del dashboard';
        this.loading = false;
      }
    });
  }

  onPeriodChange() {
    this.loadDashboardData();
    this.loadDailySales();
  }

  loadDailySales() {
    this.loadingDailySales = true;
    
    // Calcular fechas basadas en el período seleccionado
    const endDate = new Date();
    const startDate = new Date();
    
    switch(this.selectedPeriod) {
      case '7d':
        startDate.setDate(endDate.getDate() - 7);
        break;
      case '30d':
        startDate.setDate(endDate.getDate() - 30);
        break;
      case '90d':
        startDate.setDate(endDate.getDate() - 90);
        break;
      case '1y':
        startDate.setFullYear(endDate.getFullYear() - 1);
        break;
      default:
        startDate.setDate(endDate.getDate() - 30);
    }

    const startDateStr = startDate.toISOString().split('T')[0];
    const endDateStr = endDate.toISOString().split('T')[0];

    this.dashboardService.getDailySales(startDateStr, endDateStr, 'day').subscribe({
      next: (response) => {
        this.dailySalesData = response.data;
        this.loadingDailySales = false;
        
        setTimeout(() => {
          this.createDailySalesChart();
        }, 100);
      },
      error: (error) => {
        console.error('Error loading daily sales:', error);
        this.loadingDailySales = false;
      }
    });
  }

  createAllCharts() {
    if (!this.dashboardData) return;
    
    this.createRevenueChart(this.dashboardData.charts.revenue_trend);
    this.createStatusChart(this.dashboardData.charts.orders_by_status);
    this.createTopProductsChart(this.dashboardData.charts.top_products);
    this.createCategoryChart(this.dashboardData.charts.sales_by_category);
    this.createDeliveryChart(this.dashboardData.charts.delivery_type_distribution);
    
    if (this.dailySalesData) {
      this.createDailySalesChart();
    }
  }

  createDailySalesChart() {
    if (this.dailySalesChart) {
      this.dailySalesChart.destroy();
    }

    if (!this.dailySalesData || !this.dailySalesChartRef) return;

    const ctx = this.dailySalesChartRef?.nativeElement?.getContext('2d');
    if (!ctx) return;

    const data = this.dailySalesData.sales_by_period;
    
    // Formatear fechas para mostrar mejor
    const labels = data.map(item => {
      const date = new Date(item.date);
      return date.toLocaleDateString('es-CO', { month: 'short', day: 'numeric' });
    });

    const config: ChartConfiguration = {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'Ingresos Diarios',
          data: data.map(item => item.revenue),
          backgroundColor: 'rgba(78, 205, 196, 0.7)',
          borderColor: '#4ecdc4',
          borderWidth: 2,
          borderRadius: 5
        }, {
          label: 'Pedidos',
          data: data.map(item => item.order_count),
          backgroundColor: 'rgba(255, 107, 107, 0.7)',
          borderColor: '#ff6b6b',
          borderWidth: 2,
          borderRadius: 5,
          yAxisID: 'y1'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            labels: {
              color: 'white'
            }
          },
          tooltip: {
            callbacks: {
              afterLabel: (context) => {
                const index = context.dataIndex;
                const item = data[index];
                return [
                  `Promedio: ${this.formatPrice(item.avg_order_value)}`,
                  `Clientes únicos: ${item.unique_customers}`
                ];
              }
            }
          }
        },
        scales: {
          x: {
            ticks: {
              color: 'white',
              maxRotation: 45,
              minRotation: 45
            },
            grid: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          },
          y: {
            type: 'linear',
            position: 'left',
            ticks: {
              color: 'white',
              callback: (value) => '$' + Number(value).toLocaleString()
            },
            grid: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          },
          y1: {
            type: 'linear',
            position: 'right',
            ticks: {
              color: 'white'
            },
            grid: {
              display: false
            }
          }
        }
      }
    };

    this.dailySalesChart = new Chart(ctx, config);
  }

  createRevenueChart(data: RevenueTrendItem[]) {
    if (this.revenueChart) {
      this.revenueChart.destroy();
    }

    const ctx = this.revenueChartRef?.nativeElement?.getContext('2d');
    if (!ctx) return;

    const config: ChartConfiguration = {
      type: 'line',
      data: {
        labels: data.map(item => item.period),
        datasets: [{
          label: 'Ingresos',
          data: data.map(item => item.revenue),
          backgroundColor: 'rgba(78, 205, 196, 0.2)',
          borderColor: '#4ecdc4',
          borderWidth: 3,
          fill: true,
          tension: 0.4,
          pointBackgroundColor: '#4ecdc4',
          pointBorderColor: '#fff',
          pointBorderWidth: 2,
          pointRadius: 6
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            labels: {
              color: 'white'
            }
          },
          tooltip: {
            callbacks: {
              label: (context) => {
                const index = context.dataIndex;
                const item = data[index];
                return [
                  `Ingresos: ${this.formatPrice(item.revenue)}`,
                  `Pedidos: ${item.order_count}`,
                  `Promedio: ${this.formatPrice(item.avg_order_value)}`
                ];
              }
            }
          }
        },
        scales: {
          x: {
            ticks: {
              color: 'white'
            },
            grid: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          },
          y: {
            ticks: {
              color: 'white',
              callback: (value) => {
                return '$' + Number(value).toLocaleString();
              }
            },
            grid: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          }
        }
      }
    };

    this.revenueChart = new Chart(ctx, config);
  }

  createStatusChart(data: OrderStatusItem[]) {
    if (this.statusChart) {
      this.statusChart.destroy();
    }

    const ctx = this.statusChartRef?.nativeElement?.getContext('2d');
    if (!ctx) return;

    const config: ChartConfiguration = {
      type: 'doughnut',
      data: {
        labels: data.map(item => item.label),
        datasets: [{
          data: data.map(item => item.count),
          backgroundColor: data.map(item => this.getStatusColor(item.status)),
          borderWidth: 0,
          hoverOffset: 10
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              color: 'white',
              padding: 20,
              font: {
                size: 12
              }
            }
          },
          tooltip: {
            callbacks: {
              label: (context) => {
                const index = context.dataIndex;
                const item = data[index];
                return `${item.label}: ${item.count} (${item.percentage}%)`;
              }
            }
          }
        }
      }
    };

    this.statusChart = new Chart(ctx, config);
  }

  createTopProductsChart(data: TopProduct[]) {
    if (this.topProductsChart) {
      this.topProductsChart.destroy();
    }

    const ctx = this.topProductsChartRef?.nativeElement?.getContext('2d');
    if (!ctx) return;

    // Limitar a top 10 para mejor visualización
    const top10 = data.slice(0, 10);

    const config: ChartConfiguration = {
      type: 'bar',
      data: {
        labels: top10.map(item => item.name.length > 20 ? item.name.substring(0, 20) + '...' : item.name),
        datasets: [{
          label: 'Ingresos',
          data: top10.map(item => item.revenue),
          backgroundColor: 'rgba(78, 205, 196, 0.7)',
          borderColor: '#4ecdc4',
          borderWidth: 2
        }, {
          label: 'Cantidad Vendida',
          data: top10.map(item => item.quantity_sold),
          backgroundColor: 'rgba(255, 107, 107, 0.7)',
          borderColor: '#ff6b6b',
          borderWidth: 2,
          yAxisID: 'y1'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            labels: {
              color: 'white'
            }
          }
        },
        scales: {
          x: {
            ticks: {
              color: 'white'
            },
            grid: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          },
          y: {
            type: 'linear',
            position: 'left',
            ticks: {
              color: 'white',
              callback: (value) => '$' + Number(value).toLocaleString()
            },
            grid: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          },
          y1: {
            type: 'linear',
            position: 'right',
            ticks: {
              color: 'white'
            },
            grid: {
              display: false
            }
          }
        }
      }
    };

    this.topProductsChart = new Chart(ctx, config);
  }

  createCategoryChart(data: SalesByCategory[]) {
    if (this.categoryChart) {
      this.categoryChart.destroy();
    }

    const ctx = this.categoryChartRef?.nativeElement?.getContext('2d');
    if (!ctx) return;

    const colors = this.generateColors(data.length);

    const config: ChartConfiguration = {
      type: 'pie',
      data: {
        labels: data.map(item => item.category),
        datasets: [{
          data: data.map(item => item.revenue),
          backgroundColor: colors,
          borderWidth: 2,
          borderColor: 'rgba(255, 255, 255, 0.2)'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              color: 'white',
              padding: 15
            }
          },
          tooltip: {
            callbacks: {
              label: (context) => {
                const index = context.dataIndex;
                const item = data[index];
                const total = data.reduce((sum, cat) => sum + cat.revenue, 0);
                const percentage = ((item.revenue / total) * 100).toFixed(1);
                return [
                  `${item.category}: ${this.formatPrice(item.revenue)}`,
                  `Items: ${item.item_count}`,
                  `${percentage}% del total`
                ];
              }
            }
          }
        }
      }
    };

    this.categoryChart = new Chart(ctx, config);
  }

  createDeliveryChart(data: DeliveryTypeDistribution[]) {
    if (this.deliveryChart) {
      this.deliveryChart.destroy();
    }

    const ctx = this.deliveryChartRef?.nativeElement?.getContext('2d');
    if (!ctx) return;

    const config: ChartConfiguration = {
      type: 'bar',
      data: {
        labels: data.map(item => this.getDeliveryTypeLabel(item.type)),
        datasets: [{
          label: 'Cantidad de Pedidos',
          data: data.map(item => item.count),
          backgroundColor: 'rgba(78, 205, 196, 0.7)',
          borderColor: '#4ecdc4',
          borderWidth: 2
        }, {
          label: 'Ingresos',
          data: data.map(item => item.revenue),
          backgroundColor: 'rgba(255, 107, 107, 0.7)',
          borderColor: '#ff6b6b',
          borderWidth: 2,
          yAxisID: 'y1'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            labels: {
              color: 'white'
            }
          }
        },
        scales: {
          x: {
            ticks: {
              color: 'white'
            },
            grid: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          },
          y: {
            ticks: {
              color: 'white'
            },
            grid: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          },
          y1: {
            type: 'linear',
            position: 'right',
            ticks: {
              color: 'white',
              callback: (value) => '$' + Number(value).toLocaleString()
            },
            grid: {
              display: false
            }
          }
        }
      }
    };

    this.deliveryChart = new Chart(ctx, config);
  }

  private generateColors(count: number): string[] {
    const baseColors = [
      'rgba(78, 205, 196, 0.8)',
      'rgba(255, 107, 107, 0.8)',
      'rgba(255, 159, 64, 0.8)',
      'rgba(75, 192, 192, 0.8)',
      'rgba(153, 102, 255, 0.8)',
      'rgba(255, 99, 132, 0.8)',
      'rgba(54, 162, 235, 0.8)',
      'rgba(255, 206, 86, 0.8)'
    ];
    
    const colors: string[] = [];
    for (let i = 0; i < count; i++) {
      colors.push(baseColors[i % baseColors.length]);
    }
    return colors;
  }

  getStatusText(status: string): string {
    const statusMap: { [key: string]: string } = {
      'pending': 'Pendiente',
      'processing': 'En Proceso',
      'paid': 'Finalizado',
      'failed': 'Fallido',
      'cancelled': 'Cancelado'
    };
    return statusMap[status] || status;
  }

  getStatusClass(status: string): string {
    const classMap: { [key: string]: string } = {
      'pending': 'status-pending',
      'processing': 'status-processing',
      'paid': 'status-paid',
      'failed': 'status-failed',
      'cancelled': 'status-cancelled'
    };
    return classMap[status] || 'status-default';
  }

  private getStatusColor(status: string): string {
    const colorMap: { [key: string]: string } = {
      'pending': '#3b82f6',
      'processing': '#f39c12',
      'paid': '#27ae60',
      'failed': '#e74c3c',
      'cancelled': '#95a5a6'
    };
    return colorMap[status] || '#95a5a6';
  }

  getDeliveryTypeLabel(type: string): string {
    const labels: { [key: string]: string } = {
      'delivery': 'Domicilio',
      'pickup': 'Recoger',
      'dine_in': 'Comer Aquí',
      'unknown': 'Desconocido'
    };
    return labels[type] || type;
  }

  getAlertIcon(alert: SystemAlert): string {
    const iconMap: { [key: string]: string } = {
      'warning': 'fa-exclamation-triangle',
      'error': 'fa-times-circle',
      'info': 'fa-info-circle',
      'success': 'fa-check-circle'
    };
    return iconMap[alert.type] || 'fa-info-circle';
  }

  getAlertClass(alert: SystemAlert): string {
    return `alert-${alert.severity} alert-${alert.type}`;
  }

  formatPrice(amount: number): string {
    return new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP',
      minimumFractionDigits: 0
    }).format(amount);
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-CO', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }


  refreshDashboard() {
    this.loadDashboardData();
  }

  ngOnDestroy() {
    if (this.revenueChart) {
      this.revenueChart.destroy();
    }
    if (this.statusChart) {
      this.statusChart.destroy();
    }
    if (this.topProductsChart) {
      this.topProductsChart.destroy();
    }
    if (this.categoryChart) {
      this.categoryChart.destroy();
    }
    if (this.deliveryChart) {
      this.deliveryChart.destroy();
    }
    if (this.dailySalesChart) {
      this.dailySalesChart.destroy();
    }
  }
}
