import 'dart:convert';
import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fms/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/screens/login_screen.dart';
import 'navigation_bar/fluid_nav_bar.dart';

var globalUser;
checkLogin() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var user = pref.getString('user');
  if (user == null) {
    return null;
  } else {
    return jsonDecode(user);
  }
}

setUser(user) async {
  user = jsonEncode(user).toString();
  globalUser = jsonDecode(user);
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString('user', user);
  return;
}

removeUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove('user');
  return;
}

splash() {
  return AnimatedSplashScreen(
      backgroundColor: Colors.black,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(
            Icons.file_copy,
            color: Colors.white,
            size: 50,
          ),
          Expanded(
            child: Text(
              "File Management System",
              style: TextStyle(
                  fontSize: 20, color: Colors.white, fontFamily: 'OpenSans'),
            ),
          )
        ],
      ),
      nextScreen: globalUser == null ? const LoginScreen() : HomeScreen());
}

var dashboardFields = {
  'Files': [
    {
      'title': 'Create New File',
      'route': '/newfile',
      'icon': Icons.file_download
    },
    {
      'title': 'Receive File',
      'route': '/receivefile',
      'icon': Icons.receipt_long
    },
    // {
    //   'title': 'Manual Accept',
    //   'route': '/manualaccept',
    //   'icon': Icons.mark_as_unread
    // },
  ],
  // 'Our Department Files': [
  //   {
  //     'title': 'New Created Files',
  //     'route': '/newfiles',
  //     'icon': Icons.plus_one
  //   },
  //   {
  //     'title': 'Files in Process',
  //     'route': '/inprocessfiles',
  //     'icon': Icons.work
  //   },
  //   {
  //     'title': 'Completed Files',
  //     'route': '/completedfiles',
  //     'icon': Icons.done
  //   },
  //   {
  //     'title': 'Archived Files',
  //     'route': '/achivedfiles',
  //     'icon': Icons.archive
  //   },
  // ],
  // 'Other Department Files': [
  //   {
  //     'title': 'Total Files',
  //     'route': '/totalfilesindept',
  //     'icon': Icons.file_copy
  //   },
  //   {
  //     'title': 'Today Received',
  //     'route': '/todayreceviedfiles',
  //     'icon': Icons.receipt
  //   },
  //   {
  //     'title': 'Today Sent Files',
  //     'route': '/todaysentfiles',
  //     'icon': Icons.send
  //   },
  // ]
};

List<Color?> colors = [
  Colors.red[600],
  Colors.blue[600],
  Colors.green[600],
  Colors.cyan[600],
  Colors.orange[600],
  Colors.purple[600],
];
MaterialColor mainColor = Colors.blue;
List<MaterialColor> appColors = [
  // Colors.red,
  Colors.blue,
  // Colors.green,
  Colors.cyan,
  // Colors.orange,
  // Colors.purple,
];

drawer(context) {
  Size size = MediaQuery.of(context).size;
  return Drawer(
      child: ListView(children: [
    Container(
      child: Center(
        child: ListTile(
          tileColor: Colors.white,
          title: Text(
            globalUser['employee_name'],
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          leading: Icon(Icons.person),
        ),
      ),
      height: size.height / 10,
      // width: 30,
      decoration: BoxDecoration(
        color: mainColor,
      ),
    ),
    ListTile(
      onTap: () async {
        globalUser = null;
        await removeUser();
        Navigator.of(context).pushReplacementNamed('/login');
      },
      leading: const Icon(
        Icons.logout,
        size: 20,
        // color: Colors.white,
      ),
      title: const Text(
        'Logout',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      // tileColor: Colors.red[900],
    ),
    ...dashboardFields.entries.map((e) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(e.key),
            children: e.value.map((el) {
              return getListTile(el, context);
            }).toList()),
      );
    }).toList()
  ]));
}

Widget getListTile(el, context) {
  return ListTile(
    leading: Icon(
      el['icon'],
      color: mainColor,
    ),
    title: Text(el['title']!),
    onTap: () {
      Navigator.of(context).pushNamed(el['route']!);
    },
  );
}

checkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    }
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
}
