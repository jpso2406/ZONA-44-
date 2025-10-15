import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, catchError, of } from 'rxjs';

export interface AdminProducto {
  id?: number;
  nombre: string;
  precio: number;
  descripcion?: string;
  grupo_id: number;
  stock?: number;
  activo?: boolean;
  foto_url?: string;
}

@Injectable({
  providedIn: 'root'
})
export class AdminProductosService {
  private apiUrl = 'http://localhost:3000/api/v1/productos';

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('auth_token');
    return new HttpHeaders({
      'Authorization': token || '',
      'Content-Type': 'application/json'
    });
  }

  listProductos(): Observable<AdminProducto[]> {
    return this.http.get<AdminProducto[]>(this.apiUrl, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error fetching productos:', error);
          return of([]);
        })
      );
  }

  createProducto(producto: AdminProducto): Observable<any> {
    return this.http.post(this.apiUrl, { producto }, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error creating producto:', error);
          throw error;
        })
      );
  }

  updateProducto(id: number, producto: AdminProducto): Observable<any> {
    return this.http.put(`${this.apiUrl}/${id}`, { producto }, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error updating producto:', error);
          throw error;
        })
      );
  }

  deleteProducto(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${id}`, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error deleting producto:', error);
          throw error;
        })
      );
  }
}
