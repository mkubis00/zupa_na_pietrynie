import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

void snackBarWarning(BuildContext context, String content) {
  AnimatedSnackBar.material(
    content,
    type: AnimatedSnackBarType.error,
    duration: const Duration(seconds: 4),
    mobileSnackBarPosition: MobileSnackBarPosition.top, // Position of snackbar on mobile devices
  ).show(context);
}
