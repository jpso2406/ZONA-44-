import { Injectable } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

@Injectable({ providedIn: 'root' })
export class LanguageService {
  constructor(private translate: TranslateService) {
    const savedLang = localStorage.getItem('lang') || 'es';
    this.translate.setDefaultLang(savedLang);
    this.translate.use(savedLang);
    console.log('[LANGUAGE SERVICE] init lang ->', savedLang);
  }

  get currentLang(): string {
    return this.translate.currentLang || this.translate.getDefaultLang();
  }

  changeLanguage(lang: string): void {
    this.translate.use(lang);
    localStorage.setItem('lang', lang);
  }
}