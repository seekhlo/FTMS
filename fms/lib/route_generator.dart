import 'package:flutter/material.dart';
import 'package:fms/forms/addnewfile.dart';
import 'package:fms/forms/receivefile.dart';
import 'package:fms/login/screens/login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    String? name = settings.name;
    var args = (settings.arguments ?? {}) as Map;
    switch (name!.toLowerCase()) {
      case '/newfile':
        {
          return MaterialPageRoute(builder: (_) => const NewFileForm());
        }
      case '/receivefile':
        {
          return MaterialPageRoute(builder: (_) => const RecevieFileForm());
        }
      case '/login':
        {
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        }

      default:
        return _errorPage(settings.name.toString());
    }
  }

  static Route<dynamic> _errorPage(String name) {
    return MaterialPageRoute(builder: (_) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(centerTitle: true, title: const Icon(Icons.error)),
          body: Center(
            child: Text(name.toUpperCase() + " page Coming Soon"),
          ),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
