import { Component } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  endpoint = 'http://152.67.71.8/login';
  constructor(private httpClient: HttpClient) {}
  httpHeader = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin':'*',
    }),
  };
  email!: string;
  password!: string;

  login() {
    var response =
     this.httpClient.post(
      this.endpoint, 
      JSON.stringify("email:"+this.email+"passwordhash:"+this.password),
      this.httpHeader).subscribe(data => console.log(data))
    console.log(response);
  }
}
