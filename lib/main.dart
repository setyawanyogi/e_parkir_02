import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_parkir_02/login/login.dart';
void main() => runApp(
    MaterialApp(
      home: MyApp(),
      )
    );

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
     ),
  home: Scaffold(
      body: Center(
        child: LoginUser()
        )
      )
    );
 }
}

