import 'package:flutter/material.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart_model.dart';
import 'package:flutter_application_1/services/cart_service/cart_service.dart';

class CartItemCountBadge extends StatelessWidget {
  const CartItemCountBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CardModel>>(
      stream: CartService.loadProductsStream(),
      initialData: const [], // Provide an initial empty list
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data!;
          int totalItems = 0;
          for (final product in products) {
            totalItems += int.parse(product.quantity);
          }
          return badges.Badge(
            label: Text(totalItems.toString()),
            child: const Icon(Icons.shopping_bag),
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading cart');
        } else {
          return const badges.Badge(
            label: Text('0'),
            child: Icon(Icons.shopping_bag),
          ); // Show 0 while loading
        }
      },
    );
  }
}
