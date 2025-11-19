import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { GlobalCartService } from '../../Services/global-cart.service';
import { CarritoItem, CarritoComponent } from '../../Components/shared/carrito/carrito';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../Components/shared/footer/footer";
import { Promociones } from "../../Components/shared/promociones/promociones";
import { AnunciosPublicComponent } from '../../Components/shared/anuncios-public/anuncios-public';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { Observable } from 'rxjs';


@Component({
  standalone: true,
  imports: [FooterComponent, TranslateModule, NavbarComponent, Promociones, CarritoComponent, AnunciosPublicComponent],
  templateUrl: './home.html',
  styleUrls: ['./home.css']
})
export class Home implements OnInit, OnDestroy {
  cartItems: CarritoItem[] = [];
  total = 0;
  private cartSub?: any;

  constructor(
    private translate: TranslateService,
    private cdr: ChangeDetectorRef,
    private cartService: GlobalCartService
  ) {}

  ngOnInit() {
    this.cartSub = this.cartService.cartItems$.subscribe(items => {
      this.cartItems = items;
      this.total = this.cartService.getTotal();
      this.cdr.detectChanges();
    });
    this.translate.onLangChange.subscribe(() => {
      this.cdr.detectChanges();
    });
  }

  ngOnDestroy() {
    if (this.cartSub) this.cartSub.unsubscribe();
  }

  t(key: string): Observable<string> {
    return this.translate.stream(key);
  }

  addPromoToCart(promo: any) {
    const item: CarritoItem = {
      id: promo.id,
      name: promo.title,
      precio: promo.newPrice,
      cantidad: 1,
      foto_url: promo.image
    };
    this.cartService.addItem(item);
    // Promoción agregada al carrito sin mostrar alert
  }

  increaseItem(id: number) {
    const item = this.cartItems.find(i => i.id === id);
    if (item) this.cartService.updateItem(id, item.cantidad + 1);
  }

  decreaseItem(id: number) {
    const item = this.cartItems.find(i => i.id === id);
    if (item) {
      if (item.cantidad > 1) this.cartService.updateItem(id, item.cantidad - 1);
      else this.removeItem(id);
    }
  }

  removeItem(id: number) {
    this.cartService.removeItem(id);
  }

  clearCart() {
    this.cartService.clearCart();
    this.showNotification('¡Carrito limpiado después del pago!');
  }

  showNotification(msg: string) {
    // Simple notification logic (replace with your own UI)
    alert(msg);
  }
}
