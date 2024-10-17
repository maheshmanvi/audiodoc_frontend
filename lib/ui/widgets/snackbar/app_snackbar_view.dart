import 'package:audiodoc/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbarToastView extends StatelessWidget {
  final Widget? icon;
  final IconData? iconData;
  final String? text;
  final Widget? textWidget;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const AppSnackbarToastView._internal({
    super.key,
    this.icon,
    this.iconData,
    this.text,
    this.textWidget,
    this.actionText,
    this.onActionPressed,
  });

  factory AppSnackbarToastView({Key? key, Widget? icon, IconData? iconData, String? text, Widget? textWidget, String? actionText, VoidCallback? onActionPressed}) {
    return AppSnackbarToastView._internal(
      key: key,
      icon: icon,
      iconData: iconData,
      text: text,
      textWidget: textWidget,
      actionText: actionText,
      onActionPressed: onActionPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _resolveContent();
    return SnackBar(content: content, action: _resolveAction(), behavior: SnackBarBehavior.floating, margin: const EdgeInsets.all(16));
  }

  Widget _resolveContent() {
    Widget? iconWidget = _resolveIcon();
    Widget? textWidget = _resolveText();
    return Row(
      children: [
        if (iconWidget != null) ...[
          iconWidget,
          const SizedBox(width: 8),
        ],
        textWidget,
      ],
    );
  }

  Widget? _resolveIcon() {
    if (icon != null) {
      return icon;
    }
    if (iconData != null) {
      return Icon(iconData);
    }
    return null;
  }

  Widget _resolveText() {
    if (text != null) {
      return Center(child: Text(text!));
    }
    if (textWidget == null) {
      throw Exception('Text or TextWidget must be provided');
    }
    return const SizedBox.shrink();
  }

  SnackBarAction? _resolveAction() {
    if (actionText != null && onActionPressed != null) {
      return SnackBarAction(
        label: actionText!,
        onPressed: onActionPressed!,
      );
    }
    return null;
  }

  static SnackBar toast({required String message}) {
    return SnackBar(
      elevation: 2,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(16),
      content: Text(message),
    );
  }
}

class AppSnackbarView extends SnackBar {
  final String? actionText;
  final VoidCallback? onActionPressed;

  const AppSnackbarView._internal({
    super.key,
    required super.content,
    required super.behavior,
    required super.duration,
    this.actionText,
    this.onActionPressed,
    super.action,
    super.elevation,
    super.width,
  });

  factory AppSnackbarView({
    Key? key,
    required BuildContext context,
    Widget? content,
    String? message,
    String? description,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Duration duration = const Duration(seconds: 2),
    String? actionText,
    VoidCallback? onActionPressed,
    SnackBarAction? action,
    double? elevation,
    double? width = 360,
  }) {
    Widget contentWidget = _resolveContent(context, content, message, description);
    SnackBarAction? resolvedActin = _resolveAction(context, actionText, onActionPressed, action);
    return AppSnackbarView._internal(
      key: key,
      content: contentWidget,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      actionText: actionText,
      onActionPressed: onActionPressed,
      action: resolvedActin,
      elevation: elevation,
      width: width,
    );
  }

  static Widget _resolveContent(BuildContext context, Widget? content, String? contentText, String? description) {
    if (content != null) {
      return content;
    }
    if (contentText != null && description != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(contentText, style: context.theme.textTheme.bodyMedium?.copyWith(fontWeight: context.theme.typo.fw.bold)),
          const SizedBox(height: 2),
          Text(description, style: context.theme.textTheme.bodyMedium),
        ],
      );
    } else {
      return Text(contentText!);
    }
    throw Exception('Content or ContentText must be provided');
  }

  static SnackBarAction? _resolveAction(BuildContext context, String? actionText, VoidCallback? onActionPressed, SnackBarAction? action) {
    if (actionText != null) {
      return SnackBarAction(
        label: actionText,
        onPressed: () {
          if (onActionPressed != null) {
            onActionPressed();
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
      );
    }
    return action;
  }
}
