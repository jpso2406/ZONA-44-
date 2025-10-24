import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService, RegisterRequest } from '../auth.service';
import { NavbarComponent } from "../../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../../Components/shared/footer/footer";
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent, FooterComponent, TranslateModule],
  templateUrl: './register.html',
  styleUrl: './register.css'
})
export class RegisterComponent implements OnInit {
  userData: RegisterRequest = {
    email: '',
    password: '',
    first_name: '',
    last_name: '',
    phone: '',
    address: '',
    city: '',
    department: ''
  };

  confirmPassword = '';
  loading = false;
  error = '';
  success = '';
  showPassword = false;
  showConfirmPassword = false;

  constructor(
    private authService: AuthService,
    private router: Router,
    private translate: TranslateService
  ) {}

  ngOnInit(): void {
    // Si ya está autenticado, redirigir al perfil
    if (this.authService.isAuthenticated()) {
      this.router.navigate(['/perfil']);
    }
  }

  onSubmit(): void {
    if (!this.validateForm()) {
      return;
    }

    this.loading = true;
    this.error = '';
    this.success = '';

    this.authService.register(this.userData).subscribe({
      next: (response) => {
        this.loading = false;
        if (response.success) {
          this.success = this.translate.instant('REGISTER.SUCCESS');
          // Redirigir al login después de 2 segundos
          setTimeout(() => {
            this.router.navigate(['/login']);
          }, 2000);
        } else {
          this.error = response.errors?.join(', ') || response.message || this.translate.instant('REGISTER.ERROR');
        }
      },
      error: (error) => {
        this.loading = false;
        this.error = this.translate.instant('REGISTER.CONNECTION_ERROR');
        console.error('Register error:', error);
      }
    });
  }

  private validateForm(): boolean {
    // Validar campos requeridos
    if (!this.userData.first_name.trim()) {
      this.error = this.translate.instant('REGISTER.VALIDATION.FIRST_NAME_REQUIRED');
      return false;
    }
    if (!this.userData.last_name.trim()) {
      this.error = this.translate.instant('REGISTER.VALIDATION.LAST_NAME_REQUIRED');
      return false;
    }
    if (!this.userData.email.trim()) {
      this.error = this.translate.instant('REGISTER.VALIDATION.EMAIL_REQUIRED');
      return false;
    }
    if (!this.userData.password.trim()) {
      this.error = this.translate.instant('REGISTER.VALIDATION.PASSWORD_REQUIRED');
      return false;
    }
    if (!this.userData.phone.trim()) {
      this.error = this.translate.instant('REGISTER.VALIDATION.PHONE_REQUIRED');
      return false;
    }
    if (!this.userData.address.trim()) {
      this.error = this.translate.instant('REGISTER.VALIDATION.ADDRESS_REQUIRED');
      return false;
    }
    if (!this.userData.city.trim()) {
      this.error = this.translate.instant('REGISTER.VALIDATION.CITY_REQUIRED');
      return false;
    }
    if (!this.userData.department.trim()) {
      this.error = this.translate.instant('REGISTER.VALIDATION.DEPARTMENT_REQUIRED');
      return false;
    }

    // Validar formato de email
    if (!this.isValidEmail(this.userData.email)) {
      this.error = this.translate.instant('REGISTER.VALIDATION.EMAIL_INVALID');
      return false;
    }

    // Validar contraseña
    if (this.userData.password.length < 6) {
      this.error = this.translate.instant('REGISTER.VALIDATION.PASSWORD_MINLENGTH');
      return false;
    }

    // Validar confirmación de contraseña
    if (this.userData.password !== this.confirmPassword) {
      this.error = this.translate.instant('REGISTER.VALIDATION.PASSWORD_MISMATCH');
      return false;
    }

    return true;
  }

  private isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  goToLogin(): void {
    this.router.navigate(['/login']);
  }

  goToHome(): void {
    this.router.navigate(['/']);
  }

  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }

  toggleConfirmPasswordVisibility(): void {
    this.showConfirmPassword = !this.showConfirmPassword;
  }
}
