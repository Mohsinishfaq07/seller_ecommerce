import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadCategory extends ConsumerWidget {
  const UploadCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Category"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Consumer(
            builder: (_, WidgetRef ref, __) {
              return Center(
                child: TextFormField(
                  onChanged: (val) {
                    ref
                        .read(uploadCategoryProvider
                            .categoryNameController.notifier)
                        .state = TextEditingController(text: val);
                  },
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00897B)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              );
            },
          ),
          Consumer(
            builder: (_, WidgetRef ref, __) {
              final categoryNameController =
                  ref.watch(uploadCategoryProvider.categoryNameController);
              return ElevatedButton(
                onPressed: () {
                  if (categoryNameController.text.isEmpty) {
                    globalFunctions.showToast(
                        message: 'Please enter category name',
                        toastType: ToastType.error);
                    return;
                  }
                  uploadCategory(
                    categoryName: categoryNameController.text,
                  );
                },
                child: const Text('upload category'),
              );
            },
          )
        ],
      ),
    );
  }

  uploadCategory({
    required String categoryName,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc('categories')
          .set(
        {
          'categoryName': FieldValue.arrayUnion(
            [categoryName],
          ),
        },
        SetOptions(
          merge: true,
        ),
      );
      globalFunctions.showToast(
          message: 'Category uploaded successfully',
          toastType: ToastType.success);
    } catch (e) {
      globalFunctions.showLog(message: 'error: ${e.toString()}');
    }
  }
}
