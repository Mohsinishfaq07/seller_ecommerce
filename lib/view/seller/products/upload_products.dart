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
          automaticallyImplyLeading: false,
          title: const Text('Upload Products'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    return ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          final List<XFile> images =
                              await picker.pickMultiImage();
                          List<String> imagesList = [];
                          for (var image in images) {
                            imagesList.add(image.path);
                          }
                          ref
                              .read(sellerProvider.productImages.notifier)
                              .state = imagesList;
                        },
                        child: Text('Add Images'));
                  },
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final images = ref.watch(sellerProvider.productImages);
                      return ListView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey, width: 2),
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: FileImage(
                                  File(
                                    images[index],
                                  ),
                                ),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    final updatedImages =
                                        List<String>.from(images);
                                    updatedImages.removeAt(index);
                                    ref
                                        .read(sellerProvider
                                            .productImages.notifier)
                                        .state = updatedImages;
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red)),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    return Center(
                      child: TextFormField(
                        onChanged: (val) {
                          ref
                              .read(
                                  sellerProvider.productNameController.notifier)
                              .state = TextEditingController(text: val);
                        },
                        decoration: InputDecoration(
                          labelText: 'Product Nme',
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
                            borderSide:
                                const BorderSide(color: Color(0xFF00897B)),
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
                    return Center(
                      child: TextFormField(
                        onChanged: (val) {
                          ref
                              .read(sellerProvider
                                  .productPriceController.notifier)
                              .state = TextEditingController(text: val);
                        },
                        decoration: InputDecoration(
                          labelText: 'Product Price',
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
                            borderSide:
                                const BorderSide(color: Color(0xFF00897B)),
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
                    return Center(
                      child: TextFormField(
                        onChanged: (val) {
                          ref
                              .read(sellerProvider
                                  .productDescriptionController.notifier)
                              .state = TextEditingController(text: val);
                        },
                        decoration: InputDecoration(
                          labelText: 'Product Description',
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
                            borderSide:
                                const BorderSide(color: Color(0xFF00897B)),
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
                    return Center(
                      child: TextFormField(
                        onChanged: (val) {
                          ref
                              .read(sellerProvider
                                  .extraProductInformationController.notifier)
                              .state = TextEditingController(text: val);
                        },
                        decoration: InputDecoration(
                          labelText: 'Product Extra Information',
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
                            borderSide:
                                const BorderSide(color: Color(0xFF00897B)),
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
                    final images = ref.watch(sellerProvider.productImages);
                    final prodName =
                        ref.watch(sellerProvider.productNameController);
                    final prodDescription =
                        ref.watch(sellerProvider.productDescriptionController);
                    final productPrice =
                        ref.watch(sellerProvider.productPriceController);
                    final prodExtraInfo = ref.watch(
                        sellerProvider.extraProductInformationController);
                    return ElevatedButton(
                      onPressed: () {
                        if (images.isEmpty ||
                            prodName.text.isEmpty ||
                            prodDescription.text.isEmpty ||
                            productPrice.text.isEmpty ||
                            prodExtraInfo.text.isEmpty) {
                          globalFunctions.showToast(
                              message: 'Please fill all the fields',
                              toastType: ToastType.error);
                        } else {
                          ProductSellModel productSellModel = ProductSellModel(
                              productName: prodName.text,
                              productDescription: prodDescription.text,
                              productPrice: productPrice.text,
                              images: images,
                              uploadedBy:
                                  FirebaseAuth.instance.currentUser!.uid,
                              extraProductInformation: prodExtraInfo.text,
                              prodCategory: productCategory);
                          firestoreService.uploadProduct(
                              productSellModel: productSellModel,
                              categoryName: productCategory);
                        }
                      },
                      child: const Text('upload Product'),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
