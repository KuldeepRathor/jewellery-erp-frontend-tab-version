import 'dart:typed_data';

import '../barcode_template.dart';
import '../model/barcode_model.dart';

class BarcodeGenerator {
  BarcodeGenerator._privateConstructor();
  static final BarcodeGenerator instance =
      BarcodeGenerator._privateConstructor();

  Future<Uint8List> generateEBarcode(BarcodeModel data) async {
    final pdf = await BarcodeTemplate(data: data).getBarcodePdf();
    return pdf.save();
  }
}
