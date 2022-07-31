import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fms/global.dart';
import 'package:fms/route_generator.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  globalUser = await checkLogin();
  await checkConnection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ran = Random().nextInt(appColors.length);
    mainColor = appColors[ran];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'National Textile University FMS',
      theme: ThemeData(primarySwatch: mainColor),
      home: splash(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
