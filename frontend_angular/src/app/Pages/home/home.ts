import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../Components/shared/footer/footer";
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { Observable } from 'rxjs';


@Component({
  standalone: true,
  imports: [FooterComponent, TranslateModule],
  templateUrl: './home.html',
  styleUrls: ['./home.css']
})
export class Home implements OnInit, OnDestroy {
  
  constructor(
    private translate: TranslateService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit() {
    // Solo escuchar cambios de idioma básicos
    this.translate.onLangChange.subscribe(() => {
      console.log('[HOME] Language changed, forcing change detection');
      this.cdr.detectChanges();
    });
  }

  ngOnDestroy() {
    // Cleanup si es necesario
  }

  t(key: string): Observable<string> {
    return this.translate.stream(key);
  }
}
