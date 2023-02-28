import axios, { AxiosResponse } from "axios";
import { Mission } from "./mission.dto";

export class MissionHelper{
    public async getAlarms(needCurrent:boolean){
      let url ='https://cf-intranet.ooelfv.at/webext2/rss/json_2tage.txt';
      if(needCurrent){
        url ='https://cf-intranet.ooelfv.at/webext2/rss/json_laufend.txt';
      }
      const getalarms = async ()  => {
        let result: AxiosResponse = await axios.get(url);
        return result.data;
      };
      return await getalarms();
    }

    public async extractAlarms():Promise<Mission[]>{
        let alarms:String;
        let missions:Mission[] = [];
        await this.getAlarms(false).then(x=>alarms=x);
        let alarmCnt = alarms['cnt_einsaetze'];
        for(let i = 0; i < alarmCnt;i++){
          let temp = alarms['einsaetze'][i]['einsatz'];
          let firedeps = [];
          for(let i = 0; i < temp['cntfeuerwehren'];i++){
            firedeps.push(temp['feuerwehrenarray'][i.toString()]['fwname']+`${temp['cntfeuerwehren']>1?"\n":""}`);
          }
          let tempMission:Mission = {
            mission_id:String(temp['num1']),
            alarm_time:String(temp['startzeit']),
            stage:Number(temp['alarmstufe']),
            alarmtype:String(temp['einsatztyp']['text']),
            alarmsubtype:String(temp['einsatzsubtyp']['text']),
            district:String(temp['bezirk']['text']),
            street:String(temp['adresse']['efeanme']),
            street_no:Number(temp['adresse']['estnum']),
            area:String(temp['adresse']['earea']+"/ "+temp['adresse']['emun']),
            additional_info:String(temp['adresse']['ecompl']),
            longitude:String(temp['wgs84']['lng']),
            latitude:String(temp['wgs84']['lat']),
            firedepartments:firedeps.toString()
          }
          missions.push(tempMission);
        }
        return missions;
    }
}