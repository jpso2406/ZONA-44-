import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TranslateModule, TranslateService, LangChangeEvent } from '@ngx-translate/core';
import { CarritoComponent, CarritoItem } from '../../Components/shared/carrito/carrito';
import { GlobalCartService } from '../../Services/global-cart.service';
import { Grupo, Producto, MenuService } from './menu.service';
import { OrdersService } from '../order/orders.service';
import { FooterComponent } from '../../Components/shared/footer/footer';
import { Subscription } from 'rxjs';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";

interface CartItem {
  producto: Producto;
  cantidad: number;
}

@Component({
  selector: 'app-menu',
  standalone: true,
  imports: [CommonModule, CarritoComponent, FooterComponent, TranslateModule, NavbarComponent],
  templateUrl: './menu.html',
  styleUrls: ['./menu.css']
})
export class Menu implements OnInit, OnDestroy {
  grupos: Grupo[] = [];
  filteredGrupos: Grupo[] = [];
  loading = true;
  selectedCategory = 'all';
  cartItems: CarritoItem[] = [];
  total = 0;
  private cartSub?: any;

  private langSub?: Subscription;

  constructor(
    private menuService: MenuService,
    private ordersService: OrdersService,
    private translate: TranslateService,
    private cartService: GlobalCartService
  ) {
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
    this.cartSub = this.cartService.cartItems$.subscribe(items => {
      this.cartItems = items;
      this.total = this.cartService.getTotal();
    });
  }

  ngOnDestroy(): void {
    if (this.langSub) {
      this.langSub.unsubscribe();
    }
    if (this.cartSub) this.cartSub.unsubscribe();
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
    const item: CarritoItem = {
      id: producto.id,
      name: producto.name,
      precio: producto.precio,
      cantidad: 1,
      foto_url: producto.foto_url
    };
    this.cartService.addItem(item);
    // Producto agregado al carrito sin mostrar alert
  }

  getTotalPrice(): number {
    return this.cartService.getTotal();
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
      cart: this.cartItems.map(i => ({ producto_id: i.id, cantidad: i.cantidad }))
    };

    this.ordersService.createOrder(payload).subscribe({
      next: (res) => {
        if (res.success) {
          alert('Orden creada exitosamente');
          this.cartService.clearCart();
        } else {
          alert(`Error al crear la orden: ${res.errors?.join(', ')}`);
        }
      },
      error: (err) => {
        alert('No se pudo crear la orden');
      }
    });
  }

  increaseItem = (id: number) => {
    const item = this.cartItems.find(i => i.id === id);
    if (item) this.cartService.updateItem(id, item.cantidad + 1);
  };

  decreaseItem = (id: number) => {
    const item = this.cartItems.find(i => i.id === id);
    if (!item) return;
    if (item.cantidad > 1) this.cartService.updateItem(id, item.cantidad - 1);
    else this.removeItem(id);
  };

  removeItem = (id: number) => {
    this.cartService.removeItem(id);
  };
}