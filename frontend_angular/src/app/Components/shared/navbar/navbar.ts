import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { AuthService, User } from '../../../Pages/auth/auth.service';
import { Subscription } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';
import { GoogleAuthService } from '../../../Services/google-auth.service';
import { TranslateModule } from '@ngx-translate/core';


@Component({
    selector: 'app-navbar',
    templateUrl: 'navbar.html',
    standalone: true,
    imports: [
    CommonModule,
    RouterLink,
    RouterLinkActive,
    TranslateModule
    ],
    styleUrls: ['navbar.css', 'language-switcher.css']
})
export class NavbarComponent implements OnInit, OnDestroy {
    isMobileMenuOpen = false;
    isAuthenticated = false;
    currentUser: User | null = null;
    currentLang: string;
    private authSubscription: Subscription = new Subscription();

    constructor(
        private translate: TranslateService,
        private authService: AuthService,
        private googleAuthService: GoogleAuthService,
        private cdr: ChangeDetectorRef
    ) {
        const lang = localStorage.getItem('lang') || 'es';
        this.translate.use(lang);
        console.log('[NAVBAR] init lang ->', lang);
        this.currentLang = lang;
    }

    // Método para cambiar el idioma
    switchLanguage(lang: string) {
        console.log('[NAVBAR] switchLanguage called ->', lang);
        console.log('[NAVBAR] currentLang before change ->', this.translate.currentLang);
        
        // Guardar el idioma en localStorage
        localStorage.setItem('lang', lang);
        this.currentLang = lang;
        
        // Cambiar idioma
        this.translate.use(lang).subscribe({
            next: () => {
                console.log('[NAVBAR] Language successfully changed to ->', this.translate.currentLang);
                
                // Forzar recarga de la página para aplicar cambios
                setTimeout(() => {
                    console.log('[NAVBAR] Reloading page to apply language changes...');
                    window.location.reload();
                }, 100);
            },
            error: (err) => {
                console.error('[NAVBAR] Error changing language ->', err);
            }
        });
    }

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