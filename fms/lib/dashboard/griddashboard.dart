import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fms/global.dart';

import '../requests.dart';

class GridDashboard extends StatefulWidget {
  @override
  State<GridDashboard> createState() => _GridDashboardState();
}

Map tiles = {};
Map<String, dynamic> dashboard_map = {
  "average_time": {
    'title': "Average Time",
    "icon": Icon(Icons.timelapse, size: 60)
  },
  "new_files": {'title': "New Files", "icon": Icon(Icons.file_copy, size: 42)},
  "inprocess_files": {
    'title': "Inprocess Files",
    "icon": Icon(Icons.wifi_protected_setup_sharp, size: 60)
  },
  "opened_files": {
    'title': "Opened Files",
    "icon": Icon(Icons.open_in_new, size: 60)
  },
  "archived_files": {
    'title': "Archived Files",
    "icon": Icon(Icons.archive, size: 60)
  },
  "other_dept_files": {
    'title': "Other Department",
    "icon": Icon(Icons.other_houses, size: 60)
  },
  "other_dept_files_received": {
    'title': "Other Department Received",
    "icon": Icon(Icons.download, size: 60)
  },
  "other_dept_files_sent": {
    'title': "Other Department Sent",
    "icon": Icon(Icons.upload, size: 60)
  },
  "my_watch_list_files": {
    'title': "Watch List",
    "icon": Icon(Icons.list, size: 60)
  },
};

class _GridDashboardState extends State<GridDashboard> {
  var loader = true;
  @override
  void initState() {
    Map dta = {
      // "status": 1,
      // "message": "Dashbord Widgets",
      // "data": {
      //   "new_files": 10,
      //   "inprocess_files": 10,
      //   "opened_files": 25,
      //   "archived_files": 0,
      //   "other_dept_files": 0,
      //   "other_dept_files_received": 0,
      //   "other_dept_files_sent": 0,
      //   "my_watch_list_files": 29,
      //   "average_time": "1 Month(s), 1 Day(s), 18 Hour(s), 27 Minute(s)"
      // }
    };
    getDashboardAPI()
        .then((value) => dta = value)
        .whenComplete(() => setState(() {
              loader = false;
              tiles = dta['data'];
            }));
    var sortedKeys = tiles.keys.toList()..sort();
    for (var key in sortedKeys) {
      Map data = dashboard_map[key];
      var element = tiles[key];
      DashboardItem d = DashboardItem(
          number: element.toString(), title: data['title'], icon: data['icon']);
      myDList.add(d);
    }
    // for (var element in tiles.entries) {
    //   Map data = dashboard_map[element.key];
    //   DashboardItem d = DashboardItem(
    //       number: element.value.toString(),
    //       title: data['title'],
    //       icon: data['icon']);
    //   myDList.add(d);
    // }
    // setState(() {});
    super.initState();
  }

  Widget getGridTile(data) {
    return Container(
      decoration: BoxDecoration(
          color: Color(color),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          data.icon!,
          SizedBox(
            height: 14,
          ),
          Center(
            child: Text(
              data.title!,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(
            height: 13,
          ),
          Text(
            data.number!,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  List<DashboardItem> myDList = [];

  var color = mainColor[800].hashCode;
  @override
  Widget build(BuildContext context) {
    color = mainColor[800].hashCode;
    return Scaffold(
      backgroundColor: mainColor[200],
      drawer: drawer(context),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
      ),
      body: loader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(height: 20),
                ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    globalUser['employee_name'],
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  leading: Icon(Icons.person),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: GridView.count(
                      childAspectRatio: 1.0,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      children: myDList.map((data) {
                        return getGridTile(data);
                      }).toList()),
                ),
                SizedBox(height: 60),
              ],
            ),
    );
  }
}

class DashboardItem {
  String? title;
  String? number;
  Icon? icon;
  DashboardItem({this.title, this.number, this.icon});
}
