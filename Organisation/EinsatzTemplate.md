# Einsatzdaten

## Grundinformationen

| Feld                |  Datentyp  |                           Anmerkungen |
| :------------------ | :--------: | ------------------------------------: |
| Leitstellen Jahr    |    YYYY    |                         Keine Anmerk. |
| Einsatznummer       | String(10) |          Beratung mit Preinning nötig |
| Nachbarschaftshilfe |    Bool    |                          Ja oder Nein |
| Kategorie           |    ENUM    | Brandeinsatz oder Technischer EInsatz |
## Stammdaten
| Feld                         | Datentyp |    Anmerkungen |
| :--------------------------- | :------: | -------------: |

## Brand
### Personenrettung
| Feld                         | Datentyp |    Anmerkungen |
| :--------------------------- | :------: | -------------: |
| aus Notlage/Gebäude gerettet |   int    | Default Wert 0 |
| aus Kraftfahrzeug gerettet   |   int    | Default Wert 0 |
| davon verletzte Zivilperson  |   int    | Default Wert 0 |
| totgeborgene Zivilperson     |   int    | Default Wert 0 |

### Tierrettung 
| Feld              | Datentyp |    Anmerkungen |
| :---------------- | :------: | -------------: |
| gerettete Tiere   |   int    | Default Wert 0 |
| totgeborene Tiere |   int    | Default Wert 0 |

### Brand-Statistik
| Feld              | Datentyp |            Anmerkungen |
| :---------------- | :------: | ---------------------: |
| Brand, Entdeckugn |   ENUM   |
| Brand, Ausmaß     |   ENUM   |
| Brand, Klasse     |  String  |
| Brand             |   ENUM   | Gebäude oder sonstiges |
| Objektart         |   ENUM   |
| Brand, Bauart     |   ENUM   |
| Brand, Lage       |   ENUM   |
| Brand, Verlauf    |   ENUM   |

## Technischer-ES

### Tierrettung 
| Feld              | Datentyp |    Anmerkungen |
| :---------------- | :------: | -------------: |
| gerettete Tiere   |   int    | Default Wert 0 |
| totgeborene Tiere |   int    | Default Wert 0 |

### Brand-Statistik
| Feld              | Datentyp |            Anmerkungen |
| :---------------- | :------: | ---------------------: |
| Brand, Entdeckugn |   ENUM   |
| Brand, Ausmaß     |   ENUM   |
| Brand, Klasse     |  String  |
| Brand             |   ENUM   | Gebäude oder sonstiges |
| Objektart         |   ENUM   |
| Brand, Bauart     |   ENUM   |
| Brand, Lage       |   ENUM   |
| Brand, Verlauf    |   ENUM   |

### Technische-Statistik
| Feld                | Datentyp |    Anmerkungen |
| :------------------ | :------: | -------------: |
| Ursache             |   ENUM   |
| Haupt-Tätigkeit     |   ENUM   |
| Gefährliche Stoffe  |   ENUM   | Kann leer sein |
| Weitere Tätigkeiten |  string  |


