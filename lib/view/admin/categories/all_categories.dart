import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadedCategoryScreen extends StatelessWidget {
  const UploadedCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final docRef =
        FirebaseFirestore.instance.collection('categories').doc('categories');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No categories found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List categoryList = data['categoryName'] ?? [];

          return ListView.builder(
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              final category = categoryList[index];

              return ListTile(
                title: Text(category),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await docRef.update({
                      'categoryName': FieldValue.arrayRemove([category]),
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
