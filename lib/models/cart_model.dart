import 'package:flutter_application_1/models/product_sell_model.dart';

class CardModel {
  final String productName;
  final String productPrice;
  final String productId;
  final String quantity;
  final String customerId;
  final String orderId;
  final String sellerId;
  final String productImage;
  final String orderStatus;

  CardModel(
      {required this.productName,
      required this.productPrice,
      required this.productId,
      required this.quantity,
      required this.customerId,
      required this.orderId,
      required this.sellerId,
      required this.orderStatus,
      required this.productImage});

  factory CardModel.fromMap(Map<String, dynamic> data) {
    return CardModel(
      productName: data['productName'] ?? '',
      productPrice: data['productPrice'] ?? '',
      productId: data['productId'] ?? '',
      quantity: data['quantity'] ?? '',
      customerId: data['customerId'] ?? '',
      orderId: data['orderId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      productImage: data['productImage'] ?? '',
      orderStatus: data['orderStatus'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productId': productId,
      'quantity': quantity,
      'customerId': customerId,
      'orderId': orderId,
      'sellerId': sellerId,
      'productImage': productImage,
      'orderStatus': orderStatus,
    };
  }
}

class ProductModel {
  final String productName;
  final String productPrice;
  final String productId;
  final String quantity;
  final String customerId;
  final String orderId;
  final String sellerId;
  final String productImage;
  final String orderStatus;
  final String description;
  final double price;

  ProductModel({
    required this.productName,
    required this.productPrice,
    required this.productId,
    required this.quantity,
    required this.customerId,
    required this.orderId,
    required this.sellerId,
    required this.productImage,
    required this.orderStatus,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productId': productId,
      'quantity': quantity,
      'customerId': customerId,
      'orderId': orderId,
      'sellerId': sellerId,
      'productImage': productImage,
      'orderStatus': orderStatus,
      'description': description,
      'price': price,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productName: map['productName'] ?? '',
      productPrice: map['productPrice'] ?? '',
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? '',
      customerId: map['customerId'] ?? '',
      orderId: map['orderId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      productImage: map['productImage'] ?? '',
      orderStatus: map['orderStatus'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0, // Ensure double
    );
  }
}

class CartItem {
  final ProductSellModel product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(), // Use product.toMap()
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: ProductSellModel.fromMap(
          map['product'] as Map<String, dynamic>), // Cast
      quantity: map['quantity']?.toInt() ?? 0, // Ensure int
    );
  }
}

class CartModel {
  final List<CartItem> items;

  CartModel({
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> itemsData = map['items'] ?? [];
    return CartModel(
      items: itemsData
          .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  CartModel copyWith({
    List<CartItem>? items,
  }) {
    return CartModel(
      items: items ?? this.items,
    );
  }
}
