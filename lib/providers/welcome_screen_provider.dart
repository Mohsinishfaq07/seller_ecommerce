import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreenNotifier extends ChangeNotifier {
  late AnimationController _controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  void initializeAnimations(TickerProvider vsync) {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

final welcomeScreenProvider = ChangeNotifierProvider.autoDispose((ref) {
  return WelcomeScreenNotifier();
});
