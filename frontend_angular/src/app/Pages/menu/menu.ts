import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TranslateModule, TranslateService, LangChangeEvent } from '@ngx-translate/core';
import { CarritoComponent, CarritoItem } from '../../Components/shared/carrito/carrito';
import { Grupo, Producto, MenuService } from './menu.service';
import { OrdersService } from '../order/orders.service';
import { FooterComponent } from '../../Components/shared/footer/footer';
import { Subscription } from 'rxjs';

interface CartItem {
  producto: Producto;
  cantidad: number;
}

@Component({
  selector: 'app-menu',
  standalone: true,
  imports: [CommonModule, CarritoComponent, FooterComponent, TranslateModule],
  templateUrl: './menu.html',
  styleUrls: ['./menu.css']
})
export class Menu implements OnInit, OnDestroy {
  grupos: Grupo[] = [];
  filteredGrupos: Grupo[] = [];
  loading = true;
  selectedCategory = 'all';
  cartItems: CartItem[] = [];

  get carritoItems(): CarritoItem[] {
    return this.cartItems.map(ci => ({
      id: ci.producto.id,
      name: ci.producto.name,
      precio: ci.producto.precio,
      cantidad: ci.cantidad,
      foto_url: ci.producto.foto_url
    }));
  }

  private langSub?: Subscription;

  constructor(
    private menuService: MenuService,
    private ordersService: OrdersService,
    private translate: TranslateService
  ) {
    console.log('[MENU] constructor currentLang ->', this.translate.currentLang);
    this.langSub = this.translate.onLangChange.subscribe((e: LangChangeEvent) => {
      console.log('[MENU] onLangChange ->', e.lang);
    });
  }

  ngOnInit(): void {
    this.menuService.getGrupos().subscribe({
      next: (data) => {
        this.grupos = data;
        this.filteredGrupos = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error al cargar grupos', err);
        this.loading = false;
      }
    });
  }

  ngOnDestroy(): void {
    if (this.langSub) {
      this.langSub.unsubscribe();
    }
  }

  getTotalProductos(): number {
    return this.grupos.reduce((total, grupo) => total + grupo.productos.length, 0);
  }

  filterByCategory(categorySlug: string): void {
    this.selectedCategory = categorySlug;
    if (categorySlug === 'all') {
      this.filteredGrupos = this.grupos;
    } else {
      this.filteredGrupos = this.grupos.filter(grupo => grupo.slug === categorySlug);
    }

    if (categorySlug !== 'all') {
      setTimeout(() => {
        const element = document.getElementById(categorySlug);
        if (element) {
          element.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }, 100);
    }
  }

  addToCart(producto: Producto): void {
    const existingItem = this.cartItems.find(item => item.producto.id === producto.id);

    if (existingItem) {
      existingItem.cantidad += 1;
    } else {
      this.cartItems.push({ producto, cantidad: 1 });
    }

    console.log(`Added ${producto.name} to cart`);
  }

  getTotalPrice(): number {
    return this.cartItems.reduce((total, item) => total + (item.producto.precio * item.cantidad), 0);
  }

  goToCheckout(): void {
    const payload = {
      customer: {
        name: 'Invitado',
        email: 'guest@example.com',
        phone: '0000000000'
      },
      delivery_type: 'recoger' as const,
      total_amount: this.getTotalPrice(),
      cart: this.cartItems.map(i => ({ producto_id: i.producto.id, cantidad: i.cantidad }))
    };

    this.ordersService.createOrder(payload).subscribe({
      next: (res) => {
        if (res.success) {
          console.log('Orden creada:', res.order_id);
          alert('Orden creada exitosamente');
        } else {
          alert(`Error al crear la orden: ${res.errors?.join(', ')}`);
        }
      },
      error: (err) => {
        console.error('Error creando la orden', err);
        alert('No se pudo crear la orden');
      }
    });
  }

  increaseItem = (id: number) => {
    const it = this.cartItems.find(i => i.producto.id === id);
    if (it) it.cantidad += 1;
  };

  decreaseItem = (id: number) => {
    const it = this.cartItems.find(i => i.producto.id === id);
    if (!it) return;
    if (it.cantidad > 1) it.cantidad -= 1; else this.removeItem(id);
  };

  removeItem = (id: number) => {
    this.cartItems = this.cartItems.filter(i => i.producto.id !== id);
  };
}