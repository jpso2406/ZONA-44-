import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Producto {
  id: number;
  name: string;
  precio: number;
  descripcion: string;
  foto_url: string;
}

export interface Grupo {
  id: number;
  nombre: string;
  slug: string;
  foto_url: string;
  productos: Producto[];
}

@Injectable({
  providedIn: 'root'
})
export class MenuService {
  private apiUrl = 'http://localhost:3000/api/v1/grupos'; // 👈 tu endpoint Rails

  constructor(private http: HttpClient) {}

  getGrupos(): Observable<Grupo[]> {
    return this.http.get<Grupo[]>(this.apiUrl);
  }
}
