import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/view/auth/login_page.dart';
import 'package:flutter_application_1/view/chat_page/chat_page.dart';
import 'package:flutter_application_1/view/Profile/AllUsersProfile.dart';

import 'package:flutter_application_1/view/seller/orders/active_orders.dart';
import 'package:flutter_application_1/view/seller/orders/dispatched_orders.dart';
import 'package:flutter_application_1/view/seller/orders/processing_products.dart';
import 'package:flutter_application_1/view/seller/products/available_categories.dart';
import 'package:flutter_application_1/view/seller/products/listed_products.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProductsPage(),
    const OrdersPage(),
    const ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25
        ),
        backgroundColor: AppColors.accent,
        automaticallyImplyLeading: true, // Ensure leading is shown for the drawer
        title: Text(_selectedIndex == 0
            ? 'Products'
            : _selectedIndex == 1
                ? 'Orders'
                : 'Chats'),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 30,
                  child:Image.asset("assets/user.png"),
                  ),
                  SizedBox(height: 10,),
                  const Text(
                    'Seller Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? 'Not logged in',
                    style: const TextStyle(
                      
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                globalFunctions.nextScreen(context, const UserProfilePage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                try {
                  await FirebaseAuth.instance.signOut();
                    globalFunctions.nextScreen(context,  CustomerLoginScreen());
                } catch (e) {
                  print('Error signing out: $e');
                  // Optionally show an error message
                }
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _DashboardCard(
              icon: Icons.upload_file,
              title: 'Upload Product',
              color: Colors.blue,
              onTap: () => globalFunctions.nextScreen(
                context,
                const AvailableCategories(),
              ),
            ),
            const SizedBox(height: 16),
            _DashboardCard(
              icon: Icons.inventory,
              title: 'Listed Products',
              color: Colors.green,
              onTap: () => globalFunctions.nextScreen(
                context,
                const ListedProducts(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _DashboardCard(
              icon: Icons.new_releases,
              title: 'New Orders',
              color: Colors.orange,
              onTap: () => globalFunctions.nextScreen(
                context,
                ActiveOrders(),
              ),
            ),
            const SizedBox(height: 16),
            _DashboardCard(
              icon: Icons.pending_actions,
              title: 'Processing Orders',
              color: Colors.purple,
              onTap: () => globalFunctions.nextScreen(
                context,
                ProcessingOrders(),
              ),
            ),
            const SizedBox(height: 16),
            _DashboardCard(
              icon: Icons.local_shipping,
              title: 'Dispatched Orders',
              color: Colors.teal,
              onTap: () => globalFunctions.nextScreen(
                context,
                CompletedOrders(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}