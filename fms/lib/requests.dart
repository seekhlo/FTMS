import 'dart:convert';

import 'package:http/http.dart' as http;

import 'global.dart';
import 'model/file.dart';

String login_url = "https://fmtsapi.ntu.edu.pk/login";
String dashboard_url =
    "https://fmtsapi.ntu.edu.pk/dashboard/token/dept_id/sub_dept_id/employee_id";
String receiveFileUrl = "https://fmtsapi.ntu.edu.pk/receive_file";
String createFileUrl = "https://fmtsapi.ntu.edu.pk/create_file";
String saveEditFileUrl = "https://fmtsapi.ntu.edu.pk/save_edit_file";

Future loginAPI(cnic, pass) async {
  final http.Response res =
      await http.post(Uri.parse(login_url), body: <String, String>{
    'cnic': cnic,
    'userpass': pass,
  });
  var data = jsonDecode(res.body);
  // var user = await getUserDetails(data);
  // print(data);
  // print(user);
  // data.add(user['data']);
  return data;
}

Future saveEditFileAPI(map) async {
  print(map);
  final http.Response res =
      await http.post(Uri.parse(saveEditFileUrl), body: map);
  var data = jsonDecode(res.body);
  return data;
}

Future createFileAPI(map) async {
  final http.Response res =
      await http.post(Uri.parse(createFileUrl), body: map);
  var data = jsonDecode(res.body);
  return data;
}

Future receiveFileAPI(map) async {
//  barcode, employee_id, dept_id, sub_dept_id, token
  final http.Response res =
      await http.post(Uri.parse(receiveFileUrl), body: map);
  var data = jsonDecode(res.body);
  return data;
}

Future getDashboardAPI() async {
// https://fmtsapi.ntu.edu.pk/dashboard/token/dept_id/sub_dept_id/employee_id
  var data = Map<String, dynamic>.from(globalUser);
  String url =
      "https://fmtsapi.ntu.edu.pk/dashboard/${data['token']}/${data['sub_dept_id']}/${data['employee_id']}";
  final http.Response res = await http.get(Uri.parse(url));
  return jsonDecode(res.body);
}

Future getUserDetails() async {
  var data = Map<String, dynamic>.from(globalUser);

// https://fmtsapi.ntu.edu.pk/fmts_employees/token/employee_id
  String url =
      "https://fmtsapi.ntu.edu.pk/fmts_employees/${data['token']}/${data['employee_id']}";
  final http.Response res = await http.get(Uri.parse(url));
  return jsonDecode(res.body)['data'];
}

Future getFiles(req) async {
  final http.Response res = await http.get(Uri.parse(req));
  return jsonDecode(res.body);
}

Future printBarcode(fileID) async {
  var data = Map<String, dynamic>.from(globalUser);

  // https://fmtsapi.ntu.edu.pk/print_barcode/token/employee_id/file_id
  String url =
      "https://fmtsapi.ntu.edu.pk/print_barcode/${data['token']}/${data['employee_id']}/${fileID}";
  final http.Response res = await http.get(Uri.parse(url));
  return jsonDecode(res.body)['data'];
  // return res.body;
  // return "a";
}

Future archiveFileAPI(fileID) async {
  var data = Map<String, dynamic>.from(globalUser);
  final http.Response res = await http.post(Uri.parse(
      "https://fmtsapi.ntu.edu.pk/archive_file/${data['token']}/${data['employee_id']}/${fileID}"));
  print(res.body);
  return jsonDecode(res.body);
}
