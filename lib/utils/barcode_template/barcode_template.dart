import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/barcode_template/model/barcode_model.dart';
import 'package:printing/printing.dart';

class BarcodeTemplate {
  final BarcodeModel data;
  BarcodeTemplate({required this.data});

  /// FONTS
  late Font valuesFont;
  late Font labelFont;

  /// FONT SIZE
  double valuesFontSize = 5; // Smaller font size
  double labelFontSize = 6; // Slightly larger for labels

  /// FONT COLOR
  PdfColor valueColor = PdfColors.black;
  PdfColor labelColor = PdfColors.blue600;

  Future<void> setFontFamily(String fontFamily) async {
    valuesFont = await PdfGoogleFonts.robotoRegular();
    labelFont = await PdfGoogleFonts.robotoBold();
  }

  Future<Document> getBarcodePdf() async {
    await setFontFamily(data.fontFamily);

    final barcode = Document();
    barcode.addPage(
      MultiPage(
        pageFormat: const PdfPageFormat(
          70 * PdfPageFormat.mm,
          10 * PdfPageFormat.mm,
        ),
        build: (context) {
          return List.generate(
            data.count,
            (_) => barcodePreviewWidget(), // Generate each barcode
          );
        },
      ),
    );
    return barcode;
  }

  Widget barcodePreviewWidget() {
    return Container(
      width: 50 * PdfPageFormat.mm,
      height: 10 * PdfPageFormat.mm,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Wt: ",
                    style: TextStyle(
                      font: valuesFont,
                      fontSize: valuesFontSize,
                      color: valueColor,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    data.weight ?? '',
                    style: TextStyle(
                      font: labelFont,
                      fontSize: labelFontSize,
                      color: labelColor,
                    ),
                  ),
                ],
              ),
              if (data.itemName != null && data.itemName!.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      data.itemName!.length > 20
                          ? data.itemName!.substring(0, 19)
                          : data.itemName!,
                      style: TextStyle(
                        font: valuesFont,
                        fontSize: valuesFontSize,
                        color: valueColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      data.itemCode ?? 'CDI',
                      style: TextStyle(
                        font: valuesFont,
                        fontSize: valuesFontSize,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ],
              Row(
                children: [
                  BarcodeWidget(
                    data: data.barCode,
                    width: 18 * PdfPageFormat.mm,
                    height: 3 * PdfPageFormat.mm,
                    drawText: data.showNumber,
                    barcode: Barcode.code39(),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'CDI',
                    style: TextStyle(
                      font: valuesFont,
                      fontSize: valuesFontSize,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    data.weightGroup ?? '',
                    style: TextStyle(
                      font: valuesFont,
                      fontSize: valuesFontSize,
                      color: valueColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    data.purity ?? '',
                    style: TextStyle(
                      font: labelFont,
                      fontSize: labelFontSize,
                      color: labelColor,
                    ),
                  ),
                ],
              ),
              Text(
                data.barCode,
                style: TextStyle(
                  font: valuesFont,
                  fontSize: valuesFontSize,
                  color: valueColor,
                ),
              ),
              Center(
                child: BarcodeWidget(
                  data: data.barCode,
                  width: 18 * PdfPageFormat.mm,
                  height: 3 * PdfPageFormat.mm,
                  drawText: data.showNumber,
                  barcode: Barcode.code39(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
