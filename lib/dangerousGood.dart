import 'dart:ffi';

class DangerousGood{
  late int unNr;
  late int hazardsNr;
  late String classification;
  late String name;

  DangerousGood();

  factory DangerousGood.fromJson(Map<String, dynamic> json) {
    var dgood = DangerousGood();
      dgood.unNr= int.parse(json['un_nr']);
      dgood.hazardsNr= json['hazards_nr']==null?-1:int.parse(json['hazards_nr']);
      dgood.classification= json['classification'];
      dgood.name= json['name'];
    return dgood;
  }
}