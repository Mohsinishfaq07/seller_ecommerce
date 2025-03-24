import 'package:flutter/material.dart';

class SellerEditPage extends StatelessWidget {
  const SellerEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Seller Edit Products Page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
