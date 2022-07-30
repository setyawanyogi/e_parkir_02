import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_parkir_02/home/home_page.dart';
import 'package:e_parkir_02/home/pages/parkir_page.dart';
import 'package:e_parkir_02/home/pages/crud/add.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with AutomaticKeepAliveClientMixin {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          //get detail data with id
          //"http://10.0.2.2/eparkirlogin/parkir/detail.php?id_parkir='${barcode!.code}'"));
          "http://103.55.37.171/eparkir/parkir/detail.php?id_parkir='${barcode!.code}'"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future _onUpdate(context) async {
    try {
      return await http.post(
        //Uri.parse("http://10.0.2.2/eparkirlogin/parkir/update.php"),
        Uri.parse("http://103.55.37.171/eparkir/parkir/update.php?id_parkir='${barcode!.code}'"),
        body: {
          // "id": widget.id,
          // "title": title.text,
          // "content": content.text,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        print(data["message"]);
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  // title: Text('${data["plat_nomor"]}'),
                  title: Text(data["plat_nomor"]),
                  content: Text(data["status"]),
                ));
        // printer.connect(selectedDevice!);

        // printer.printNewLine();
        // printer.printNewLine();
        // printer.printCustom('E_PARKIR', 3, 1);
        // printer.printNewLine();
        // printer.printNewLine();
        // printer.printCustom(data["plat_nomor"], 2, 1);
        // printer.printCustom(data["jenis_kendaraan"], 2, 1);
        // printer.printCustom(data["jam_masuk"], 2, 1);
        // printer.printCustom(data["jam_keluar"], 2, 1);
        // printer.printCustom(data["tgl"], 2, 1);
        // printer.printCustom(data['biaya'], 2, 1);
        // printer.printCustom(data['status'], 2, 1);
        // printer.printNewLine();
        // printer.printNewLine();
        // printer.printQRcode(data["id_parkir"].toString(), 200, 200, 1);
        // printer.printNewLine();
        // printer.printNewLine();
        // printer.printNewLine();

        // Navigator.of(context)
        //   .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new HomePage()));
      });
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
        title: Text("Scan QR"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQRView(context),
          Positioned(bottom: 10, child: buildResult()),
          Positioned(top: 10, child: buildControlButtons()),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: 500,
      //   itemBuilder:(context, index){
      //     return Card(
      //       color: index % 2 == 0? Colors.purple : null,
      //       child: Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: Column(
      //           children: <Widget>[
      //             Text('Title of Parkir ${index+1}',
      //             style:
      //               TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
      //               color: index % 2 == 0? Colors.white : null,),
      //               ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
      //             ],
      //         ),
      //       ),
      //     );
      //   },
      //   ),
    );
  }

  Widget buildControlButtons() => Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                        snapshot.data! ? Icons.flash_on : Icons.flash_off);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
            ),
            IconButton(
              icon: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(Icons.switch_camera);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
            ),
          ],
        ),
      );

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white24),
        child: Text(
          barcode != null ? 'Result : ${barcode!.code}' : 'Scan a Code!',
          maxLines: 3,
        ),
        
        
      );

  Widget buildQRView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderWidth: 10,
          borderRadius: 10,
          borderLength: 20,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    _onUpdate(barcode);
    setState(() => this.controller = controller);
      //      setState(() {
      //   _onUpdate(context);
      // });
    
    controller.scannedDataStream
         .listen((barcode) => setState(() => this.barcode = barcode));
        //.listen((barcode) => setState(() => _onUpdate));
    //     .listen((barcode) {
    //       setState(() {
    //     _onUpdate;
    //   });
    // });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
