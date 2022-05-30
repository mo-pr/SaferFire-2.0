class Protocol{

  //Grunddaten
  String? einstznummer;
  DateTime? leitstellenJahr;
  bool? nachbarschaftshilfe;
  String? kategorie;

  //Stammdaten
  DateTime? uhrzeitAusfahrt;
  DateTime? uhrzeitAnkunft;
  DateTime? uhrzeitWiederbereit;
  DateTime? uhrzeitEnde;
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
  int? tiereGerettet;
  int? tiereTot;

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
  String? ursache;
  String? hauptTaetigkeit;
  String? gerfaehrlicheStoffe;
  String? weiterTaetigkeiten;

  Protocol(
      this.einstznummer,
      this.kategorie,
      this.strasse,
      this.koordinaten,
      this.alarmart);
}