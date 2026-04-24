import 'dart:typed_data';
import 'package:pdf/pdf.dart' show PdfColor, PdfColors, PdfPageFormat;
import 'package:pdf/widgets.dart' as pw;
import 'package:jewellery_erp_frontend_tab_version/feature/home/model/get_global_settings_response.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/payment_methods.dart';

class HeaderCell {
  final String text;
  final pw.TextAlign alignment;

  HeaderCell(this.text, this.alignment);
}

class VACalculationResult {
  final double vaPercentage;
  final double vaGrams;
  final double vaAmount;
  final String displayText;

  VACalculationResult({
    required this.vaPercentage,
    required this.vaGrams,
    required this.vaAmount,
    required this.displayText,
  });
}

SalePrintTemplate? _getTemplate1Settings(
  GetGlobalSettingsResponse? globalSettings,
) {
  if (globalSettings?.salePrintTemplates == null) return null;

  return globalSettings!.salePrintTemplates!.firstWhere(
    (template) => template.templateNumber == 1,
    orElse: () => globalSettings.salePrintTemplates!.first,
  );
}

class SalesInvoicePdfGenerator {
  static String _formatZeroAmount(String? amount, {String defaultEmpty = ''}) {
    if (amount == null || PaymentConstants.zeroAmounts.contains(amount)) {
      return '';
    }
    return amount.isEmpty ? defaultEmpty : amount;
  }

  static VACalculationResult _calculateVA(
    GetSalesRecordByIdAggregateResponseLineItem lineItem,
    SalePrintTemplate? template,
  ) {
    final netWeight = double.tryParse(lineItem.finalNetWeight ?? '0') ?? 0;
    final rate = double.tryParse(lineItem.rate ?? '0') ?? 0;
    final wastageType = lineItem.wastageType ?? '%';

    double vaPercentage = 0;
    double vaGrams = 0;
    double vaAmount = 0;
    String displayText = '';

    if (wastageType == '%') {
      // Use percentage VA from template or line item
      vaPercentage = double.tryParse(lineItem.finalVa ?? '0') ?? 0;
      vaGrams = (netWeight * vaPercentage) / 100;
      vaAmount = vaGrams * rate;
    } else if (wastageType == 'gm') {
      // Use grams VA from line item
      vaGrams = double.tryParse(lineItem.finalVa ?? '0') ?? 0;
      vaPercentage = netWeight > 0 ? (vaGrams / netWeight) * 100 : 0;
      vaAmount = vaGrams * rate;
    }

    // Format display text based on template settings
    if (template != null) {
      displayText = _formatVADisplay(
        vaPercentage,
        vaGrams,
        vaAmount,
        template.percentVa ?? 'percentage',
        wastageType,
      );
    } else {
      // Fallback display
      displayText =
          wastageType == '%'
              ? '${vaPercentage.toStringAsFixed(1)}%'
              : '${vaGrams.toStringAsFixed(3)}gm';
    }

    return VACalculationResult(
      vaPercentage: vaPercentage,
      vaGrams: vaGrams,
      vaAmount: vaAmount,
      displayText: displayText,
    );
  }

  static String _formatVADisplay(
    double vaPercentage,
    double vaGrams,
    double vaAmount,
    String displayType,
    String wastageType,
  ) {
    switch (displayType) {
      case 'percentage':
        return '${vaPercentage.toStringAsFixed(1)}%';
      case 'grams':
        return '${vaGrams.toStringAsFixed(3)}gm';
      case 'both':
        return '${vaGrams.toStringAsFixed(3)}(${vaPercentage.toStringAsFixed(1)}%)';
      case 'amount':
        return vaAmount.toStringAsFixed(0);
      case 'none':
        return '';
      default:
        // Default to showing based on wastageType
        return wastageType == '%'
            ? '${vaPercentage.toStringAsFixed(1)}%'
            : '${vaGrams.toStringAsFixed(3)}gm';
    }
  }

  static Future<Uint8List> generateInvoice(
    GetSalesRecordByIdAggregateResponse sale, {
    GetGlobalSettingsResponse? globalSettings,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.courierPrimeRegular();
    final boldFont = await PdfGoogleFonts.courierPrimeBold();
    final paymentDetails = sale.paymentDetails?.first;
    final formattedMethods = _formatNonCashPaymentMethods(
      sale.paymentDetails?.first.paymentMethodDetails,
    );

    final template1Settings = _getTemplate1Settings(globalSettings);
    final numberOfCopies = template1Settings?.panInvoiceCopy ?? 1;

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

      return addressParts.join(', ');
    }

    for (int copyIndex = 0; copyIndex < numberOfCopies; copyIndex++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            // Create the main content
            final mainContent = pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 100),
                // Invoice Title
                pw.Center(
                  child: pw.Text(
                    "TAX INVOICE SALES",
                    style: pw.TextStyle(font: font, fontSize: 10),
                  ),
                ),

                pw.SizedBox(height: 5),

                // Customer Details Section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
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
                              pw.Expanded(
                                child: pw.Text(
                                  '${sale.partyDetails?.name ?? ""} ',
                                  style: pw.TextStyle(font: font, fontSize: 10),
                                ),
                              ),
                              if (sale.partyDetails?.name != "Cash Sales" &&
                                  sale.partyDetails?.panNumber != null &&
                                  sale.partyDetails!.panNumber!.isNotEmpty)
                                pw.Text(
                                  ' (Pan: ${sale.partyDetails?.panNumber})',
                                  style: pw.TextStyle(font: font, fontSize: 10),
                                ),
                              pw.Spacer(),
                            ],
                          ),
                          pw.SizedBox(height: 1),
                          if (sale.partyDetails?.name != "Cash Sales")
                            pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: 80,
                                  child: pw.Text(
                                    'Mobile no',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                pw.Text(
                                  ': ',
                                  style: pw.TextStyle(font: font, fontSize: 10),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    (sale.partyDetails?.phoneNumber ?? ""),
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          pw.SizedBox(height: 1),
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
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    // Display customer address if available
                                    if (sale.partyDetails?.name != "Cash Sales")
                                      pw.Text(
                                        formatAddress(sale.partyDetails),
                                        style: pw.TextStyle(
                                          font: font,
                                          fontSize: 10,
                                        ),
                                      ),

                                    // Always show state info from main response (with spacing)
                                    pw.SizedBox(height: 15),
                                    pw.Text(
                                      '${sale.stateName ?? ""} (Code:${sale.stateCode ?? ""})',
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
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                'No.  : ',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  sale.saleNumber ?? "",
                                  style: pw.TextStyle(font: font, fontSize: 10),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 1),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                'Date : ',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  _formatDate(sale.createdAt),
                                  style: pw.TextStyle(font: font, fontSize: 10),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 1),
                          if (sale.lineItems?.isNotEmpty ?? false)
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  'Rate : ',
                                  style: pw.TextStyle(font: font, fontSize: 10),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    sale.lineItems?.first.rate ?? "",
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 10,
                                    ),
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

                pw.SizedBox(height: 5),

                // Items Table
                _buildItemsTable(sale, font, template1Settings),

                pw.SizedBox(height: 10),
                _buildPrePaymentDetails(sale.paymentDetails!.first, font),

                // Old Gold Table
                if (sale.oldGolds?.isNotEmpty ?? false)
                  _buildOldGoldTable(sale, font),

                // Payment Details
                if (sale.paymentDetails?.isNotEmpty ?? false)
                  _buildPaymentDetails(sale.paymentDetails!.first, font),

                // Use Expanded with flex instead of Spacer to leave room for footer
                pw.Expanded(child: pw.SizedBox(), flex: 1),
                // payment method details
                if (sale.paymentDetails?.isNotEmpty ?? false)
                  if (formattedMethods.isNotEmpty)
                    _buildDynamicGrid(formattedMethods, font),

                pw.SizedBox(height: 2),

                // Payment Methods Row
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      for (final entry
                          in PaymentConstants.paymentMethods.entries)
                        _buildPaymentMethodCell(
                          entry.value,
                          _calculateTotalPaymentByMethod(
                            paymentDetails?.paymentMethodDetails,
                            entry.key,
                          ),
                          font,
                        ),
                      // Special cases
                      _buildPaymentMethodCell(
                        'Bal.',
                        _formatZeroAmount(paymentDetails?.balanceAmount),
                        font,
                      ),
                      _buildPaymentMethodCell('V.Addn', '', font),
                      _buildPaymentMethodCell(
                        'Purchase',
                        _formatZeroAmount(
                          paymentDetails?.purchaseOldGold,
                          defaultEmpty: ' ',
                        ),
                        font,
                      ),
                    ],
                  ),
                ),

                // pw.SizedBox(height: 15),
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

                pw.SizedBox(height: 15),
                if (template1Settings?.showAdditionalMessage == true &&
                    template1Settings?.additionalMessage?.isNotEmpty == true)
                  pw.Column(
                    children: [
                      pw.Text(
                        template1Settings!.additionalMessage!,
                        style: pw.TextStyle(font: font, fontSize: 10),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 10),
                    ],
                  ),
              ],
            );

            // Check if invoice is cancelled and add watermark
            if (sale.isCancelled == true) {
              return pw.Stack(
                children: [
                  // Main content
                  mainContent,
                  // Watermark overlay with lines
                  pw.Positioned.fill(
                    child: pw.Center(
                      child: pw.Transform.rotate(
                        angle: 0.75, // Rotate approximately 45 degrees
                        child: pw.Column(
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            // Top line
                            pw.Container(
                              width: 270,
                              height: 3,
                              color: PdfColor.fromHex('#FFB3B3'),
                            ),
                            pw.SizedBox(height: 5),
                            // CANCELLED text
                            pw.Text(
                              'CANCELLED',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 50,
                                color: PdfColor.fromHex('#FFB3B3'),
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            // Bottom line
                            pw.Container(
                              width: 270,
                              height: 3,
                              color: PdfColor.fromHex('#FFB3B3'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Return normal content without watermark
              return mainContent;
            }
          },
        ),
      );
    }
    return pdf.save();
  }

  static List<String> _formatNonCashPaymentMethods(
    List<PaymentMethodDetail>? paymentDetails,
  ) {
    if (paymentDetails == null || paymentDetails.isEmpty) {
      return [];
    }
    // Filter out cash payments and get non-cash payments
    final nonCashPayments =
        paymentDetails
            .where(
              (payment) =>
                  payment.method != null &&
                  payment.method != PaymentConstants.cashKey &&
                  payment.method!.isNotEmpty,
            )
            .toList();

    if (nonCashPayments.isEmpty) {
      return [];
    }

    // Format each payment method
    List<String> formattedPayments = [];

    for (var payment in nonCashPayments) {
      // Skip if amount is zero or empty
      double amount = double.tryParse(payment.amount ?? '0') ?? 0;
      if (amount == 0) continue;

      // Format date
      String dateStr = '';
      if (payment.date != null) {
        dateStr =
            '${payment.date!.day}/${payment.date!.month}/${payment.date!.year % 100}';
      }

      // Get display name for payment method
      String methodDisplay =
          PaymentConstants.paymentMethods[payment.method] ?? payment.method!;

      // Format: "METHOD: AMOUNT - DATE - UTR (paymentCode)"
      String formatted = '$methodDisplay:${amount.toStringAsFixed(2)}';

      if (dateStr.isNotEmpty) {
        formatted += '-$dateStr';
      }

      // Add UTR with payment code if available
      String utrCode = payment.paymentCode ?? '';
      formatted += '-$utrCode';

      // Bank Name

      String bankName = payment.pos ?? '';
      if (bankName.isNotEmpty) {
        formatted += '($bankName)';
      }

      formattedPayments.add(formatted);
    }

    return formattedPayments;
  }

  static String _calculateTotalPaymentByMethod(
    List<PaymentMethodDetail>? paymentDetails,
    String method,
  ) {
    if (paymentDetails == null || paymentDetails.isEmpty) {
      return '';
    }

    // Filter payments by method
    // Need to handle special case for NEFT/RTGS
    final paymentsOfType = paymentDetails.where((p) {
      if (method == 'BANK_TRANSFER' && p.method == 'NEFT/RTGS') {
        return true;
      }
      if (method == 'IMPS' && p.method == 'UPI/IMPS') {
        return true;
      }
      return p.method == method;
    });

    // If no payments of this type, return empty string
    if (paymentsOfType.isEmpty) {
      return '';
    }

    // Sum up all amounts for this payment method
    double totalAmount = 0.0;
    for (var payment in paymentsOfType) {
      totalAmount += double.tryParse(payment.amount ?? '0') ?? 0;
    }

    // Return empty string if the amount is 0
    if (totalAmount == 0) {
      return '';
    }

    // Format the amount with 2 decimal places
    return totalAmount.toStringAsFixed(2);
  }

  static pw.Widget _buildPaymentMethodCell(
    String label,
    String amount,
    pw.Font font,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(label, style: pw.TextStyle(font: font, fontSize: 8)),
        pw.SizedBox(height: 2),
        pw.Text(amount, style: pw.TextStyle(font: font, fontSize: 8)),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text,
    pw.Font font, {
    pw.TextAlign alignment = pw.TextAlign.left,
    PdfColor color = PdfColors.black,
    bool isStoneDetails = false,
    bool splitLine = false, // New flag to control split behavior
  }) {
    if (splitLine && text.contains('(') && text.contains(')')) {
      final firstHalf = text.split('(')[0].trim(); // "12.000"
      final secondHalf = '(${text.split('(')[1]}'; // "(12.00%)"

      return pw.Padding(
        padding: const pw.EdgeInsets.all(1),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              firstHalf,
              style: pw.TextStyle(font: font, fontSize: 8, color: color),
              softWrap: !isStoneDetails,
              tightBounds: true,
              textAlign: alignment,
              overflow:
                  isStoneDetails
                      ? pw.TextOverflow.visible
                      : pw.TextOverflow.clip,
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              secondHalf,
              style: pw.TextStyle(font: font, fontSize: 8, color: color),
              softWrap: !isStoneDetails,
              tightBounds: true,
              textAlign: alignment,
              overflow:
                  isStoneDetails
                      ? pw.TextOverflow.visible
                      : pw.TextOverflow.clip,
            ),
          ],
        ),
      );
    }

    // Default behavior
    return pw.Padding(
      padding: const pw.EdgeInsets.all(1),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 8, color: color),
        softWrap: !isStoneDetails,
        tightBounds: true,
        textAlign: alignment,
        overflow:
            isStoneDetails ? pw.TextOverflow.visible : pw.TextOverflow.clip,
      ),
    );
  }

  static String _getHsnCode(
    GetSalesRecordByIdAggregateResponseLineItem lineItem,
  ) {
    // Get HSN from ornament if available through tagging record
    final hsnCode = lineItem.taggingRecord?.designLineItem?.ornament?.hsnSac;
    return hsnCode ?? "-"; // Fallback to default if not found
  }

  static pw.Widget _buildItemsTable(
    GetSalesRecordByIdAggregateResponse sale,
    pw.Font font,
    SalePrintTemplate? template1Settings,
  ) {
    final headerCells = [
      HeaderCell('Sl', pw.TextAlign.left),
      HeaderCell('Item Description', pw.TextAlign.left),
      HeaderCell('HSN', pw.TextAlign.left),
      HeaderCell('Pc', pw.TextAlign.left),
      HeaderCell('Wt.', pw.TextAlign.left),
      HeaderCell('V.A', pw.TextAlign.left),
      HeaderCell('M.C', pw.TextAlign.left),
      HeaderCell('Stn', pw.TextAlign.left),
      HeaderCell('Hmrk', pw.TextAlign.left),
      HeaderCell('Amount', pw.TextAlign.right),
    ];

    List<pw.TableRow> rows = [
      // Header Row
      pw.TableRow(
        children:
            headerCells
                .map(
                  (cell) => _buildTableCell(
                    cell.text,
                    font,
                    alignment: cell.alignment,
                  ),
                )
                .toList(),
      ),
    ];

    // Data Rows
    for (var index = 0; index < (sale.lineItems?.length ?? 0); index++) {
      final lineItem = sale.lineItems![index];
      final vaResult = _calculateVA(lineItem, template1Settings);

      // Main Item Row
      rows.add(
        pw.TableRow(
          children: [
            _buildTableCell('${index + 1}', font, alignment: pw.TextAlign.left),
            _buildTableCell(
              "${sale.lineItems![index].description} ${sale.lineItems![index].code} - ${sale.lineItems![index].tag} (${sale.lineItems![index].taggingRecord?.purity}})",
              font,
              alignment: pw.TextAlign.left,
            ),
            _buildTableCell(
              _getHsnCode(lineItem),
              font,
              alignment: pw.TextAlign.left,
            ),
            _buildTableCell(
              '${sale.lineItems?[index].finalPieces ?? 1}',
              font,
              alignment: pw.TextAlign.left,
            ),
            _buildTableCell(
              sale.lineItems![index].finalNetWeight ?? '',
              font,
              alignment: pw.TextAlign.left,
            ),
            _buildTableCell(
              vaResult.displayText,
              font,
              alignment: pw.TextAlign.left,
              splitLine: true,
            ),
            _buildTableCell(
              (template1Settings?.mcTotal == true)
                  ? (sale.lineItems![index].makingChargeAmount ?? '')
                  : (sale.lineItems![index].finalMc ?? ''),
              font,
              alignment: pw.TextAlign.left,
            ),
            _buildTableCell(
              sale.lineItems![index].stoneCost ?? '',
              font,
              alignment: pw.TextAlign.left,
            ),
            _buildTableCell(
              sale.lineItems![index].hallMark ?? '',
              font,
              alignment: pw.TextAlign.left,
            ),
            _buildTableCell(
              _formatAmount(sale.lineItems![index].salesAmount),
              font,
              alignment: pw.TextAlign.right,
            ),
          ],
        ),
      );

      // Add stone details only if stone cost is valid
      if (_hasValidStoneCost(sale.lineItems![index])) {
        // First, add the Gr Wt and Stn Wt line
        rows.add(
          pw.TableRow(
            children: [
              _buildTableCell('', font),
              _buildTableCell(
                'Gr Wt:${sale.lineItems![index].finalGrossWeight ?? sale.lineItems![index].taggingGrossWeight ?? ""} Stn Wt +/-:${_extractStoneWeight(sale.lineItems![index])}',
                font,
                color: PdfColors.grey600,
              ),
              ...List.generate(7, (_) => _buildTableCell('', font)),
            ],
          ),
        );

        // In your current code, try replacing the stone details section with this:

        if (sale.lineItems![index].taggingRecord?.lineStones?.isNotEmpty ==
            true) {
          for (var stone in sale.lineItems![index].taggingRecord!.lineStones!) {
            try {
              // Directly access properties of LineStone object
              String stoneName = stone.referenceStone?.code ?? 'STONE';
              String pieces = stone.pieces?.toString() ?? '0';
              String carats = stone.carat ?? '';
              String rate = stone.rate ?? '';

              // Use the total property if available, otherwise calculate
              String amount;
              if (stone.total != null && stone.total!.isNotEmpty) {
                amount = stone.total!;
              } else {
                // Calculate the total amount if possible
                double caratValue = double.tryParse(carats) ?? 0;
                double rateValue = double.tryParse(rate) ?? 0;
                amount = (caratValue * rateValue).toStringAsFixed(0);
              }

              // Format stone details with the correct pattern
              String stoneDetails =
                  '$stoneName $pieces ${carats}ct X $rate=$amount';

              // The key change: Use a custom widget instead of _buildTableCell
              rows.add(
                pw.TableRow(
                  children: [
                    _buildTableCell('', font),
                    // Use custom cell that prevents line wrapping
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(0),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              stoneDetails,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 8,
                                color: PdfColors.grey600,
                              ),
                              // overflow: pw.TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // _buildTableCell('$amount', font),
                    ...List.generate(8, (_) => _buildTableCell('', font)),
                  ],
                ),
              );
            } catch (e) {
              // Fallback in case of error
              rows.add(
                pw.TableRow(
                  children: [
                    _buildTableCell('', font),
                    _buildTableCell('STONE', font, color: PdfColors.grey600),
                    ...List.generate(8, (_) => _buildTableCell('', font)),
                  ],
                ),
              );
            }
          }
        }
      }
    }
    // Add a divider row before totals
    rows.add(
      pw.TableRow(
        children: [
          _buildTableCell('', font),
          _buildTableCell('', font),
          _buildTableCell('', font),
          pw.Container(height: 1, color: PdfColors.grey),
          pw.Container(height: 1, color: PdfColors.grey),
          pw.Container(height: 1, color: PdfColors.grey),
          pw.Container(height: 1, color: PdfColors.grey),
          pw.Container(height: 1, color: PdfColors.grey),
          pw.Container(height: 1, color: PdfColors.grey),
          pw.Container(height: 1, color: PdfColors.grey),
        ],
      ),
    );

    num totalPieces = 0;
    double totalWeight = 0;
    double totalAmount = 0;

    // Sum up values from all line items
    for (var item in (sale.lineItems ?? [])) {
      // Handle nullable int properly with a null check
      totalPieces += (item.finalPieces ?? 1);
      totalWeight += double.tryParse(item.finalNetWeight ?? '0') ?? 0;
      totalAmount += double.tryParse(item.salesAmount ?? '0') ?? 0;
    }

    // Add Total Row
    rows.add(
      pw.TableRow(
        children: [
          _buildTableCell('', font),
          _buildTableCell('', font),
          _buildTableCell('', font),
          _buildTableCell(totalPieces.toString(), font, color: PdfColors.black),
          _buildTableCell(
            totalWeight.toStringAsFixed(3),
            font,
            color: PdfColors.black,
          ),
          _buildTableCell('', font),
          _buildTableCell('', font),
          _buildTableCell('', font),
          _buildTableCell('', font),
          _buildTableCell(
            _formatAmount(totalAmount.toString()),
            font,
            color: PdfColors.black,
            alignment: pw.TextAlign.right,
          ),
        ],
      ),
    );

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.white),
      columnWidths: {
        0: const pw.FixedColumnWidth(40), // Sl
        1: const pw.FixedColumnWidth(400), // Item Description
        2: const pw.FixedColumnWidth(70), // HSN
        3: const pw.FixedColumnWidth(45), // Pc
        4: const pw.FixedColumnWidth(100), // Wt.
        5: const pw.FixedColumnWidth(100), // V.A
        6: const pw.FixedColumnWidth(90), // M.C
        7: const pw.FixedColumnWidth(90), // Stn
        8: const pw.FixedColumnWidth(70), // Hmrk
        9: const pw.FixedColumnWidth(140), // Amount
      },
      children: rows,
    );
  }

  // Helper method to calculate the difference between net weight and gross weight
  static String _extractStoneWeight(
    GetSalesRecordByIdAggregateResponseLineItem item,
  ) {
    try {
      // Calculate the difference between net weight and gross weight
      double netWeight =
          double.tryParse(
            item.finalNetWeight ?? item.taggingNetWeight ?? '0',
          ) ??
          0;
      double grossWeight =
          double.tryParse(
            item.finalGrossWeight ?? item.taggingGrossWeight ?? '0',
          ) ??
          0;

      // The stone weight difference is gross weight - net weight
      double stoneDifference = grossWeight - netWeight;

      // Ensure the difference is not negative
      stoneDifference = stoneDifference.abs();

      return stoneDifference.toStringAsFixed(3);
    } catch (e) {
      return '0.000';
    }
  }

  // Helper method to check if stone cost is valid and greater than 0
  static bool _hasValidStoneCost(
    GetSalesRecordByIdAggregateResponseLineItem item,
  ) {
    if (item.stoneCost == null || item.stoneCost!.isEmpty) {
      return false;
    }
    final stoneCost = double.tryParse(item.stoneCost!) ?? 0;
    return stoneCost > 0;
  }

  static pw.Widget _buildOldGoldTable(
    GetSalesRecordByIdAggregateResponse sale,
    pw.Font font,
  ) {
    // Safety check for old gold data
    if (sale.oldGolds == null || sale.oldGolds!.isEmpty) {
      return pw.Container(); // Return empty container if no old gold data
    }

    // Calculate totals for old gold
    double totalGrossWeight = 0.0;
    double totalAmount = 0.0;

    // Sum up values from all old gold items
    for (var oldGold in sale.oldGolds!) {
      totalGrossWeight += double.tryParse(oldGold.grossWeight ?? '0') ?? 0;
      totalAmount += double.tryParse(oldGold.amount ?? '0') ?? 0;
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'OLD PURCHASE-Bill.${sale.purchaseInvoiceNumber ?? ""}',
          style: pw.TextStyle(font: font, fontSize: 9),
        ),
        pw.SizedBox(height: 4),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.white),
          columnWidths: {
            0: const pw.FixedColumnWidth(80), // Item
            1: const pw.FixedColumnWidth(50), // Wt.
            2: const pw.FixedColumnWidth(50), // Dust
            3: const pw.FixedColumnWidth(50), // Wst.
            4: const pw.FixedColumnWidth(50), // Rate
            5: const pw.FixedColumnWidth(30), // +/-
            6: const pw.FixedColumnWidth(70), // Amount
          },
          children: [
            // Header Row
            pw.TableRow(
              children:
                  [
                    'Item',
                    'Gr.Wt.',
                    'Dust',
                    'Wst.',
                    'Rate',
                    '+/-',
                    'Amount',
                  ].map((text) => _buildTableCell(text, font)).toList(),
            ),
            // Old Gold Entries
            ...sale.oldGolds!.map((oldGold) {
              // Get description or default to 'OLD GOLD'
              final description = oldGold.description ?? 'OLD GOLD';

              // Get net weight
              final weight = oldGold.grossWeight ?? '0';

              // Get rate
              final rate = oldGold.rate ?? '0';

              // Get purity type
              final purity = "${oldGold.purity}%";

              // Get amount directly
              final amount = oldGold.amount ?? '0';
              final roundoff = oldGold.roundOff ?? "0";

              // Build table row
              return pw.TableRow(
                children: [
                  _buildTableCell(description, font),
                  _buildTableCell(weight, font),
                  _buildTableCell(oldGold.less ?? '0.00', font),
                  _buildTableCell(purity, font),
                  _buildTableCell(rate, font),
                  _buildTableCell(roundoff, font),
                  _buildTableCell(_formatAmount(amount), font),
                ],
              );
            }),
            // Add a divider row before totals
            pw.TableRow(
              children: [
                pw.Container(height: 1, color: PdfColors.grey),
                pw.Container(height: 1, color: PdfColors.grey),
                pw.Container(height: 1, color: PdfColors.grey),
                pw.Container(height: 1, color: PdfColors.grey),
                pw.Container(height: 1, color: PdfColors.grey),
                pw.Container(height: 1, color: PdfColors.grey),
                pw.Container(height: 1, color: PdfColors.grey),
              ],
            ),
            // Total Row
            pw.TableRow(
              children: [
                _buildTableCell('Total', font, color: PdfColors.black),
                _buildTableCell(
                  totalGrossWeight.toStringAsFixed(3),
                  font,
                  color: PdfColors.black,
                ),
                _buildTableCell('', font),
                _buildTableCell('', font),
                _buildTableCell('', font),
                _buildTableCell('', font),
                _buildTableCell(
                  _formatAmount(totalAmount.toString()),
                  font,
                  color: PdfColors.black,
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
      ],
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

  static pw.Widget _buildPrePaymentDetails(
    PaymentDetail payment,
    pw.Font font,
  ) {
    final cgstValue = double.tryParse(payment.cgst ?? '0') ?? 0;
    final sgstValue = double.tryParse(payment.sgst ?? '0') ?? 0;
    final showIGST = cgstValue == 0 && sgstValue == 0;

    final oldGoldValue = double.tryParse(payment.purchaseOldGold ?? '0') ?? 0;
    final showOldGold = oldGoldValue > 0 && payment.purchaseOldGold != '0.00';

    final roundOffValue = double.tryParse(payment.roundOff ?? '0') ?? 0;
    final showRoundOff = roundOffValue != 0 && payment.roundOff != '0.00';

    return pw.Container(
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          if (!showIGST) ...[
            _buildRightAlignedAmountRow(
              'CGST 1.5%:',
              payment.cgst ?? '0',
              font,
            ),
            _buildRightAlignedAmountRow(
              'SGST 1.5%:',
              payment.sgst ?? '0',
              font,
            ),
          ],
          if (showIGST)
            _buildRightAlignedAmountRow('IGST 3%:', payment.igst ?? '0', font),
          _buildRightAlignedAmountRow('Nett:', payment.nettTdsTcs ?? '0', font),
          if (showRoundOff)
            _buildRightAlignedAmountRow(
              'Round Off:',
              payment.roundOff ?? '0',
              font,
            ),
          if (!showOldGold)
            _buildRightAlignedAmountRow(
              'Received:',
              payment.receivedAmount ?? '0',
              font,
            ),

          // _buildRightAlignedAmountRow(
          //     'Rcvd:', payment.receivedAmount ?? '0', font),
        ],
      ),
    );
  }

  static pw.Widget _buildDynamicGrid(List<String> items, pw.Font font) {
    const int itemsPerRow = 3;
    List<pw.Widget> rows = [];

    for (int i = 0; i < items.length; i += itemsPerRow) {
      final chunk = items.sublist(
        i,
        (i + itemsPerRow > items.length) ? items.length : i + itemsPerRow,
      );

      rows.add(
        pw.Row(
          children:
              chunk
                  .map(
                    (item) => pw.Expanded(
                      child: pw.Text(
                        item,
                        style: pw.TextStyle(font: font, fontSize: 7.5),
                      ),
                    ),
                  )
                  .toList(),
        ),
      );

      rows.add(pw.SizedBox(height: 1));
    }

    return pw.Column(children: rows);
  }

  static pw.Widget _buildPaymentDetails(PaymentDetail payment, pw.Font font) {
    final oldGoldValue = double.tryParse(payment.purchaseOldGold ?? '0') ?? 0;
    final balanceValue = double.tryParse(payment.balanceAmount ?? '0') ?? 0;

    final showOldGold = oldGoldValue > 0 && payment.purchaseOldGold != '0.00';
    final showBalance = balanceValue > 0 && payment.balanceAmount != '0.00';

    return pw.Container(
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          if (showOldGold)
            _buildRightAlignedAmountRow(
              'Old Purchase:',
              payment.purchaseOldGold ?? '0',
              font,
            ),
          if (showOldGold)
            _buildRightAlignedAmountRow(
              'Nett:',
              payment.finalAmount ?? '0',
              font,
            ),
          if (showOldGold)
            _buildRightAlignedAmountRow(
              'Received:',
              payment.receivedAmount ?? '0',
              font,
            ),
          if (showBalance)
            _buildRightAlignedAmountRow(
              'Balance:',
              payment.balanceAmount ?? '0',
              font,
            ),
        ],
      ),
    );
  }

  // New helper method that creates properly right-aligned rows like in the reference image
  static pw.Widget _buildRightAlignedAmountRow(
    String label,
    String amount,
    pw.Font font,
  ) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10)),
        pw.SizedBox(width: 16), // Fixed spacing between label and amount
        pw.SizedBox(
          width:
              100, // Fixed width for the amount, ensures consistent alignment
          child: pw.Text(
            _formatAmount(amount),
            style: pw.TextStyle(font: font, fontSize: 10),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
