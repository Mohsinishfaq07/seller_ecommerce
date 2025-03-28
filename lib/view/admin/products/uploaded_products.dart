import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/product_sell_model.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productRef = FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!.docs
              .map((doc) =>
                  ProductSellModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.images.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.images.first,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        product.productName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Price: ${product.productPrice}'),
                      const SizedBox(height: 4),
                      Text('Category: ${product.prodCategory}'),
                      const SizedBox(height: 4),
                      Text('Uploaded By: ${product.uploadedBy}'),
                      const SizedBox(height: 4),
                      Text('Description: ${product.productDescription}'),
                      const SizedBox(height: 4),
                      Text('Extra Info: ${product.extraProductInformation}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
