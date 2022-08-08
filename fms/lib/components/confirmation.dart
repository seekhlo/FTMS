import 'package:flutter/material.dart';

Future confirmationDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: SingleChildScrollView(
          child: Column(
            children: const [
              Text('Are You Sure you want to Archive this?'),
            ],
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            color: Colors.green,
            child: const Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          MaterialButton(
            color: Colors.red,
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}
