import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showTopSnackBarr(BuildContext context, String message, {Color backgroundColor = Colors.red}) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.fromLTRB(8, kToolbarHeight + 8, 8, 8),
    borderRadius: BorderRadius.circular(16),
    backgroundColor: backgroundColor,
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}
