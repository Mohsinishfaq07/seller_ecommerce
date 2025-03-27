class ProductSellModel {
  final String productName;
  final String productDescription;
  final String productPrice;
  final List<String> images;
  final String uploadedBy;
  final String extraProductInformation;
  final String prodCategory;

  ProductSellModel({
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.images,
    required this.uploadedBy,
    required this.extraProductInformation,
    required this.prodCategory,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productDescription': productDescription,
      'productPrice': productPrice,
      'images': images,
      'uploadedBy': uploadedBy,
      'extraProductInformation': extraProductInformation,
      'prodCategory': prodCategory,
    };
  }

  factory ProductSellModel.fromMap(Map<String, dynamic> map) {
    return ProductSellModel(
      prodCategory: map['prodCategory'] ?? '',
      productName: map['productName'] ?? '',
      productDescription: map['productDescription'] ?? '',
      productPrice: map['productPrice'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      uploadedBy: map['uploadedBy'] ?? '',
      extraProductInformation: map['extraProductInformation'] ?? '',
    );
  }
}
