import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/product_sell_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SellerUploadProducts extends StatelessWidget {
  final String productCategory;
  const SellerUploadProducts({super.key, required this.productCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final images = ref.watch(sellerProvider.productImages);
          final prodName = ref.watch(sellerProvider.productNameController);
          final prodDescription =
              ref.watch(sellerProvider.productDescriptionController);
          final productPrice = ref.watch(sellerProvider.productPriceController);
          final prodExtraInfo =
              ref.watch(sellerProvider.extraProductInformationController);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Section
                  const _SectionTitle(title: 'Product Images'),
                  const SizedBox(height: 8),
                  _ImagePickerSection(images: images, ref: ref),
                  const SizedBox(height: 24),

                  // Product Details Section
                  _SectionTitle(title: 'Product Details'),
                  const SizedBox(height: 16),
                  _CustomTextField(
                    label: 'Product Name',
                    onChanged: (val) {
                      ref
                          .read(sellerProvider.productNameController.notifier)
                          .state = TextEditingController(text: val);
                    },
                  ),
                  const SizedBox(height: 16),
                  _CustomTextField(
                    label: 'Price',
                    onChanged: (val) {
                      ref
                          .read(sellerProvider.productPriceController.notifier)
                          .state = TextEditingController(text: val);
                    },
                    keyboardType: TextInputType.number,
                    prefixText: '\$ ',
                  ),
                  const SizedBox(height: 16),
                  _CustomTextField(
                    label: 'Description',
                    onChanged: (val) {
                      ref
                          .read(sellerProvider
                              .productDescriptionController.notifier)
                          .state = TextEditingController(text: val);
                    },
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _CustomTextField(
                    label: 'Additional Information',
                    onChanged: (val) {
                      ref
                          .read(sellerProvider
                              .extraProductInformationController.notifier)
                          .state = TextEditingController(text: val);
                    },
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _handleSubmit(
                        context: context,
                        images: images,
                        prodName: prodName,
                        prodDescription: prodDescription,
                        productPrice: productPrice,
                        prodExtraInfo: prodExtraInfo,
                        productCategory: productCategory,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Upload Product',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSubmit({
    required BuildContext context,
    required List<String> images,
    required TextEditingController prodName,
    required TextEditingController prodDescription,
    required TextEditingController productPrice,
    required TextEditingController prodExtraInfo,
    required String productCategory,
  }) {
    if (images.isEmpty ||
        prodName.text.isEmpty ||
        prodDescription.text.isEmpty ||
        productPrice.text.isEmpty ||
        prodExtraInfo.text.isEmpty) {
      globalFunctions.showToast(
        message: 'Please fill all the fields',
        toastType: ToastType.error,
      );
      return;
    }

    final productSellModel = ProductSellModel(
      productName: prodName.text,
      productDescription: prodDescription.text,
      productPrice: productPrice.text,
      images: images,
      uploadedBy: FirebaseAuth.instance.currentUser!.uid,
      extraProductInformation: prodExtraInfo.text,
      prodCategory: productCategory,
    );

    firestoreService.uploadProduct(
      productSellModel: productSellModel,
      categoryName: productCategory,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ImagePickerSection extends StatelessWidget {
  final List<String> images;
  final WidgetRef ref;

  const _ImagePickerSection({required this.images, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (images.isEmpty)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: InkWell(
              onTap: () => _pickImages(ref),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text('Add Product Images',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          )
        else
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              children: [
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(images[index]),
                              height: 180,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.close, size: 16),
                                color: Colors.white,
                                onPressed: () {
                                  final updatedImages =
                                      List<String>.from(images);
                                  updatedImages.removeAt(index);
                                  ref
                                      .read(
                                          sellerProvider.productImages.notifier)
                                      .state = updatedImages;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () => _pickImages(ref),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _pickImages(WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      final List<String> imagesList =
          pickedImages.map((image) => image.path).toList();
      ref.read(sellerProvider.productImages.notifier).state = imagesList;
    }
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final Function(String) onChanged;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? prefixText;

  const _CustomTextField({
    required this.label,
    required this.onChanged,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
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
    );
  }
}
