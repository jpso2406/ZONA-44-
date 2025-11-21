import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../Components/shared/footer/footer";
import { SeguimientoService, OrderTracking } from './seguimiento.service';

@Component({
    selector: 'app-seguimiento',
    templateUrl: 'seguimiento.html',
    styleUrl: 'seguimiento.css',
    imports: [CommonModule, FormsModule, TranslateModule, NavbarComponent, FooterComponent],
})

export class Seguimiento implements OnInit {
    orderNumber: string = '';
    email: string = '';
    orderData: OrderTracking | null = null;
    loading: boolean = false;
    error: string = '';
    searched: boolean = false;

    orderStatuses = [
        { key: 'pending', label: 'Pendiente', icon: 'fa-clock' },
        { key: 'processing', label: 'En Proceso', icon: 'fa-spinner' },
        { key: 'paid', label: 'Finalizado', icon: 'fa-check-circle' },
        { key: 'failed', label: 'Pago Fallido', icon: 'fa-times-circle' },
        { key: 'cancelled', label: 'Cancelado', icon: 'fa-ban' }
    ];

    constructor(private seguimientoService: SeguimientoService) { }

    ngOnInit() { }

    trackOrder() {
        if (!this.orderNumber || !this.email) {
            this.error = 'TRACKING.ERROR_REQUIRED';
            return;
        }

        this.loading = true;
        this.error = '';
        this.searched = true;
        this.orderData = null;

        this.seguimientoService.trackOrder(this.orderNumber, this.email).subscribe({
            next: (data) => {
                this.orderData = data;
                this.loading = false;
            },
            error: (err) => {
                this.error = err.error?.error || err.error?.message || 'TRACKING.ERROR_NOT_FOUND';
                this.loading = false;
            }
        });
    }

    getStatusIndex(status: string): number {
        return this.orderStatuses.findIndex(s => s.key === status);
    }

    isStatusCompleted(statusKey: string): boolean {
        if (!this.orderData) return false;
        
        const currentStatus = this.orderData.status;
        
        // Si el pedido fue cancelado o falló, solo ese estado está activo
        if (currentStatus === 'failed' || currentStatus === 'cancelled') {
            return false;
        }
        
        // Para estados normales de progresión
        const statusOrder = ['pending', 'processing', 'paid'];
        const currentIndex = statusOrder.indexOf(currentStatus);
        const checkIndex = statusOrder.indexOf(statusKey);
        
        // Si el estado a verificar no está en la progresión normal, no está completado
        if (checkIndex === -1) return false;
        
        return checkIndex < currentIndex;
    }

    isStatusActive(statusKey: string): boolean {
        if (!this.orderData) return false;
        return this.orderData.status === statusKey;
    }

    isStatusFailed(): boolean {
        return this.orderData?.status === 'failed';
    }

    isStatusCancelled(): boolean {
        return this.orderData?.status === 'cancelled';
    }

    getStatusLabel(status: string): string {
        const statusObj = this.orderStatuses.find(s => s.key === status);
        return statusObj ? statusObj.label : status;
    }

    formatDate(dateString: string): string {
        const date = new Date(dateString);
        return date.toLocaleDateString('es-ES', { 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    formatPrice(price: string | number): string {
        if (!price) return '$0';
        
        const numPrice = typeof price === 'string' ? parseFloat(price) : price;
        
        if (isNaN(numPrice)) return '$0';
        
        return new Intl.NumberFormat('es-CO', {
            style: 'currency',
            currency: 'COP',
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(numPrice);
    }

    resetForm() {
        this.orderNumber = '';
        this.email = '';
        this.orderData = null;
        this.error = '';
        this.searched = false;
    }
}