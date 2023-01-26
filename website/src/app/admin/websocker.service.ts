import { JsonPipe } from '@angular/common';
import { Component, Injectable } from '@angular/core';
import { CookieService } from 'ngx-cookie-service';
import { BehaviorSubject } from 'rxjs';
import { Socket, io } from 'socket.io-client';

@Injectable({
    providedIn: 'root',
})

export class WebsocketService {
    constructor(private cookieService:CookieService){}
    isTesting:boolean = true;
    alarms$: BehaviorSubject<string> = new BehaviorSubject('');
    socket= io('http://152.67.71.8:80/alarms');
    testsocket= io('http://152.67.71.8:80/testalarms');
    token = this.cookieService.get('token');

    public sendAlarmsRequest() {
        var body = '';
        if(this.isTesting){
            body = JSON.stringify({'token': this.token,'count':4});
            this.testsocket.emit('alarmsReq', body);
        }
        else{
            body = JSON.stringify({'token': this.token});
            this.socket.emit('alarmsReq', body);
        }
        console.log('alarmsReq: ', body)
    }

    public getAlarms = () => {
        this.socket.on('alarmsRes', (alarm) =>{
            console.log(alarm);
            this.alarms$.next(alarm);
        });
        return this.alarms$.asObservable();
    };
}
