import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, catchError, of, map } from 'rxjs';

export interface AdminAnuncio {
  id?: number;
  activo: boolean;
  posicion: number;
  fecha_inicio?: string;
  fecha_fin?: string;
  imagen_url?: string;
  created_at?: string;
  updated_at?: string;
}

interface AnunciosResponse {
  success: boolean;
  anuncios: AdminAnuncio[];
}

interface AnuncioResponse {
  success: boolean;
  anuncio: AdminAnuncio;
}

interface AnuncioMessageResponse {
  success: boolean;
  message: string;
}

@Injectable({
  providedIn: 'root'
})
export class AdminAnunciosService {
  private apiUrl = 'http://localhost:3000/api/v1/admin/anuncios';

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('auth_token');
    return new HttpHeaders({
      'Authorization': token || '',
      'Content-Type': 'application/json'
    });
  }

  private getHeadersForFormData(): HttpHeaders {
    const token = localStorage.getItem('auth_token');
    return new HttpHeaders({
      'Authorization': token || ''
      // No establecer Content-Type para FormData - el navegador lo hace automáticamente
    });
  }

  listAnuncios(): Observable<AdminAnuncio[]> {
    return this.http.get<AnunciosResponse>(this.apiUrl, { headers: this.getHeaders() })
      .pipe(
        map(response => response.anuncios || []),
        catchError(error => {
          console.error('Error fetching anuncios:', error);
          return of([]);
        })
      );
  }

  getAnuncio(id: number): Observable<AdminAnuncio> {
    return this.http.get<AnuncioResponse>(`${this.apiUrl}/${id}`, { headers: this.getHeaders() })
      .pipe(
        map(response => response.anuncio),
        catchError(error => {
          console.error('Error fetching anuncio:', error);
          throw error;
        })
      );
  }

  createAnuncio(anuncio: Partial<AdminAnuncio>, imagen?: File): Observable<any> {
    const formData = new FormData();
    
    // Agregar campos del anuncio
    if (anuncio.activo !== undefined) {
      formData.append('activo', anuncio.activo ? 'true' : 'false');
    }
    if (anuncio.posicion !== undefined) {
      formData.append('posicion', String(anuncio.posicion));
    }
    if (anuncio.fecha_inicio) {
      formData.append('fecha_inicio', anuncio.fecha_inicio);
    }
    if (anuncio.fecha_fin) {
      formData.append('fecha_fin', anuncio.fecha_fin);
    }
    
    // Agregar imagen si existe
    if (imagen) {
      formData.append('imagen', imagen);
    }

    return this.http.post(this.apiUrl, formData, { headers: this.getHeadersForFormData() })
      .pipe(
        catchError(error => {
          console.error('Error creating anuncio:', error);
          throw error;
        })
      );
  }

  updateAnuncio(id: number, anuncio: Partial<AdminAnuncio>, imagen?: File): Observable<any> {
    const formData = new FormData();
    
    // Agregar campos del anuncio
    if (anuncio.activo !== undefined) {
      formData.append('activo', anuncio.activo ? 'true' : 'false');
    }
    if (anuncio.posicion !== undefined) {
      formData.append('posicion', String(anuncio.posicion));
    }
    if (anuncio.fecha_inicio) {
      formData.append('fecha_inicio', anuncio.fecha_inicio);
    }
    if (anuncio.fecha_fin) {
      formData.append('fecha_fin', anuncio.fecha_fin);
    }
    
    // Agregar imagen si existe
    if (imagen) {
      formData.append('imagen', imagen);
    }

    return this.http.patch(`${this.apiUrl}/${id}`, formData, { headers: this.getHeadersForFormData() })
      .pipe(
        catchError(error => {
          console.error('Error updating anuncio:', error);
          throw error;
        })
      );
  }

  deleteAnuncio(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${id}`, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error deleting anuncio:', error);
          throw error;
        })
      );
  }
}

