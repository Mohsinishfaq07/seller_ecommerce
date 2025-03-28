import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatProvider {
  final chatMessageController =
      StateProvider.autoDispose<TextEditingController>(
    (ref) => TextEditingController(),
  );
}
