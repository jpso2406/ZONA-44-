import { Component, OnInit, ViewChild, ElementRef, AfterViewInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AdminDashboardService, DashboardStats } from '../services/admin-dashboard.service';
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

  stats: DashboardStats | null = null;
  loading = true;
  error: string | null = null;

  // Charts
  revenueChart: Chart | null = null;
  statusChart: Chart | null = null;

  constructor(private dashboardService: AdminDashboardService) {}

  ngOnInit() {
    this.loadDashboardData();
  }

  ngAfterViewInit() {
    // Los gráficos se crearán después de cargar los datos
  }

  loadDashboardData() {
    this.loading = true;
    this.error = null;

    this.dashboardService.getDashboardStats().subscribe({
      next: (data) => {
        this.stats = data;
        this.loading = false;
        // Crear gráficos después de cargar los datos
        setTimeout(() => {
          this.createCharts(data);
        }, 100);
      },
      error: (error) => {
        console.error('Error loading dashboard:', error);
        this.error = 'Error al cargar los datos del dashboard';
        this.loading = false;
      }
    });
  }

  createCharts(data: DashboardStats) {
    this.createRevenueChart(data);
    this.createStatusChart(data);
  }

  createRevenueChart(data: DashboardStats) {
    if (this.revenueChart) {
      this.revenueChart.destroy();
    }

    const ctx = this.revenueChartRef?.nativeElement?.getContext('2d');
    if (!ctx) return;

    const config: ChartConfiguration = {
      type: 'line',
      data: {
        labels: data.monthly_revenue.map(item => item.month),
        datasets: [{
          label: 'Ingresos',
          data: data.monthly_revenue.map(item => item.revenue),
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
              callback: function(value) {
                return '$' + value.toLocaleString();
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

  createStatusChart(data: DashboardStats) {
    if (this.statusChart) {
      this.statusChart.destroy();
    }

    const ctx = this.statusChartRef?.nativeElement?.getContext('2d');
    if (!ctx) return;

    const config: ChartConfiguration = {
      type: 'doughnut',
      data: {
        labels: data.orders_by_status.map(item => this.getStatusText(item.status)),
        datasets: [{
          data: data.orders_by_status.map(item => item.count),
          backgroundColor: ['#f39c12', '#27ae60'],
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
              padding: 20
            }
          }
        }
      }
    };

    this.statusChart = new Chart(ctx, config);
  }

  getStatusText(status: string): string {
    const statusMap: { [key: string]: string } = {
      'processing': 'En Proceso',
      'paid': 'Pagado'
    };
    return statusMap[status] || status;
  }

  getStatusClass(status: string): string {
    const classMap: { [key: string]: string } = {
      'processing': 'status-processing',
      'paid': 'status-paid'
    };
    return classMap[status] || 'status-default';
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
  }
}