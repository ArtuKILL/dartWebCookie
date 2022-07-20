import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';

final http.Client _client = http.Client();
final urlAppointments = Uri.parse(
    'https://myonlinedoctor-main.herokuapp.com/api/patient/appointments');
final urlLogin =
    Uri.parse('https://myonlinedoctor-main.herokuapp.com/api/auth/login');

Future<void> getAppointments() async {
  var dio = Dio();

  // var response = await dio.get(
  //   'https://myonlinedoctor-main.herokuapp.com/api/patient/appointments',
  //   queryParameters: {
  //     "pageIndex": 1,
  //     "pageSize": 1,
  //   },
  // );

  var response = await _client.get(
    urlAppointments,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  print(response.body);
}

Future<User> createUser(String email) async {
  // DioForBrowser _d = DioForBrowser(options);
  // var dio = DioForBrowser();
  // final BrowserClient _client = Browser;

  // Response response = await dio.post(
  //   'https://myonlinedoctor-main.herokuapp.com/api/auth/login',
  //   data: jsonEncode(<String, String>{
  //     'password': "12345678",
  //     'email': "doctor@email.com",
  //   }),
  // );

  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;

  var response = await _client.post(
    urlLogin,
    body: jsonEncode(
      <String, String>{
        'email': "doctor@email.com",
        'password': "12345678",
      },
    ),
  );

  //debugPrint(response.body.toString());

  if (response.statusCode == 201) {
    // print(Browser());

    return const User();
  } else {
    // If the server dpassword not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Doctor no existe');
  }
}

class User {
  final String password = "12345678";
  final String email = "doctor@email.com";

  const User();

  factory User.fromJson(Map<String, dynamic> json) {
    return const User();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<User>? _futureUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureUser == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter email'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              var user = createUser(_controller.text);
              getAppointments();
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.email);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
