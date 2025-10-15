import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, catchError, of } from 'rxjs';

export interface AdminGrupo {
  id?: number;
  nombre: string;
  slug: string;
  descripcion?: string;
  foto_url?: string;
}

@Injectable({
  providedIn: 'root'
})
export class AdminGruposService {
  private apiUrl = 'http://localhost:3000/api/v1/grupos';

  constructor(private http: HttpClient) {}

  private getHeaders(): HttpHeaders {
    const token = localStorage.getItem('auth_token');
    return new HttpHeaders({
      'Authorization': token || '',
      'Content-Type': 'application/json'
    });
  }

  listGrupos(): Observable<AdminGrupo[]> {
    return this.http.get<AdminGrupo[]>(this.apiUrl, { headers: this.getHeaders() })
      .pipe(
        catchError(error => {
          console.error('Error fetching grupos:', error);
          return of([]);
        })
      );
  }

  createGrupo(grupo: AdminGrupo, foto?: File): Observable<any> {
    const formData = new FormData();
    formData.append('grupo[nombre]', grupo.nombre);
    formData.append('grupo[slug]', grupo.slug);
    if (grupo.descripcion) {
      formData.append('grupo[descripcion]', grupo.descripcion);
    }
    if (foto) {
      formData.append('grupo[foto]', foto);
    }

    const token = localStorage.getItem('auth_token');
    const headers = new HttpHeaders({
      'Authorization': token || ''
    });

    return this.http.post(this.apiUrl, formData, { headers });
  }

  updateGrupo(id: number, grupo: AdminGrupo, foto?: File): Observable<any> {
    const formData = new FormData();
    formData.append('grupo[nombre]', grupo.nombre);
    formData.append('grupo[slug]', grupo.slug);
    if (grupo.descripcion) {
      formData.append('grupo[descripcion]', grupo.descripcion);
    }
    if (foto) {
      formData.append('grupo[foto]', foto);
    }

    const token = localStorage.getItem('auth_token');
    const headers = new HttpHeaders({
      'Authorization': token || ''
    });

    return this.http.put(`${this.apiUrl}/${id}`, formData, { headers });
  }

  deleteGrupo(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${id}`, { headers: this.getHeaders() });
  }
}
