import { Component } from '@angular/core';
import { WebsocketService } from './websocker.service';

@Component({
  selector: 'app-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.css']
})

export class AdminComponent {
  alarmList: string[] = [];

  constructor(private alarmService: WebsocketService){}

  ngOnInit(){
    this.sendAlarmRequest();
    this.alarmService.getAlarms().subscribe((alarm: string) => {
      console.log(alarm);
      this.alarmList.push(alarm);
    })
  }

  sendAlarmRequest() {
    this.alarmService.sendAlarmsRequest();
  }
}
