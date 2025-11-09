import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { Router } from '@angular/router';
import { of, throwError } from 'rxjs';

import { Promociones } from './promociones';
import { PromocionesService } from '../../../Services/promociones.service';
import { PromocionesPublicService } from '../../../Services/promociones-public.service';
import { GlobalCartService } from '../../../Services/global-cart.service';
import { AuthService } from '../../../Pages/auth/auth.service';

describe('Promociones', () => {
  let component: Promociones;
  let fixture: ComponentFixture<Promociones>;
  let mockPromocionesService: jasmine.SpyObj<PromocionesService>;
  let mockPromocionesPublicService: jasmine.SpyObj<PromocionesPublicService>;
  let mockCartService: jasmine.SpyObj<GlobalCartService>;
  let mockAuthService: jasmine.SpyObj<AuthService>;
  let mockRouter: jasmine.SpyObj<Router>;
  let mockTranslateService: jasmine.SpyObj<TranslateService>;

  const mockPromociones = [
    {
      id: 1,
      title: 'Test Promo',
      description: 'Test Description',
      image: 'test.jpg',
      newPrice: 10.99,
      oldPrice: 15.99,
      isNew: true,
      validUntil: new Date('2025-12-31'),
      isActive: true,
      producto_id: 101
    }
  ];

  beforeEach(async () => {
    const promoServiceSpy = jasmine.createSpyObj('PromocionesService', ['getPromociones']);
    const publicServiceSpy = jasmine.createSpyObj('PromocionesPublicService', ['getPromocionesPublicas']);
    const cartServiceSpy = jasmine.createSpyObj('GlobalCartService', ['addItem']);
    const authServiceSpy = jasmine.createSpyObj('AuthService', ['isAuthenticated', 'getCurrentUser']);
    const routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    const translateServiceSpy = jasmine.createSpyObj('TranslateService', ['get']);

    await TestBed.configureTestingModule({
      imports: [Promociones, TranslateModule.forRoot()],
      providers: [
        { provide: PromocionesService, useValue: promoServiceSpy },
        { provide: PromocionesPublicService, useValue: publicServiceSpy },
        { provide: GlobalCartService, useValue: cartServiceSpy },
        { provide: AuthService, useValue: authServiceSpy },
        { provide: Router, useValue: routerSpy },
        { provide: TranslateService, useValue: translateServiceSpy }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(Promociones);
    component = fixture.componentInstance;
    
    mockPromocionesService = TestBed.inject(PromocionesService) as jasmine.SpyObj<PromocionesService>;
    mockPromocionesPublicService = TestBed.inject(PromocionesPublicService) as jasmine.SpyObj<PromocionesPublicService>;
    mockCartService = TestBed.inject(GlobalCartService) as jasmine.SpyObj<GlobalCartService>;
    mockAuthService = TestBed.inject(AuthService) as jasmine.SpyObj<AuthService>;
    mockRouter = TestBed.inject(Router) as jasmine.SpyObj<Router>;
    mockTranslateService = TestBed.inject(TranslateService) as jasmine.SpyObj<TranslateService>;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should load promociones on init', () => {
    mockPromocionesPublicService.getPromocionesPublicas.and.returnValue(of(mockPromociones));
    
    component.ngOnInit();
    
    expect(mockPromocionesPublicService.getPromocionesPublicas).toHaveBeenCalled();
    expect(component.promociones).toEqual(mockPromociones);
    expect(component.loading).toBeFalse();
  });

  it('should handle error and fallback to local service', () => {
    mockPromocionesPublicService.getPromocionesPublicas.and.returnValue(throwError('Network error'));
    mockPromocionesService.getPromociones.and.returnValue(of(mockPromociones));
    
    component.loadPromociones();
    
    expect(mockPromocionesPublicService.getPromocionesPublicas).toHaveBeenCalled();
    expect(mockPromocionesService.getPromociones).toHaveBeenCalled();
    expect(component.promociones).toEqual(mockPromociones);
    expect(component.loading).toBeFalse();
  });

  it('should handle promo selection when user is authenticated', () => {
    mockAuthService.isAuthenticated.and.returnValue(true);
    spyOn(window, 'alert');
    
    component.selectPromo(mockPromociones[0]);
    
    expect(mockCartService.addItem).toHaveBeenCalledWith({
      id: 101,
      name: 'Test Promo',
      precio: 10.99,
      cantidad: 1,
      foto_url: 'test.jpg',
      promocion_id: 1,
      is_promocion: true
    });
    expect(window.alert).toHaveBeenCalledWith('Promoción agregada al carrito correctamente');
  });

  it('should redirect to login when user is not authenticated', () => {
    mockAuthService.isAuthenticated.and.returnValue(false);
    spyOn(window, 'alert');
    
    component.selectPromo(mockPromociones[0]);
    
    expect(window.alert).toHaveBeenCalledWith('Debes iniciar sesión para agregar promociones al carrito');
    expect(mockRouter.navigate).toHaveBeenCalledWith(['/login']);
    expect(mockCartService.addItem).not.toHaveBeenCalled();
  });

  it('should track promociones by id', () => {
    const result = component.trackByPromoId(0, mockPromociones[0]);
    expect(result).toBe(1);
  });

  it('should navigate to login', () => {
    component.navigateToLogin();
    expect(mockRouter.navigate).toHaveBeenCalledWith(['/login']);
  });

  it('should handle image error', () => {
    const mockEvent = {
      target: {
        src: 'invalid-image.jpg'
      }
    };
    
    component.onImageError(mockEvent);
    
    expect(mockEvent.target.src).toBe('assets/burger.png');
  });

  it('should return emergency promociones when all services fail', () => {
    mockPromocionesPublicService.getPromocionesPublicas.and.returnValue(throwError('Network error'));
    mockPromocionesService.getPromociones.and.returnValue(throwError('Local error'));
    
    component.loadPromociones();
    
    expect(component.promociones.length).toBe(1);
    expect(component.promociones[0].id).toBe(999);
    expect(component.error).toBe('Error al cargar las promociones');
  });

  it('should check if user is authenticated', () => {
    mockAuthService.isAuthenticated.and.returnValue(true);
    
    const result = component.isUserAuthenticated();
    
    expect(result).toBeTrue();
    expect(mockAuthService.isAuthenticated).toHaveBeenCalled();
  });

  it('should get current user', () => {
    const mockUser = { 
      id: 1, 
      name: 'Test User',
      email: 'test@example.com',
      first_name: 'Test',
      last_name: 'User',
      phone: '123456789',
      password: 'password',
      role: 'user',
      address: 'Test Address',
      city: 'Test City',
      department: 'Test Department',
      created_at: new Date(),
      updated_at: new Date()
    };
    mockAuthService.getCurrentUser.and.returnValue(mockUser);
    
    const result = component.getCurrentUser();
    
    expect(result).toEqual(mockUser);
    expect(mockAuthService.getCurrentUser).toHaveBeenCalled();
  });

  it('should unsubscribe on destroy', () => {
    spyOn(component['subscription'], 'unsubscribe');
    
    component.ngOnDestroy();
    
    expect(component['subscription'].unsubscribe).toHaveBeenCalled();
  });
});