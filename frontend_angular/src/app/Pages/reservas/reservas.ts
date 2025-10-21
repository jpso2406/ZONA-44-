import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule, NgIf, NgFor } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { ReservasService, TableReservation } from './reservas.service';
import { AuthService, User } from '../auth/auth.service';
import { Subscription } from 'rxjs';

@Component({
    templateUrl: './reservas.html',
    styleUrl: './reservas.css',
    imports: [NavbarComponent, CommonModule, FormsModule, NgIf, NgFor]
})

export class ReservasComponent implements OnInit, OnDestroy {
    // Formulario de nueva reserva
    newReservation: TableReservation = {
        name: '',
        email: '',
        phone: '',
        date: '',
        time: '',
        people_count: 1,
        comments: ''
    };

    // Estados del componente
    isLoading = false;
    showForm = true;
    message = '';
    messageType = '';
    
    // Usuario autenticado
    currentUser: User | null = null;
    private authSubscription: Subscription = new Subscription();

    // Opciones para el formulario
    timeSlots = [
        { value: '12:00', label: '12:00 - Almuerzo' },
        { value: '12:30', label: '12:30 - Almuerzo' },
        { value: '13:00', label: '13:00 - Almuerzo' },
        { value: '13:30', label: '13:30 - Almuerzo' },
        { value: '14:00', label: '14:00 - Almuerzo' },
        { value: '14:30', label: '14:30 - Almuerzo' },
        { value: '19:00', label: '19:00 - Cena' },
        { value: '19:30', label: '19:30 - Cena' },
        { value: '20:00', label: '20:00 - Cena' },
        { value: '20:30', label: '20:30 - Cena' },
        { value: '21:00', label: '21:00 - Cena' },
        { value: '21:30', label: '21:30 - Cena' },
        { value: '22:00', label: '22:00 - Cena' }
    ];

    constructor(
        private reservasService: ReservasService,
        private authService: AuthService
    ) { }

    ngOnInit() {
        this.setMinDate();
        this.loadUserData();
    }

    ngOnDestroy() {
        this.authSubscription.unsubscribe();
    }

    // Cargar datos del usuario autenticado
    loadUserData() {
        this.authSubscription.add(
            this.authService.currentUser$.subscribe(user => {
                this.currentUser = user;
                if (user) {
                    this.autoFillForm(user);
                }
            })
        );
    }

    // Autocompletar formulario con datos del usuario
    autoFillForm(user: User) {
        this.newReservation.name = `${user.first_name} ${user.last_name}`.trim();
        this.newReservation.email = user.email;
        this.newReservation.phone = user.phone;
    }

    // Establecer fecha mínima (hoy)
    setMinDate() {
        const today = new Date();
        this.newReservation.date = this.reservasService.formatDateForInput(today);
    }


    // Crear nueva reserva
    createReservation() {
        // Sanitizar entradas antes de validar
        this.newReservation.name = (this.newReservation.name || '').replace(/[^A-Za-zÁÉÍÓÚáéíóúÑñ\s'-]/g, ' ').replace(/\s+/g, ' ').trim();
        this.newReservation.email = (this.newReservation.email || '').trim();
        this.newReservation.phone = (this.newReservation.phone || '').replace(/[^0-9+\s()-]/g, '').replace(/\s+/g, ' ').trim();

        if (!this.validateForm()) {
            return;
        }

        this.isLoading = true;
        // Evitar doble envío si se hace submit repetido
        const payload: TableReservation = { ...this.newReservation };
        this.reservasService.createReservation(payload).subscribe({
            next: (response) => {
                if (response.success) {
                    this.showMessage('¡Solicitud de reserva enviada exitosamente! Esté pendiente a su correo para la confirmación.', 'success');
                    this.resetForm();
                } else {
                    this.showMessage('Error al enviar la solicitud: ' + (response.errors?.join(', ') || 'Error desconocido'), 'error');
                }
                this.isLoading = false;
            },
            error: (error) => {
                console.error('Error al crear reserva:', error);
                this.showMessage('Error al enviar la solicitud de reserva. Por favor, intente nuevamente.', 'error');
                this.isLoading = false;
            }
        });
    }


    // Validar formulario
    validateForm(): boolean {
        // Nombre: solo letras, espacios y guiones/apóstrofes
        if (!this.newReservation.name.trim()) {
            this.showMessage('Por favor, ingrese su nombre completo', 'error');
            return false;
        }
        if (!/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s'-]{2,}$/.test(this.newReservation.name)) {
            this.showMessage('El nombre solo puede contener letras y espacios', 'error');
            return false;
        }

        if (!this.newReservation.email.trim()) {
            this.showMessage('Por favor, ingrese su correo electrónico', 'error');
            return false;
        }
        // Email básico
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(this.newReservation.email)) {
            this.showMessage('Ingrese un correo electrónico válido', 'error');
            return false;
        }

        if (!this.newReservation.phone.trim()) {
            this.showMessage('Por favor, ingrese su número de teléfono', 'error');
            return false;
        }
        // Teléfono: dígitos y símbolos comunes
        if (!/^[0-9+()\-\s]{7,20}$/.test(this.newReservation.phone)) {
            this.showMessage('Ingrese un teléfono válido (solo dígitos y +()- )', 'error');
            return false;
        }

        if (!this.newReservation.date) {
            this.showMessage('Por favor, seleccione una fecha para su reserva', 'error');
            return false;
        }

        if (!this.newReservation.time) {
            this.showMessage('Por favor, seleccione una hora para su reserva', 'error');
            return false;
        }

        if (this.newReservation.people_count < 1) {
            this.showMessage('El número de personas debe ser al menos 1', 'error');
            return false;
        }

        if (!this.reservasService.isDateValid(this.newReservation.date, this.newReservation.time)) {
            this.showMessage('La fecha y hora seleccionadas deben ser futuras', 'error');
            return false;
        }

        return true;
    }

    // Resetear formulario
    resetForm() {
        // Si el usuario está logueado, mantener sus datos
        if (this.currentUser) {
            this.newReservation = {
                name: `${this.currentUser.first_name} ${this.currentUser.last_name}`.trim(),
                email: this.currentUser.email,
                phone: this.currentUser.phone,
                date: '',
                time: '',
                people_count: 1,
                comments: ''
            };
        } else {
            this.newReservation = {
                name: '',
                email: '',
                phone: '',
                date: '',
                time: '',
                people_count: 1,
                comments: ''
            };
        }
        this.setMinDate();
    }

    // Solo letras (bloquea números para inputs de texto)
    allowOnlyLetters(event: KeyboardEvent) {
        const char = event.key;
        const allowed = /^[A-Za-zÁÉÍÓÚáéíóúÑñ\s'-]$/;
        if (!allowed.test(char)) {
            event.preventDefault();
        }
    }

    // Solo caracteres válidos para teléfono (bloquea letras)
    allowOnlyPhoneChars(event: KeyboardEvent) {
        const char = event.key;
        const allowed = /^[0-9+()\-\s]$/;
        if (!allowed.test(char)) {
            event.preventDefault();
        }
    }

    // Sanitización en tiempo real
    onNameInput() {
        this.newReservation.name = (this.newReservation.name || '')
            .replace(/[^A-Za-zÁÉÍÓÚáéíóúÑñ\s'-]/g, ' ')
            .replace(/\s+/g, ' ')
            .trim();
    }

    onPhoneInput() {
        this.newReservation.phone = (this.newReservation.phone || '')
            .replace(/[^0-9+()\-\s]/g, '')
            .replace(/\s+/g, ' ')
            .trim();
    }

    // Mostrar mensaje
    showMessage(text: string, type: 'success' | 'error' | 'info') {
        this.message = text;
        this.messageType = type;
        setTimeout(() => {
            this.message = '';
        }, 5000);
    }

}