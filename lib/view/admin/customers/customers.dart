import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/customer_model.dart';
import 'package:flutter_application_1/models/seller_model.dart';

class CustomersShowPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CustomersShowPage({super.key});

  Stream<List<CustomerModel>> fetchNonApprovedSellers() {
    return _firestore
        .collection('users')
        .where('userType', isEqualTo: UserType.customer.toString())
        // .where('approved', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CustomerModel.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
      ),
      body: StreamBuilder<List<CustomerModel>>(
        stream: fetchNonApprovedSellers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No customers found."));
          }

          List<CustomerModel> customers = snapshot.data!;

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              CustomerModel customerModel = customers[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('name: ${customerModel.name}'),
                  Text('userType: ${customerModel.userType}'),
                  Text('number: ${customerModel.number}'),
                  IconButton(
                    onPressed: () {
                      firestoreService.deleteAccount(
                          docId: customerModel.userId);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
