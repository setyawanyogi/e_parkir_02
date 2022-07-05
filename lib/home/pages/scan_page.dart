import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);
  

  @override
  _ScanPageState createState() => _ScanPageState();
  
}

class _ScanPageState extends State<ScanPage> 
with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Keluar"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: 500,
        itemBuilder:(context, index){
          return Card(
            color: index % 2 == 0? Colors.purple : null,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text('Title of Parkir ${index+1}', 
                  style: 
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                    color: index % 2 == 0? Colors.white : null,),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
                  ],
              ),
            ),
          );
        }, 
        ),  
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}