import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/view/customer/customer_cartegories.dart';
import 'package:flutter_application_1/view/customer/orders/customer_order.dart';
import 'package:flutter_application_1/view/seller/Seller%20BottomNavbar/Seller_bottom_Nav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../categories_page.dart';
import '../../Profile/AllUsersProfile.dart';
import '../home_page/customer_home.dart';
final currentIndexProvider = StateProvider<int>((ref) => 0);



class CustomerBottomNavigationBar extends ConsumerWidget {
  const CustomerBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    final pages = [
      const CustomerHomePage(),
      const CategoriesScreen(),
      const OrdersScreen(),
      const UserProfilePage(),
    ];

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => ref.read(currentIndexProvider.notifier).state = index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}