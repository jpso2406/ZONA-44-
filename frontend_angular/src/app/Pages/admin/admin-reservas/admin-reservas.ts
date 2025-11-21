import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AdminReservasService, TableReservation } from './admin-reservas.service';
import { AuthService } from '../../auth/auth.service';

@Component({
    templateUrl: './admin-reservas.html',
    styleUrl: './admin-reservas.css',
    imports: [CommonModule, FormsModule]
})

export class AdminReservasComponent implements OnInit {
    // Lista de todas las reservas
    allReservations: TableReservation[] = [];
    filteredReservations: TableReservation[] = [];
    
    // Estados del componente
    isLoading = false;
    message = '';
    messageType = '';
    
    // Filtros
    statusFilter = 'todas';
    dateFilter = '';
    
    // Reserva seleccionada para editar
    selectedReservation: TableReservation | null = null;
    isEditing = false;
    
    // Opciones para filtros
    statusOptions = [
        { value: 'todas', label: 'Todas las reservas' },
        { value: 'pendiente', label: 'Pendientes' },
        { value: 'confirmada', label: 'Confirmadas' },
        { value: 'cancelada', label: 'Canceladas' }
    ];

    constructor(
        private adminReservasService: AdminReservasService,
        private authService: AuthService,
        private router: Router
    ) { }

    ngOnInit() {
        // Verificar si el usuario está autenticado
        if (!this.authService.isAuthenticated()) {
            this.showMessage('No estás autenticado. Redirigiendo al login...', 'error');
            setTimeout(() => {
                this.router.navigate(['/login']);
            }, 2000);
            return;
        }
        
        this.loadReservations();
    }

    // Cargar todas las reservas
    loadReservations() {
        this.isLoading = true;
        console.log('Loading reservations...');

        this.adminReservasService.getAllReservations().subscribe({
            next: (reservations) => {
                console.log('Reservations loaded:', reservations);
                this.allReservations = reservations;
                this.applyFilters();
                this.isLoading = false;
            },
            error: (error) => {
                console.error('Error al cargar reservas:', error);
                console.error('Error status:', error.status);
                console.error('Error message:', error.message);
                
                if (error.status === 401) {
                    this.showMessage('No tienes permisos para acceder a esta sección. Redirigiendo al login...', 'error');
                    setTimeout(() => {
                        this.router.navigate(['/login']);
                    }, 2000);
                } else if (error.status === 403) {
                    this.showMessage('Acceso denegado. Solo los administradores pueden ver las reservas.', 'error');
                } else if (error.status === 404) {
                    this.showMessage('Endpoint no encontrado. Verifica que el backend esté funcionando.', 'error');
                } else if (error.status === 0) {
                    this.showMessage('Error de conexión. Verifica que el backend esté ejecutándose en http://localhost:3000', 'error');
                } else {
                    this.showMessage(`Error al cargar las reservas: ${error.message || 'Error desconocido'}`, 'error');
                }
                this.isLoading = false;
            }
        });
    }

    // Aplicar filtros
    applyFilters() {
        let filtered = [...this.allReservations];
        
        // Filtrar por estado
        if (this.statusFilter !== 'todas') {
            filtered = this.adminReservasService.filterReservationsByStatus(filtered, this.statusFilter);
        }
        
        // Filtrar por fecha
        if (this.dateFilter) {
            filtered = this.adminReservasService.filterReservationsByDate(filtered, this.dateFilter);
        }
        
        this.filteredReservations = filtered;
    }

    // Cambiar filtro de estado
    onStatusFilterChange() {
        this.applyFilters();
    }

    // Cambiar filtro de fecha
    onDateFilterChange() {
        this.applyFilters();
    }

    // Limpiar filtros
    clearFilters() {
        this.statusFilter = 'todas';
        this.dateFilter = '';
        this.applyFilters();
    }

    // Seleccionar reserva para editar
    selectReservation(reservation: TableReservation) {
        this.selectedReservation = { ...reservation };
        this.isEditing = true;
    }

    // Cancelar edición
    cancelEdit() {
        this.selectedReservation = null;
        this.isEditing = false;
    }

    // Guardar cambios de la reserva
    saveReservation() {
        if (!this.selectedReservation || !this.selectedReservation.id) return;

        this.isLoading = true;
        this.adminReservasService.updateReservation(
            this.selectedReservation.id,
            {
                status: this.selectedReservation.status,
                comments: this.selectedReservation.comments
            }
        ).subscribe({
            next: (response) => {
                if (response.success) {
                    this.showMessage('Reserva actualizada exitosamente', 'success');
                    this.loadReservations();
                    this.cancelEdit();
                } else {
                    this.showMessage('Error: ' + (response.errors?.join(', ') || 'Error desconocido'), 'error');
                }
                this.isLoading = false;
            },
            error: (error) => {
                console.error('Error al actualizar reserva:', error);
                this.showMessage('Error al actualizar la reserva', 'error');
                this.isLoading = false;
            }
        });
    }

    // Eliminar reserva
    deleteReservation(reservation: TableReservation) {
        if (!reservation.id) return;

        if (confirm(`¿Estás seguro de que quieres eliminar la reserva de ${reservation.name}?`)) {
            this.isLoading = true;
            this.adminReservasService.deleteReservation(reservation.id).subscribe({
                next: (response) => {
                    if (response.success) {
                        this.showMessage('Reserva eliminada exitosamente', 'success');
                        this.loadReservations();
                    } else {
                        this.showMessage('Error al eliminar la reserva', 'error');
                    }
                    this.isLoading = false;
                },
                error: (error) => {
                    console.error('Error al eliminar reserva:', error);
                    this.showMessage('Error al eliminar la reserva', 'error');
                    this.isLoading = false;
                }
            });
        }
    }

    // Mostrar mensaje
    showMessage(text: string, type: 'success' | 'error' | 'info') {
        this.message = text;
        this.messageType = type;
        setTimeout(() => {
            this.message = '';
        }, 5000);
    }

    // Obtener estadísticas rápidas
    getStats() {
        const total = this.allReservations.length;
        const pending = this.allReservations.filter(r => r.status === 'pendiente').length;
        const confirmed = this.allReservations.filter(r => r.status === 'confirmada').length;
        const cancelled = this.allReservations.filter(r => r.status === 'cancelada').length;

        return { total, pending, confirmed, cancelled };
    }

    // Formatear fecha para mostrar
    formatDisplayDate(dateString: string): string {
        return this.adminReservasService.formatDisplayDate(dateString);
    }

    // Formatear fecha y hora para mostrar
    formatDisplayDateTime(dateString: string, timeString: string): string {
        return this.adminReservasService.formatDisplayDateTime(dateString, timeString);
    }

    // Formatear solo la hora
    formatDisplayTime(timeString: string): string {
        return this.adminReservasService.formatDisplayTime(timeString);
    }

    // Formatear fecha de creación
    formatCreatedAt(dateString: string): string {
        return this.adminReservasService.formatCreatedAt(dateString);
    }

    // Obtener clase CSS para el estado
    getStatusClass(status: string): string {
        return this.adminReservasService.getStatusClass(status);
    }

    // Obtener texto del estado
    getStatusText(status: string): string {
        return this.adminReservasService.getStatusText(status);
    }
}
