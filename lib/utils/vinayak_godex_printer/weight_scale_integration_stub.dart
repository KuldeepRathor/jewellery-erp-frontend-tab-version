// lib/utils/vinayak_godex_printer/weight_scale_integration_stub.dart

import 'dart:async';

/// Stub implementation for unsupported platforms
class WeightScaleManager {
  static bool get isSupported => false;

  Future<String?> getWeightFromScale({
    String scalePort = 'COM3',
    int baudRate = 9600,
    int timeout = 1,
    int parity = 0,
    int stopBits = 1,
    int dataBits = 7,
    int maxDuration = 10,
    int maxReadings = 10,
  }) async {
    throw UnsupportedError('Weight scale not supported on this platform');
  }

  Future<void> dispose() async {}

  static List<String> getAvailablePorts() => [];
}
