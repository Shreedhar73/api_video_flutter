import 'package:flutter/material.dart';

class ShowToast {
  static void show(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
