import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:saferfire/constants.dart';

abstract class UserAuthentication {
  static Future<http.Response> register(
      String email, String password, String fireStation) async {
    return http.post(
      Uri.parse('http://$ipAddress/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'passwordhash': _hashPassword(password),
        'firestation': fireStation,
      }),
    );
  }

  static Future<http.Response> login(String email, String password) {
    return http.post(
      Uri.parse('http://$ipAddress/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'passwordhash': _hashPassword(password),
      }),
    );
  }

  static Future<http.Response> createGuest(String fireStation) async {
    return http.post(
      Uri.parse('http://$ipAddress/guest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firestation': fireStation,
      }),
    );
  }

  static Future<http.Response> getAlarms(String fireStation) async{
    return http.post(
      Uri.parse('http://$ipAddress/allalarmsdb'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiQWRtaW4iLCJpYXQiOjE2NDY5MDY1NDQsImV4cCI6MTY3ODQ0MjU0NH0.6YuZjOA_t-SGFg3cVZH0IYrBIUOEMbTRXHcBupmih2Q',
        'firestation': 'FF Schweinbach'
      }),
    );
  }
  static String _hashPassword(String password){
    var bytes1 = utf8.encode(password);
    return sha256.convert(bytes1).toString();
  }
}
