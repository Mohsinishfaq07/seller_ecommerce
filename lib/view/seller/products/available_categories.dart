import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/view/seller/products/listed_products.dart';
import 'package:flutter_application_1/view/seller/products/upload_products.dart';

class AvailableCategories extends StatelessWidget {
  const AvailableCategories({super.key});

  Future<List<String>> fetchCategories() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('categories')
          .doc('categories')
          .get();

      List<dynamic> data = doc['categoryName'];
      return List<String>.from(data);
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Categories'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categories[index]),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  globalFunctions.nextScreen(
                    context,
                    SellerUploadProducts(
                      productCategory: categories[index],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
