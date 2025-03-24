import 'package:flutter/material.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          TextButton(
            onPressed: null,
            child: Text('Manage Account'),
          ),
          TextButton(
            onPressed: null,
            child: Text('Payment Setting'),
          ),
          TextButton(
            onPressed: null,
            child: Text('Address Book'),
          ),
          TextButton(
            onPressed: null,
            child: Text('Country'),
          ),
          TextButton(
            onPressed: null,
            child: Text('Account Security'),
          ),
          TextButton(
            onPressed: null,
            child: Text('Request Account Deletion'),
          ),
        ],
      ),
    );
  }
}
