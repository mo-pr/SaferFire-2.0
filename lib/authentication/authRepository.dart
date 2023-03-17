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
            prefs.setString('access_token', 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ6NC1zcUVETXpGSllqOVUwQzIxUGVUVS1ObVRxaFhkU3NHVk1nbHpoanBJIn0.eyJleHAiOjE2NzkyOTk2MTIsImlhdCI6MTY3ODQzNTYxMiwianRpIjoiZWU1ZDk5OTMtMDQ1Ni00MTE1LWE5ZTgtMDgzZDYwZmI0NDliIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3JlYWxtcy9zYWZlcmZpcmUiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiNmZjMDM5ODQtNzA3YS00ZWQ4LWI1OWMtZjM2MWFhNzlkNzZmIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoic2FmZXJmaXJlX2FwcCIsInNlc3Npb25fc3RhdGUiOiI5MDZjYjk3Yi02NmVhLTQwYmEtOTBmMS05MWFkMWJhNzI3NzAiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbImRlZmF1bHQtcm9sZXMtc2FmZXJmaXJlIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7InNhZmVyZmlyZV9hcHAiOnsicm9sZXMiOlsic2FmZXJmaXJlX2FkbWluIl19LCJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6InByb2ZpbGUgZW1haWwiLCJzaWQiOiI5MDZjYjk3Yi02NmVhLTQwYmEtOTBmMS05MWFkMWJhNzI3NzAiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZmlyZXN0YXRpb24iOiJGRiBUZXN0IiwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4iLCJnaXZlbl9uYW1lIjoiIiwiZmFtaWx5X25hbWUiOiIiLCJlbWFpbCI6ImFkbWluQHNhZmVyZmlyZS5hdCJ9.do4QVUwzz5wW4nPdwxAvgajEnTEuEQmXK5ivLCWL_qjPjpdikozYf6u2sFyKt_qnSWEEz7h9lZTLcdVa8a1U_xyGL7wxdT2MOENbCzuX4egPglve6G3TuCbPzRUGqMJJbhp_YvhOq1EqXYQDYBUEg1tt83fnMqgfIo9NQ03AgvBleD97NMKNi0ngmYQmbqd0NEiqL-MvM4CByVwFWfwe2AcuhOPTkNqyYQrR31rK2PW6dlX69sN88m67jWUfO2sHSBT2AHD-x6Y6M5ojAn-F-WkrrNnEvAyr8zhODe3VmFVgDOuJBAk9VUh4o2rASxarPQp1-jsAZJhUMiKDSw5cNg');
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