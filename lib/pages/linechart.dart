import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../authentication.dart';

List<double> spots = List<double>.filled(12, 0, growable: false);
List<AlarmData> data = [];
final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy');
String currentYear = formatter.format(now); //current year in String
List<double> daysInOneMonth = [];
var firestation;
var monthForHeader = "Alle";
var typeForHeader = "Alle";

class LineChart extends StatefulWidget {
  const LineChart({super.key});

  @override
  LineChartState createState() => LineChartState();
}

class LineChartState extends State<LineChart> {
  //for filter year
  List<String> itemsYear = List<String>.filled(10, "", growable: false);
  String dropdownvalueYear = currentYear;

  //for month
  var itemsMonth = ['Alle', 'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'July', 'August', 'September', 'Oktober', 'November', 'Dezember'];
  String? dropdownvalueMonth;

  //for alarmtyp
  var itemsType = ['Alle', 'Technischer Einsatz', 'Brand'];
  String? dropdownvalueType;

  @override
  Widget build(BuildContext context) {
    itemsYear = getYears();

    if (dropdownvalueMonth == "Alle" || dropdownvalueMonth == null) {
      data = [
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
    }
    else
    {
      data = [];

      for (int i = 1; i <= spots.length; i++)
      {
        data.add(AlarmData("$i", spots[i-1]));
      }
    }

    return FutureBuilder<List<double>>(
        future: getSpots(),
        builder: (context, AsyncSnapshot<List<double>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold (
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title:  Text("Statistik"),
                  centerTitle: true,
                  backgroundColor: Colors.red[700],
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                ),
                bottomNavigationBar: BottomAppBar(
                  color: Colors.red,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DropdownButton( //year button
                        value: dropdownvalueYear,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: itemsYear.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalueYear = newValue!;
                          });
                        },
                      ),
                      DropdownButton( //month button
                        hint: const Text("Monat"),
                        value: dropdownvalueMonth,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: itemsMonth.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalueMonth = newValue!;
                            monthForHeader = dropdownvalueMonth!;
                          });
                        },
                      ),
                      DropdownButton( //alarmtyp button
                        hint: const Text("Einsatzart"),
                        value: dropdownvalueType,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: itemsType.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalueType = newValue!;
                            typeForHeader = dropdownvalueType!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                body: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                        title: ChartTitle(text: 'Feuerwehr: $firestation | Jahr: $dropdownvalueYear | Monat: $monthForHeader | Typ: $typeForHeader'),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<AlarmData, String>>[
                          LineSeries<AlarmData, String>(
                            dataSource: data,
                            xValueMapper: (AlarmData alarms, _) => alarms.month,
                            yValueMapper: (AlarmData alarms, _) => alarms.alarmCount,
                            name: 'Alarms',
                          )
                        ]
                    )
                )
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }

  Future<List<double>> getSpots() async {
    List<double> spotsArray = [0,0,0,0,0,0,0,0,0,0,0,0]; //12 months -> ++ if alarm
    var res = await UserAuthentication.getAlarms("");
    var split =res.body.split("},{");

    List<String> dates = [];
    List<String> types = [];

    for (int i = 0; i < split.length; i++)
    {
      var alarmsplit = split[i].split("\",\"");
      var date = alarmsplit[1].split(", ")[1];
      dates.add(date);
      var type = alarmsplit[4].split("\":\"")[1];
      types.add(type);
    }

    if (dropdownvalueMonth == null || dropdownvalueMonth == "Alle") {
      for (int i = 0; i < dates.length; i++) {
        if (dropdownvalueType == null || dropdownvalueType == "Alle") {
          if (dates[i].contains('Jan') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[0]++;
          }
          else if (dates[i].contains('Feb') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[1]++;
          }
          else if (dates[i].contains('Mar') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[2]++;
          }
          else if (dates[i].contains('Apr') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[3]++;
          }
          else if (dates[i].contains('May') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[4]++;
          }
          else if (dates[i].contains('Jun') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[5]++;
          }
          else if (dates[i].contains('Jul') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[6]++;
          }
          else if (dates[i].contains('Aug') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[7]++;
          }
          else if (dates[i].contains('Sep') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[8]++;
          }
          else if (dates[i].contains('Oct') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[9]++;
          }
          else if (dates[i].contains('Nov') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[10]++;
          }
          else if (dates[i].contains('Dec') && dates[i].contains(dropdownvalueYear)) {
            spotsArray[11]++;
          }
        }
        if (dropdownvalueType == "Brand") {
          if (dates[i].contains('Jan') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[0]++;
          }
          else if (dates[i].contains('Feb') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[1]++;
          }
          else if (dates[i].contains('Mar') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[2]++;
          }
          else if (dates[i].contains('Apr') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[3]++;
          }
          else if (dates[i].contains('May') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[4]++;
          }
          else if (dates[i].contains('Jun') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[5]++;
          }
          else if (dates[i].contains('Jul') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[6]++;
          }
          else if (dates[i].contains('Aug') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[7]++;
          }
          else if (dates[i].contains('Sep') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[8]++;
          }
          else if (dates[i].contains('Oct') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[9]++;
          }
          else if (dates[i].contains('Nov') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[10]++;
          }
          else if (dates[i].contains('Dec') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[11]++;
          }
        }
        else if (dropdownvalueType == "Technischer Einsatz") {
          if (dates[i].contains('Jan') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[0]++;
          }
          else if (dates[i].contains('Feb') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[1]++;
          }
          else if (dates[i].contains('Mar') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[2]++;
          }
          else if (dates[i].contains('Apr') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[3]++;
          }
          else if (dates[i].contains('May') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[4]++;
          }
          else if (dates[i].contains('Jun') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[5]++;
          }
          else if (dates[i].contains('Jul') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[6]++;
          }
          else if (dates[i].contains('Aug') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[7]++;
          }
          else if (dates[i].contains('Sep') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[8]++;
          }
          else if (dates[i].contains('Oct') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[9]++;
          }
          else if (dates[i].contains('Nov') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[10]++;
          }
          else if (dates[i].contains('Dec') && dates[i].contains(dropdownvalueYear) &&
              types[i].contains("TE")) {
            spotsArray[11]++;
          }
        }
      }
    }

    if (dropdownvalueMonth != null && dropdownvalueMonth != "Alle")
    {
      String? chosenMonthString = dropdownvalueMonth;

      int chosenYear = int.parse(dropdownvalueYear);
      int chosenMonth = getMonthNumber(chosenMonthString!);

      int daysInMonth = getDaysInMonth(chosenYear, chosenMonth);
      daysInOneMonth = List<double>.filled(daysInMonth, 0, growable: false); //makes list for every day in month

      //get shortform for month
      String monthShortform = getShortformMonth(chosenMonth);

      if (dropdownvalueType == "Alle" || dropdownvalueType == null) {
        for (int i = 0; i < dates.length; i++) {
          if (dates[i].contains(dropdownvalueYear) &&
              dates[i].contains(monthShortform)) {
            var day = int.parse(dates[i].split(' ')[0]);
            daysInOneMonth[day]++;
          }
        }
      }
      else if (dropdownvalueType == 'Brand')
      {
        for (int i = 0; i < dates.length; i++) {
          if (dates[i].contains(dropdownvalueYear) &&
              dates[i].contains(monthShortform) && types[i].contains('Brand')) {
            var day = int.parse(dates[i].split(' ')[0]);

            daysInOneMonth[day]++;
          }
        }
      }
      else if (dropdownvalueType == 'Technischer Einsatz')
      {
        for (int i = 0; i < dates.length; i++) {
          if (dates[i].contains(dropdownvalueYear) &&
              dates[i].contains(monthShortform) && !types[i].contains('Brand')) {
            var day = int.parse(dates[i].split(' ')[0]);

            daysInOneMonth[day]++;
          }
        }
      }

      spotsArray = daysInOneMonth;
    }



    setState((){
      spots = spotsArray;
    });

    return spotsArray;
  }

  static List<String> getYears() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy');

    String currentYear = formatter.format(now); //current year in String
    int yearInt = int.parse(currentYear); //current year in Int

    List<String> items = List<String>.filled(10, "", growable: false);
    items[0] = currentYear;

    for (int i = 1; i < 10; i++)
    {
      items[i] = (yearInt - i).toString(); //gets all 20 years before current year
    }

    return items;
  }

  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month - 1];
  }

  static int getMonthNumber(String month) {
    if (month == 'Januar')
    {
      return 1;
    }
    else if (month == 'Februar')
    {
      return 2;
    }
    else if (month == 'März')
    {
      return 3;
    }
    else if (month == 'April')
    {
      return 4;
    }
    else if (month == 'Mai')
    {
      return 5;
    }
    else if (month == 'Juni')
    {
      return 6;
    }
    else if (month == 'Juli')
    {
      return 7;
    }
    else if (month == 'August')
    {
      return 8;
    }
    else if (month == 'September')
    {
      return 9;
    }
    else if (month == 'Oktober')
    {
      return 10;
    }
    else if (month == 'November')
    {
      return 11;
    }
    else if (month == 'Dezember')
    {
      return 12;
    }

    return -1;
  }

  static String getShortformMonth(int month) {
    if (month == 1)
    {
      return 'Jan';
    }
    else if (month == 2)
    {
      return 'Feb';
    }
    else if (month == 3)
    {
      return 'Mar';
    }
    else if (month == 4)
    {
      return 'Apr';
    }
    else if (month == 5)
    {
      return 'May';
    }
    else if (month == 6)
    {
      return 'Jun';
    }
    else if (month == 7)
    {
      return 'Jul';
    }
    else if (month == 8)
    {
      return 'Aug';
    }
    else if (month == 9)
    {
      return 'Sep';
    }
    else if (month == 10)
    {
      return 'Oct';
    }
    else if (month == 11)
    {
      return 'Nov';
    }
    else if (month == 12)
    {
      return 'Dec';
    }

    return "null";
  }

  @override
  void initState() {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        spots = await getSpots();
      });
    });
    super.initState();
  }
}

class AlarmData {
  AlarmData(this.month, this.alarmCount);
  final String month;
  final double alarmCount;
}



