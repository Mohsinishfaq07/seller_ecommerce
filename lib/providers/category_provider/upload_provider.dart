import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadCategoryProvider {
  final categoryNameController =
      StateProvider.autoDispose<TextEditingController>(
    (ref) => TextEditingController(),
  );
}
