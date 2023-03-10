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
            prefs.clear();
            prefs.setString('access_token', 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJaZEZBRnVORkFKSXZFVm43dENGOE5YMnJiVWF2Mk83VDhnTk10YWZ4V01NIn0.eyJleHAiOjE2NzkyOTU0NDIsImlhdCI6MTY3ODQzMTQ0MiwianRpIjoiZGE4ZWEyYmQtMDQzZC00MjY0LTlkMmEtODVlMTRlYTc2YzQwIiwiaXNzIjoiaHR0cHM6Ly9zYWZlcmZpcmUub3JnOjg0NDMvcmVhbG1zL3NhZmVyZmlyZSIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiI2NjI3YWM0Ni1kMDE5LTRkOTItYWVmMC1lN2MzNDZiZmIzYjIiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJzYWZlcmZpcmVfYXBwIiwic2Vzc2lvbl9zdGF0ZSI6ImExMzI4ZGI2LTAwMDQtNDRkMi05MmU5LTFjYzA3YzhjOTAyMSIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1zYWZlcmZpcmUiLCJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsic2FmZXJmaXJlX2FwcCI6eyJyb2xlcyI6WyJzYWZlcmZpcmVfYWRtaW4iXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6ImExMzI4ZGI2LTAwMDQtNDRkMi05MmU5LTFjYzA3YzhjOTAyMSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlc3RhdGlvbiI6IkZGIFRlc3QiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhZG1pbiIsImdpdmVuX25hbWUiOiIiLCJmYW1pbHlfbmFtZSI6IiIsImVtYWlsIjoiYWRtaW5Ac2FmZXJmaXJlLmF0In0.gH2zmLr5uHztBYzOcxSEPLBcbplAYEEilA6GqTMhi0mfWYp4g7Do-iPtZWUqG3pShd345sI52m_VB90oZ_hCixxFnfjIzpVMMFbWmQtm_ohKB_5o9kXCDv2NjFJP6gAJWX6eP996xTvGpciBwQ9qvxUF2KjsyQhoCGCXynR-tqC7rm4t9sMtKHZ5rmh09vsKYFciQ1IpWetuDS09BhSL1OEzDraZaYfMQIqHHrq4KaLGxohPHAhTd5h9lUd63zADK2nileklRi_Cer_K-JQa7ZgVr9ihU1dwrs5_jp_F_2mpn3MwoTpqcPn7sbrR9wqhbbYg9Ess7awafhw040tWTw');
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
    var headers = {
      'Authorization': 'Bearer '+accessToken!,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse(Environment.logoutUrl));
    request.bodyFields = {
      'client_id': Environment.clientId,
      'client_secret': Environment.clientSec,
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