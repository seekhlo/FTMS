import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fms/global.dart';

import '../dashboard/griddashboard.dart';
import '../forms/addnewfile.dart';
import '../forms/receivefile.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget {
  @override
  State createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State {
  Widget? _child;

  @override
  void initState() {
    _child = GridDashboard();
    super.initState();
  }

  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: _child,
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(
                icon: Icons.create,
                backgroundColor: mainColor,
                extras: {"label": "Create File"}),
            FluidNavBarIcon(
                icon: Icons.dashboard_sharp,
                backgroundColor: mainColor,
                extras: {"label": "dashboard"}),
            FluidNavBarIcon(
                icon: Icons.receipt,
                backgroundColor: mainColor,
                extras: {"label": "Receive FIle"}),
          ],
          onChange: _handleNavigationChange,
          style: const FluidNavBarStyle(
              iconSelectedForegroundColor: Colors.white,
              iconUnselectedForegroundColor: Colors.white60),
          scaleFactor: 1.5,
          defaultIndex: 1,
          itemBuilder: (icon, item) => Semantics(
            label: icon.extras!["label"],
            child: item,
          ),
        ),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = NewFileForm();
          break;
        case 1:
          _child = GridDashboard();
          break;
        case 2:
          _child = RecevieFileForm();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}
