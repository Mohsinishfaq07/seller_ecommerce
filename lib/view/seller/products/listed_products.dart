import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/models/product_sell_model.dart';

class ProductWithId {
  final String id;
  final ProductSellModel product;

  ProductWithId({required this.id, required this.product});
}

class ListedProducts extends StatefulWidget {
  const ListedProducts({super.key});

  @override
  State<ListedProducts> createState() => _ListedProductsState();
}

class _ListedProductsState extends State<ListedProducts> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<ProductWithId>> fetchUserProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('uploadedBy', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final product = ProductSellModel.fromMap(doc.data());
              return ProductWithId(id: doc.id, product: product);
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listed Products'),
      ),
      body: StreamBuilder<List<ProductWithId>>(
        stream: fetchUserProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final productList = snapshot.data ?? [];

          if (productList.isEmpty) {
            return const Center(child: Text('No products listed.'));
          }

          return ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index].product;
              final docId = productList[index].id;

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(product.images[0]),
                    Text('Product Name:${product.productName}'),
                    Text('Product Description: ${product.productDescription}'),
                    Text('Price: ${product.productPrice}'),
                    Text('Category: ${product.prodCategory}'),
                    IconButton(
                      onPressed: () async {
                        firestoreService.deleteProduct(productId: docId);
                      },
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
