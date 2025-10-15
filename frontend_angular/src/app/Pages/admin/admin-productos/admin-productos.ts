import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AdminProductosService, AdminProducto } from '../services/productos.service';
import { AdminGruposService, AdminGrupo } from '../services/grupos.service';

@Component({
  selector: 'app-admin-productos',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-productos.html',
  styleUrls: ['./admin-productos.css']
})
export class AdminProductosComponent implements OnInit {
  productos: AdminProducto[] = [];
  grupos: AdminGrupo[] = [];
  loading = false;
  error: string | null = null;
  success: string | null = null;
  isEditing = false;
  currentProducto: AdminProducto | null = null;

  productoForm = {
    nombre: '',
    precio: 0,
    descripcion: '',
    grupo_id: 0,
    stock: 0,
    activo: true
  };

  constructor(
    private productosService: AdminProductosService,
    private gruposService: AdminGruposService
  ) {}

  ngOnInit() {
    this.loadProductos();
    this.loadGrupos();
  }

  loadProductos() {
    this.loading = true;
    this.error = null;
    
    this.productosService.listProductos().subscribe({
      next: (productos) => {
        this.productos = productos;
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al cargar los productos';
        this.loading = false;
        console.error('Error loading productos:', error);
      }
    });
  }

  loadGrupos() {
    this.gruposService.listGrupos().subscribe({
      next: (grupos) => {
        this.grupos = grupos;
      },
      error: (error) => {
        console.error('Error loading grupos:', error);
      }
    });
  }

  createProducto() {
    if (!this.validateForm()) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    const producto: AdminProducto = {
      nombre: this.productoForm.nombre,
      precio: this.productoForm.precio,
      descripcion: this.productoForm.descripcion,
      grupo_id: this.productoForm.grupo_id,
      stock: this.productoForm.stock || 0,
      activo: this.productoForm.activo
    };

    this.productosService.createProducto(producto).subscribe({
      next: (response) => {
        this.success = 'Producto creado exitosamente';
        this.clearForm();
        this.loadProductos();
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al crear el producto';
        this.loading = false;
        console.error('Error creating producto:', error);
      }
    });
  }

  editProducto(producto: AdminProducto) {
    this.isEditing = true;
    this.currentProducto = producto;
    this.productoForm = {
      nombre: producto.nombre,
      precio: producto.precio,
      descripcion: producto.descripcion || '',
      grupo_id: producto.grupo_id,
      stock: producto.stock || 0,
      activo: producto.activo !== false
    };
  }

  updateProducto() {
    if (!this.validateForm() || !this.currentProducto) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    const producto: AdminProducto = {
      id: this.currentProducto.id,
      nombre: this.productoForm.nombre,
      precio: this.productoForm.precio,
      descripcion: this.productoForm.descripcion,
      grupo_id: this.productoForm.grupo_id,
      stock: this.productoForm.stock || 0,
      activo: this.productoForm.activo
    };

    this.productosService.updateProducto(this.currentProducto.id!, producto).subscribe({
      next: (response) => {
        this.success = 'Producto actualizado exitosamente';
        this.cancelEdit();
        this.loadProductos();
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al actualizar el producto';
        this.loading = false;
        console.error('Error updating producto:', error);
      }
    });
  }

  deleteProducto(id: number) {
    if (!confirm('¿Estás seguro de que quieres eliminar este producto?')) {
      return;
    }

    this.loading = true;
    this.error = null;
    this.success = null;

    this.productosService.deleteProducto(id).subscribe({
      next: (response) => {
        this.success = 'Producto eliminado exitosamente';
        this.loadProductos();
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al eliminar el producto';
        this.loading = false;
        console.error('Error deleting producto:', error);
      }
    });
  }

  cancelEdit() {
    this.isEditing = false;
    this.currentProducto = null;
    this.clearForm();
  }

  clearForm() {
    this.productoForm = {
      nombre: '',
      precio: 0,
      descripcion: '',
      grupo_id: 0,
      stock: 0,
      activo: true
    };
  }

  getGrupoNombre(grupoId: number): string {
    const grupo = this.grupos.find(g => g.id === grupoId);
    return grupo ? grupo.nombre : 'Sin grupo';
  }

  validateForm(): boolean {
    if (!this.productoForm.nombre.trim()) {
      this.error = 'El nombre del producto es requerido';
      return false;
    }
    if (!this.productoForm.precio || this.productoForm.precio <= 0) {
      this.error = 'El precio debe ser mayor a 0';
      return false;
    }
    if (!this.productoForm.grupo_id) {
      this.error = 'Debe seleccionar un grupo';
      return false;
    }
    return true;
  }
}