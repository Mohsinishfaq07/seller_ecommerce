import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/view/chat_page/chat_page.dart';
import 'package:flutter_application_1/view/seller/orders/active_orders.dart';
import 'package:flutter_application_1/view/seller/orders/dispatched_orders.dart';
import 'package:flutter_application_1/view/seller/orders/processing_products.dart';
import 'package:flutter_application_1/view/seller/products/available_categories.dart';
import 'package:flutter_application_1/view/seller/products/listed_products.dart';

class SellerNewHomePage extends StatefulWidget {
  const SellerNewHomePage({super.key});

  @override
  State<SellerNewHomePage> createState() => _SellerNewHomePageState();
}

class _SellerNewHomePageState extends State<SellerNewHomePage> {
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
        automaticallyImplyLeading: false,
        title: Text(_selectedIndex == 0
            ? 'Products'
            : _selectedIndex == 1
                ? 'Orders'
                : 'Chats'),
        elevation: 0,
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
