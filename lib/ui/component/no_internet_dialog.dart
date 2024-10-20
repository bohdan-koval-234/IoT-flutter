import 'package:flutter/material.dart';

void showNoInternetDialog(BuildContext context) {
  showDialog<Dialog>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your internet connection'
            ' and try again.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
