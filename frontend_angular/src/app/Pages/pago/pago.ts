import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../Components/shared/footer/footer";
import { GlobalCartService } from '../../Services/global-cart.service';
import { TranslateModule, TranslateService } from '@ngx-translate/core';

interface PaymentRequest {
  card_number: string;
  card_expiration: string;
  card_cvv: string;
  card_name: string;
}

interface PaymentResponse {
  success: boolean;
  message?: string;
  error?: string;
  order_id?: number;
}

@Component({
  selector: 'app-pago',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent, FooterComponent, TranslateModule],
  templateUrl: './pago.html',
  styleUrl: './pago.css'
})
export class PagoComponent implements OnInit {
navigateToHome() {
throw new Error('Method not implemented.');
}
  orderId: number | null = null;
  orderTotal: number = 0;
  
  // Form data
  cardData = {
    number: '',
    expiration: '',
    cvv: '',
    name: ''
  };
  
  // UI state
  loading = false;
  error = '';
  success = false;
  paymentResult: PaymentResponse | null = null;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private http: HttpClient,
    private globalCartService: GlobalCartService,
    private translate: TranslateService
  ) {}

  ngOnInit(): void {
    // Obtener order_id desde query parameters
    this.route.queryParams.subscribe(params => {
      if (params['order_id']) {
        this.orderId = parseInt(params['order_id']);
      }
      if (params['total']) {
        this.orderTotal = parseFloat(params['total']);
      }
    });

    // Si no hay order_id, redirigir al menú
    if (!this.orderId) {
      this.router.navigate(['/menu']);
    }
  }

  onSubmit(): void {
    if (!this.validateForm()) {
      return;
    }

    this.loading = true;
    this.error = '';

    const paymentRequest: PaymentRequest = {
      card_number: this.cardData.number.replace(/\s/g, ''),
      card_expiration: this.cardData.expiration,
      card_cvv: this.cardData.cvv,
      card_name: this.cardData.name
    };

    this.processPayment(paymentRequest).subscribe({
      next: (response) => {
        this.loading = false;
        this.paymentResult = response;
        
        if (response.success) {
          this.success = true;
          
          // ← AGREGAR ESTA LÍNEA: Limpiar el carrito después del pago exitoso
          this.globalCartService.clearCart();
          
          // Redirigir al home después de 3 segundos
          setTimeout(() => {
            this.router.navigate(['/']);
          }, 3000);
        } else {
          this.error = response.error || this.translate.instant('PAYMENT.ERRORS.PROCESSING');
        }
      },
      error: (error) => {
        this.loading = false;
        this.error = error.error?.error || this.translate.instant('PAYMENT.ERRORS.PROCESSING');
        console.error('Error processing payment:', error);
      }
    });
  }

  private processPayment(paymentData: PaymentRequest): Observable<PaymentResponse> {
    const url = `http://localhost:3000/api/v1/orders/${this.orderId}/pay`;
    return this.http.post<PaymentResponse>(url, paymentData);
  }

  private validateForm(): boolean {
    if (!this.cardData.number.trim()) {
      this.error = this.translate.instant('PAYMENT.ERRORS.NUMBER_REQUIRED');
      return false;
    }
    if (!this.cardData.expiration.trim()) {
      this.error = this.translate.instant('PAYMENT.ERRORS.EXPIRATION_REQUIRED');
      return false;
    }
    if (!this.cardData.cvv.trim()) {
      this.error = this.translate.instant('PAYMENT.ERRORS.CVV_REQUIRED');
      return false;
    }
    if (!this.cardData.name.trim()) {
      this.error = this.translate.instant('PAYMENT.ERRORS.NAME_REQUIRED');
      return false;
    }
    
    // Validar formato de número de tarjeta (básico)
    const cardNumber = this.cardData.number.replace(/\s/g, '');
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      this.error = this.translate.instant('PAYMENT.ERRORS.NUMBER_LENGTH');
      return false;
    }
    
    // Validar formato de expiración (MM/YY)
    const expirationRegex = /^(0[1-9]|1[0-2])\/\d{2}$/;
    if (!expirationRegex.test(this.cardData.expiration)) {
      this.error = this.translate.instant('PAYMENT.ERRORS.EXPIRATION_FORMAT');
      return false;
    }
    
    // Validar CVV
    if (this.cardData.cvv.length < 3 || this.cardData.cvv.length > 4) {
      this.error = this.translate.instant('PAYMENT.ERRORS.CVV_LENGTH');
      return false;
    }
    
    return true;
  }

  formatCardNumber(event: any): void {
    let value = event.target.value.replace(/\s/g, '');
    value = value.replace(/(.{4})/g, '$1 ').trim();
    this.cardData.number = value;
  }

  formatExpiration(event: any): void {
    let value = event.target.value.replace(/\D/g, '');
    if (value.length >= 2) {
      value = value.substring(0, 2) + '/' + value.substring(2, 4);
    }
    this.cardData.expiration = value;
  }

  onlyNumbers(event: KeyboardEvent, allowSlash: boolean = false): boolean {
    const charCode = event.which ? event.which : event.keyCode;
    
    // Permitir teclas especiales (backspace, delete, tab, escape, enter, home, end, arrow keys)
    if ([8, 9, 27, 13, 46, 35, 36, 37, 38, 39, 40].indexOf(charCode) !== -1 ||
        // Permitir Ctrl+A, Ctrl+C, Ctrl+V, Ctrl+X
        (charCode === 65 && event.ctrlKey) || // Ctrl+A
        (charCode === 67 && event.ctrlKey) || // Ctrl+C
        (charCode === 86 && event.ctrlKey) || // Ctrl+V
        (charCode === 88 && event.ctrlKey)) { // Ctrl+X
      return true;
    }
    
    // Para el campo de fecha, permitir la barra diagonal (/)
    if (allowSlash && charCode === 47) {
      return true;
    }
    
    // Solo permitir números (0-9)
    if (charCode < 48 || charCode > 57) {
      event.preventDefault();
      return false;
    }
    
    return true;
  }

  onGoBack(): void {
    this.router.navigate(['/menu']);
  }

  clearError(): void {
    this.error = '';
  }
}