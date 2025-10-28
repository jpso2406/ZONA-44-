import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TranslateModule } from '@ngx-translate/core';
import { of } from 'rxjs';

import { Promociones } from './promociones';
import { PromocionesService } from '../../../Services/promociones.service';
import { PromocionesPublicService } from '../../../Services/promociones-public.service';

describe('Promociones', () => {
  let component: Promociones;
  let fixture: ComponentFixture<Promociones>;
  let mockPromocionesService: jasmine.SpyObj<PromocionesService>;
  let mockPromocionesPublicService: jasmine.SpyObj<PromocionesPublicService>;

  const mockPromociones = [
    {
      id: 1,
      title: 'Test Promo',
      description: 'Test Description',
      image: 'test.jpg',
      newPrice: 10.99,
      isActive: true
    }
  ];

  beforeEach(async () => {
    const promoServiceSpy = jasmine.createSpyObj('PromocionesService', ['getPromociones', 'addToCart']);
    const publicServiceSpy = jasmine.createSpyObj('PromocionesPublicService', ['getPromocionesPublicas']);

    await TestBed.configureTestingModule({
      imports: [Promociones, TranslateModule.forRoot()],
      providers: [
        { provide: PromocionesService, useValue: promoServiceSpy },
        { provide: PromocionesPublicService, useValue: publicServiceSpy }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(Promociones);
    component = fixture.componentInstance;
    
    mockPromocionesService = TestBed.inject(PromocionesService) as jasmine.SpyObj<PromocionesService>;
    mockPromocionesPublicService = TestBed.inject(PromocionesPublicService) as jasmine.SpyObj<PromocionesPublicService>;
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

  it('should handle promo selection', () => {
    mockPromocionesService.addToCart.and.returnValue(of(true));
    spyOn(window, 'alert');
    
    component.selectPromo(mockPromociones[0]);
    
    expect(mockPromocionesService.addToCart).toHaveBeenCalledWith(1);
    expect(window.alert).toHaveBeenCalledWith('¡Promoción "Test Promo" agregada al carrito!');
  });

  it('should track promociones by id', () => {
    const result = component.trackByPromoId(0, mockPromociones[0]);
    expect(result).toBe(1);
  });
});