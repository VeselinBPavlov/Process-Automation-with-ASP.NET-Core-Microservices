import { Component, Input, OnInit } from '@angular/core';
import { openCloseAnimation, openCloseShadeAnimation } from './animations';
import { FormBuilder, FormGroup } from '@angular/forms';

@Component({
  selector: 'app-pop-up',
  templateUrl: './pop-up.component.html',
  styleUrls: ['./pop-up.component.scss'],
  animations: [
    openCloseAnimation,
    openCloseShadeAnimation,
  ],
  standalone: false
})
export class PopUpComponent implements OnInit {
  @Input() isOpen = false;
  @Input() permissionsInput: any;

  permissionsForm!: FormGroup;
  constructor() {

  }

  ngOnInit() {

  }
}
