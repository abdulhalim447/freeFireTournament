import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

void showSnackBarMessage(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
  Duration? duration,
}) {
  final Color backgroundColor;
  final IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle_outline;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      icon = Icons.error_outline;
    case SnackBarType.info:
      backgroundColor = Colors.blue;
      icon = Icons.info_outline;
  }

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration ?? const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
