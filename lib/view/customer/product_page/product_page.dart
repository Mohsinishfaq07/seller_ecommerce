import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/cart_model.dart';
import 'package:flutter_application_1/models/product_sell_model.dart';
import 'package:flutter_application_1/services/cart_service/cart_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductSellModel product;
  final String productId;

  const ProductDetailsScreen(
      {Key? key, required this.product, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: ListView.builder(
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey, width: 2),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(product.images[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Product Name
              Text(
                product.productName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Product Description
              Text(
                product.productDescription,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // Product Price
              Text(
                "\$${product.productPrice}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                product.extraProductInformation,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      CardModel cardModel = CardModel(
                          productName: product.productName,
                          productPrice: product.productPrice,
                          productId: productId,
                          quantity: '1',
                          customerId: FirebaseAuth.instance.currentUser!.uid,
                          orderId: generateRandom10DigitNumber(),
                          sellerId: product.uploadedBy,
                          productImage: product.images[0],
                          orderStatus: OrderStatus.active.name);
                      Navigator.pop(context);
                      CartService.addProduct(product: cardModel);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Message Seller'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

String generateRandom10DigitNumber() {
  final random = Random();
  String result = '';

  for (int i = 0; i < 10; i++) {
    result += random.nextInt(10).toString(); // Appends a random digit (0-9)
  }

  return result;
}
