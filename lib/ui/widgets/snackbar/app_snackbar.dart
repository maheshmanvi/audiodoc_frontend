import 'package:audiodoc/ui/widgets/snackbar/app_snackbar_view.dart';
import 'package:flutter/material.dart';

enum AppSnackbarPosition {
  bottomCenter,
}

enum AppSnackbarType {
  info,
  success,
  warning,
  error,
}

class AppSnackBar {
  static const defaultPosition = AppSnackbarPosition.bottomCenter;
  static const defaultType = AppSnackbarType.info;

  static const shortDuration = Duration(seconds: 2);
  static const longDuration = Duration(seconds: 4);

  static void show(
    BuildContext context, {
    required String message,
    required String description,
    Duration? duration,
    String? actionText,
  }) async {
    AppSnackbarView appSnackBar = AppSnackbarView(context: context, message: message, description: description, actionText: actionText);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(appSnackBar);
  }

  static void showToast(
    BuildContext context, {
    required String message,
    Duration? duration,
    AppSnackbarType type = AppSnackbarType.info,
    String? actionText,
  }) {
    AppSnackbarView appSnackBar = AppSnackbarView(context: context, message: message, actionText: actionText);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(appSnackBar);
  }

  static void showErrorToast(BuildContext context, {required String message, String? actionText}) {
    showToast(context, message: message, actionText: actionText);
  }

  static void showError(BuildContext context, {required String message, required String description, String? actionText}) async {
    AppSnackbarView appSnackBar = AppSnackbarView(
      context: context,
      message: message,
      description: description,
      actionText: actionText,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(appSnackBar);
  }

  static void showSuccess(BuildContext context, {required String message, required String description}) async {
    show(context, message: message, description: description, duration: longDuration);
  }

  static void showSuccessToast(BuildContext context, {required String message, String? actionText}) {
    showToast(context, message: message, actionText: actionText);
  }
}
