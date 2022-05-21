import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';

showSnackbar(
  String message,
  BuildContext context, {
  SnackbarIntent snackbarIntent = SnackbarIntent.info,
}) {
  Color color;

  switch (snackbarIntent) {
    case SnackbarIntent.error:
      color = errorColor;
      break;
    case SnackbarIntent.warning:
      color = warningColor;
      break;
    case SnackbarIntent.info:
      color = infoColor;
      break;
    case SnackbarIntent.debug:
      color = debugColor;
      break;
  }

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: color),
        textAlign: TextAlign.center,
      ),
      backgroundColor: mobileBackgroundColor,
    ),
  );
}

enum SnackbarIntent {
  error,
  warning,
  info,
  debug,
}
