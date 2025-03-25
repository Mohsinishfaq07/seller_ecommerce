import 'package:flutter/material.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer' as developer;

class GlobalFunctions {
  nextScreen(BuildContext context, screenName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screenName),
    );
  }

  popScreen(BuildContext context) {
    Navigator.pop(context);
  }

  showLog({required String message}) {
    developer.log(message);
  }

  showToast({required String message, required ToastType toastType}) {
    Color toastColor = getToastColor(toastType: toastType);
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: toastColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  getToastColor({
    required ToastType toastType,
  }) {
    switch (toastType) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.info:
        return Colors.blue;
    }
  }

  void nextScreenReplace(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
