import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AuthService } from '../Pages/auth/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canActivate(): boolean {
    console.log('AuthGuard checking authentication...');
    const isAuth = this.authService.isAuthenticated();
    console.log('Is authenticated:', isAuth);
    console.log('Current token:', this.authService.getToken());
    
    if (isAuth) {
      return true;
    } else {
      console.log('Not authenticated, redirecting to login');
      this.router.navigate(['/login']);
      return false;
    }
  }
}
