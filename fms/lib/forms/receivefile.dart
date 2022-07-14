import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fms/global.dart';
// import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../components/flashbar.dart';
import '../requests.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// https://fmtsapi.ntu.edu.pk/create_file
// Parameters: file_subject, file_desc, employee_id, dept_id, sub_dept_id, token

class RecevieFileForm extends StatefulWidget {
  const RecevieFileForm({Key? key}) : super(key: key);

  @override
  State<RecevieFileForm> createState() => _RecevieFileFormState();
}

List<Map<String, dynamic>> addnewfilefields = [
  {
    'key': 'barcode',
    'title': 'Barcode',
    'type': 'textfield',
    'required': true,
    'controller': TextEditingController(),
    'disable': false,
  },
];

class _RecevieFileFormState extends State<RecevieFileForm> {
  var pageKey = GlobalKey<ScaffoldState>();

  textfields() {
    return addnewfilefields.map((e) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            readOnly: e['disable'] == true,
            controller: e['controller'] as TextEditingController,
            decoration: InputDecoration(
              labelText: e['title'].toString() +
                  (e['required'] as bool ? ' *' : ' (Optional)'),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mainColor, width: 2.0),
              ),
              hintText: e['title'].toString(),
            )),
      );
    }).toList();
  }

  Map<String, dynamic> e = addnewfilefields[0];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: pageKey,
        drawer: drawer(context),
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.receipt),
              Text(" Receive File"),
            ],
          ),
        ),
        body: ListView(children: [
          const SizedBox(
            height: 30,
          ),
          Icon(
            Icons.receipt,
            size: 100,
            color: mainColor,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: TextButton(
                  onPressed: () async {
                    String barcodeScanRes =
                        await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666", "CANCEL", false, ScanMode.DEFAULT);
                    e['controller'].text = barcodeScanRes;
                    setState(() {});
                  },
                  child: Icon(Icons.camera_alt)),
              title: Row(
                children: [
                  Expanded(
                    child: TextField(
                        readOnly: e['disable'] == true,
                        controller: e['controller'] as TextEditingController,
                        decoration: InputDecoration(
                          labelText: e['title'].toString() +
                              (e['required'] as bool ? ' *' : ' (Optional)'),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mainColor, width: 2.0),
                          ),
                          hintText: e['title'].toString(),
                        )),
                  ),
                  e['controller'].text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            e['controller'].text = "";
                            setState(() {});
                          },
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red[900],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          // ...textfields(),
          inputButtons()
        ]),
      ),
    );
  }

  inputButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          color: mainColor,
          child: const Text("Receive"),
          onPressed: () {
            receiveFile();
          }),
    );
  }

  validate() {
    bool flag = true;
    for (var e in addnewfilefields) {
      TextEditingController controller =
          e['controller'] as TextEditingController;
      if (controller.text.isEmpty) {
        flag = false;
      }
    }
    return flag;
  }

  resetForm() {
    for (var e in addnewfilefields) {
      TextEditingController controller =
          e['controller'] as TextEditingController;
      controller.text = "";
    }
  }

  receiveFile() async {
    bool flag = validate();
    if (flag) {
      Map<String, dynamic> fieldValues = {};
      for (var e in addnewfilefields) {
        TextEditingController controller =
            e['controller'] as TextEditingController;
        fieldValues[e['key'].toString()] = controller.text;
      }
      var data = Map<String, dynamic>.from(globalUser);
      fieldValues['employee_id'] = data['employee_id'].toString();
      fieldValues['dept_id'] = data['dept_id'].toString();
      fieldValues['sub_dept_id'] = data['sub_dept_id'].toString();
      fieldValues['token'] = data['token'].toString();
      var res = await receiveFileAPI(fieldValues);
      showSnackbar(
          key: pageKey, msg: res['message'], status: res['status'] == 1);
      if (res['status'] == 1) {
        resetForm();
      }
    } else {
      showSnackbar(key: pageKey, msg: "Complete the Form", status: false);
    }
  }
}
