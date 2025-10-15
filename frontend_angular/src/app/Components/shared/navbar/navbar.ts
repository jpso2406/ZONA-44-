
import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { AuthService, User } from '../../../Pages/auth/auth.service';
import { Subscription } from 'rxjs';

@Component({
    selector: 'app-navbar',
    templateUrl: 'navbar.html',
    imports: [CommonModule, RouterLink, RouterLinkActive],
    styleUrl: 'navbar.css'
})
export class NavbarComponent implements OnInit, OnDestroy {
    isMobileMenuOpen = false;
    isAuthenticated = false;
    currentUser: User | null = null;
    private authSubscription: Subscription = new Subscription();

    constructor(private authService: AuthService) {}

    ngOnInit(): void {
        // Suscribirse a cambios de autenticación
        this.authSubscription.add(
            this.authService.currentUser$.subscribe(user => {
                this.currentUser = user;
                this.isAuthenticated = !!user;
            })
        );
    }

    ngOnDestroy(): void {
        this.authSubscription.unsubscribe();
    }

    toggleMobileMenu() {
        this.isMobileMenuOpen = !this.isMobileMenuOpen;
    }

    closeMobileMenu() {
        this.isMobileMenuOpen = false;
    }

    logout() {
        this.authService.logout();
        this.closeMobileMenu();
    }

    scrollToFooter() {
        // Hacer scroll suave hasta el final de la página
        window.scrollTo({
            top: document.body.scrollHeight,
            behavior: 'smooth'
        });
    }
}