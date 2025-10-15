import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

export interface CarritoItem {
  id: number;
  name: string;
  precio: number;
  cantidad: number;
  foto_url?: string;
}

@Component({
  selector: 'app-carrito',
  standalone: true,
  imports: [CommonModule],
  templateUrl: 'carrito.html',
  styleUrl: 'carrito.css'
})
export class CarritoComponent {
  @Input() items: CarritoItem[] = [];
  @Input() total = 0;

  @Output() increase = new EventEmitter<number>();
  @Output() decrease = new EventEmitter<number>();
  @Output() remove = new EventEmitter<number>();
  @Output() checkout = new EventEmitter<void>();

  isOpen = false;

  constructor(private router: Router) {}

  toggle(): void {
    this.isOpen = !this.isOpen;
  }

  goToCheckout(): void {
    if (this.items.length === 0) return;
    
    // Cerrar el modal del carrito
    this.isOpen = false;
    
    // Navegar a la página de orden con los datos del carrito
    this.router.navigate(['/order'], {
      queryParams: {
        cart: JSON.stringify(this.items),
        total: this.total
      }
    });
  }
}


