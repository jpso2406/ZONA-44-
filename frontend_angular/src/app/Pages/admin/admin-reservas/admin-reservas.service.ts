import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from '../../auth/auth.service';

export interface TableReservation {
  id?: number;
  name: string;
  email: string;
  phone: string;
  date: string;
  time: string;
  people_count: number;
  comments?: string;
  status?: string;
  user_id?: number;
  created_at?: string;
  updated_at?: string;
}

export interface AdminReservationResponse {
  success: boolean;
  reservation?: TableReservation;
  errors?: string[];
}

@Injectable({
  providedIn: 'root'
})
export class AdminReservasService {
  private apiUrl = 'http://localhost:3000/api/v1';

  constructor(
    private http: HttpClient,
    private authService: AuthService
  ) { }

  // Obtener headers con autenticación
  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('auth_token');
    console.log('Token found:', token ? 'Yes' : 'No');
    console.log('Token value:', token);
    
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token || ''
    });

    return headers;
  }

  // Obtener todas las reservas (admin)
  getAllReservations(): Observable<TableReservation[]> {
    console.log('Making request to:', `${this.apiUrl}/admin/table_reservations`);
    console.log('Headers being sent:', this.getHeaders());
    
    return this.http.get<TableReservation[]>(
      `${this.apiUrl}/admin/table_reservations`,
      { 
        headers: this.getHeaders()
        // withCredentials: true  // Comentado temporalmente por CORS
      }
    );
  }

  // Obtener una reserva específica (admin)
  getReservation(id: number): Observable<TableReservation> {
    return this.http.get<TableReservation>(
      `${this.apiUrl}/admin/table_reservations/${id}`,
      { 
        headers: this.getHeaders()
        // withCredentials: true  // Comentado temporalmente por CORS
      }
    );
  }

  // Actualizar reserva (admin)
  updateReservation(id: number, reservation: Partial<TableReservation>): Observable<AdminReservationResponse> {
    return this.http.patch<AdminReservationResponse>(
      `${this.apiUrl}/admin/table_reservations/${id}`,
      { table_reservation: reservation },
      { 
        headers: this.getHeaders()
        // withCredentials: true  // Comentado temporalmente por CORS
      }
    );
  }

  // Eliminar reserva (admin)
  deleteReservation(id: number): Observable<{ success: boolean }> {
    return this.http.delete<{ success: boolean }>(
      `${this.apiUrl}/admin/table_reservations/${id}`,
      { 
        headers: this.getHeaders()
        // withCredentials: true  // Comentado temporalmente por CORS
      }
    );
  }

  // Filtrar reservas por estado
  filterReservationsByStatus(reservations: TableReservation[], status: string): TableReservation[] {
    if (status === 'todas') return reservations;
    return reservations.filter(reservation => reservation.status === status);
  }

  // Filtrar reservas por fecha
  filterReservationsByDate(reservations: TableReservation[], date: string): TableReservation[] {
    if (!date) return reservations;
    return reservations.filter(reservation => reservation.date === date);
  }

  // Formatear fecha para mostrar
  formatDisplayDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-ES', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  }

  // Formatear fecha y hora para mostrar
  formatDisplayDateTime(dateString: string, timeString: string): string {
    if (!dateString) return '';
    const date = new Date(`${dateString}T${timeString}`);
    if (isNaN(date.getTime())) return '';
    return date.toLocaleString('es-ES', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  // Formatear solo la hora (extrae HH:mm de un string de tiempo)
  formatDisplayTime(timeString: string): string {
    if (!timeString) return '';
    
    // Si viene como ISO string completo (ej: "2000-01-01T21:00:00.000Z")
    if (timeString.includes('T')) {
      const date = new Date(timeString);
      if (!isNaN(date.getTime())) {
        return date.toLocaleTimeString('es-ES', {
          hour: '2-digit',
          minute: '2-digit',
          hour12: false
        });
      }
    }
    
    // Si viene como "HH:mm" o "HH:mm:ss", extraer solo HH:mm
    if (timeString.match(/^\d{2}:\d{2}/)) {
      return timeString.substring(0, 5);
    }
    
    return timeString;
  }

  // Formatear fecha de creación (created_at)
  formatCreatedAt(dateString: string): string {
    if (!dateString) return '';
    const date = new Date(dateString);
    if (isNaN(date.getTime())) return '';
    return date.toLocaleString('es-ES', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  // Obtener clase CSS para el estado
  getStatusClass(status: string): string {
    switch (status) {
      case 'pendiente':
        return 'status-pending';
      case 'confirmada':
        return 'status-confirmed';
      case 'cancelada':
        return 'status-cancelled';
      default:
        return 'status-unknown';
    }
  }

  // Obtener texto del estado
  getStatusText(status: string): string {
    switch (status) {
      case 'pendiente':
        return 'Pendiente';
      case 'confirmada':
        return 'Confirmada';
      case 'cancelada':
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }

  // Obtener opciones de estado para el select
  getStatusOptions() {
    return [
      { value: 'pendiente', label: 'Pendiente' },
      { value: 'confirmada', label: 'Confirmada' },
      { value: 'cancelada', label: 'Cancelada' }
    ];
  }
}
