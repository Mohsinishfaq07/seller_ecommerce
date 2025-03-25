import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'SellerScreen/seller_edit.dart'; // Edit Page
import 'SellerScreen/seller_messages.dart'; // Messages Page
import 'SellerScreen/seller_profile.dart'; // Profile Page

class SellerHomePage extends ConsumerStatefulWidget {
  const SellerHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends ConsumerState<SellerHomePage> {
  int _selectedIndex = 0; // Current selected tab index
  final List<Widget> _pages = [
    const SellerHomeContent(),
    const SellerProfilePage(),
    const SellerMessagesPage(),
    const SellerEditPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleLogout() async {
    try {
      // Show confirmation dialog
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
          ],
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}

class SellerHomeContent extends StatelessWidget {
  const SellerHomeContent({Key? key}) : super(key: key);

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Seller Center',
          style:
              TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Get the root navigator context
              final rootContext = Navigator.of(context).context;
              await (rootContext
                      .findAncestorStateOfType<_SellerHomePageState>()
                      ?._handleLogout() ??
                  Future.value());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('dorSV98i',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Followers 0', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildOrderSection(),
            const SizedBox(height: 20),
            _buildBusinessSetupSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('13/02/2025 00:27:50', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              OrderStatusWidget(count: '0', label: 'To Process'),
              OrderStatusWidget(count: '0', label: 'Shipping'),
              OrderStatusWidget(count: '0', label: 'Review'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessSetupSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Start your business right now!',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 10),
          BusinessStepWidget(
              step: '1',
              label: 'Add Email',
              page: DummyPage(title: 'Add Email')),
          BusinessStepWidget(
              step: '2',
              label: 'Add warehouse address',
              page: DummyPage(title: 'Warehouse Address')),
          BusinessStepWidget(
              step: '3',
              label: 'Add ID & Bank documents',
              page: DummyPage(title: 'ID & Bank Documents')),
          BusinessStepWidget(
              step: '4',
              label: 'Upload products',
              page: DummyPage(title: 'Upload Products')),
        ],
      ),
    );
  }
}

class OrderStatusWidget extends StatelessWidget {
  final String count;
  final String label;
  const OrderStatusWidget({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: count == '0' ? Colors.red : Colors.black)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class BusinessStepWidget extends StatelessWidget {
  final String step;
  final String label;
  final Widget page;
  const BusinessStepWidget(
      {required this.step, required this.label, required this.page});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(step,
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold)),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
    );
  }
}

class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.green),
      body: Center(child: Text('$title Page')),
    );
  }
}
