import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive, Router } from '@angular/router';
import { AuthService, User } from '../../../Pages/auth/auth.service';
import { Subscription } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';
import { GoogleAuthService } from '../../../Services/google-auth.service';
import { TranslateModule } from '@ngx-translate/core';
import { ClickOutsideDirective } from '../../../directives/click-outside.directive';


@Component({
    selector: 'app-navbar',
    templateUrl: 'navbar.html',
    standalone: true,
    imports: [
    CommonModule,
    RouterLink,
    RouterLinkActive,
    TranslateModule,
    ClickOutsideDirective
    ],
    styleUrls: ['navbar.css', 'language-switcher.css']
})
export class NavbarComponent implements OnInit, OnDestroy {
    isMobileMenuOpen = false;
    isAuthenticated = false;
    currentUser: User | null = null;
    currentLang: string;
    isLanguageDropdownOpen = false;
    private authSubscription: Subscription = new Subscription();

    constructor(
        private translate: TranslateService,
        private authService: AuthService,
        private googleAuthService: GoogleAuthService,
        private cdr: ChangeDetectorRef,
        private router: Router
    ) {
        const lang = localStorage.getItem('lang') || 'es';
        this.translate.use(lang);
        console.log('[NAVBAR] init lang ->', lang);
        this.currentLang = lang;
    }

    // Método para toggle del dropdown de idioma
    toggleLanguageDropdown() {
        this.isLanguageDropdownOpen = !this.isLanguageDropdownOpen;
    }

    // Método para cerrar el dropdown al hacer clic afuera
    closeLanguageDropdown() {
        this.isLanguageDropdownOpen = false;
    }

    // Método para cambiar el idioma
    switchLanguage(lang: string) {
        console.log('[NAVBAR] switchLanguage called ->', lang);
        console.log('[NAVBAR] currentLang before change ->', this.translate.currentLang);
        
        // Cerrar el dropdown
        this.closeLanguageDropdown();
        
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
        // Navegar al home después del logout
        this.router.navigate(['/']);
    }

    // Método para navegación programática que evita problemas de scroll
    navigateTo(route: string, event?: Event) {
        if (event) {
            event.preventDefault();
            event.stopPropagation();
        }
        this.closeMobileMenu();
        this.router.navigate([route]);
    }

    scrollToFooter() {
        // Prevenir comportamiento por defecto y hacer scroll suave hasta el final de la página
        const footerElement = document.querySelector('app-footer') || document.querySelector('footer');
        if (footerElement) {
            footerElement.scrollIntoView({ 
                behavior: 'smooth',
                block: 'start'
            });
        } else {
            // Fallback si no encuentra el footer
            window.scrollTo({
                top: document.body.scrollHeight,
                behavior: 'smooth'
            });
        }
    }
}