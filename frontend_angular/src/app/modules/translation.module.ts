import { NgModule } from '@angular/core';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import { TranslateModule, TranslateLoader, TranslateService } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';

export function HttpLoaderFactory(http: HttpClient) {
  console.log('[TRANSLATION] Creating HttpLoader for translations');
  return new TranslateHttpLoader(http, './assets/i18n/', '.json');
}

@NgModule({
  imports: [
    HttpClientModule,
    TranslateModule.forRoot({
      defaultLanguage: 'es',
      useDefaultLang: true,
      loader: {
        provide: TranslateLoader,
        useFactory: HttpLoaderFactory,
        deps: [HttpClient]
      }
    })
  ],
  exports: [TranslateModule, HttpClientModule]
})
export class TranslationModule {
  constructor(private translate: TranslateService) {
    console.log('[TRANSLATION] Module constructor called');
    
    // Obtener idioma guardado o usar español por defecto
    const savedLang = localStorage.getItem('lang') || 'es';
    console.log('[TRANSLATION] Setting language to:', savedLang);
    
    // Configurar idioma
    this.translate.setDefaultLang(savedLang);
    this.translate.use(savedLang);
    
    // Verificar que las traducciones se carguen
    setTimeout(() => {
      this.translate.get('HOME.WELCOME').subscribe(
        (translation) => {
          console.log('[TRANSLATION] Translation test - HOME.WELCOME:', translation);
        },
        (error) => {
          console.error('[TRANSLATION] Error loading translation:', error);
        }
      );
    }, 1000);
  }
}
