import { Component } from '@angular/core';
import { NavbarComponent } from "../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../Components/shared/footer/footer";

@Component({
  imports: [NavbarComponent, FooterComponent],
  templateUrl: './home.html',
  styleUrl: './home.css'
})
export class Home {

}
