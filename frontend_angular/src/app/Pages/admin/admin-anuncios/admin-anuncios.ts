import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AdminAnunciosService, AdminAnuncio } from '../services/admin-anuncios.service';

@Component({
  selector: 'app-admin-anuncios',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-anuncios.html',
  styleUrls: ['./admin-anuncios.css']
})
export class AdminAnunciosComponent implements OnInit, OnDestroy {
  anuncios: AdminAnuncio[] = [];
  anunciosFiltrados: AdminAnuncio[] = [];
  loading = false;
  error: string | null = null;
  success: string | null = null;
  private successTimeout: any = null;
  
  // Filtros de búsqueda
  filtroActivo: string = 'todos';
  filtroTexto: string = '';
  
  // Estados de modales
  showCreateModal = false;
  showEditModal = false;
  showDeleteModal = false;
  selectedAnuncio: AdminAnuncio | null = null;

  // Formulario del modal
  anuncioForm = {
    id: null as number | null,
    activo: true,
    posicion: 0,
    fecha_inicio: '',
    fecha_fin: ''
  };

  // Imagen seleccionada
  selectedImage: File | null = null;
  selectedImagePreview: string | null = null;
  currentImageUrl: string | null = null;

  // PAGINACIÓN
  pageSize = 6;
  currentPage = 1;

  constructor(
    private anunciosService: AdminAnunciosService
  ) {}

  ngOnInit() {
    this.loadAnuncios();
    this.anunciosFiltrados = [...this.anuncios];
  }

  ngOnDestroy() {
    // Limpiar timeout al destruir el componente
    if (this.successTimeout) {
      clearTimeout(this.successTimeout);
    }
  }

  loadAnuncios() {
    this.loading = true;
    this.error = null;
    this.anunciosService.listAnuncios().subscribe({
      next: (anuncios) => {
        this.anuncios = anuncios || [];
        this.currentPage = 1;
        this.aplicarFiltros();
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al cargar los anuncios';
        this.loading = false;
        console.error('Error loading anuncios:', error);
      }
    });
  }

  // ===== FUNCIONES DE MODALES =====
  
  // Modal de crear
  openCreateModal() {
    console.log('Abriendo modal de crear anuncio');
    this.clearForm();
    this.showCreateModal = true;
    this.error = null;
    this.success = null;
  }
  
  closeCreateModal() {
    console.log('Cerrando modal de crear anuncio');
    this.showCreateModal = false;
    this.clearForm();
  }
  
  // Modal de editar
  openEditModal(anuncio: AdminAnuncio) {
    console.log('Abriendo modal de editar anuncio:', anuncio);
    this.selectedAnuncio = anuncio;
    this.anuncioForm = {
      id: anuncio.id || null,
      activo: anuncio.activo ?? true,
      posicion: anuncio.posicion || 0,
      fecha_inicio: anuncio.fecha_inicio ? this.formatDateForInput(anuncio.fecha_inicio) : '',
      fecha_fin: anuncio.fecha_fin ? this.formatDateForInput(anuncio.fecha_fin) : ''
    };
    this.currentImageUrl = anuncio.imagen_url || null;
    this.selectedImage = null;
    this.selectedImagePreview = null;
    this.showEditModal = true;
    this.error = null;
    this.success = null;
  }
  
  closeEditModal() {
    console.log('Cerrando modal de editar anuncio');
    this.showEditModal = false;
    this.selectedAnuncio = null;
    this.clearForm();
  }
  
  // Modal de eliminar
  openDeleteModal(anuncio: AdminAnuncio) {
    console.log('Abriendo modal de eliminar anuncio:', anuncio);
    this.selectedAnuncio = anuncio;
    this.showDeleteModal = true;
    this.error = null;
    this.success = null;
  }
  
  closeDeleteModal() {
    console.log('Cerrando modal de eliminar anuncio');
    this.showDeleteModal = false;
    this.selectedAnuncio = null;
  }

  // ===== OPERACIONES CRUD =====

  createAnuncio() {
    if (!this.validateForm()) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    const anuncioPayload: Partial<AdminAnuncio> = {
      activo: this.anuncioForm.activo,
      posicion: this.anuncioForm.posicion,
      fecha_inicio: this.anuncioForm.fecha_inicio || undefined,
      fecha_fin: this.anuncioForm.fecha_fin || undefined
    };

    this.anunciosService.createAnuncio(anuncioPayload, this.selectedImage || undefined).subscribe({
      next: (response) => {
        this.setSuccessMessage('Anuncio creado exitosamente');
        this.closeCreateModal();
        this.loadAnuncios();
        this.loading = false;
      },
      error: (error) => {
        this.error = error?.error?.errors?.join(', ') || 'Error al crear el anuncio';
        this.loading = false;
        console.error('Error creating anuncio:', error);
      }
    });
  }

  updateAnuncio() {
    if (!this.validateForm() || !this.selectedAnuncio) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    const anuncioPayload: Partial<AdminAnuncio> = {
      activo: this.anuncioForm.activo,
      posicion: this.anuncioForm.posicion,
      fecha_inicio: this.anuncioForm.fecha_inicio || undefined,
      fecha_fin: this.anuncioForm.fecha_fin || undefined
    };

    // Solo enviar imagen si se seleccionó una nueva
    const imagenToSend = this.selectedImage || undefined;

    this.anunciosService.updateAnuncio(this.selectedAnuncio.id!, anuncioPayload, imagenToSend).subscribe({
      next: (response) => {
        this.setSuccessMessage('Anuncio actualizado exitosamente');
        this.closeEditModal();
        this.loadAnuncios();
        this.loading = false;
      },
      error: (error) => {
        this.error = error?.error?.errors?.join(', ') || 'Error al actualizar el anuncio';
        this.loading = false;
        console.error('Error updating anuncio:', error);
      }
    });
  }

  deleteAnuncio() {
    if (!this.selectedAnuncio) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    this.anunciosService.deleteAnuncio(this.selectedAnuncio.id!).subscribe({
      next: (response) => {
        this.setSuccessMessage('Anuncio eliminado exitosamente');
        this.closeDeleteModal();
        this.loadAnuncios();
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al eliminar el anuncio';
        this.loading = false;
        console.error('Error deleting anuncio:', error);
      }
    });
  }

  clearForm() {
    this.anuncioForm = {
      id: null,
      activo: true,
      posicion: 0,
      fecha_inicio: '',
      fecha_fin: ''
    };
    this.selectedImage = null;
    this.selectedImagePreview = null;
    this.currentImageUrl = null;
  }

  // ===== MANEJO DE MENSAJES DE ÉXITO =====

  setSuccessMessage(message: string) {
    this.success = message;
    // Limpiar timeout anterior si existe
    if (this.successTimeout) {
      clearTimeout(this.successTimeout);
    }
    // Ocultar el mensaje después de 3 segundos
    this.successTimeout = setTimeout(() => {
      this.success = null;
    }, 3000);
  }

  // ===== MANEJO DE IMÁGENES =====

  onImageSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.selectedImage = file;

      // Crear preview de la imagen
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.selectedImagePreview = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

  // ===== FUNCIONES AUXILIARES =====

  trackByAnuncioId(index: number, anuncio: AdminAnuncio): number {
    return anuncio.id || index;
  }

  validateForm(): boolean {
    if (this.anuncioForm.posicion < 0) {
      this.error = 'La posición debe ser mayor o igual a 0';
      return false;
    }
    if (this.anuncioForm.fecha_inicio && this.anuncioForm.fecha_fin) {
      const inicio = new Date(this.anuncioForm.fecha_inicio);
      const fin = new Date(this.anuncioForm.fecha_fin);
      if (fin < inicio) {
        this.error = 'La fecha de fin debe ser posterior a la fecha de inicio';
        return false;
      }
    }
    return true;
  }

  formatDateForInput(dateString: string): string {
    // Convierte una fecha ISO a formato YYYY-MM-DD para el input type="date"
    const date = new Date(dateString);
    return date.toISOString().split('T')[0];
  }

  getEstadoText(activo: boolean): string {
    return activo ? 'Activo' : 'Inactivo';
  }

  getEstadoClass(activo: boolean): string {
    return activo ? 'estado-activo' : 'estado-inactivo';
  }

  // ===== MÉTODOS DE FILTRADO Y PAGINACIÓN =====
  
  aplicarFiltros() {
    let anunciosFiltrados = [...this.anuncios];

    // Filtrar por estado activo
    if (this.filtroActivo && this.filtroActivo !== 'todos') {
      const activo = this.filtroActivo === 'activo';
      anunciosFiltrados = anunciosFiltrados.filter(anuncio => 
        anuncio.activo === activo
      );
    }

    // Filtrar por texto (búsqueda general)
    const texto = (this.filtroTexto || '').toString().toLowerCase().trim();
    if (texto) {
      anunciosFiltrados = anunciosFiltrados.filter(anuncio => {
        const posicion = String(anuncio.posicion || '').toLowerCase();
        return posicion.includes(texto);
      });
    }

    this.anunciosFiltrados = anunciosFiltrados;
    this.currentPage = 1;
    this.ensureCurrentPageInRange();
  }

  onFiltroActivoChange() {
    this.aplicarFiltros();
  }

  onFiltroTextoChange() {
    this.aplicarFiltros();
  }

  limpiarFiltros() {
    this.filtroActivo = 'todos';
    this.filtroTexto = '';
    this.aplicarFiltros();
  }

  // PAGINACIÓN ------------------------------------------------
  get totalPages(): number {
    return Math.max(1, Math.ceil(this.anunciosFiltrados.length / this.pageSize));
  }

  get paginatedAnuncios(): AdminAnuncio[] {
    const start = (this.currentPage - 1) * this.pageSize;
    return this.anunciosFiltrados.slice(start, start + this.pageSize);
  }

  ensureCurrentPageInRange(): void {
    if (this.currentPage > this.totalPages) this.currentPage = this.totalPages;
    if (this.currentPage < 1) this.currentPage = 1;
  }

  goToPage(page: number): void {
    if (page < 1 || page > this.totalPages) return;
    this.currentPage = page;
  }

  nextPage(): void {
    if (this.currentPage < this.totalPages) this.currentPage++;
  }

  prevPage(): void {
    if (this.currentPage > 1) this.currentPage--;
  }
  // -----------------------------------------------------------
}

