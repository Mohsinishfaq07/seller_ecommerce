import 'package:flutter/material.dart';

class ScreenUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

  // Get proportionate height according to screen size
  static double getProportionateScreenHeight(double inputHeight) {
    double screenHeight = ScreenUtils.screenHeight;
    // 812 is the layout height that designer use
    return (inputHeight / 812.0) * screenHeight;
  }

  // Get proportionate width according to screen size
  static double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = ScreenUtils.screenWidth;
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }

  static double adaptiveSize(double size) {
    return orientation == Orientation.portrait
        ? getProportionateScreenHeight(size)
        : getProportionateScreenWidth(size);
  }
}
