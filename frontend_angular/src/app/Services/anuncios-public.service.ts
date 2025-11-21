import { Injectable } from '@angular/core';
import { Observable, map, catchError, of } from 'rxjs';
import { HttpClient } from '@angular/common/http';

export interface AnuncioPublico {
  id: number;
  posicion: number;
  imagen_url?: string;
  fecha_inicio?: string;
  fecha_fin?: string;
}

interface AnunciosPublicResponse {
  success: boolean;
  anuncios: AnuncioPublico[];
}

@Injectable({
  providedIn: 'root'
})
export class AnunciosPublicService {
  private apiUrl = 'http://localhost:3000/api/v1';
  
  constructor(private http: HttpClient) {}

  /**
   * Obtiene los anuncios públicos visibles (no requiere autenticación)
   */
  getAnunciosPublicos(): Observable<AnuncioPublico[]> {
    return this.http.get<AnunciosPublicResponse>(`${this.apiUrl}/anuncios`).pipe(
      map(response => response.anuncios || []),
      catchError(error => {
        console.error('Error obteniendo anuncios públicos:', error);
        return of([]);
      })
    );
  }
}

