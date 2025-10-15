import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, catchError, of } from 'rxjs';

export interface Promocion {
  id: number;
  nombre: string;
  precio_total: number;
  precio_original: number;
  descuento: number;
  producto_id: number;
  imagen_url?: string;
  created_at: string;
  updated_at: string;
  producto?: {
    id: number;
    name: string;
    precio: number;
    descripcion: string;
  };
}

export interface CreatePromocionRequest {
  promocion: {
    nombre: string;
    precio_total: number;
    precio_original: number;
    descuento: number;
    producto_id: number;
    imagen?: File;
  };
}

export interface UpdatePromocionRequest {
  promocion: {
    nombre?: string;
    precio_total?: number;
    precio_original?: number;
    descuento?: number;
    producto_id?: number;
    imagen?: File;
  };
}

@Injectable({
  providedIn: 'root'
})
export class AdminPromocionesService {
  private apiUrl = 'http://localhost:3000/api/v1';

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('auth_token');
    return new HttpHeaders({
      'Authorization': token || '',
      'Content-Type': 'application/json'
    });
  }

  getPromociones(): Observable<Promocion[]> {
    return this.http.get<Promocion[]>(`${this.apiUrl}/promociones`, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error fetching promociones:', error);
          return of([]);
        })
      );
  }

  getPromocion(id: number): Observable<Promocion> {
    return this.http.get<Promocion>(`${this.apiUrl}/promociones/${id}`, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error fetching promocion:', error);
          throw error;
        })
      );
  }

  createPromocion(payload: CreatePromocionRequest): Observable<any> {
    const formData = new FormData();
    
    // Agregar todos los campos del payload
    Object.keys(payload.promocion).forEach(key => {
      const value = payload.promocion[key as keyof typeof payload.promocion];
      if (value !== undefined && value !== null) {
        if (value instanceof File) {
          formData.append(`promocion[${key}]`, value);
        } else {
          formData.append(`promocion[${key}]`, String(value));
        }
      }
    });

    const headers = new HttpHeaders({
      'Authorization': localStorage.getItem('auth_token') || ''
      // No establecer Content-Type para FormData - el navegador lo hace automáticamente
    });

    return this.http.post(`${this.apiUrl}/promociones`, formData, { headers })
      .pipe(
        catchError(error => {
          console.error('Error creating promocion:', error);
          throw error;
        })
      );
  }

  updatePromocion(id: number, payload: UpdatePromocionRequest): Observable<any> {
    const formData = new FormData();
    
    // Agregar todos los campos del payload
    Object.keys(payload.promocion).forEach(key => {
      const value = payload.promocion[key as keyof typeof payload.promocion];
      if (value !== undefined && value !== null) {
        if (value instanceof File) {
          formData.append(`promocion[${key}]`, value);
        } else {
          formData.append(`promocion[${key}]`, String(value));
        }
      }
    });

    const headers = new HttpHeaders({
      'Authorization': localStorage.getItem('auth_token') || ''
      // No establecer Content-Type para FormData - el navegador lo hace automáticamente
    });

    return this.http.patch(`${this.apiUrl}/promociones/${id}`, formData, { headers })
      .pipe(
        catchError(error => {
          console.error('Error updating promocion:', error);
          throw error;
        })
      );
  }

  deletePromocion(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/promociones/${id}`, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error deleting promocion:', error);
          throw error;
        })
      );
  }

  getProductos(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/productos`, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error fetching productos:', error);
          return of([]);
        })
      );
  }
}
