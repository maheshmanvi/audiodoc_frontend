import 'package:audiodoc/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? confirmText;
  final Color? confirmButtonColor;
  final Color? confirmTextColor;
  final String? cancelText;
  final Color? cancelButtonColor;
  final Color? cancelTextColor;

  const ConfirmDialog({
    super.key,
    this.title,
    this.message,
    this.confirmText,
    this.confirmButtonColor,
    this.confirmTextColor,
    this.cancelText,
    this.cancelButtonColor,
    this.cancelTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? "Are you sure?", style: context.theme.textTheme.titleMedium),
      content: Text(message ?? "Do you want to proceed?", style: context.theme.textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          style: TextButton.styleFrom(
            backgroundColor: cancelButtonColor ?? context.theme.colors.primaryTint90,
            foregroundColor: cancelTextColor ?? context.theme.colors.contentPrimary,
          ),
          child: Text(
            cancelText ?? 'Cancel',
          ),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          style: TextButton.styleFrom(
            foregroundColor: confirmTextColor ?? context.theme.colors.onPrimary,
            backgroundColor: confirmButtonColor ?? context.theme.colors.primary,
          ),
          child: Text(confirmText ?? 'Confirm'),
        ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    String? title,
    String? message,
    String? confirmText,
    Color? confirmButtonColor,
    Color? confirmTextColor,
    String? cancelText,
    Color? cancelButtonColor,
    Color? cancelTextColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          confirmButtonColor: confirmButtonColor,
          confirmTextColor: confirmTextColor,
          cancelText: cancelText,
          cancelButtonColor: cancelButtonColor,
          cancelTextColor: cancelTextColor,
        );
      },
      barrierColor: context.theme.colors.dialogBarrier,
    );
  }
}
