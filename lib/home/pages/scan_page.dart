import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with AutomaticKeepAliveClientMixin {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;

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
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
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
                  if(snapshot.data != null){
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
                  if(snapshot.data != null){
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
    setState(() => this.controller = controller);

    controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
