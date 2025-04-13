class CategoryModel {
  final String categoryName;

  CategoryModel({
    required this.categoryName,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryName: map['categoryName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
    };
  }
}