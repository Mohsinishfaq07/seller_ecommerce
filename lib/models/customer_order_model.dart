class OrderModel {
  final String orderId;
  final String productId;
  final String productName;
  final String productImage;
  final String productPrice;
  final String quantity;
  final String sellerId;
  final String customerId;
  final String orderStatus;

  OrderModel({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    required this.sellerId,
    required this.customerId,
    required this.orderStatus,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      orderId: data['orderId'] ?? '',
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      productImage: data['productImage'] ?? '',
      productPrice: data['productPrice'] ?? '',
      quantity: data['quantity'] ?? '',
      sellerId: data['sellerId'] ?? '',
      customerId: data['customerId'] ?? '',
      orderStatus: data['orderStatus'] ?? '',
    );
  }
}
