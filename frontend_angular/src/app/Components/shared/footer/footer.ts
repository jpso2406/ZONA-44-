import { Component } from '@angular/core';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-footer',
    standalone: true,
    imports: [TranslateModule],
    templateUrl: 'footer.html',
    styleUrl: 'footer.css'
})

export class FooterComponent {
    version = '5.0.0';
}