import 'dart:developer';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

Future<void> generateThermalReceipt() async {
  try {
    final pdf = pw.Document();

    // Calculate content height (or use a fixed value)
    const receiptHeight = 250.0 * PdfPageFormat.mm;

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(
          80 * PdfPageFormat.mm,
          receiptHeight,
          marginAll: 5 * PdfPageFormat.mm,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  'MY STORE',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text(
                  '123 Main Street',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Tel: (555) 123-4567',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Divider(thickness: 1),

              // Date & Receipt Number
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
                  pw.Text('Receipt #: 001'),
                ],
              ),
              pw.SizedBox(height: 10),

              // Items Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      'Item',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      'Qty',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      'Price',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 1),

              // Items
              _buildItem('Coffee', 2, 3.50),
              _buildItem('Sandwich', 1, 6.99),
              _buildItem('Cookies', 3, 2.50),
              _buildItem('Orange Juice', 1, 4.25),

              pw.Divider(thickness: 1),

              // Subtotal
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text('Subtotal:'), pw.Text('\$22.24')],
              ),
              pw.SizedBox(height: 3),

              // Tax
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text('Tax (10%):'), pw.Text('\$2.22')],
              ),
              pw.SizedBox(height: 3),

              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL:',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '\$24.46',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),

              pw.Divider(thickness: 1),

              // Payment Method
              pw.SizedBox(height: 5),
              pw.Text('Payment Method: Cash'),
              pw.Text('Amount Paid: \$30.00'),
              pw.Text('Change: \$5.54'),

              pw.SizedBox(height: 15),

              // Footer
              pw.Center(
                child: pw.Text(
                  'Thank You for Your Purchase!',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text(
                  'Please Come Again',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Get the directory to save the file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/thermal_receipt_80mm.pdf';

    // Save the PDF
    final output = File(filePath);
    await output.writeAsBytes(await pdf.save());

    // Show success toast with path
    showSuccessToast(message: "✅ PDF saved successfully!");
    showSuccessToast(message: "📄 File opened: $filePath");

    // Print path to console
    log('✅ PDF saved successfully!');
    log('📁 Path: $filePath');

    // Open the file automatically
    // final result = await OpenFile.open(filePath);
    // log('📄 File opened: ${result.message}');
  } catch (e) {
    // Show error toast
    showErrorToast(message: "❌ Error saving PDF: $e");

    log('❌ Error: $e');
  }
}

pw.Widget _buildItem(String name, int qty, double price) {
  final total = qty * price;
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(flex: 3, child: pw.Text(name)),
        pw.Expanded(child: pw.Text('$qty')),
        pw.Expanded(
          child: pw.Text(
            '\$${total.toStringAsFixed(2)}',
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
