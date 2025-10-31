import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AdminGruposService, AdminGrupo } from '../services/grupos.service';


@Component({
  selector: 'app-admin-grupos',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-grupos.html',
  styleUrls: ['./admin-grupos.css']
})
export class AdminGruposComponent implements OnInit {
  grupos: AdminGrupo[] = [];
  loading = false;
  error: string | null = null;
  success: string | null = null;
  isEditing = false;
  currentGrupo: AdminGrupo | null = null;
  selectedFile: File | null = null;

  grupoForm = {
    nombre: '',
    slug: '',
    descripcion: ''
  };

  // Variables para los modales
  showModal = false;
  showDeleteModal = false;
  grupoToDelete: any = null;
  currentImageUrl = '';

  constructor(private gruposService: AdminGruposService) {}

  ngOnInit() {
    this.loadGrupos();
  }

  loadGrupos() {
    this.loading = true;
    this.error = null;
    
    this.gruposService.listGrupos().subscribe({
      next: (grupos) => {
        this.grupos = grupos;
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al cargar los grupos';
        this.loading = false;
        console.error('Error loading grupos:', error);
      }
    });
  }

  createGrupo() {
    if (!this.validateForm()) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    const grupo: AdminGrupo = {
      nombre: this.grupoForm.nombre,
      slug: this.grupoForm.slug,
      descripcion: this.grupoForm.descripcion
    };

    this.gruposService.createGrupo(grupo, this.selectedFile || undefined).subscribe({
      next: (response) => {
        this.success = 'Grupo creado exitosamente';
        this.loading = false;
        this.closeModal(); // Cerrar modal después de crear
        this.loadGrupos();
        
        // Mostrar mensaje de éxito por 3 segundos
        setTimeout(() => {
          this.success = null;
        }, 3000);
      },
      error: (error) => {
        this.error = 'Error al crear el grupo';
        this.loading = false;
        console.error('Error creating grupo:', error);
      }
    });
  }

  updateGrupo() {
    if (!this.validateForm() || !this.currentGrupo) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    const grupo: AdminGrupo = {
      id: this.currentGrupo.id,
      nombre: this.grupoForm.nombre,
      slug: this.grupoForm.slug,
      descripcion: this.grupoForm.descripcion
    };

    this.gruposService.updateGrupo(this.currentGrupo.id!, grupo, this.selectedFile || undefined).subscribe({
      next: (response) => {
        this.success = 'Grupo actualizado exitosamente';
        this.loading = false;
        this.closeModal(); // Cerrar modal después de actualizar
        this.loadGrupos();
        
        // Mostrar mensaje de éxito por 3 segundos
        setTimeout(() => {
          this.success = null;
        }, 3000);
      },
      error: (error) => {
        this.error = 'Error al actualizar el grupo';
        this.loading = false;
        console.error('Error updating grupo:', error);
      }
    });
  }

  // Función mantenida para compatibilidad, pero ahora usa el modal
  cancelEdit() {
    this.closeModal();
  }

  clearForm() {
    this.grupoForm = {
      nombre: '',
      slug: '',
      descripcion: ''
    };
    this.selectedFile = null;
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.selectedFile = file;
    }
  }

  validateForm(): boolean {
    if (!this.grupoForm.nombre.trim()) {
      this.error = 'El nombre del grupo es requerido';
      return false;
    }
    if (!this.grupoForm.slug.trim()) {
      this.error = 'El slug del grupo es requerido';
      return false;
    }
    return true;
  }

  // ===== FUNCIONES DE MODAL =====

  // Abrir modal para crear nuevo grupo
  openCreateModal() {
    console.log('openCreateModal called'); // Debug
    this.isEditing = false;
    this.currentGrupo = null;
    this.clearForm();
    this.currentImageUrl = '';
    this.showModal = true;
    this.error = null;
    this.success = null;
    console.log('showModal set to:', this.showModal); // Debug
  }

  // Abrir modal para editar grupo existente
  openEditModal(grupo: AdminGrupo) {
    console.log('openEditModal called with:', grupo); // Debug
    this.isEditing = true;
    this.currentGrupo = grupo;
    this.grupoForm = {
      nombre: grupo.nombre,
      slug: grupo.slug,
      descripcion: grupo.descripcion || ''
    };
    this.currentImageUrl = grupo.foto_url || '';
    this.selectedFile = null;
    this.showModal = true;
    this.error = null;
    this.success = null;
    console.log('showModal set to:', this.showModal); // Debug
  }

  // Cerrar modal principal
  closeModal() {
    this.showModal = false;
    this.isEditing = false;
    this.currentGrupo = null;
    this.clearForm();
    this.currentImageUrl = '';
    this.error = null;
    this.success = null;
  }

  // Confirmar eliminación - abrir modal de confirmación
  confirmDeleteGrupo(grupo: AdminGrupo) {
    this.grupoToDelete = grupo;
    this.showDeleteModal = true;
  }

  // Cerrar modal de eliminación
  closeDeleteModal() {
    this.showDeleteModal = false;
    this.grupoToDelete = null;
  }

  // Ejecutar eliminación después de confirmación
  executeDelete() {
    if (this.grupoToDelete) {
      this.loading = true;
      this.error = null;
      this.success = null;

      this.gruposService.deleteGrupo(this.grupoToDelete.id!).subscribe({
        next: (response) => {
          this.success = 'Grupo eliminado exitosamente';
          this.loadGrupos();
          this.loading = false;
          this.closeDeleteModal();
        },
        error: (error) => {
          this.error = 'Error al eliminar el grupo';
          this.loading = false;
          console.error('Error deleting grupo:', error);
        }
      });
    }
  }
}