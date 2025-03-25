import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashOpacityProvider = StateProvider<double>((ref) => 0.0);

final splashControllerProvider = Provider.autoDispose((ref) {
  // Animate opacity from 0 to 1
  Future.delayed(const Duration(milliseconds: 300), () {
    ref.read(splashOpacityProvider.notifier).state = 1.0;
  });

  return null;
});
