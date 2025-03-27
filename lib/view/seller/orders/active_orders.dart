import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';

class ActiveOrders extends StatelessWidget {
  const ActiveOrders({super.key});

  Stream<List<Map<String, dynamic>>> fetchActiveOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('orderStatus', isEqualTo: OrderStatus.active.name)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Orders')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchActiveOrders(),
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
            return const Center(child: Text('No active orders.'));
          }

          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return Card(
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    child: Column(
                      children: [
                        Text('Order ID: ${order['orderId'] ?? 'N/A'}'),
                        ElevatedButton(
                            onPressed: () {
                              firestoreService.updateOrderStatus(
                                  orderId: order['orderId'] ?? '',
                                  status: OrderStatus.processing.name);
                            },
                            child: Text('Update to Processin')),
                        ElevatedButton(
                            onPressed: () {
                              firestoreService.updateOrderStatus(
                                  orderId: order['orderId'] ?? '',
                                  status: OrderStatus.dispatched.name);
                            },
                            child: Text('Update to Dispatched'))
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
