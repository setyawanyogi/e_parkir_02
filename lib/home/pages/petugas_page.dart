import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_parkir_02/login/login.dart';
import 'package:e_parkir_02/home/home_page.dart';

class PetugasPage extends StatelessWidget {
  // User Logout Function.
  logout(BuildContext context) {
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              title: Text('Petugas'),
              centerTitle: true,
              automaticallyImplyLeading: false),
          body: SafeArea(
            child: Column(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //        image: DecorationImage(
                //            image: NetworkImage("add you image URL here "),
                //            fit: BoxFit.cover)
                //           ),
                //   child: Container(
                //     width: double.infinity,
                //     height: 200,
                //     child: Container(
                //       alignment: Alignment(0.0, 2.5),
                //       child: CircleAvatar(
                //          backgroundImage:
                //              NetworkImage(""),
                //          radius: 60.0,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Rajat Palankar",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Belgaum, India",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "App Developer at XYZ Company",
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    elevation: 2.0,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        child: Text(
                          "Skill Sets",
                          style: TextStyle(
                              letterSpacing: 2.0, fontWeight: FontWeight.w300),
                        ))),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "App Developer || Digital Marketer",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w300),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      
                    ),
                  ),
                ),
               
                
              ],
            ),
          )),
    );
  }
}
