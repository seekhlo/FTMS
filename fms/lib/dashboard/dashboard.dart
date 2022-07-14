import 'dart:math';

import 'package:flutter/material.dart';

import '../global.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: drawer(context),
        backgroundColor: mainColor[50],
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.dashboard),
              Text("Dashboard"),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: dashboardFields.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(e.key),
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(2),
                        children: e.value.map((el) {
                          return makeDashboardItem(el['title']!.toString(),
                              el['route']!.toString(), el['icon'], context);
                        }).toList(),
                      ),
                    ]),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

Card makeDashboardItem(String? title, String? route, icon, context) {
  final _random = Random();
  int ran = _random.nextInt(colors.length);
  return Card(
    elevation: 2,
    margin: const EdgeInsets.all(8),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: colors[ran],
        boxShadow: [
          BoxShadow(
            color: colors[ran]!,
            blurRadius: 3,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(route!);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            Center(
              child: Text(
                title!,
                style: const TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
