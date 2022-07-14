import 'dart:convert';

import 'package:http/http.dart' as http;

import 'global.dart';

String login_url = "https://fmtsapi.ntu.edu.pk/login";
String dashboard_url =
    "https://fmtsapi.ntu.edu.pk/dashboard/token/dept_id/sub_dept_id/employee_id";
String receiveFileUrl = "https://fmtsapi.ntu.edu.pk/receive_file";
String createFileUrl = "https://fmtsapi.ntu.edu.pk/create_file";

Future loginAPI(cnic, pass) async {
  final http.Response res =
      await http.post(Uri.parse(login_url), body: <String, String>{
    'cnic': cnic,
    'userpass': pass,
  });
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
      "https://fmtsapi.ntu.edu.pk/dashboard/${data['token']}/${data['dept_id']}/${data['sub_dept_id']}/${data['employee_id']}";
  final http.Response res = await http.get(Uri.parse(url));
  return jsonDecode(res.body);
}
