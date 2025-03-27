import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/app_styles.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/utils/screen_utils.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadCategory extends ConsumerWidget {
  const UploadCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenUtils().init(context);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            "Upload Category",
            style: TextStyle(color: AppColors.white),
          ),
          iconTheme: const IconThemeData(color: AppColors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppStyles.formContainerDecoration,
                child: Column(
                  children: [
                    const Icon(
                      Icons.category_rounded,
                      size: 50,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add New Category',
                      style: AppStyles.headingStyle.copyWith(
                        color: AppColors.primary,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Create a new category for products',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Form Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppStyles.formContainerDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final controller = ref.watch(
                            uploadCategoryProvider.categoryNameController);
                        return CustomTextField(
                          controller: controller,
                          label: 'Category Name',
                          prefixIcon: Icons.label_outline,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final categoryNameController = ref.watch(
                            uploadCategoryProvider.categoryNameController);
                        return ElevatedButton.icon(
                          onPressed: () async {
                            if (categoryNameController.text.isEmpty) {
                              globalFunctions.showToast(
                                message: 'Please enter category name',
                                toastType: ToastType.error,
                              );
                              return;
                            }
                            await uploadCategory(
                              categoryName: categoryNameController.text,
                            );
                            // Clear the field after successful upload
                            categoryNameController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.upload),
                          label: const Text(
                            'Upload Category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> uploadCategory({required String categoryName}) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc('categories')
          .set(
        {
          'categoryName': FieldValue.arrayUnion([categoryName]),
        },
        SetOptions(merge: true),
      );
      globalFunctions.showToast(
        message: 'Category uploaded successfully',
        toastType: ToastType.success,
      );
    } catch (e) {
      globalFunctions.showToast(
        message: 'Failed to upload category: ${e.toString()}',
        toastType: ToastType.error,
      );
      globalFunctions.showLog(message: 'error: ${e.toString()}');
    }
  }
}
