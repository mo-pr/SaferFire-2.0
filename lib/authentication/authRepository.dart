import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:saferfire/authentication/env.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static Future<bool> keycloakLogin(String username, String password) async {
    bool isLoggedIn = false;
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    final http = new IOClient(client);
    const Map<String,String> header = {
      'Content-type':'application/x-www-form-urlencoded'
    };
    Map<String, String> data = {
      'client_id': Environment.clientId,
      'client_secret': Environment.clientSec,
      'grant_type': 'password',
      'username': username,
      'password': password,
    };
    await http.post(Uri.parse(Environment.ssoUrl),body: data,headers: header)
        .then(
            (response) async {
              print(data);
          print("Reponse status : ${response.statusCode}");
          print("Response body : ${response.body}");

          if (response.statusCode == 200) {
            var prefs = await SharedPreferences.getInstance();
            var JSONObj = JsonDecoder().convert(response.body);
            Map<String, dynamic> claims = JwtDecoder.decode(JSONObj['access_token']);
            prefs.setString('access_token', JSONObj['access_token']);
            prefs.setString('refresh_token', JSONObj['refresh_token']);
            List<String> roles = claims['resource_access']['saferfire_app']['roles']
                .toString().replaceAll('[', '').replaceAll(']', '')
                .split(', ');
            prefs.setString('firestation', claims["firestation"].toString());
            prefs.setString('role', roles[0]);
            isLoggedIn = true;
          }
          else{
            isLoggedIn = false;
          }

        });
    return isLoggedIn;
  }

  static Future<bool> keycloakLogout() async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('access_token');
    var refreshToken = prefs.getString('refresh_token');
    var headers = {
      'Authorization': 'Bearer '+accessToken!,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse(Environment.logoutUrl));
    request.bodyFields = {
      'client_id': Environment.clientId,
      'client_secret': Environment.clientSec,
      'refresh_token': refreshToken!,
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 204) {
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }
  }
}