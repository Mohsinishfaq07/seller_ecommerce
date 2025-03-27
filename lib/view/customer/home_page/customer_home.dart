import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/app_styles.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/functions/global_functions.dart';
import 'package:flutter_application_1/models/product_sell_model.dart';
import 'package:flutter_application_1/view/customer/cart/cart_page.dart';
import 'package:flutter_application_1/view/customer/orders/orders_page.dart';
import 'package:flutter_application_1/view/customer/product_page/product_page.dart';
import 'package:flutter_application_1/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerHomePage extends ConsumerWidget {
  const CustomerHomePage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (shouldLogout ?? false) {
        await constants.authServices.signOut(context: context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to logout. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        actions: [
          ElevatedButton(
              onPressed: () {
                constants.globalFunctions
                    .nextScreen(context, CustomerOrdersPage());
              },
              child: Text('Orders')),
          IconButton(
              icon: const Icon(Icons.card_travel, color: AppColors.white),
              onPressed: () {
                constants.globalFunctions.nextScreen(context, CartPage());
              }),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .doc('categories')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No categories found.'));
            }

            List<dynamic> categoryList =
                snapshot.data!.get('categoryName') ?? [];
            debugPrint('category list:$categoryList');
            return ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                final category = categoryList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        category.toString().toUpperCase(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .where('prodCategory', isEqualTo: category)
                            .snapshots(),
                        builder: (context, prodSnapshot) {
                          if (prodSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (prodSnapshot.hasError) {
                            return Center(
                                child: Text('Error: ${prodSnapshot.error}'));
                          }

                          final productDocs = prodSnapshot.data?.docs ?? [];

                          if (productDocs.isEmpty) {
                            return const Center(
                                child: Text('No products available.'));
                          }

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productDocs.length,
                            itemBuilder: (context, i) {
                              final product = productDocs[i];
                              ProductSellModel prod = ProductSellModel(
                                  productName: product['productName'],
                                  productDescription:
                                      product['productDescription'],
                                  productPrice: product['productPrice'],
                                  images: List<String>.from(
                                      product['images'] ?? []),
                                  uploadedBy: product['uploadedBy'],
                                  extraProductInformation:
                                      product['extraProductInformation'],
                                  prodCategory: product['prodCategory']);
                              return GestureDetector(
                                onTap: () {
                                  constants.globalFunctions.nextScreen(
                                      context,
                                      ProductDetailsScreen(
                                        product: prod,
                                        productId: product.id,
                                      ));
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(8),
                                  child: Container(
                                    width: 140,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          prod.images[0],
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          prod.productName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text("Price: \$${prod.productPrice}"),
                                        // Add image or more fields if needed
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
