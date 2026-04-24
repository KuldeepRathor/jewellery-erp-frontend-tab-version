import 'dart:typed_data';
import 'package:pdf/pdf.dart' show PdfColor, PdfColors, PdfPageFormat;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/get_purchase_invoice_by_id.dart';

class PurchaseInvoicePdfGenerator {
  // Simplified method that only accepts GetPurchaseInvoiceById
  static Future<Uint8List> generateInvoice(
    GetPurchaseInvoiceById purchase,
  ) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.courierPrimeRegular();

    // Helper function to format address similar to SalesInvoicePdfGenerator
    String formatAddress(PartyDetails? partyDetails) {
      // If partyDetails is null or address is empty, return empty string
      if (partyDetails?.address == null || partyDetails!.address!.isEmpty) {
        return '';
      }

      // Get the default address
      Address? addressInfo = partyDetails.address!.firstWhere(
        (addr) => addr.isDefault == true,
        orElse: () => partyDetails.address!.first,
      );

      List<String> addressParts = [];

      if (addressInfo.addressLine1 != null &&
          addressInfo.addressLine1!.isNotEmpty) {
        addressParts.add(addressInfo.addressLine1!);
      }

      if (addressInfo.addressLine2 != null &&
          addressInfo.addressLine2!.isNotEmpty) {
        addressParts.add(addressInfo.addressLine2!);
      }

      if (addressInfo.city != null && addressInfo.city!.isNotEmpty) {
        addressParts.add(addressInfo.city!);
      }

      if (addressInfo.state != null && addressInfo.state!.isNotEmpty) {
        addressParts.add(addressInfo.state!);
      }

      if (addressInfo.pincode != null && addressInfo.pincode!.isNotEmpty) {
        addressParts.add(addressInfo.pincode!);
      }

      return addressParts.join(', ');
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 150),
              // Title
              pw.Center(
                child: pw.Text(
                  "OLD PURCHASE",
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
              ),

              pw.SizedBox(height: 20),

              // Header Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left side - Customer Details
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              width: 80,
                              child: pw.Text(
                                'Name',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                            pw.Text(
                              ': ',
                              style: pw.TextStyle(font: font, fontSize: 10),
                            ),
                            pw.Text(
                              purchase.partyDetails?.name ??
                                  purchase.partyName ??
                                  "",
                              style: pw.TextStyle(font: font, fontSize: 10),
                            ),
                            if (purchase.partyDetails?.panNumber !=
                                    "Cash Sales" &&
                                purchase.partyDetails?.panNumber != null &&
                                purchase.partyDetails!.panNumber!.isNotEmpty)
                              pw.Text(
                                " (Pan: ${purchase.partyDetails?.panNumber})",
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            pw.Spacer(),
                          ],
                        ),
                        pw.SizedBox(height: 5), // Phone number
                        if (purchase.partyDetails?.phoneNumber != null ||
                            purchase.partyPhoneNumber != null)
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.SizedBox(
                                width: 80,
                                child: pw.Text(
                                  'Mobile',
                                  style: pw.TextStyle(font: font, fontSize: 10),
                                ),
                              ),
                              pw.Text(
                                ': ',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  purchase.partyDetails?.phoneNumber ??
                                      purchase.partyPhoneNumber ??
                                      "",
                                  style: pw.TextStyle(font: font, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        pw.SizedBox(height: 5),
                        // Address handling
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              width: 80,
                              child: pw.Text(
                                'Address',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                            pw.Text(
                              ': ',
                              style: pw.TextStyle(font: font, fontSize: 10),
                            ),
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  // Display formatted address if available in partyDetails
                                  pw.Text(
                                    purchase.partyDetails != null
                                        ? formatAddress(purchase.partyDetails)
                                        : purchase.partyAddress ?? "",
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        //       // PAN number if available
                        //       if (purchase.partyDetails?.panNumber != null &&
                        //           purchase.partyDetails!.panNumber!.isNotEmpty)
                        //         pw.SizedBox(height: 5),
                        //       if (purchase.partyDetails?.panNumber != null &&
                        //           purchase.partyDetails!.panNumber!.isNotEmpty)
                        //         pw.Row(
                        //           crossAxisAlignment: pw.CrossAxisAlignment.start,
                        //           children: [
                        //             pw.SizedBox(
                        //               width: 80,
                        //               child: pw.Text('PAN',
                        //                   style:
                        //                       pw.TextStyle(font: font, fontSize: 10)),
                        //             ),
                        //             pw.Text(': ',
                        //                 style:
                        //                     pw.TextStyle(font: font, fontSize: 10)),
                        //             pw.Expanded(
                        //               child: pw.Text(
                        //                   purchase.partyDetails?.panNumber ?? "",
                        //                   style:
                        //                       pw.TextStyle(font: font, fontSize: 10)),
                        //             ),
                        //           ],
                        //         ),
                        //       // GST number if available
                        //       if (purchase.partyDetails?.gstNumber != null &&
                        //           purchase.partyDetails!.gstNumber!.isNotEmpty ||
                        //           purchase.partyGst != null &&
                        //           purchase.partyGst!.isNotEmpty)
                        //         pw.SizedBox(height: 5),
                        //       if (purchase.partyDetails?.gstNumber != null &&
                        //           purchase.partyDetails!.gstNumber!.isNotEmpty ||
                        //           purchase.partyGst != null &&
                        //           purchase.partyGst!.isNotEmpty)
                        //         pw.Row(
                        //           crossAxisAlignment: pw.CrossAxisAlignment.start,
                        //           children: [
                        //             pw.SizedBox(
                        //               width: 80,
                        //               child: pw.Text('GST',
                        //                   style:
                        //                       pw.TextStyle(font: font, fontSize: 10)),
                        //             ),
                        //             pw.Text(': ',
                        //                 style:
                        //                     pw.TextStyle(font: font, fontSize: 10)),
                        //             pw.Expanded(
                        //               child: pw.Text(
                        //                   purchase.partyDetails?.gstNumber ?? purchase.partyGst ?? "",
                        //                   style:
                        //                       pw.TextStyle(font: font, fontSize: 10)),
                        //             ),
                        //           ],
                        //         ),
                      ],
                    ),
                  ),
                  // Right side - Invoice Details
                  pw.Expanded(
                    flex: 2,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              'No. : ',
                              style: pw.TextStyle(font: font, fontSize: 10),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                purchase.invoiceNumber ?? "",
                                style: pw.TextStyle(font: font, fontSize: 10),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Date : ',
                              style: pw.TextStyle(font: font, fontSize: 10),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                _formatDate(purchase.invoiceCreateDate),
                                style: pw.TextStyle(font: font, fontSize: 10),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Rate : ',
                              style: pw.TextStyle(font: font, fontSize: 10),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                _getRate(purchase),
                                style: pw.TextStyle(font: font, fontSize: 10),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Main Table
              _buildItemsTable(purchase, font),

              pw.SizedBox(height: 80),

              // Amount in words
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Amount in numbers
                  pw.Text(
                    'Rs.${_getTotalAmount(purchase)}',
                    style: pw.TextStyle(font: font, fontSize: 14),
                  ),
                  // Amount in words on next line
                  pw.Text(
                    _convertToWords(
                      _getTotalAmount(purchase),
                    ).replaceFirst('Rupees ', ''),
                    style: pw.TextStyle(font: font, fontSize: 10),
                  ),
                ],
              ),
              // Use Expanded with flex instead of Spacer to ensure footer is visible
              pw.Expanded(child: pw.SizedBox(), flex: 1),

              // Footer
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'E.& O.E',
                    style: pw.TextStyle(font: font, fontSize: 10),
                  ),
                  pw.Text(
                    'Authorized Sign.',
                    style: pw.TextStyle(font: font, fontSize: 10),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildItemsTable(
    GetPurchaseInvoiceById purchase,
    pw.Font font,
  ) {
    final headers = [
      'Item',
      'Gr.Wt.',
      'Dust',
      'Wst.',
      'Nett-Wt.',
      'Rate',
      'Amount',
    ];

    // Get the total amount for multiple uses
    final totalAmount = _getTotalAmount(purchase);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Main table for items
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.white),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(1),
            4: const pw.FlexColumnWidth(1),
            5: const pw.FlexColumnWidth(1),
            6: const pw.FlexColumnWidth(1),
          },
          children: [
            // Header Row
            pw.TableRow(
              children:
                  headers.map((header) {
                    if (header == 'Amount') {
                      // Right-align the Amount header to match the data
                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          header,
                          style: pw.TextStyle(font: font, fontSize: 10),
                          textAlign: pw.TextAlign.right,
                        ),
                      );
                    } else {
                      // Other headers remain the same
                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          header,
                          style: pw.TextStyle(font: font, fontSize: 10),
                        ),
                      );
                    }
                  }).toList(),
            ),
            // Data Rows
            ...purchase.lineItems?.map(
                  (item) => pw.TableRow(
                    children: [
                      _buildCell(item.itemDescription ?? 'OLD GOLD', font),
                      _buildCell(item.grossWeight ?? '0.000', font),
                      _buildCell(item.less ?? '0.000', font),
                      _buildCell('0.000', font),
                      _buildCell(item.netWeight ?? '0.000', font),
                      _buildCell(item.rate ?? '0.00', font),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          _formatAmount(item.amount),
                          style: pw.TextStyle(font: font, fontSize: 10),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ) ??
                [],
            // Total Row
            pw.TableRow(
              children: [
                _buildCell('', font),
                _buildCell(_getTotalGrossWeight(purchase), font),
                _buildCell('', font),
                _buildCell('', font),
                _buildCell(_getTotalNetWeight(purchase), font),
                _buildCell('', font),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    totalAmount,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Additional info using the same table structure to maintain alignment
        pw.SizedBox(height: 2),

        // Use a table for "Nett" and "Adj.Sales Bill" to maintain alignment
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.white),
          columnWidths: {
            0: const pw.FlexColumnWidth(2.0), // Item
            1: const pw.FlexColumnWidth(1), // Gr.Wt.
            2: const pw.FlexColumnWidth(1), // Dust
            3: const pw.FlexColumnWidth(1), // Wst.
            4: const pw.FlexColumnWidth(3), // Nett-Wt.
            5: const pw.FlexColumnWidth(0), // Rate
            6: const pw.FlexColumnWidth(1.5), // Amount
          },
          children: [
            // Nett Row
            pw.TableRow(
              children: [
                _buildCell('', font),
                _buildCell('', font),
                _buildCell('', font),
                _buildCell('', font),
                _buildCell('Nett.', font),
                _buildCell('', font),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    totalAmount,
                    style: pw.TextStyle(font: font, fontSize: 10),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            ),

            // Adj.Sales Bill Row
            pw.TableRow(
              children: [
                _buildCell('', font),
                _buildCell('', font),
                _buildCell('', font),
                _buildCell('', font),
                pw.Container(
                  padding: const pw.EdgeInsets.all(4),
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(
                    'Adj.Sales Bill ${purchase.saleInvoiceNumber ?? ""}',
                    style: pw.TextStyle(font: font, fontSize: 10),
                    // maxLines: 1,
                  ),
                ),
                _buildCell('', font),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    totalAmount,
                    style: pw.TextStyle(font: font, fontSize: 10),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildCell(
    String text,
    pw.Font font, {
    bool isBold = false,
    PdfColor? color,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: 10,
          color: color ?? PdfColors.black,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String _getRate(GetPurchaseInvoiceById purchase) {
    if (purchase.lineItems?.isNotEmpty ?? false) {
      return purchase.lineItems!.first.rate ?? '0.00';
    }
    return '0.00';
  }

  static String _getTotalGrossWeight(GetPurchaseInvoiceById purchase) {
    double total = 0;
    for (var item in purchase.lineItems ?? []) {
      total += double.tryParse(item.grossWeight ?? '0') ?? 0;
    }
    return total.toStringAsFixed(3);
  }

  static String _getTotalNetWeight(GetPurchaseInvoiceById purchase) {
    double total = 0;
    for (var item in purchase.lineItems ?? []) {
      total += double.tryParse(item.netWeight ?? '0') ?? 0;
    }
    return total.toStringAsFixed(3);
  }

  static String _getTotalAmount(GetPurchaseInvoiceById purchase) {
    if (purchase.paymentDetails?.isNotEmpty ?? false) {
      return purchase.paymentDetails!.first.total ?? '0.00';
    }
    return '0.00';
  }

  static String _formatAmount(String? amount) {
    if (amount == null || amount.isEmpty) return '0.00';
    try {
      final value = double.tryParse(amount) ?? 0;
      return value.toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
  }

  static String _convertToWords(String amount) {
    try {
      final value = double.tryParse(amount) ?? 0;
      final int rupees = value.floor();
      final int paise = ((value - rupees) * 100).round();

      if (rupees == 0) {
        return "Zero Rupees Only";
      }

      String rupeesInWords = _convertNumberToWords(rupees);

      if (paise > 0) {
        String paiseInWords = _convertNumberToWords(paise);
        return "Rupees $rupeesInWords and $paiseInWords Paise Only";
      } else {
        return "Rupees $rupeesInWords Only";
      }
    } catch (e) {
      return "Zero Rupees Only";
    }
  }

  static String _convertNumberToWords(int number) {
    final List<String> ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen',
    ];

    final List<String> tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety',
    ];

    if (number == 0) {
      return '';
    } else if (number < 20) {
      return ones[number];
    } else if (number < 100) {
      return '${tens[number ~/ 10]} ${ones[number % 10]}';
    } else if (number < 1000) {
      return '${ones[number ~/ 100]} Hundred ${_convertNumberToWords(number % 100)}';
    } else if (number < 100000) {
      return '${_convertNumberToWords(number ~/ 1000)} Thousand ${_convertNumberToWords(number % 1000)}';
    } else if (number < 10000000) {
      return '${_convertNumberToWords(number ~/ 100000)} Lakh ${_convertNumberToWords(number % 100000)}';
    } else {
      return '${_convertNumberToWords(number ~/ 10000000)} Crore ${_convertNumberToWords(number % 10000000)}';
    }
  }
}
