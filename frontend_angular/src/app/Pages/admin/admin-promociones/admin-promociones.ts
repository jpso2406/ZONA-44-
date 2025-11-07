import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AdminPromocionesService, Promocion } from '../services/admin-promociones.service';

@Component({
  selector: 'app-admin-promociones',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-promociones.html',
  styleUrls: ['./admin-promociones.css']
})
export class AdminPromocionesComponent implements OnInit {
  promociones: Promocion[] = [];
  loading = false;
  error: string | null = null;
  success: string | null = null;
  isEditing = false;
  currentPromocion: Promocion | null = null;

  promocionForm = {
    nombre: '',
    precio_total: 0,
    precio_original: 0,
    descuento: 0,
    producto_id: null as number | null,
    imagen: null as File | null
  };

  productos: any[] = [];
  productosLoading = false;
  selectedImagePreview: string | null = null;

  constructor(private promocionesService: AdminPromocionesService) {}

  ngOnInit() {
    this.loadPromociones();
    this.loadProductos();
  }

  loadPromociones() {
    this.loading = true;
    this.error = null;

    this.promocionesService.getPromociones().subscribe({
      next: (promociones) => {
        this.promociones = promociones;
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading promociones:', error);
        this.error = 'Error al cargar las promociones';
        this.loading = false;
      }
    });
  }

  loadProductos() {
    // marca carga para que el template pueda mostrar estado (y evitar selects vacíos)
    this.productosLoading = true;
    this.promocionesService.getProductos().subscribe({
      next: (productos) => {
        this.productos = Array.isArray(productos) ? productos : productos || [];
        this.productosLoading = false;
      },
      error: (error) => {
        console.error('Error loading productos:', error);
        this.productos = [];
        this.productosLoading = false;
      }
    });
  }

  resetForm() {
    this.promocionForm = {
      nombre: '',
      precio_total: 0,
      precio_original: 0,
      descuento: 0,
      producto_id: null,
      imagen: null
    };
    this.selectedImagePreview = null;
    this.isEditing = false;
    this.currentPromocion = null;
    this.error = null;
    this.success = null;
  }

  startEdit(promocion: Promocion) {
    // asegurar que la lista de productos esté cargada para que el select muestre opciones
    if (!this.productos.length && !this.productosLoading) {
      this.loadProductos();
    }

    this.currentPromocion = promocion;
    this.promocionForm = {
      nombre: promocion.nombre,
      precio_total: promocion.precio_total,
      precio_original: promocion.precio_original,
      descuento: promocion.descuento,
      producto_id: promocion.producto_id ?? null,
      imagen: null
    };
    this.selectedImagePreview = (promocion as any).imagen_url || null;
    this.isEditing = true;
    this.error = null;
    this.success = null;
  }

  cancelEdit() {
    this.resetForm();
  }

  validateForm(): boolean {
    if (!this.promocionForm.nombre.trim()) {
      this.error = 'El nombre es requerido';
      return false;
    }
    // producto_id puede ser null si la lógica permite promociones globales; si requiere producto, conserva la validación
    if (this.promocionForm.producto_id == null || this.promocionForm.producto_id === 0) {
      this.error = 'Debe seleccionar un producto';
      return false;
    }
    if (this.promocionForm.precio_original <= 0) {
      this.error = 'El precio original debe ser mayor a 0';
      return false;
    }
    if (this.promocionForm.precio_total <= 0) {
      this.error = 'El precio total debe ser mayor a 0';
      return false;
    }
    if (this.promocionForm.precio_total >= this.promocionForm.precio_original) {
      this.error = 'El precio total debe ser menor al precio original';
      return false;
    }
    if (this.promocionForm.descuento <= 0 || this.promocionForm.descuento > 100) {
      this.error = 'El descuento debe estar entre 1 y 100';
      return false;
    }
    return true;
  }

  createPromocion() {
    if (!this.validateForm()) return;

    this.loading = true;
    this.error = null;

    const promocionPayload: any = {
      nombre: this.promocionForm.nombre,
      precio_total: this.promocionForm.precio_total,
      precio_original: this.promocionForm.precio_original,
      descuento: this.promocionForm.descuento,
      imagen: this.promocionForm.imagen || undefined
    };
    // sólo incluir producto_id si no es null (evita pasar null donde se espera number)
    if (this.promocionForm.producto_id != null) {
      promocionPayload.producto_id = this.promocionForm.producto_id;
    }

    const payload = { promocion: promocionPayload };

    this.promocionesService.createPromocion(payload).subscribe({
      next: (response) => {
        if (response.success) {
          this.success = 'Promoción creada exitosamente';
          this.resetForm();
          this.loadPromociones();
        }
        this.loading = false;
      },
      error: (error) => {
        console.error('Error creating promocion:', error);
        this.error = error.error?.errors?.[0] || 'Error al crear la promoción';
        this.loading = false;
      }
    });
  }

  updatePromocion() {
    if (!this.validateForm() || !this.currentPromocion) return;

    this.loading = true;
    this.error = null;

    const promocionPayload: any = {
      nombre: this.promocionForm.nombre,
      precio_total: this.promocionForm.precio_total,
      precio_original: this.promocionForm.precio_original,
      descuento: this.promocionForm.descuento,
      imagen: this.promocionForm.imagen || undefined
    };
    // sólo incluir producto_id si no es null (evita pasar null donde se espera number | undefined)
    if (this.promocionForm.producto_id != null) {
      promocionPayload.producto_id = this.promocionForm.producto_id;
    }

    const payload = { promocion: promocionPayload };

    this.promocionesService.updatePromocion(this.currentPromocion.id, payload).subscribe({
      next: (response) => {
        if (response.success) {
          this.success = 'Promoción actualizada exitosamente';
          this.resetForm();
          this.loadPromociones();
        }
        this.loading = false;
      },
      error: (error) => {
        console.error('Error updating promocion:', error);
        this.error = error.error?.errors?.[0] || 'Error al actualizar la promoción';
        this.loading = false;
      }
    });
  }

  deletePromocion(id: number) {
    if (!confirm('¿Estás seguro de que quieres eliminar esta promoción?')) {
      return;
    }

    this.loading = true;
    this.error = null;

    this.promocionesService.deletePromocion(id).subscribe({
      next: (response) => {
        if (response.success) {
          this.success = 'Promoción eliminada exitosamente';
          this.loadPromociones();
        }
        this.loading = false;
      },
      error: (error) => {
        console.error('Error deleting promocion:', error);
        this.error = 'Error al eliminar la promoción';
        this.loading = false;
      }
    });
  }

  onImageSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.promocionForm.imagen = file;

      // Crear preview de la imagen
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.selectedImagePreview = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

  calculateDiscount() {
    if (this.promocionForm.precio_original > 0 && this.promocionForm.precio_total > 0) {
      const discount = ((this.promocionForm.precio_original - this.promocionForm.precio_total) / this.promocionForm.precio_original) * 100;
      this.promocionForm.descuento = Math.round(discount);
    }
  }

  calculateTotalPrice() {
    if (this.promocionForm.precio_original > 0 && this.promocionForm.descuento > 0) {
      const discountAmount = (this.promocionForm.precio_original * this.promocionForm.descuento) / 100;
      this.promocionForm.precio_total = this.promocionForm.precio_original - discountAmount;
    }
  }

  formatPrice(amount: number): string {
    return new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP',
      minimumFractionDigits: 0
    }).format(amount);
  }

  getProductoName(producto_id: number): string {
    const producto = this.productos.find(p => Number(p.id) === Number(producto_id));
    if (!producto) return 'Producto no encontrado';
    // soportar ambos esquemas de nombre: name o nombre
    return (producto.nombre || producto.name || producto.title || '').toString();
  }

  trackByProducto(index: number, item: any) {
    return item && item.id ? item.id : index;
  }
}