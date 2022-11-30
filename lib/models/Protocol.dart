import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Protocol{

  bool IsEmpty(){
    if(einstznummer == null){
      return false;
    }
    return true;
  }

  bool isTechnisch = true;

  //Grunddaten
  String? einstznummer;
  DateTime? leitstellenJahr;
  bool? nachbarschaftshilfe;
  String? kategorie;

  //Stammdaten
  TimeOfDay? uhrzeitAusfahrt;
  TimeOfDay? uhrzeitAnkunft;
  TimeOfDay? uhrzeitWiederbereit;
  TimeOfDay? uhrzeitEnde;
  String? strasse;
  String? koordinaten;
  String? alarmart;

  //Brand
  // Personenrettung
  int? personenGebaeude;
  int? personenKraftfahrzeug;
  int? personenVerletzt;
  int? personenTot;

  // Tierrettung
  int tiereGerettet = 0;
  int tiereTot = 0;

  //Brand - Statistik
  String? brandEndeckung;
  String? brandAusmass;
  String? brandKlasse;
  String? brand;
  String? objektart;
  String? brandBauart;
  String? brandLage;
  String? brandVerlauf;

  //Technische Statistik
  String? ursache = "Ursache";
  String? hauptTaetigkeit = "Haupt-Tätigkeit";
  String? gerfaehrlicheStoffe = "Gefährliche Stoffe";
  String? weiterTaetigkeiten = "Weitere Tätigkeiten";

  Protocol(
      this.einstznummer,
      this.kategorie,
      this.strasse,
      this.koordinaten,
      this.alarmart,
      this.leitstellenJahr);
}