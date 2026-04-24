import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart' show PdfColors, PdfPageFormat;
import 'package:pdf/widgets.dart' as pw;
import 'package:jewellery_erp_frontend_tab_version/base/controllers/user_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:printing/printing.dart';

class LedgerInvoicePdfGenerator {
  static Future<Uint8List> generateLedger(
    GetSalesRecordByIdAggregateResponse sale,
  ) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.courierPrimeRegular();
    final boldFont = await PdfGoogleFonts.courierPrimeBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(sale, font, boldFont),
              pw.SizedBox(height: 20),
              // Ledger Info
              _buildLedgerInfo(sale, font, context),
              pw.SizedBox(height: 10),
              // Divider
              pw.Container(height: 1, color: PdfColors.black),
              pw.SizedBox(height: 10),
              // Table Header
              _buildTableHeader(font, boldFont),
              pw.Container(height: 1, color: PdfColors.black),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Container();
        },
        build: (pw.Context context) {
          return [
            // Table Rows - these will automatically flow to next pages
            ..._buildTransactionRows(sale, font),

            pw.SizedBox(height: 10),

            // Divider before totals
            pw.Container(height: 1, color: PdfColors.black),

            // Totals
            _buildTotals(sale, font, boldFont),

            pw.Container(height: 1, color: PdfColors.black),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(
    GetSalesRecordByIdAggregateResponse sale,
    pw.Font font,
    pw.Font boldFont,
  ) {
    UserController userController = Get.find<UserController>();

    // Extract company name from sale data or use default
    String companyName =
        " ${userController.userData.value?.organizationName ?? ""} 25-26";

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(companyName, style: pw.TextStyle(font: boldFont, fontSize: 14)),
      ],
    );
  }

  static pw.Widget _buildLedgerInfo(
    GetSalesRecordByIdAggregateResponse sale,
    pw.Font font,
    pw.Context context,
  ) {
    final customerName = sale.partyDetails?.name ?? "";

    // Calculate period - assuming 6 months from sale date
    String period = "01-04-2025 - 31-03-2026";

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Ledger      : $customerName",
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              "Sub Ledger  : ${sale.saleNumber ?? ""}",
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Period      : $period",
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
            pw.Text(
              "Page : ${context.pageNumber}",
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTableHeader(pw.Font font, pw.Font boldFont) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              "Date",
              style: pw.TextStyle(font: boldFont, fontSize: 10),
            ),
          ),
          pw.Expanded(
            flex: 6,
            child: pw.Text(
              "Narration",
              style: pw.TextStyle(font: boldFont, fontSize: 10),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              "Debit",
              style: pw.TextStyle(font: boldFont, fontSize: 10),
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              "Credit",
              style: pw.TextStyle(font: boldFont, fontSize: 10),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  static List<pw.Widget> _buildTransactionRows(
    GetSalesRecordByIdAggregateResponse sale,
    pw.Font font,
  ) {
    List<pw.Widget> rows = [];
    final paymentDetails = sale.paymentDetails?.first;

    if (paymentDetails?.paymentMethodDetails != null) {
      // Add payment method entries (Credits)
      for (var payment in paymentDetails!.paymentMethodDetails!) {
        rows.add(
          _buildTransactionRow(
            date: payment.date,
            narration: _buildPaymentNarration(payment, sale),
            credit: payment.amount ?? "0.00",
            font: font,
          ),
        );
      }
    }

    // Add TDS entry (Credit) - THIS IS THE KEY FIX
    if (paymentDetails?.tds != null &&
        double.tryParse(paymentDetails!.tds!) != 0) {
      rows.add(
        _buildTransactionRow(
          date: sale.createdAt,
          narration: "TDS Deducted\n${sale.saleNumber ?? ""}",
          credit: paymentDetails.tds!,
          font: font,
        ),
      );
    }

    // Add Gold Sales entry (Debit)
    rows.add(
      _buildTransactionRow(
        date: sale.createdAt,
        narration: _buildSalesNarration(sale),
        debit: paymentDetails?.subTotal ?? "0.00",
        font: font,
      ),
    );

    // Add CGST entry (Debit)
    if (paymentDetails?.cgst != null &&
        double.tryParse(paymentDetails!.cgst!) != 0) {
      rows.add(
        _buildTransactionRow(
          date: sale.createdAt,
          narration: _buildTaxNarration(sale, "CGST-1.5% for"),
          debit: paymentDetails.cgst!,
          font: font,
        ),
      );
    }

    // Add SGST entry (Debit)
    if (paymentDetails?.sgst != null &&
        double.tryParse(paymentDetails!.sgst!) != 0) {
      rows.add(
        _buildTransactionRow(
          date: sale.createdAt,
          narration: _buildTaxNarration(sale, "SGST-1.5% for"),
          debit: paymentDetails.sgst!,
          font: font,
        ),
      );
    }

    // Add IGST entry if applicable (Debit)
    if (paymentDetails?.igst != null &&
        double.tryParse(paymentDetails!.igst!) != 0) {
      rows.add(
        _buildTransactionRow(
          date: sale.createdAt,
          narration: _buildTaxNarration(sale, "IGST-3% for"),
          debit: paymentDetails.igst!,
          font: font,
        ),
      );
    }

    return rows;
  }

  static String _buildPaymentNarration(
    PaymentMethodDetail payment,
    GetSalesRecordByIdAggregateResponse sale,
  ) {
    String method = payment.method ?? "CASH";
    String saleNumber = sale.saleNumber ?? "";

    // Get the bank/POS name from backend, or use method as fallback
    String bankOrPos = payment.pos ?? "";

    // Determine display method based on payment method
    String displayMethod;
    if (method == 'CASH') {
      displayMethod = 'CASH ON HAND';
    } else if (method == 'CARD') {
      displayMethod = bankOrPos.isNotEmpty ? bankOrPos : 'CREDIT CARD';
    } else if (method == 'UPI/IMPS') {
      displayMethod = bankOrPos.isNotEmpty ? bankOrPos : 'UPI/IMPS';
    } else if (method == 'NEFT/RTGS') {
      displayMethod = bankOrPos.isNotEmpty ? bankOrPos : 'NEFT/RTGS';
    } else {
      displayMethod = bankOrPos.isNotEmpty ? bankOrPos : method;
    }

    // Build narration without customer name
    String narration = "$displayMethod\n";
    narration += "Bal Rcvd $saleNumber\n";

    // Add payment specific details
    if (payment.method != 'CASH' && payment.paymentCode != null) {
      String methodPrefix;
      if (method == 'UPI/IMPS') {
        methodPrefix = 'IMPS';
      } else if (method == 'CARD') {
        methodPrefix = 'CC';
      } else if (method == 'NEFT/RTGS') {
        methodPrefix = 'by';
      } else {
        methodPrefix = 'by';
      }

      narration +=
          "$methodPrefix ${bankOrPos.isNotEmpty ? bankOrPos : method.replaceAll('/', ' ')} :${payment.paymentCode}";
    } else {
      narration += "CASH  :";
    }

    return narration;
  }

  static String _buildSalesNarration(GetSalesRecordByIdAggregateResponse sale) {
    String saleNumber = sale.saleNumber ?? "";
    return "Gold Sales.$saleNumber";
  }

  static String _buildTaxNarration(
    GetSalesRecordByIdAggregateResponse sale,
    String taxType,
  ) {
    String saleNumber = sale.saleNumber ?? "";
    return "$taxType\nGold Sales.$saleNumber";
  }

  static pw.Widget _buildTransactionRow({
    DateTime? date,
    required String narration,
    String? debit,
    String? credit,
    required pw.Font font,
  }) {
    String formattedDate =
        date != null ? DateFormat('dd-MM-yyyy').format(date) : "";

    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              formattedDate,
              style: pw.TextStyle(font: font, fontSize: 9),
            ),
          ),
          pw.Expanded(
            flex: 6,
            child: pw.Text(
              narration,
              style: pw.TextStyle(font: font, fontSize: 9),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              debit != null ? _formatAmount(debit) : "",
              style: pw.TextStyle(font: font, fontSize: 9),
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              credit != null ? _formatAmount(credit) : "",
              style: pw.TextStyle(font: font, fontSize: 9),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTotals(
    GetSalesRecordByIdAggregateResponse sale,
    pw.Font font,
    pw.Font boldFont,
  ) {
    final paymentDetails = sale.paymentDetails?.first;

    // Calculate total debits
    double totalDebit = 0.0;
    totalDebit += double.tryParse(paymentDetails?.subTotal ?? "0") ?? 0.0;
    totalDebit += double.tryParse(paymentDetails?.cgst ?? "0") ?? 0.0;
    totalDebit += double.tryParse(paymentDetails?.sgst ?? "0") ?? 0.0;
    totalDebit += double.tryParse(paymentDetails?.igst ?? "0") ?? 0.0;

    // Calculate total credits (payment methods + TDS)
    double totalCredit = 0.0;
    if (paymentDetails?.paymentMethodDetails != null) {
      for (var payment in paymentDetails!.paymentMethodDetails!) {
        totalCredit += double.tryParse(payment.amount ?? "0") ?? 0.0;
      }
    }

    // Add TDS to credit side
    totalCredit += double.tryParse(paymentDetails?.tds ?? "0") ?? 0.0;

    // Balance should be 0 in a balanced ledger
    double balance = totalCredit - totalDebit;

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Expanded(
                flex: 8,
                child: pw.Text(
                  "Total.",
                  style: pw.TextStyle(font: boldFont, fontSize: 10),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  _formatAmount(totalDebit.toString()),
                  style: pw.TextStyle(font: boldFont, fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  _formatAmount(totalCredit.toString()),
                  style: pw.TextStyle(font: boldFont, fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
          pw.Row(
            children: [
              pw.Expanded(
                flex: 8,
                child: pw.Text(
                  "Nett.",
                  style: pw.TextStyle(font: boldFont, fontSize: 10),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  _formatAmount(totalDebit.toString()),
                  style: pw.TextStyle(font: boldFont, fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  _formatAmount(totalCredit.toString()),
                  style: pw.TextStyle(font: boldFont, fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
          pw.Row(
            children: [
              pw.Expanded(
                flex: 8,
                child: pw.Text(
                  "Balance.",
                  style: pw.TextStyle(font: boldFont, fontSize: 10),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  "",
                  style: pw.TextStyle(font: boldFont, fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  _formatAmount(balance.abs().toString()),
                  style: pw.TextStyle(font: boldFont, fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
}
