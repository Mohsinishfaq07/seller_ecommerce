import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerProvider {
  final productNameController =
      StateProvider.autoDispose<TextEditingController>(
          (ref) => TextEditingController());
  final productDescriptionController =
      StateProvider.autoDispose<TextEditingController>(
          (ref) => TextEditingController());
  final productPriceController =
      StateProvider.autoDispose<TextEditingController>(
          (ref) => TextEditingController());
  final extraProductInformationController =
      StateProvider.autoDispose<TextEditingController>(
          (ref) => TextEditingController());

  final productImages = StateProvider.autoDispose<List<String>>((ref) => []);
}
