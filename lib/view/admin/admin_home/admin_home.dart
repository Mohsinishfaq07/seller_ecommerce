import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/app_styles.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/utils/screen_utils.dart';
import 'package:flutter_application_1/view/admin/categories/all_categories.dart';
import 'package:flutter_application_1/view/admin/categories/upload_category.dart';
import 'package:flutter_application_1/view/admin/customers/customers.dart';
import 'package:flutter_application_1/view/admin/orders/orders_page.dart';
import 'package:flutter_application_1/view/admin/products/uploaded_products.dart';
import 'package:flutter_application_1/view/admin/sellers/approved_sellers.dart';
import 'package:flutter_application_1/view/admin/sellers/non_approved_sellers.dart';
import 'package:flutter_application_1/welcome_screen.dart';

// List<Map<String, dynamic>> data = [
//   {
//     "name": 'Approved/nSellers',
//     "function": globalFunctions.nextScreen(context, ApprovedSellersPage()),
//   }
// ];

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtils().init(context);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          title: const Text(
            "Admin Dashboard",
            style: TextStyle(color: AppColors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                authServices.signOut(context: context).then((val) {
                  globalFunctions.nextScreen(
                      context, const WelcomeHomeScreen());
                });
              },
              icon: const Icon(Icons.exit_to_app, color: AppColors.white),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppStyles.formContainerDecoration,
                child: Column(
                  children: [
                    const Icon(
                      Icons.admin_panel_settings,
                      size: 50,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome, Admin',
                      style: AppStyles.headingStyle.copyWith(
                        color: AppColors.primary,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Admin Actions Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  _buildAdminButton(
                    title: "Approved Sellers",
                    icon: Icons.verified_user,
                    onPressed: () {
                      globalFunctions.nextScreen(
                          context, ApprovedSellersPage());
                    },
                  ),
                  _buildAdminButton(
                    title: "Non Approved Sellers",
                    icon: Icons.pending_actions,
                    onPressed: () {
                      globalFunctions.nextScreen(
                          context, NonApprovedSellersPage());
                    },
                  ),
                  _buildAdminButton(
                    title: "Customers",
                    icon: Icons.people,
                    onPressed: () {
                      globalFunctions.nextScreen(context, CustomersShowPage());
                    },
                  ),
                  _buildAdminButton(
                    title: "Upload Category",
                    icon: Icons.category,
                    onPressed: () {
                      globalFunctions.nextScreen(
                          context, const UploadCategory());
                    },
                  ),
                  _buildAdminButton(
                    title: "All Categories",
                    icon: Icons.list,
                    onPressed: () {
                      globalFunctions.nextScreen(
                          context, UploadedCategoryScreen());
                    },
                  ),
                  _buildAdminButton(
                    title: "All Products",
                    icon: Icons.inventory,
                    onPressed: () {
                      globalFunctions.nextScreen(context, AllProductsScreen());
                    },
                  ),
                  _buildAdminButton(
                    title: "All Orders",
                    icon: Icons.card_travel,
                    onPressed: () {
                      globalFunctions.nextScreen(context, AdminOrdersPage());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
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
        ),
      ),
    );
  }
}
