import 'package:flutter/material.dart';
import 'package:labs/ui/widgets/home_body.dart';
import 'package:labs/ui/widgets/secret-flashlight-button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Tracker'),
        actions: const [
          SecretFlashlightButton(),
        ],
      ),
      body: const HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/profile'),
        child: const Icon(Icons.account_circle),
      ),
    );
  }
}
