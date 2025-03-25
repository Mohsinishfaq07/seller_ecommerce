import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/seller_model.dart';

class ApprovedSellersPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ApprovedSellersPage({super.key});

  Stream<List<SellerModel>> fetchNonApprovedSellers() {
    return _firestore
        .collection('users')
        .where('userType', isEqualTo: UserType.seller.toString())
        .where('approved', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SellerModel.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approved Sellers"),
      ),
      body: StreamBuilder<List<SellerModel>>(
        stream: fetchNonApprovedSellers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No approved sellers found."));
          }

          List<SellerModel> sellers = snapshot.data!;

          return ListView.builder(
            itemCount: sellers.length,
            itemBuilder: (context, index) {
              SellerModel seller = sellers[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('name: ${seller.name}'),
                  Text('shopName: ${seller.shopName}'),
                  Text('shopType: ${seller.shopType}'),
                  Text('approved: ${seller.approved}'),
                  Text('userType: ${seller.userType}'),
                  Text('number: ${seller.number}'),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(seller.userId)
                              .update({
                            'approved': false,
                          });
                        },
                        child: const Text('Mark as Non Approved'),
                      ),
                      IconButton(
                        onPressed: () async {
                          firestoreService.deleteAccount(docId: seller.userId);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
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
