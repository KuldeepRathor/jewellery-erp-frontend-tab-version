import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class CustomToastWidget {
  static void show({
    required String message,
    ToastificationType type = ToastificationType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: Get.context!,
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      autoCloseDuration: duration,
      showProgressBar: false,
      alignment: Alignment.bottomCenter,
      icon: _getIcon(type),
      primaryColor: _getPrimaryColor(type),
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(100),
    );
  }

  static Icon _getIcon(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return const Icon(Icons.check, color: Colors.white);
      case ToastificationType.error:
        return const Icon(Icons.error, color: Colors.white);
      case ToastificationType.warning:
        return const Icon(Icons.warning, color: Colors.white);
      case ToastificationType.info:
        return const Icon(Icons.info, color: Colors.white);
      // default:
      //   return const Icon(Icons.notifications, color: Colors.white);
    }
  }

  static Color _getPrimaryColor(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return Colors.green;
      case ToastificationType.error:
        return Colors.red;
      case ToastificationType.warning:
        return Colors.orange;
      case ToastificationType.info:
        return Colors.blue;
      // default:
      //   return Colors.grey;
    }
  }
}
