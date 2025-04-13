import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/models/product_sell_model.dart';
import 'package:flutter_application_1/services/cart_service/cart_service.dart';
import 'package:flutter_application_1/view/chat_page/chat_page.dart';
import 'package:flutter_application_1/view/customer/cart/cart_page.dart';
import 'package:flutter_application_1/view/customer/product_page/product_page.dart';
import 'package:flutter_application_1/widgets/Itembage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerHomePage extends ConsumerWidget {
  const CustomerHomePage({super.key});
  // Add this at the beginning of the class

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
              child: const Text(
                'Logout',
                style: TextStyle(color: AppColors.error),
              ),
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

  Widget _buildProductImage(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: Image.network(
        imageUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 120,
            color: AppColors.primaryLight.withOpacity(0.1),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 120,
            width: double.infinity,
            color: AppColors.primaryLight.withOpacity(0.1),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  color: AppColors.primary,
                  size: 32,
                ),
                SizedBox(height: 4),
                Text(
                  'Image not available',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 150,
              color: AppColors.white.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Special Offers',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get up to 50% off on\nselected items',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Shop Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CartService cartService = CartService(); // Instantiate CartService
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          child: Container(
            color: AppColors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.white,
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Welcome',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const CartItemCountBadge(),
                  title: const Text('Cart'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    constants.globalFunctions.nextScreen(
                      context,
                      const CartPage(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message, color: AppColors.primary),
                  title: const Text('Messages'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    constants.globalFunctions.nextScreen(
                      context,
                      const ChatPage(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    _handleLogout(context);
                  },
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          // automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          centerTitle: true,
        ),
        body: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('categories')
                .doc('categories')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text('No categories found.',
                      style: TextStyle(color: AppColors.white)),
                );
              }

              List<dynamic> categoryList =
                  snapshot.data!.get('categoryName') ?? [];

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        _buildFeaturedBanner(),
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'See All',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = categoryList[index];
                        return Padding(
                          // Added Padding around each category section
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.category,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        category.toString().toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 220,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('products')
                                      .where('prodCategory',
                                          isEqualTo: category)
                                      .snapshots(),
                                  builder: (context, prodSnapshot) {
                                    if (prodSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppColors.white,
                                          ),
                                        ),
                                      );
                                    }

                                    final productDocs =
                                        prodSnapshot.data?.docs ?? [];

                                    if (productDocs.isEmpty) {
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.inventory_2_outlined,
                                                color: AppColors.textSecondary,
                                                size: 32,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'No products available in this category.',
                                                style: TextStyle(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: productDocs.length,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              16), // Added horizontal padding for the list
                                      itemBuilder: (context, i) {
                                        final product = productDocs[i];
                                        ProductSellModel prod =
                                            ProductSellModel(
                                          productName: product['productName'],
                                          productDescription:
                                              product['productDescription'],
                                          productPrice: product['productPrice'],
                                          images: List<String>.from(
                                            product['images'] ?? [],
                                          ),
                                          uploadedBy: product['uploadedBy'],
                                          extraProductInformation: product[
                                              'extraProductInformation'],
                                          prodCategory: product['prodCategory'],
                                        );

                                        return GestureDetector(
                                          onTap: () {
                                            constants.globalFunctions
                                                .nextScreen(
                                              context,
                                              ProductDetailsScreen(
                                                product: prod,
                                                productId: product.id,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 160,
                                            margin: const EdgeInsets.only(
                                                right: 16),
                                            decoration: BoxDecoration(
                                              color: AppColors.white
                                                  .withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildProductImage(
                                                    prod.images[0]),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        prod.productName,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .textPrimary,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "\$${prod.productPrice}",
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                              const SizedBox(
                                  height:
                                      8), // Added some spacing after the horizontal list
                            ],
                          ),
                        );
                      },
                      childCount: categoryList.length,
                    ),
                  ),
                  const SliverPadding(
                    padding: EdgeInsets.only(
                        bottom:
                            70), // Adjust bottom padding for bottom navigation bar
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
