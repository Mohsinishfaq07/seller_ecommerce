import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/cart_model.dart';

class CompletedOrders extends StatelessWidget {
  const CompletedOrders({super.key});

  Stream<List<Map<String, dynamic>>> fetchCompletedOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('orderStatus', isEqualTo: OrderStatus.dispatched.name)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completed Orders')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchCompletedOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data ?? [];
          final currentUserId = FirebaseAuth.instance.currentUser!.uid;

          final filteredOrders = orders
              .where(
                (order) => order['sellerId'] == currentUserId,
              )
              .toList();

          if (filteredOrders.isEmpty) {
            return const Center(child: Text('No completed orders.'));
          }

          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              CardModel orderDetails = CardModel(
                productName: order['productName'] ?? '',
                productPrice: order['productPrice'] ?? '',
                productId: order['productId'] ?? '',
                quantity: order['quantity'] ?? '',
                customerId: order['customerId'] ?? '',
                orderId: order['orderId'] ?? '',
                sellerId: order['sellerId'] ?? '',
                productImage: order['productImage'] ?? '',
                orderStatus: order['orderStatus'] ?? '',
              );
              return Card(
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    child: Column(
                      children: [
                        Text('Product Name: ${orderDetails.productName}'),
                        Text('Product Price: ${orderDetails.productPrice}'),
                        Text('Quantity: ${orderDetails.quantity}'),
                        Text('Order ID: ${orderDetails.orderId}'),
                        Text('Status: ${orderDetails.orderStatus}'),
                      ],
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
