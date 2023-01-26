import { Component } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { SHA256 } from 'crypto-js';
import { Router } from '@angular/router';
import { CookieService } from 'ngx-cookie-service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  endpoint = 'http://152.67.71.8/login';
  constructor(private httpClient: HttpClient, private router: Router,private cookieService:CookieService) {}
  httpHeader = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin':'*',
    }),
    observe: 'response',
  };
  email!: string;
  password!: string;
  
  
  login() {
    let passwordhash = SHA256(this.password).toString()
    let data = JSON.stringify({"email": this.email, "passwordhash": passwordhash})
    return this.httpClient.post<string>(this.endpoint, data,
      {
        headers: new HttpHeaders({
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin':'*',
        }),
        observe: 'response',
      })
      .subscribe((response) => {
        console.log(response.body);
        if(response.status==200&&response.body!=null){
          this.cookieService.set('token', response.body!);
          this.router.navigate(['/admin']);
        }
      })
  }
}
