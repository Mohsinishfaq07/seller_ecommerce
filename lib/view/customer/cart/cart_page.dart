import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/models/cart_model.dart';
import 'package:flutter_application_1/services/cart_service/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<CardModel>>(
              stream: CartService.loadProductsStream(),
              builder: (context, snapshot) {
                // Same as above
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Cart is empty'));
                }
                List<CardModel> products = snapshot.data!;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product Name: ${product.productName}'),
                          Text('Price: Rs${product.productPrice}'),
                          Text('Quantity: ${product.quantity}'),
                          Text('Product ID: ${product.productId}'),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    CartService.updateProductQuantity(
                                  productId: product.productId,
                                  quantityChange: 1,
                                ),
                                icon: const Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () =>
                                    CartService.updateProductQuantity(
                                  productId: product.productId,
                                  quantityChange: -1,
                                ),
                                icon: const Icon(Icons.remove),
                              ),
                              IconButton(
                                onPressed: () => CartService.removeProduct(
                                  productId: product.productId,
                                ),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          StreamBuilder<double>(
            stream: CartService.totalStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              }
              double total = snapshot.data ?? 0.0;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Total: Rs${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    total > 0.0
                        ? ElevatedButton(
                            onPressed: () async {
                              List<CardModel> productsForCart =
                                  await CartService.loadProductsFromCart();
                              firestoreService.makeOrder(
                                  orders: productsForCart);
                            },
                            child: Text('check out'))
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
