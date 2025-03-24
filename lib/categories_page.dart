import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          CategoryCard(
            icon: Icons.local_mall,
            name: 'Garments',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CategoryDetailPage(category: 'Garments')),
              );
            },
          ),
          CategoryCard(
            icon: Icons.directions_walk,
            name: 'Shoes',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CategoryDetailPage(category: 'Shoes')),
              );
            },
          ),
          CategoryCard(
            icon: Icons.toys,
            name: 'Toys',
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CategoryDetailPage(category: 'Toys')),
              );
            },
          ),
          CategoryCard(
            icon: Icons.sports,
            name: 'Sports & Outdoors',
            color: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoryDetailPage(
                        category: 'Sports & Outdoors')),
              );
            },
          ),
          CategoryCard(
            icon: Icons.directions_car,
            name: 'Automotives',
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CategoryDetailPage(category: 'Automotives')),
              );
            },
          ),
          CategoryCard(
            icon: Icons.home,
            name: 'Home & Kitchen',
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CategoryDetailPage(category: 'Home & Kitchen')),
              );
            },
          ),
          CategoryCard(
            icon: Icons.electrical_services,
            name: 'Electronics',
            color: Colors.yellow,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CategoryDetailPage(category: 'Electronics')),
              );
            },
          ),
          CategoryCard(
            icon: Icons.shopping_bag,
            name: 'Fashion',
            color: Colors.pink,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CategoryDetailPage(category: 'Fashion')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Colors.white),
            const SizedBox(height: 8.0),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDetailPage extends StatelessWidget {
  final String category;

  const CategoryDetailPage({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Center(
        child: Text(
          'Welcome to $category category!',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
