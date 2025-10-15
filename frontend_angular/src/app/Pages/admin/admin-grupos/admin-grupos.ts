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
        this.clearForm();
        this.loadGrupos();
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al crear el grupo';
        this.loading = false;
        console.error('Error creating grupo:', error);
      }
    });
  }

  editGrupo(grupo: AdminGrupo) {
    this.isEditing = true;
    this.currentGrupo = grupo;
    this.grupoForm = {
      nombre: grupo.nombre,
      slug: grupo.slug,
      descripcion: grupo.descripcion || ''
    };
    this.selectedFile = null;
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
        this.cancelEdit();
        this.loadGrupos();
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al actualizar el grupo';
        this.loading = false;
        console.error('Error updating grupo:', error);
      }
    });
  }

  deleteGrupo(id: number) {
    if (!confirm('¿Estás seguro de que quieres eliminar este grupo?')) {
      return;
    }

    this.loading = true;
    this.error = null;
    this.success = null;

    this.gruposService.deleteGrupo(id).subscribe({
      next: (response) => {
        this.success = 'Grupo eliminado exitosamente';
        this.loadGrupos();
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al eliminar el grupo';
        this.loading = false;
        console.error('Error deleting grupo:', error);
      }
    });
  }

  cancelEdit() {
    this.isEditing = false;
    this.currentGrupo = null;
    this.clearForm();
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
}