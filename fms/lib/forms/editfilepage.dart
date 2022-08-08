import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fms/global.dart';

import '../components/flashbar.dart';
import '../requests.dart';

// https://fmtsapi.ntu.edu.pk/create_file
// Parameters: file_subject, file_desc, employee_id, dept_id, sub_dept_id, token

class EditFileForm extends StatefulWidget {
  var data;
  EditFileForm(this.data, {Key? key}) : super(key: key);

  @override
  State<EditFileForm> createState() => _EditFileFormState();
}

var addnewfilefields = [
  {
    'key': 'file_id',
    'title': 'File ID',
    'type': 'textfield',
    'required': true,
    'controller': TextEditingController(),
    'disable': true,
    'data_fill': 'FMTSFileID'
  },
  {
    'key': 'file_subject',
    'title': 'File Title/Subject',
    'type': 'textfield',
    'required': true,
    'controller': TextEditingController(),
    'disable': false,
    'data_fill': 'FMTSFileTitle'
  },
  {
    'key': 'file_desc',
    'title': 'File Description',
    'type': 'textfield',
    'required': true,
    'controller': TextEditingController(),
    'disable': false,
    'data_fill': 'FMTSFileDesc'
  },
];

class _EditFileFormState extends State<EditFileForm> {
  bool loader = true;
  String watchList = '';
  var watchListController = TextEditingController();
  var list;
  @override
  void initState() {
    print(widget.data);
    super.initState();
    // getUserDetails().then((value) {
    //   // print(value);
    //   list = value;
    // }).whenComplete(() {
    //   loader = false;
    //   setState(() {});
    // });
  }

  var pageKey = GlobalKey<ScaffoldState>();

  textfields() {
    return addnewfilefields.map((e) {
      TextEditingController c = e['controller'] as TextEditingController;
      c.text = widget.data[e['data_fill']];
      // print(e['data_fill']);
      // print(widget.data['FMTSFileID']);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            readOnly: e['disable'] == true,
            controller: c,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: pageKey,
        // drawer: drawer(context),
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.file_copy),
              Text(" Edit File"),
            ],
          ),
        ),
        body: ListView(children: [
          const SizedBox(
            height: 30,
          ),
          Icon(
            Icons.new_label,
            size: 100,
            color: mainColor,
          ),
          ...textfields(),
          // loader
          //     ? CircularProgressIndicator()
          //     : TextField(
          //         decoration: const InputDecoration(label: Text("Watch List")),
          //         controller: watchListController,
          //         onTap: () async {
          //           var data = await selectDropdown(
          //               context: context,
          //               setState: setState,
          //               data: list,
          //               displayValue: 'FullName',
          //               hint: 'Select Watch List');
          //           if (data == null) {
          //           } else {
          //             watchListController.text = data['EmployeeID'].toString() +
          //                 '/' +
          //                 data['FullName'];
          //             setState(() {});
          //           }
          //         },
          //       ),
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
          child: const Text("Update"),
          onPressed: () {
            saveFile();
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
    watchListController.text = "";
  }

  saveFile() async {
    // parameters: file_id, file_subject, file_desc, employee_id, token
    bool flag = validate();
    if (flag) {
      Map<String, dynamic> fieldValues = {};
      for (var e in addnewfilefields) {
        TextEditingController controller =
            e['controller'] as TextEditingController;
        fieldValues[e['key'].toString()] = controller.text;
      }
      if (watchListController.text != "") {
        fieldValues['watch_list'] = watchListController.text.split('/')[0];
      }
      var data = Map<String, dynamic>.from(globalUser);
      fieldValues['employee_id'] = data['employee_id'].toString();
      fieldValues['dept_id'] = data['dept_id'].toString();
      fieldValues['sub_dept_id'] = data['sub_dept_id'].toString();
      fieldValues['token'] = data['token'].toString();
      var res = await saveEditFileAPI(fieldValues);
      // var res;
      showSnackbar(
          key: pageKey, msg: res['message'], status: res['status'] == 1);
      if (res['status'] == 1) {
        resetForm();
        Navigator.of(context).pop(true);
      }
    } else {
      showSnackbar(key: pageKey, msg: "Complete the Form", status: false);
    }
  }
}
