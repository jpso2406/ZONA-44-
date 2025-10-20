import { Injectable } from '@angular/core';
import { AuthService } from '../Pages/auth/auth.service';
import { GOOGLE_CONFIG } from '../config/google.config';
import { TranslateService } from '@ngx-translate/core';

declare var google: any;

export interface GoogleAuthResponse {
  success: boolean;
  user_id?: number;
  token?: string;
  message?: string;
  errors?: string[];
}

@Injectable({
  providedIn: 'root'
})
export class GoogleAuthService {
  private isGoogleLoaded = false;

  constructor(
    private authService: AuthService,
    private translate: TranslateService
  ) {}

  initializeGoogleAuth(): Promise<void> {
    return new Promise((resolve) => {
      if (this.isGoogleLoaded) {
        resolve();
        return;
      }

      if (typeof google !== 'undefined' && google.accounts) {
        this.isGoogleLoaded = true;
        resolve();
        return;
      }

      const checkGoogle = () => {
        if (typeof google !== 'undefined' && google.accounts) {
          this.isGoogleLoaded = true;
          resolve();
        } else {
          setTimeout(checkGoogle, 100);
        }
      };

      checkGoogle();
    });
  }

  renderGoogleButton(elementId: string, callback: (response: any) => void): void {
    this.initializeGoogleAuth().then(() => {
      google.accounts.id.initialize({
        client_id: GOOGLE_CONFIG.CLIENT_ID,
        callback: callback,
        auto_select: false,
        cancel_on_tap_outside: true
      });

      google.accounts.id.renderButton(
        document.getElementById(elementId),
        {
          theme: 'outline',
          size: 'large',
          width: '100%',
          text: 'signin_with',
          shape: 'pill',
          logo_alignment: 'left',
          type: 'standard'
        }
      );
    });
  }

  authenticateWithGoogle(idToken: string) {
    return this.authService.loginWithGoogle(idToken);
  }

  handleGoogleResponse(response: any): void {
    console.log('Google response received:', response);

    if (response.credential) {
      console.log('ID Token received, sending to backend...');

      this.authenticateWithGoogle(response.credential).subscribe({
        next: (authResponse) => {
          console.log('Backend response:', authResponse);

          if (authResponse.success || authResponse) {
            console.log('Google auth successful, emitting success event');
            window.dispatchEvent(new CustomEvent('googleAuthSuccess', {
              detail: authResponse
            }));
          } else {
            console.log('Google auth failed:', authResponse);
            window.dispatchEvent(new CustomEvent('googleAuthError', {
              detail: (authResponse && (authResponse as any).errors)
                ? (authResponse as any).errors
                : [this.translate.instant('AUTH.ERROR_AUTH')]
            }));
          }
        },
        error: (error) => {
          console.error('Error en autenticación con Google:', error);

          if (error.status === 0 || error.status === 404) {
            console.log('Backend not available, simulating success for testing');
            window.dispatchEvent(new CustomEvent('googleAuthSuccess', {
              detail: {
                success: true,
                message: this.translate.instant('AUTH.TESTING_MODE')
              }
            }));
          } else {
            window.dispatchEvent(new CustomEvent('googleAuthError', {
              detail: [this.translate.instant('AUTH.SERVER_ERROR')]
            }));
          }
        }
      });
    } else {
      console.error('No credential received from Google');
    }
  }

  clearGoogleAuth(): void {
    if (this.isGoogleLoaded && google.accounts) {
      google.accounts.id.disableAutoSelect();
    }
  }
}
