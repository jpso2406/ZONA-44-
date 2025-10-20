import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { NavbarComponent } from "./Components/shared/navbar/navbar";
import { FooterComponent } from "./Components/shared/footer/footer";
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { TranslationModule } from './modules/translation.module';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    NavbarComponent,
    TranslationModule
],
  templateUrl: './app.html',
  styleUrls: ['./app.css']
})
export class App implements OnInit {
  
  constructor(
    private translate: TranslateService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit() {
    // Configuración básica al iniciar
    console.log('[APP] Application initialized');
  }
}

