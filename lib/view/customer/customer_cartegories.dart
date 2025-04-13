import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/categories_model.dart';
import 'package:flutter_application_1/view/customer/category_product_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;

final categoriesProvider = StreamProvider<List<CategoryModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('categories')
      .snapshots()
      .map((snapshot) {
    final doc = snapshot.docs.first; // Get the first document
    final data = doc.data();

    // Extract the list from 'categoryName'
    List<dynamic> categoryList = data['categoryName'] ?? [];

    // Convert list of strings to List<CategoryModel>
    return categoryList.map((item) => CategoryModel(categoryName: item.toString())).toList();
  });
});

// Rest of the CategoriesScreen remains the same
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: const Text(
            'Categories',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: categoriesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error loading categories',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
          ),
          data: (categories) {
            if (categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 64,
                      color: AppColors.white.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No categories found',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {

                final category = categories[index];
                print('Category Name being passed: ${category.categoryName}');
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      constants.globalFunctions.nextScreen(
                        context,
                        CustomerCategoryProductsScreen( category: category.categoryName,


                        ),



                      );
                      print('Category Object: $category'); // Debug print for category object
                      print('Category Name: ${category.categoryName}'); // Debug print for category name
                      print('Category toString: ${category.toString()}');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category,
                          size: 40,
                          color: AppColors.primary.withOpacity(0.8),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category.categoryName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}