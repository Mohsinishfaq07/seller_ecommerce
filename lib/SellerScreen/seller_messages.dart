import 'package:flutter/material.dart';

class SellerMessagesPage extends StatelessWidget {
  const SellerMessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Seller Messages Page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
