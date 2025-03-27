import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/view/seller/orders/active_orders.dart';
import 'package:flutter_application_1/view/seller/orders/dispatched_orders.dart';
import 'package:flutter_application_1/view/seller/orders/processing_products.dart';
import 'package:flutter_application_1/view/seller/products/available_categories.dart';
import 'package:flutter_application_1/view/seller/products/listed_products.dart';
import 'package:flutter_application_1/view/seller/products/upload_products.dart';

class SellerNewHomePage extends StatelessWidget {
  const SellerNewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Seller Home'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              globalFunctions.nextScreen(
                context,
                const AvailableCategories(),
              );
            },
            child: Text('upload product'),
          ),
          ElevatedButton(
            onPressed: () {
              globalFunctions.nextScreen(context, ListedProducts());
            },
            child: Text('listed products'),
          ),
          ElevatedButton(
            onPressed: () {
              globalFunctions.nextScreen(context, ActiveOrders());
            },
            child: Text('new orders'),
          ),
          ElevatedButton(
            onPressed: () {
              globalFunctions.nextScreen(context, ProcessingOrders());
            },
            child: Text('processing orders'),
          ),
          ElevatedButton(
            onPressed: () {
              globalFunctions.nextScreen(context, CompletedOrders());
            },
            child: Text('dispatched / completed orders'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('chats'),
          )
        ],
      ),
    );
  }
}
