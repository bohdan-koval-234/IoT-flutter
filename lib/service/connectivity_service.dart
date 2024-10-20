import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  late final StreamSubscription<InternetStatus> _subscription;

  ConnectivityService(BuildContext context) {
    _subscription = InternetConnection().onStatusChange.listen((status) {
        if (context.mounted && status == InternetStatus.connected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connected to the internet')),
          );
        } else if (context.mounted && status == InternetStatus.disconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No internet connection!')),
          );
        }
    });
  }

  void dispose() {
    _subscription.cancel();
  }
}
