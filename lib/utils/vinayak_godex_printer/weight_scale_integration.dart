// lib/utils/vinayak_godex_printer/weight_scale_integration.dart

import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class to handle weight scale integration
/// This is a stub implementation for web - serial port access is not available
class WeightScaleManager {
  /// Check if weight scale is supported on this platform
  static bool get isSupported => false;

  /// Gets weight from a scale (not supported on web)
  Future<String?> getWeightFromScale({
    String scalePort = 'COM3',
    int baudRate = 9600,
    int timeout = 1,
    int parity = 0, // Using int instead of SerialPortParity
    int stopBits = 1,
    int dataBits = 7,
    int maxDuration = 10,
    int maxReadings = 10,
  }) async {
    debugPrint('Weight scale not supported on web platform');
    throw UnsupportedError(
        'Serial port access is not available on web. Please use the desktop or mobile app for weight scale integration.');
  }

  /// Dispose method to clean up resources
  Future<void> dispose() async {
    // Nothing to dispose on web
  }

  /// List available serial ports (returns empty list on web)
  static List<String> getAvailablePorts() {
    debugPrint('Serial ports not available on web platform');
    return [];
  }
}
