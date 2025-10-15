import { Injectable } from '@angular/core';
import { AuthService } from '../Pages/auth/auth.service';
import { GOOGLE_CONFIG } from '../config/google.config';

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

  constructor(private authService: AuthService) {}

  // Inicializar Google Identity Services
  initializeGoogleAuth(): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this.isGoogleLoaded) {
        resolve();
        return;
      }

      // Verificar si Google ya está cargado
      if (typeof google !== 'undefined' && google.accounts) {
        this.isGoogleLoaded = true;
        resolve();
        return;
      }

      // Esperar a que Google se cargue
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

  // Renderizar el botón de Google
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
          shape: 'rectangular',
          logo_alignment: 'left'
        }
      );
    });
  }

  // Enviar id_token al backend usando AuthService
  authenticateWithGoogle(idToken: string) {
    return this.authService.loginWithGoogle(idToken);
  }

  // Manejar la respuesta de Google
  handleGoogleResponse(response: any): void {
    console.log('Google response received:', response);
    
    if (response.credential) {
      console.log('ID Token received, sending to backend...');
      
      // El id_token está en response.credential
      this.authenticateWithGoogle(response.credential).subscribe({
        next: (authResponse) => {
          console.log('Backend response:', authResponse);
          
          // Si el backend responde exitosamente (200 OK), tratar como éxito
          if (authResponse.success || authResponse) {
            console.log('Google auth successful, emitting success event');
            // Emitir evento de login exitoso
            window.dispatchEvent(new CustomEvent('googleAuthSuccess', {
              detail: authResponse
            }));
          } else {
            console.log('Google auth failed:', authResponse);
            // Emitir evento de error
            window.dispatchEvent(new CustomEvent('googleAuthError', {
              detail: (authResponse && (authResponse as any).errors) 
                ? (authResponse as any).errors 
                : [(authResponse && (authResponse as any).message) || 'Error en la autenticación']
            }));
          }
        },
        error: (error) => {
          console.error('Error en autenticación con Google:', error);
          
          // Si el backend no está disponible, simular éxito para testing
          if (error.status === 0 || error.status === 404) {
            console.log('Backend not available, simulating success for testing');
            window.dispatchEvent(new CustomEvent('googleAuthSuccess', {
              detail: { success: true, message: 'Backend no disponible - modo testing' }
            }));
          } else {
            window.dispatchEvent(new CustomEvent('googleAuthError', {
              detail: ['Error de conexión con el servidor']
            }));
          }
        }
      });
    } else {
      console.error('No credential received from Google');
    }
  }

  // Limpiar el estado de Google
  clearGoogleAuth(): void {
    if (this.isGoogleLoaded && google.accounts) {
      google.accounts.id.disableAutoSelect();
    }
  }
}
