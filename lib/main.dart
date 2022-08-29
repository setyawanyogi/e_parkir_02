// @dart=2.9

import 'package:e_parkir_02/login/testlogin.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_parkir_02/login/login.dart';
import 'package:e_parkir_02/home/home_page.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

String id_user = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: Scaffold(body: Center(child: LoginUser())),
      home: Scaffold(body: Center(child: testlogin())),
      //   routes: <String, WidgetBuilder>{
      //   '/home/HomePage': (BuildContext context) => new HomePage(
      //         id_user: id_user,
      //       ),

      // },
    );
  }
}
