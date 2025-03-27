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
