import { Component } from '@angular/core';
import { AbstractControl, FormControl, FormGroup, Validators } from '@angular/forms';
import { Subject } from 'rxjs';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {
  validationForm: FormGroup;

  constructor() {
    this.validationForm = new FormGroup({
      name: new FormControl(null, Validators.required),
      subject: new FormControl(null, Validators.required),
      message: new FormControl(null, Validators.required),
    });
  }

  get name(): AbstractControl {
    return this.validationForm.get('name')!;
  }

  get subject(): AbstractControl {
    return this.validationForm.get('subject')!;
  }

  get message(): AbstractControl {
    return this.validationForm.get('message')!;
  }

  sendMail = () =>{
    var subject = 'SaferFire: '+this.validationForm.get('subject')!.value;
    var message:string = 'Message: '+this.validationForm.get('message')!.value
    var mail = 'mailto:preiningmoritz@gmail.com?subject=' + subject+
                 '&body=' + message;
    this.validationForm.reset();
    window.open(mail);
  }
}
