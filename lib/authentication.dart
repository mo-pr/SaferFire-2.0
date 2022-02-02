import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
abstract class UserAuthentication{
  static Future<http.Response> register(String email, String password, String fireStation) async{
    return http.post(
      Uri.parse('http://86.56.241.47:3030/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'passwordhash': hashPassword(password),
        'firestation': fireStation,
      }),
    );
  }
  static Future<http.Response> login(String email, String password){
    return http.post(
      Uri.parse('http://86.56.241.47:3030/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'passwordhash': hashPassword(password),
      }),
    );
  }
  static String hashPassword(String password){
    var bytes1 = utf8.encode(password);
    return sha256.convert(bytes1).toString();
  }
}