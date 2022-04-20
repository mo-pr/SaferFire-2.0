import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:saferfire/constants.dart';

abstract class UserAuthentication{
  static Future<http.Response> register(String email, String password, String fireStation) async{
    return http.post(
      Uri.parse('http://$ipAddress:3030/register'),
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
  static Future<http.Response> login(String email, String password){
    return http.post(
      Uri.parse('http://$ipAddress:3030/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'passwordhash': _hashPassword(password),
      }),
    );
  }
  static Future<http.Response> createGuest(String fireStation)async{
    return http.post(
      Uri.parse('http://$ipAddress:3030/guest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firestation': fireStation,
      }),
    );
  }

  static String _hashPassword(String password){
    var bytes1 = utf8.encode(password);
    return sha256.convert(bytes1).toString();
  }
}