import 'package:talker/talker.dart';

/// Label configuration model
class LabelConfig {
  final String weight;
  final String tagNumber;
  final String grossWeight;
  final String purity;
  final String size;
  final String qrCode1;
  final String qrCode2;
  final String vendorId;

  LabelConfig({
    required this.weight,
    required this.tagNumber,
    required this.grossWeight,
    required this.purity,
    required this.size,
    required this.qrCode1,
    required this.qrCode2,
    this.vendorId = "",
  });
}

class GodexG500Printer {
  final Talker _logger;
  // ignore: unused_field
  final String? _selectedPrinter;

  GodexG500Printer({
    required Talker logger,
    required String? selectedPrinter,
  })  : _logger = logger,
        _selectedPrinter = selectedPrinter;

  Future<bool> printLabel(LabelConfig config) async {
    _logger.warning('Label printing is not supported on this platform');
    return false;
  }

  void dispose() {
    // No-op for non-Windows platforms
  }
}
