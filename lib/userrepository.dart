import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sweet_cookie_jar/sweet_cookie_jar.dart';

import 'app_constants.dart';

class UserRepository {
  final String _baseUrl =
      "https://myonlinedoctor-main.herokuapp.com/api/auth/login";

  Future<http.Response> loginUser() async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      cookie = SweetCookieJar.from(response: response);
      debugPrint(cookie);
      return response;
    } else {
      throw Exception('Doctor no existe');
    }
  }
}
