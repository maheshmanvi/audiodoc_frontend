import 'package:flutter/material.dart';

class LoaderTile extends StatelessWidget {
  final String message;
  final Widget? trailing;

  const LoaderTile({
    super.key,
    required this.message,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        const SizedBox(width: 16),
        Text(message),
        if (trailing != null) ...[
          const SizedBox(width: 16),
          const Spacer(),
          trailing!,
        ],
      ],
    );
  }
}

class LoadingTileCancelButton extends StatelessWidget {
  final Function() onCancel;

  const LoadingTileCancelButton({
    super.key,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: const Icon(Icons.close, size: 20),
      onPressed: onCancel,
    );
  }
}
