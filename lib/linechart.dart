import 'dart:io';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'authentication.dart';

const chosenYear = '2022';
List<double> spots = List<double>.filled(12, 0, growable: false);

class Linechart extends StatelessWidget {

  List<AlarmData> data = [
    AlarmData('JAN', spots[0]),
    AlarmData('FEB', spots[1]),
    AlarmData('MÄRZ', spots[2]),
    AlarmData('APR', spots[3]),
    AlarmData('MAI', spots[4]),
    AlarmData('JUNI', spots[5]),
    AlarmData('JULI', spots[6]),
    AlarmData('AUG', spots[7]),
    AlarmData('SEP', spots[8]),
    AlarmData('OKT', spots[9]),
    AlarmData('NOV', spots[10]),
    AlarmData('DEZ', spots[11])
  ];

  @override
  Widget build(BuildContext context) {
    getSpots().then((value) => spots = value);
    return Scaffold (
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Statistik"),
        centerTitle: true,
        backgroundColor: Colors.red[700],
        brightness: Brightness.dark,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          title: ChartTitle(text: 'Einsätze pro Monat'),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<AlarmData, String>>[
            LineSeries<AlarmData, String>(
              dataSource: data,
              xValueMapper: (AlarmData alarms, _) => alarms.month,
              yValueMapper: (AlarmData alarms, _) => alarms.alarmCount,
              name: 'Alarms',
              dataLabelSettings: DataLabelSettings(isVisible: true),
            )
          ]
        )
      )
    );
  }

  static Future<List<double>> getSpots() async{
    List<double> spotsArray = [0,0,0,0,0,0,0,0,0,0,0,0]; //12 months -> ++ if alarm
    var res = await UserAuthentication.getAlarms("");
    var split =res.body.split("\"alarm_time\":");
    List<String> dates = [];
    for (int i = 1; i < split.length; i++)
    {
      var temp = split[i].substring(6,17);
      dates.add(temp);
    }

    for (int i = 0; i < dates.length; i++)
    {
      if (dates[i].contains('Jan') && dates[i].contains(chosenYear))
      {
        spotsArray[0]++;
      }
      else if (dates[i].contains('Feb') && dates[i].contains(chosenYear))
      {
        spotsArray[1]++;
      }
      else if (dates[i].contains('Mar') && dates[i].contains(chosenYear))
      {
        spotsArray[2]++;
      }
      else if (dates[i].contains('Apr') && dates[i].contains(chosenYear))
      {
        spotsArray[3]++;
      }
      else if (dates[i].contains('May') && dates[i].contains(chosenYear))
      {
        spotsArray[4]++;
      }
      else if (dates[i].contains('Jun') && dates[i].contains(chosenYear))
      {
        spotsArray[5]++;
      }
      else if (dates[i].contains('Jul') && dates[i].contains(chosenYear))
      {
        spotsArray[6]++;
      }
      else if (dates[i].contains('Apr') && dates[i].contains(chosenYear))
      {
        spotsArray[7]++;
      }
      else if (dates[i].contains('Sep') && dates[i].contains(chosenYear))
      {
        spotsArray[8]++;
      }
      else if (dates[i].contains('Oct') && dates[i].contains(chosenYear))
      {
        spotsArray[9]++;
      }
      else if (dates[i].contains('Nov') && dates[i].contains(chosenYear))
      {
        spotsArray[10]++;
      }
      else if (dates[i].contains('Dec') && dates[i].contains(chosenYear))
      {
        spotsArray[11]++;
      }
    }

    print(spotsArray);
    return spotsArray;
  }
}

class AlarmData {
  AlarmData(this.month, this.alarmCount);
  final String month;
  final double alarmCount;
}

