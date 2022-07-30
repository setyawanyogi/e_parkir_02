import 'dart:convert';
import 'dart:async';
// import 'package:blue_print_pos/blue_print_pos.dart';
// import 'package:blue_print_pos/receipt/receipt_text_size_type.dart';
// import 'package:blue_print_pos/receipt/receipt_text_style_type.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_parkir_02/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_parkir_02/home/pages/parkir_page.dart';


class Add extends StatefulWidget {
  Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  List _getlist = [];

  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
    getDevices();
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          //'http://10.0.2.2/eparkirlogin/parkir/list.php'));
          'http://103.55.37.171/eparkir/parkir/list.php'));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // entry data to variabel list _get
        setState(() {
          _getlist = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _onSubmit() async {
    try {
      return await http.post(
        //Uri.parse("http://10.0.2.2/eparkirlogin/parkir/create.php"),
        Uri.parse("http://103.55.37.171/eparkir/parkir/create.php"),
        body: {
          "id_kendaraan": id_kendaraan.toString(),
          "status": statusValue,
          "plat_nomor": plat_nomor.text,
          //"status": status.text,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        print(data["message"]);
        // showDialog(context: context,
        // builder: (BuildContext context) => AlertDialog(
        //     // title: Text('${data["plat_nomor"]}'),
        //     title: Text(data["message"]),
        // ));
        printer.connect(selectedDevice!);

        printer.printNewLine();
        printer.printNewLine();
        printer.printCustom('E_PARKIR', 3, 1);
        printer.printNewLine();
        printer.printNewLine();
        printer.printCustom(plat_nomor.text, 2, 1);
        printer.printCustom(jenis_kendaraan, 2, 1);
        printer.printCustom(data["jam_masuk"], 2, 1);
        printer.printCustom(data["jam_keluar"], 2, 1);
        printer.printCustom(data["tgl"], 2, 1);
        printer.printCustom(data['biaya'], 2, 1);
        printer.printCustom(data['status'], 2, 1);
        printer.printNewLine();
        printer.printNewLine();
        printer.printQRcode(data["id_parkir"].toString(), 200, 200, 1);
        printer.printNewLine();
        printer.printNewLine();
        printer.printNewLine();

        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil('/home/pages/parkir_page.dart', (Route<dynamic> route) => false);
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new HomePage()));
      });
    } catch (e) {
      print(e);
    }
  }

  //thremal printer
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  // BluePrintPos bluePrintPos = BluePrintPos.instance;
  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  void InitState() {
    super.initState();
  }

  //inisialize field
  List _get = [];
  List<String> items = ['Parkir', 'Selesai'];
  String? statusValue = 'Parkir';
  String jenis_kendaraan = '';
  int? id_kendaraan;
  var plat_nomor = TextEditingController();
  var status = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Data"),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownSearch<dynamic>(
                  //you can design textfield here as you want
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Jenis Kendaraan",
                    hintText: "Pilih Jenis Kendaraan",
                  ),

                  //have two mode: menu mode and dialog mode
                  mode: Mode.MENU,
                  //if you want show search box
                  //showSearchBox: true,

                  //get data from the internet
                  onFind: (text) async {
                    var response = await http.get(Uri.parse(
                        //"http://10.0.2.2/eparkirlogin/widget/listkendaraan.php"));
                        "http://103.55.37.171/eparkir/widget/listkendaraan.php"));

                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);

                      setState(() {
                        _get = data['kendaraan'];
                      });
                    }

                    return _get as List<dynamic>;
                  },

                  //what do you want anfter item clicked
                  onChanged: (value) {
                    setState(() {
                      jenis_kendaraan = value['jenis_kendaraan'];
                      id_kendaraan = value['id_kendaraan'];
                    });
                  },

                  //this data appear in dropdown after clicked
                  itemAsString: (item) => item['jenis_kendaraan'],
                ),
                SizedBox(height: 20),
                Text(
                  'Plat Nomor',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: plat_nomor,
                  decoration: InputDecoration(
                      hintText: "Tulis Plat Nomor",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      fillColor: Colors.white,
                      filled: true),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Plat Nomor is Required!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Status',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: statusValue,
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                            value: item, child: Text(item)))
                        .toList(),
                    onChanged: (item) => setState(() => statusValue = item),
                  ),
                ),
                SizedBox(height: 15),
                DropdownButton<BluetoothDevice>(
                    value: selectedDevice,
                    hint: const Text('Select Thermal Printer'),
                    onChanged: (devices) {
                      setState(() {
                        selectedDevice = devices;
                      });
                    },
                    items: devices
                        .map((e) => DropdownMenuItem(
                              child: Text(e.name!),
                              value: e,
                            ))
                        .toList()),
                SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //validate
                    if (_formKey.currentState!.validate()) {
                      //send data to database with this method
                      _onSubmit();
                    }
                  },
                ),
                SizedBox(height: 5),
                ElevatedButton(
                    onPressed: () {
                      printer.connect(selectedDevice!);
                    },
                    child: const Text('Connect')),
                ElevatedButton(
                    onPressed: () {
                      printer.disconnect();
                    },
                    child: const Text('Disconnect')),
                ElevatedButton(
                    onPressed: () {
                      printer.connect(selectedDevice!);

                      printer.printNewLine();
                      printer.printNewLine();
                      printer.printCustom('E_PARKIR', 3, 1);
                      printer.printNewLine();
                      printer.printNewLine();
                      printer.printCustom(plat_nomor.text, 2, 1);
                      printer.printNewLine();
                      printer.printCustom(jenis_kendaraan, 2, 1);
                      printer.printNewLine();
                      printer.printNewLine();
                      printer.printQRcode(id_kendaraan.toString(), 200, 200, 1);
                      printer.printNewLine();
                      printer.printNewLine();
                      printer.printNewLine();
                    },
                    child: const Text('Print'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
