import 'dart:ffi';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';
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
  final String? _selectedPrinter;

  GodexG500Printer({
    required Talker logger,
    required String? selectedPrinter,
  })  : _logger = logger,
        _selectedPrinter = selectedPrinter;

  /// Generates TSPL commands for the label
  String _generateLabelCommands(LabelConfig config) {
    return """
^Q10,2
^W70
^H16
^P1
^S2
^AT
^C1
^R0
~Q-10
^O0
^D0
^E10
~R200
^L
Dy2-me-dd
Th:m:s
AA,20,6,1,1,0,0,NWT :
AB,55,0,1,1,0,0,${config.weight}
AB,55,0,1,1,0,0,
AA,20,26,1,1,0,0,
AB,210,2,1,1,0,0,${config.tagNumber}
AA,320,6,1,1,0,0,
AA,20,26,1,1,0,0,${config.grossWeight}
AA,400,30,1,1,0,0,${config.vendorId}
AA,210,26,1,1,0,0,${config.purity}
AA,320,26,1,1,0,0,${config.size}
AA,145,49,1,1,0,0,${config.qrCode1}
BQ,45,50,1,5,20,0,0,${config.qrCode1}
BQ,220,49,1,5,20,0,0,${config.qrCode2}
AA,330,49,1,1,0,0,
AA,330,49,1,1,0,0,${config.qrCode2}
E
""";
  }

  /// Sends print data to Windows printer
  Future<void> _printToWindows(List<int> bytes) async {
    if (_selectedPrinter == null) {
      throw Exception('No printer selected');
    }

    _logger.info('Printing to Windows printer: $_selectedPrinter');
    final allocator = Arena();
    final printerName = _selectedPrinter.toNativeUtf16(allocator: allocator);
    final phPrinter = calloc<HANDLE>();

    try {
      if (OpenPrinter(printerName, phPrinter, nullptr) == 0) {
        throw Exception('Failed to open printer');
      }

      final hPrinter = phPrinter.value;
      await _processPrintJob(hPrinter, bytes, allocator);
    } catch (e) {
      _logger.error('Printing error: $e');
      rethrow;
    } finally {
      free(phPrinter);
      allocator.free(printerName);
    }
  }

  /// Process the print job
  Future<void> _processPrintJob(
    int hPrinter,
    List<int> bytes,
    Arena allocator,
  ) async {
    final pDocInfo = calloc<DOC_INFO_1>()
      ..ref.pDocName = 'Label_Print'.toNativeUtf16(allocator: allocator)
      ..ref.pOutputFile = nullptr
      ..ref.pDatatype = 'RAW'.toNativeUtf16(allocator: allocator);

    try {
      if (StartDocPrinter(hPrinter, 1, pDocInfo) == 0) {
        throw Exception('Failed to start document');
      }

      if (StartPagePrinter(hPrinter) == 0) {
        throw Exception('Failed to start page');
      }

      await _writeDataToPrinter(hPrinter, bytes);

      if (EndPagePrinter(hPrinter) == 0) {
        throw Exception('Failed to end page');
      }
      if (EndDocPrinter(hPrinter) == 0) {
        throw Exception('Failed to end document');
      }

      _logger.info('Print job completed successfully');
    } finally {
      ClosePrinter(hPrinter);
    }
  }

  /// Write data to printer
  Future<void> _writeDataToPrinter(int hPrinter, List<int> bytes) async {
    final pBytes = calloc<Uint8>(bytes.length);
    final byteData = pBytes.asTypedList(bytes.length);
    final dwWritten = calloc<DWORD>();

    try {
      byteData.setAll(0, bytes);

      if (WritePrinter(
              hPrinter, pBytes.cast<Void>(), bytes.length, dwWritten) ==
          0) {
        throw Exception('Failed to write to printer');
      }

      _logger.info('Bytes written: ${dwWritten.value}');
    } finally {
      free(pBytes);
      free(dwWritten);
    }
  }

  /// Public method to print a label
  Future<void> printLabel(LabelConfig config) async {
    try {
      _logger.info('Starting label print process');
      final commands = _generateLabelCommands(config);
      _logger.info('Generated TSPL commands: $commands');

      final bytes = commands.codeUnits;
      await _printToWindows(bytes);

      _logger.info('Label printed successfully');
    } catch (e) {
      _logger.error('Failed to print label: $e');
      rethrow;
    }
  }
}
