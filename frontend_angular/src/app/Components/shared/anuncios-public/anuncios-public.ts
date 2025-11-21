import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AnunciosPublicService, AnuncioPublico } from '../../../Services/anuncios-public.service';

@Component({
  selector: 'app-anuncios-public',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './anuncios-public.html',
  styleUrls: ['./anuncios-public.css']
})
export class AnunciosPublicComponent implements OnInit, OnDestroy {
  anuncios: AnuncioPublico[] = [];
  currentAnuncioIndex = 0;
  showModal = false;
  loading = false;

  constructor(private anunciosService: AnunciosPublicService) {}

  ngOnInit() {
    // Mostrar anuncios cada vez que se actualiza la página
    this.loadAnuncios();
  }

  ngOnDestroy() {
    // No es necesario limpiar nada aquí
  }

  loadAnuncios() {
    this.loading = true;
    this.anunciosService.getAnunciosPublicos().subscribe({
      next: (anuncios) => {
        this.anuncios = anuncios || [];
        
        // Ordenar por posición
        this.anuncios.sort((a, b) => a.posicion - b.posicion);
        
        // Solo mostrar si hay anuncios
        if (this.anuncios.length > 0) {
          this.showModal = true;
          this.currentAnuncioIndex = 0;
        }
        
        this.loading = false;
      },
      error: (error) => {
        console.error('Error cargando anuncios:', error);
        this.loading = false;
      }
    });
  }

  closeModal() {
    this.showModal = false;
  }

  nextAnuncio() {
    if (this.currentAnuncioIndex < this.anuncios.length - 1) {
      this.currentAnuncioIndex++;
    } else {
      // Si es el último, cerrar el modal
      this.closeModal();
    }
  }

  prevAnuncio() {
    if (this.currentAnuncioIndex > 0) {
      this.currentAnuncioIndex--;
    }
  }

  goToAnuncio(index: number) {
    if (index >= 0 && index < this.anuncios.length) {
      this.currentAnuncioIndex = index;
    }
  }

  get currentAnuncio(): AnuncioPublico | null {
    return this.anuncios[this.currentAnuncioIndex] || null;
  }

  get hasMultipleAnuncios(): boolean {
    return this.anuncios.length > 1;
  }
}

