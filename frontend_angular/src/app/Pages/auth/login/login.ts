import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService, LoginRequest } from '../auth.service';
import { GoogleAuthService } from '../../../Services/google-auth.service';
import { NavbarComponent } from "../../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../../Components/shared/footer/footer";
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule, NavbarComponent, FooterComponent, TranslateModule],
  templateUrl: './login.html',
  styleUrl: './login.css'
})
export class LoginComponent implements OnInit, OnDestroy {
  // Estados del componente
  loading = false;
  googleLoading = false;
  error = '';
  success = '';
  showPassword = false;

  // Formulario reactivo
  loginForm!: FormGroup;

  constructor(
    private authService: AuthService,
    private googleAuthService: GoogleAuthService,
    private router: Router,
    private fb: FormBuilder,
    private translate: TranslateService
  ) {
    this.initializeForm();
  }

  ngOnInit(): void {
    this.checkAuthenticationStatus();
    this.setupGoogleAuth();
    this.setupGoogleAuthListeners();
  }

  ngOnDestroy(): void {
    this.cleanupEventListeners();
  }

  private initializeForm(): void {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(6)]]
    });
  }

  private checkAuthenticationStatus(): void {
    if (this.authService.isAuthenticated()) {
      this.router.navigate(['/perfil']);
    }
  }

  private setupGoogleAuth(): void {
    setTimeout(() => {
      this.googleAuthService.renderGoogleButton('google-signin-button', (response: any) => {
        this.googleAuthService.handleGoogleResponse(response);
      });
    }, 500);
  }

  private setupGoogleAuthListeners(): void {
    this.handleGoogleAuthSuccess = this.handleGoogleAuthSuccess.bind(this);
    this.handleGoogleAuthError = this.handleGoogleAuthError.bind(this);
    
    window.addEventListener('googleAuthSuccess', this.handleGoogleAuthSuccess);
    window.addEventListener('googleAuthError', this.handleGoogleAuthError);
  }

  private cleanupEventListeners(): void {
    window.removeEventListener('googleAuthSuccess', this.handleGoogleAuthSuccess);
    window.removeEventListener('googleAuthError', this.handleGoogleAuthError);
  }

  private handleGoogleAuthSuccess = (event: any): void => {
    this.googleLoading = false;
    this.error = '';
    this.success = this.translate.instant('LOGIN.GOOGLE_SUCCESS');
    
    setTimeout(() => {
      this.router.navigate(['/perfil']).catch(() => {
        window.location.href = '/perfil';
      });
    }, 1500);
  };

  private handleGoogleAuthError = (event: any): void => {
    this.googleLoading = false;
    this.error = event.detail?.join(', ') || this.translate.instant('LOGIN.GOOGLE_ERROR');
    this.success = '';
  };

  // Métodos públicos para el template
  onSubmit(): void {
    if (this.loginForm.invalid) {
      this.markFormGroupTouched();
      return;
    }

    this.loading = true;
    this.error = '';
    this.success = '';

    const credentials: LoginRequest = this.loginForm.value;

    this.authService.login(credentials).subscribe({
      next: (response) => {
        this.loading = false;
        if (response.success) {
          this.success = this.translate.instant('LOGIN.SUCCESS');
          setTimeout(() => {
            this.router.navigate(['/perfil']);
          }, 1000);
        } else {
          this.error = response.message || this.translate.instant('LOGIN.ERROR');
        }
      },
      error: (error) => {
        this.loading = false;
        this.error = this.getErrorMessage(error);
        console.error('Login error:', error);
      }
    });
  }

  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }

  getFieldError(fieldName: string): string {
    const field = this.loginForm.get(fieldName);
    if (field && field.invalid && (field.dirty || field.touched)) {
      const errors = field.errors;
      if (errors) {
        const firstError = Object.keys(errors)[0];
        if (fieldName === 'email') {
          if (firstError === 'required') return this.translate.instant('LOGIN.VALIDATION.EMAIL_REQUIRED');
          if (firstError === 'email') return this.translate.instant('LOGIN.VALIDATION.EMAIL_INVALID');
        } else if (fieldName === 'password') {
          if (firstError === 'required') return this.translate.instant('LOGIN.VALIDATION.PASSWORD_REQUIRED');
          if (firstError === 'minlength') return this.translate.instant('LOGIN.VALIDATION.PASSWORD_MINLENGTH');
        }
        return this.translate.instant('LOGIN.VALIDATION.INVALID_FIELD');
      }
    }
    return '';
  }

  isFieldInvalid(fieldName: string): boolean {
    const field = this.loginForm.get(fieldName);
    return !!(field && field.invalid && (field.dirty || field.touched));
  }

  private markFormGroupTouched(): void {
    Object.keys(this.loginForm.controls).forEach(key => {
      const control = this.loginForm.get(key);
      control?.markAsTouched();
    });
  }

  private getErrorMessage(error: any): string {
    if (error.status === 401) {
      return this.translate.instant('LOGIN.INVALID_CREDENTIALS');
    } else if (error.status === 0) {
      return this.translate.instant('LOGIN.CONNECTION_ERROR');
    } else if (error.error?.message) {
      return error.error.message;
    }
    return this.translate.instant('LOGIN.UNEXPECTED_ERROR');
  }

  // Navegación
  goToRegister(): void {
    this.router.navigate(['/register']);
  }

  goToForgotPassword(): void {
    this.router.navigate(['/forgot-password']);
  }

  goToHome(): void {
    this.router.navigate(['/']);
  }

  handleGoogleSignIn(): void {
    this.googleLoading = true;
    // La funcionalidad se maneja a través del GoogleAuthService
    // que se inicializa en ngOnInit
  }

  // Getters para el template
  get email() { return this.loginForm.get('email'); }
  get password() { return this.loginForm.get('password'); }
}
