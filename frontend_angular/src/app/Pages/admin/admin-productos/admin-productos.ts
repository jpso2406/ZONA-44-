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
  productosFiltrados: AdminProducto[] = [];
  grupos: AdminGrupo[] = [];
  loading = false;
  error: string | null = null;
  success: string | null = null;
  
  // Filtros de búsqueda
  filtroGrupo: number | string = '';
  filtroTexto: string = '';
  
  // Estados de modales
  showCreateModal = false;
  showEditModal = false;
  showDeleteModal = false;
  selectedProducto: AdminProducto | null = null;

  productoForm = {
    id: null as number | null,
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
    this.productosFiltrados = [...this.productos];
  }

  loadProductos() {
    this.loading = true;
    this.error = null;
    
    this.productosService.listProductos().subscribe({
      next: (productos) => {
        this.productos = productos;
        this.aplicarFiltros();
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

  // ===== FUNCIONES DE MODALES =====
  
  // Modal de crear
  openCreateModal() {
    console.log('Abriendo modal de crear producto');
    this.clearForm();
    this.showCreateModal = true;
    this.error = null;
    this.success = null;
  }
  
  closeCreateModal() {
    console.log('Cerrando modal de crear producto');
    this.showCreateModal = false;
    this.clearForm();
  }
  
  // Modal de editar
  openEditModal(producto: AdminProducto) {
    console.log('Abriendo modal de editar producto:', producto);
    this.selectedProducto = producto;
    this.productoForm = {
      id: producto.id || null,
      nombre: producto.nombre,
      precio: producto.precio,
      descripcion: producto.descripcion || '',
      grupo_id: producto.grupo_id,
      stock: producto.stock || 0,
      activo: producto.activo !== false
    };
    this.showEditModal = true;
    this.error = null;
    this.success = null;
  }
  
  closeEditModal() {
    console.log('Cerrando modal de editar producto');
    this.showEditModal = false;
    this.selectedProducto = null;
    this.clearForm();
  }
  
  // Modal de eliminar
  openDeleteModal(producto: AdminProducto) {
    console.log('Abriendo modal de eliminar producto:', producto);
    this.selectedProducto = producto;
    this.showDeleteModal = true;
    this.error = null;
    this.success = null;
  }
  
  closeDeleteModal() {
    console.log('Cerrando modal de eliminar producto');
    this.showDeleteModal = false;
    this.selectedProducto = null;
  }

  // ===== OPERACIONES CRUD =====

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
        this.closeCreateModal();
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

  updateProducto() {
    if (!this.validateForm() || !this.selectedProducto) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    const producto: AdminProducto = {
      id: this.selectedProducto.id,
      nombre: this.productoForm.nombre,
      precio: this.productoForm.precio,
      descripcion: this.productoForm.descripcion,
      grupo_id: this.productoForm.grupo_id,
      stock: this.productoForm.stock || 0,
      activo: this.productoForm.activo
    };

    this.productosService.updateProducto(this.selectedProducto.id!, producto).subscribe({
      next: (response) => {
        this.success = 'Producto actualizado exitosamente';
        this.closeEditModal();
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

  deleteProducto() {
    if (!this.selectedProducto) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    this.productosService.deleteProducto(this.selectedProducto.id!).subscribe({
      next: (response) => {
        this.success = 'Producto eliminado exitosamente';
        this.closeDeleteModal();
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

  clearForm() {
    this.productoForm = {
      id: null,
      nombre: '',
      precio: 0,
      descripcion: '',
      grupo_id: 0,
      stock: 0,
      activo: true
    };
  }

  // ===== FUNCIONES AUXILIARES =====

  trackByProductoId(index: number, producto: AdminProducto): number {
    return producto.id || index;
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

  // ===== MÉTODOS DE FILTRADO =====
  
  aplicarFiltros() {
    let productosFiltrados = [...this.productos];

    // Filtrar por grupo
    if (this.filtroGrupo && this.filtroGrupo !== '') {
      productosFiltrados = productosFiltrados.filter(producto => 
        producto.grupo_id === Number(this.filtroGrupo)
      );
    }

    // Filtrar por texto (nombre o descripción)
    if (this.filtroTexto.trim()) {
      const textoFiltro = this.filtroTexto.toLowerCase().trim();
      productosFiltrados = productosFiltrados.filter(producto => 
        producto.nombre.toLowerCase().includes(textoFiltro) ||
        (producto.descripcion && producto.descripcion.toLowerCase().includes(textoFiltro))
      );
    }

    this.productosFiltrados = productosFiltrados;
  }

  onFiltroGrupoChange() {
    this.aplicarFiltros();
  }

  onFiltroTextoChange() {
    this.aplicarFiltros();
  }

  limpiarFiltros() {
    this.filtroGrupo = '';
    this.filtroTexto = '';
    this.aplicarFiltros();
  }
}