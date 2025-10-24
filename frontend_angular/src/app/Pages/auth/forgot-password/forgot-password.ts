import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { PasswordResetService } from './password-reset.service';
import { FooterComponent } from "../../../Components/shared/footer/footer";
import { NavbarComponent } from "../../../Components/shared/navbar/navbar";
import { TranslateModule, TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-forgot-password',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, FooterComponent, NavbarComponent, TranslateModule],
  templateUrl: './forgot-password.html',
  styleUrls: ['./forgot-password.css']
})
export class ForgotPasswordComponent implements OnInit {
  forgotPasswordForm: FormGroup;
  loading = false;
  message: string | null = null;
  messageType: 'success' | 'error' = 'success';
  step = 1; // 1: email, 2: code verification, 3: new password

  constructor(
    private fb: FormBuilder,
    private passwordResetService: PasswordResetService,
    private router: Router,
    private translate: TranslateService
  ) {
    this.forgotPasswordForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      code: ['', [Validators.required, Validators.pattern(/^\d{6}$/)]],
      password: ['', [Validators.required, Validators.minLength(6)]],
      confirmPassword: ['', [Validators.required]]
    }, { validators: this.passwordMatchValidator });
  }

  ngOnInit(): void {
    this.showMessage(this.translate.instant('FORGOT_PASSWORD.INITIAL_MESSAGE'), 'success');
  }

  passwordMatchValidator(form: FormGroup) {
    const password = form.get('password');
    const confirmPassword = form.get('confirmPassword');
    
    if (password && confirmPassword && password.value !== confirmPassword.value) {
      confirmPassword.setErrors({ passwordMismatch: true });
      return { passwordMismatch: true };
    }
    
    if (confirmPassword && confirmPassword.errors && confirmPassword.errors['passwordMismatch']) {
      delete confirmPassword.errors['passwordMismatch'];
      if (Object.keys(confirmPassword.errors).length === 0) {
        confirmPassword.setErrors(null);
      }
    }
    
    return null;
  }

  get email() { return this.forgotPasswordForm.get('email'); }
  get code() { return this.forgotPasswordForm.get('code'); }
  get password() { return this.forgotPasswordForm.get('password'); }
  get confirmPassword() { return this.forgotPasswordForm.get('confirmPassword'); }

  onSubmit(): void {
    if (this.step === 1) {
      this.requestPasswordReset();
    } else if (this.step === 2) {
      this.verifyCode();
    } else if (this.step === 3) {
      this.resetPassword();
    }
  }

  requestPasswordReset(): void {
    if (this.email?.invalid) {
      this.markFormGroupTouched();
      return;
    }

    this.loading = true;
    this.passwordResetService.requestPasswordReset({ email: this.email?.value })
      .subscribe({
        next: (response) => {
          this.loading = false;
          this.step = 2;
          this.showMessage(this.translate.instant('FORGOT_PASSWORD.CODE_SENT'), 'success');
        },
        error: (error) => {
          this.loading = false;
          this.showMessage(this.getErrorMessage(error), 'error');
        }
      });
  }

  verifyCode(): void {
    if (this.code?.invalid) {
      this.markFormGroupTouched();
      return;
    }

    this.loading = true;
    this.passwordResetService.verifyResetCode({
      email: this.email?.value,
      code: this.code?.value
    }).subscribe({
      next: (response) => {
        this.loading = false;
        this.step = 3;
        this.showMessage(this.translate.instant('FORGOT_PASSWORD.CODE_VERIFIED'), 'success');
      },
      error: (error) => {
        this.loading = false;
        this.showMessage(this.getErrorMessage(error), 'error');
      }
    });
  }

  resetPassword(): void {
    if (this.forgotPasswordForm.invalid) {
      this.markFormGroupTouched();
      return;
    }

    this.loading = true;
    this.passwordResetService.resetPassword({
      email: this.email?.value,
      code: this.code?.value,
      password: this.password?.value
    }).subscribe({
      next: (response) => {
        this.loading = false;
        this.showMessage(this.translate.instant('FORGOT_PASSWORD.PASSWORD_UPDATED'), 'success');
        
        // Limpiar todos los campos del formulario
        this.forgotPasswordForm.reset();
        this.step = 1;
        
        // Redirigir al login después de un breve delay
        setTimeout(() => {
          this.router.navigate(['/login']);
        }, 1500);
      },
      error: (error) => {
        this.loading = false;
        this.showMessage(this.getErrorMessage(error), 'error');
      }
    });
  }

  goBack(): void {
    if (this.step === 1) {
      this.router.navigate(['/login']);
    } else {
      this.step--;
      this.clearMessage();
    }
  }

  resendCode(): void {
    this.requestPasswordReset();
  }

  private markFormGroupTouched(): void {
    Object.keys(this.forgotPasswordForm.controls).forEach(key => {
      const control = this.forgotPasswordForm.get(key);
      control?.markAsTouched();
    });
  }

  private showMessage(message: string, type: 'success' | 'error'): void {
    this.message = message;
    this.messageType = type;
  }

  private clearMessage(): void {
    this.message = null;
  }

  private getErrorMessage(error: any): string {
    if (error.error?.message) {
      return error.error.message;
    }
    if (error.status === 404) {
      return this.translate.instant('FORGOT_PASSWORD.EMAIL_NOT_FOUND');
    }
    if (error.status === 422) {
      return this.translate.instant('FORGOT_PASSWORD.INVALID_DATA');
    }
    if (error.status === 0) {
      return this.translate.instant('FORGOT_PASSWORD.CONNECTION_ERROR');
    }
    return this.translate.instant('FORGOT_PASSWORD.UNEXPECTED_ERROR');
  }

  getFieldError(fieldName: string): string {
    const field = this.forgotPasswordForm.get(fieldName);
    if (field?.hasError('required')) {
      return this.translate.instant('FORGOT_PASSWORD.VALIDATION.REQUIRED', { 
        field: this.translate.instant(`FORGOT_PASSWORD.FIELDS.${fieldName.toUpperCase()}`) 
      });
    }
    if (field?.hasError('email')) {
      return this.translate.instant('FORGOT_PASSWORD.VALIDATION.EMAIL_INVALID');
    }
    if (field?.hasError('pattern')) {
      return this.translate.instant('FORGOT_PASSWORD.VALIDATION.CODE_PATTERN');
    }
    if (field?.hasError('minlength')) {
      return this.translate.instant('FORGOT_PASSWORD.VALIDATION.PASSWORD_MINLENGTH');
    }
    if (field?.hasError('passwordMismatch')) {
      return this.translate.instant('FORGOT_PASSWORD.VALIDATION.PASSWORD_MISMATCH');
    }
    return '';
  }

  isFieldInvalid(fieldName: string): boolean {
    const field = this.forgotPasswordForm.get(fieldName);
    return !!(field && field.invalid && (field.dirty || field.touched));
  }

  getStepTitle(): string {
    switch (this.step) {
      case 1: return this.translate.instant('FORGOT_PASSWORD.STEP1_TITLE');
      case 2: return this.translate.instant('FORGOT_PASSWORD.STEP2_TITLE');
      case 3: return this.translate.instant('FORGOT_PASSWORD.STEP3_TITLE');
      default: return this.translate.instant('FORGOT_PASSWORD.STEP1_TITLE');
    }
  }

  getStepDescription(): string {
    switch (this.step) {
      case 1: return this.translate.instant('FORGOT_PASSWORD.STEP1_DESC');
      case 2: return this.translate.instant('FORGOT_PASSWORD.STEP2_DESC');
      case 3: return this.translate.instant('FORGOT_PASSWORD.STEP3_DESC');
      default: return '';
    }
  }
}
