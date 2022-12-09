import 'dart:ffi';
import 'dart:io';
import 'package:intl/date_symbol_data_http_request.dart';
import 'package:intl/intl.dart';
import 'package:saferfire/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'authentication.dart';

List<double> spots = List<double>.filled(12, 0, growable: false);
List<AlarmData> data = [];
final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy');
String currentYear = formatter.format(now); //current year in String
List<int> daysInOneMonth = [];

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

    return FutureBuilder<List<double>>(
        future: getSpots(dropdownvalueYear),
        builder: (context, AsyncSnapshot<List<double>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold (
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text("Statistik"),
                  centerTitle: true,
                  backgroundColor: Colors.red[700],
                  brightness: Brightness.dark,
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
                        items: itemsYear?.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalueYear = newValue!;
                            spots = List<double>.filled(12, 0, growable: false);
                            getSpots(dropdownvalueYear).then((value) => spots = value);

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
                          });
                        },
                      ),
                      DropdownButton( //month button
                        hint: const Text("choose month"),
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
                          });
                        },
                      ),
                      DropdownButton( //alarmtyp button
                        hint: const Text("choose type"),
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
                            spots = List<double>.filled(12, 0, growable: false);
                            getSpots(dropdownvalueYear).then((value) => spots = value);

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
                          });
                        },
                      ),
                    ],
                  ),
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
                          )
                        ]
                    )
                )
            );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }

  Future<List<double>> getSpots(String chosenYear) async {
    List<double> spotsArray = [0,0,0,0,0,0,0,0,0,0,0,0]; //12 months -> ++ if alarm
    var res = await UserAuthentication.getAlarms("");
    var split =res.body.split("},{");
    List<String> dates = [];
    List<String> types = [];
    List<int> days = [];

    for (int i = 0; i < split.length; i++)
    {
      var alarmsplit = split[i].split("\",\"");
      var date = alarmsplit[0].split(", ")[1];
      dates.add(date);
      var type = alarmsplit[1].split("\":\"")[1];
      types.add(type);
    }

    if (dropdownvalueMonth == null || dropdownvalueMonth == "Alle") {
      for (int i = 0; i < dates.length; i++) {
        if (dropdownvalueType == null || dropdownvalueType == "Alle") {
          if (dates[i].contains('Jan') && dates[i].contains(chosenYear)) {
            spotsArray[0]++;
          }
          else if (dates[i].contains('Feb') && dates[i].contains(chosenYear)) {
            spotsArray[1]++;
          }
          else if (dates[i].contains('Mar') && dates[i].contains(chosenYear)) {
            spotsArray[2]++;
          }
          else if (dates[i].contains('Apr') && dates[i].contains(chosenYear)) {
            spotsArray[3]++;
          }
          else if (dates[i].contains('May') && dates[i].contains(chosenYear)) {
            spotsArray[4]++;
          }
          else if (dates[i].contains('Jun') && dates[i].contains(chosenYear)) {
            spotsArray[5]++;
          }
          else if (dates[i].contains('Jul') && dates[i].contains(chosenYear)) {
            spotsArray[6]++;
          }
          else if (dates[i].contains('Aug') && dates[i].contains(chosenYear)) {
            spotsArray[7]++;
          }
          else if (dates[i].contains('Sep') && dates[i].contains(chosenYear)) {
            spotsArray[8]++;
          }
          else if (dates[i].contains('Oct') && dates[i].contains(chosenYear)) {
            spotsArray[9]++;
          }
          else if (dates[i].contains('Nov') && dates[i].contains(chosenYear)) {
            spotsArray[10]++;
          }
          else if (dates[i].contains('Dec') && dates[i].contains(chosenYear)) {
            spotsArray[11]++;
          }
        }
        if (dropdownvalueType == "Brand") {
          if (dates[i].contains('Jan') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[0]++;
          }
          else if (dates[i].contains('Feb') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[1]++;
          }
          else if (dates[i].contains('Mar') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[2]++;
          }
          else if (dates[i].contains('Apr') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[3]++;
          }
          else if (dates[i].contains('May') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[4]++;
          }
          else if (dates[i].contains('Jun') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[5]++;
          }
          else if (dates[i].contains('Jul') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[6]++;
          }
          else if (dates[i].contains('Aug') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[7]++;
          }
          else if (dates[i].contains('Sep') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[8]++;
          }
          else if (dates[i].contains('Oct') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[9]++;
          }
          else if (dates[i].contains('Nov') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[10]++;
          }
          else if (dates[i].contains('Dec') && dates[i].contains(chosenYear) &&
              types[i].contains(dropdownvalueType!)) {
            spotsArray[11]++;
          }
        }
        else if (dropdownvalueType == "Technischer Einsatz") {
          if (dates[i].contains('Jan') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[0]++;
          }
          else if (dates[i].contains('Feb') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[1]++;
          }
          else if (dates[i].contains('Mar') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[2]++;
          }
          else if (dates[i].contains('Apr') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[3]++;
          }
          else if (dates[i].contains('May') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[4]++;
          }
          else if (dates[i].contains('Jun') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[5]++;
          }
          else if (dates[i].contains('Jul') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[6]++;
          }
          else if (dates[i].contains('Aug') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[7]++;
          }
          else if (dates[i].contains('Sep') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[8]++;
          }
          else if (dates[i].contains('Oct') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[9]++;
          }
          else if (dates[i].contains('Nov') && dates[i].contains(chosenYear) &&
              types[i].contains("TE")) {
            spotsArray[10]++;
          }
          else if (dates[i].contains('Dec') && dates[i].contains(chosenYear) &&
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
          daysInOneMonth = List<int>.filled(daysInMonth, 0, growable: false); //makes list for every day in month

          for (int i = 0; i < dates.length; i++)
            {
              print(dates[0]);
            }



      }

    setState((){
      spots = spotsArray;
    });

    return spotsArray;
  }

  static List<String> getYears()
  {
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

  static int getMonthNumber(String month)
  {
    if (month == 'Jan')
      {
        return 1;
      }
    else if (month == 'Feb')
      {
        return 2;
      }
    else if (month == 'Mar')
    {
      return 3;
    }
    else if (month == 'Apr')
    {
      return 4;
    }
    else if (month == 'Mai')
    {
      return 5;
    }
    else if (month == 'Jun')
    {
      return 6;
    }
    else if (month == 'Jul')
    {
      return 7;
    }
    else if (month == 'Aug')
    {
      return 8;
    }
    else if (month == 'Sep')
    {
      return 9;
    }
    else if (month == 'Okt')
    {
      return 10;
    }
    else if (month == 'Nov')
    {
      return 11;
    }
    else if (month == 'Dec')
    {
      return 12;
    }

    return -1;
  }

  @override
  void initState() {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        spots = await getSpots(dropdownvalueYear);

        print("spots init");
        print(spots);
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







