import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_parkir_02/home/pages/crud/add.dart';
import 'package:e_parkir_02/home/pages/crud/edit.dart';
import 'package:intl/intl.dart';

class ParkirPage extends StatefulWidget {
  ParkirPage({Key key}) : super(key: key);

  @override
  _ParkirPageState createState() => _ParkirPageState();
}

class _ParkirPageState extends State<ParkirPage>
    with AutomaticKeepAliveClientMixin {
  List _get = [];
  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          'http://10.0.2.2/eparkirlogin/parkir/list.php'));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // entry data to variabel list _get
        setState(() {
          _get = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Parkir"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _get.length != 0
          ? ListView.builder(
              itemCount: _get.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  // onTap: () {
                  //   Navigator.push(
                  //   context,
                  //   //routing into edit page
                  //   //we pass the id note
                  //   MaterialPageRoute(builder: (context) => Edit(id_parkir: _get[index]['id_parkir'],))
                  //   );
                  // },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: <Widget>[
                          // Text('${_get[index]['plat_nomor']}',
                          // style:
                          //   TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                          //   //color: index % 2 == 0? Colors.white : null,
                          //   ),
                          //   ),
                          // SizedBox(
                          //   height: 2,
                          // ),
                          // Text('${_get[index]['jenis_kendaraan']}',
                          // style:
                          //   TextStyle(fontSize: 16,
                          //   //color: index % 2 == 0? Colors.white : null,
                          //   ),
                          // ),

                          ListTile(
                            title: Text(
                              '${_get[index]['plat_nomor']}   (${_get[index]['status']})',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Rp. ${_get[index]['biaya']}',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            // leading: CircleAvatar(
                            //   backgroundColor: Colors.green,
                            //   radius: 30,
                            //   child: Icon(Icons.local_parking, color: Colors.white,size: 30.0,),
                            // ),
                            //Icon(Icons.local_parking, color: Colors.green,size: 30.0,),
                            //trailing: Icon(Icons.star)),
                            trailing: Column(
                              children: <Widget>[
                                
                                Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '${_get[index]['jam_masuk']} - ${_get[index]['jam_keluar']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 3,
                                  ),
                                ),
                                Text(
                                  '${_get[index]['tgl']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                //Icon(Icons.flight_land),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "No Data Available",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              //routing into add page
              MaterialPageRoute(builder: (context) => Add()));
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
