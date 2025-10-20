import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

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

export interface ReservationResponse {
  success: boolean;
  reservation?: TableReservation;
  errors?: string[];
}

@Injectable({
  providedIn: 'root'
})
export class ReservasService {
  private apiUrl = 'http://localhost:3000/api/v1';
  private headers = new HttpHeaders({
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  constructor(private http: HttpClient) { }

  // Crear una nueva reserva
  createReservation(reservation: TableReservation): Observable<ReservationResponse> {
    return this.http.post<ReservationResponse>(
      `${this.apiUrl}/table_reservations`,
      { table_reservation: reservation },
      { headers: this.headers }
    );
  }

  // Obtener todas las reservas del usuario
  getUserReservations(): Observable<TableReservation[]> {
    return this.http.get<TableReservation[]>(
      `${this.apiUrl}/table_reservations`,
      { headers: this.headers }
    );
  }

  // Obtener una reserva específica
  getReservation(id: number): Observable<TableReservation> {
    return this.http.get<TableReservation>(
      `${this.apiUrl}/table_reservations/${id}`,
      { headers: this.headers }
    );
  }

  // Cancelar una reserva
  cancelReservation(id: number): Observable<{ success: boolean }> {
    return this.http.patch<{ success: boolean }>(
      `${this.apiUrl}/table_reservations/${id}/cancel`,
      {},
      { headers: this.headers }
    );
  }

  // Formatear fecha para el input date
  formatDateForInput(date: Date): string {
    return date.toISOString().split('T')[0];
  }

  // Formatear hora para el input time
  formatTimeForInput(time: string): string {
    return time;
  }

  // Validar que la fecha no sea en el pasado
  isDateValid(date: string, time: string): boolean {
    const selectedDateTime = new Date(`${date}T${time}`);
    const now = new Date();
    return selectedDateTime > now;
  }
}
