// import 'dart:typed_data';
// import 'package:pdf/pdf.dart' show PdfColors, PdfPageFormat;
// import 'package:pdf/widgets.dart' as pw;
// import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_listing_paginated_response.dart';
// import 'package:printing/printing.dart';

// class InvoiceTemplate {
//   final String companyName;
//   final String companyTagline;
//   final String invoiceTitle;
//   final String stateCode;
//   final String gstPrefix;
//   final String footerText;
//   final String address;
//   final String phone;
//   final String email;
//   final String currency;

//   InvoiceTemplate({
//     this.companyName = 'Sumangali Jewellers',
//     this.companyTagline = 'GOLD | DIAMOND | PLATINUM | SILVER',
//     this.invoiceTitle = 'TAX INVOICE-GOLD SALES',
//     this.stateCode = 'TAMILNADU CODE:33',
//     this.gstPrefix = 'GST:',
//     this.footerText = '** Goods Delivered At Our Premises **',
//     this.address = 'Bazaar Street, Pallipet - 631 207,\nTiruvallur Dist. (TN)',
//     this.phone = '044 2784 3251',
//     this.email = 'sumangali.accts@gmail.com',
//     this.currency = '₹',
//   });
// }

// class SalesInvoicePdfGenerator {
//   static final defaultTemplate = InvoiceTemplate();

//   static Future<Uint8List> generateInvoice(
//     GetSalesPaginatedResponseValue sale, {
//     InvoiceTemplate? template,
//   }) async {
//     template ??= defaultTemplate;
//     final pdf = pw.Document();

//   final font = await PdfGoogleFonts.courierPrimeRegular();
//   final boldFont = await PdfGoogleFonts.courierPrimeBold();

//     // // Create logo with proper sizing
//     // final logo = pw.Container(
//     //   width: 40,
//     //   height: 40,
//     //   child: pw.Center(
//     //     child: pw.Text(
//     //       'S',
//     //       style: pw.TextStyle(
//     //         font: boldFont,
//     //         color: PdfColors.amber,
//     //         fontSize: 24,
//     //       ),
//     //     ),
//     //   ),
//     // );

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(50),
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               // Header Section with proper width
//               // pw.Container(
//               //   width: double.infinity,
//               //   padding:
//               //       const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               //   decoration: pw.BoxDecoration(
//               //     color: PdfColors.purple900,
//               //     borderRadius: pw.BorderRadius.circular(8),
//               //   ),
//               //   child: pw.Row(
//               //     children: [
//               //       logo,
//               //       pw.SizedBox(width: 10),
//               //       pw.Expanded(
//               //         child: pw.Column(
//               //           crossAxisAlignment: pw.CrossAxisAlignment.start,
//               //           children: [
//               //             pw.Text(
//               //               template!.companyName,
//               //               style: pw.TextStyle(
//               //                 font: boldFont,
//               //                 color: PdfColors.amber,
//               //                 fontSize: 20,
//               //               ),
//               //             ),
//               //             pw.Text(
//               //               template.companyTagline,
//               //               style: pw.TextStyle(
//               //                 font: font,
//               //                 color: PdfColors.white,
//               //                 fontSize: 10,
//               //               ),
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),

//               pw.SizedBox(height: 20),

//               // Invoice Title
//               pw.Text(
//                 template!.invoiceTitle,
//                 style: pw.TextStyle(
//                   font: boldFont,
//                   fontSize: 16,
//                 ),
//               ),

//               pw.SizedBox(height: 20),

//               // Customer Details with proper spacing
//               pw.Container(
//                 width: double.infinity,
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border.all(color: PdfColors.grey300),
//                   borderRadius: pw.BorderRadius.circular(4),
//                 ),
//                 padding: const pw.EdgeInsets.all(10),
//                 child: pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text('Name : ${sale.name}',
//                             style: pw.TextStyle(font: font, fontSize: 10)),

//                             //  pw.Text('Address : ${sale.}',
//                             // style: pw.TextStyle(font: font, fontSize: 10)),
//                         // pw.Text(
//                         //     '${template.stateCode} (${template.gstPrefix}${sale.id})',
//                         //     style: pw.TextStyle(font: font, fontSize: 10)),
//                       ],
//                     ),
//                     pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.end,
//                       children: [
//                         pw.Text('No. : ${sale.salesNumber}',
//                             style: pw.TextStyle(font: font, fontSize: 10)),
//                         pw.Text('Date : ${_formatDate(sale.createdAt)}',
//                             style: pw.TextStyle(font: font, fontSize: 10)),
//                         pw.Text(
//                             'Rate : ${template.currency}${_formatAmount(sale.invoiceAmount)}',
//                             style: pw.TextStyle(font: font, fontSize: 10)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               pw.SizedBox(height: 20),

//               // Items Table with fixed column widths
//               pw.Table(
//                 border: pw.TableBorder.all(color: PdfColors.grey300),
//                 columnWidths: {
//                   0: const pw.FixedColumnWidth(30), // Sl
//                   1: const pw.FixedColumnWidth(150), // Item
//                   2: const pw.FixedColumnWidth(70), // HSN
//                   3: const pw.FixedColumnWidth(40), // Pc
//                   4: const pw.FixedColumnWidth(70), // Wt.
//                   5: const pw.FixedColumnWidth(100), // Amount
//                 },
//                 children: [
//                   // Header row
//                   pw.TableRow(
//                     decoration: const pw.BoxDecoration(
//                       color: PdfColors.grey200,
//                     ),
//                     children: [
//                       'Sl',
//                       'Item',
//                       'HSN',
//                       'Pc',
//                       'Wt.',
//                       'Amount',
//                     ]
//                         .map((text) => pw.Padding(
//                               padding: const pw.EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 2),
//                               child: pw.Text(
//                                 text,
//                                 style:
//                                     pw.TextStyle(font: boldFont, fontSize: 10),
//                                 textAlign: text == 'Amount'
//                                     ? pw.TextAlign.right
//                                     : pw.TextAlign.left,
//                               ),
//                             ))
//                         .toList(),
//                   ),
//                   // Data row
//                   pw.TableRow(
//                     children: [
//                       '1',
//                       'GOLD ORNAMENTS',
//                       '711319',
//                       '1',
//                       sale.oldGoldNetWeight ?? '0.00',
//                       '${template.currency}${_formatAmount(sale.invoiceAmount)}',
//                     ]
//                         .map((text) => pw.Padding(
//                               padding: const pw.EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 2),
//                               child: pw.Text(
//                                 text,
//                                 style: pw.TextStyle(font: font, fontSize: 10),
//                                 textAlign: text.startsWith('₹')
//                                     ? pw.TextAlign.right
//                                     : pw.TextAlign.left,
//                               ),
//                             ))
//                         .toList(),
//                   ),
//                 ],
//               ),

//               pw.SizedBox(height: 20),

//               // Totals section with right alignment
//               pw.Container(
//                 width: 200,
//                 alignment: pw.Alignment.centerRight,
//                 margin: const pw.EdgeInsets.only(left: 250),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.stretch,
//                   children: [
//                     _buildTotalRow('Taxable Amount:', sale.invoiceAmount ?? '0',
//                         font, template.currency),
//                     pw.Divider(color: PdfColors.grey300),
//                     _buildTotalRow(
//                         'CGST 1.5%:',
//                         _calculateGST(sale.invoiceAmount),
//                         font,
//                         template.currency),
//                     _buildTotalRow(
//                         'SGST 1.5%:',
//                         _calculateGST(sale.invoiceAmount),
//                         font,
//                         template.currency),
//                     pw.Divider(color: PdfColors.grey300),
//                     _buildTotalRow('Nett:', sale.invoiceAmount ?? '0', boldFont,
//                         template.currency),
//                     _buildTotalRow('Balance:', sale.invoiceAmount ?? '0',
//                         boldFont, template.currency),
//                   ],
//                 ),
//               ),

//               pw.Spacer(),

//               // Footer section
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text('E.& O.E',
//                       style: pw.TextStyle(font: font, fontSize: 10)),
//                   pw.Text(template.footerText,
//                       style: pw.TextStyle(font: font, fontSize: 10)),
//                   pw.Text('Authorized Sign.',
//                       style: pw.TextStyle(font: font, fontSize: 10)),
//                 ],
//               ),

//               pw.SizedBox(height: 20),

//               // Contact information footer
//               // pw.Container(
//               //   width: double.infinity,
//               //   padding:
//               //       const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               //   decoration: pw.BoxDecoration(
//               //     color: PdfColors.purple900,
//               //     borderRadius: pw.BorderRadius.circular(8),
//               //   ),
//               //   child: pw.Row(
//               //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               //     children: [
//               //       pw.Expanded(
//               //         flex: 2,
//               //         child: pw.Text(template.address,
//               //             style: pw.TextStyle(
//               //                 font: font,
//               //                 color: PdfColors.white,
//               //                 fontSize: 10)),
//               //       ),
//               //       pw.Expanded(
//               //         flex: 1,
//               //         child: pw.Text(template.phone,
//               //             style: pw.TextStyle(
//               //                 font: font, color: PdfColors.white, fontSize: 10),
//               //             textAlign: pw.TextAlign.center),
//               //       ),
//               //       pw.Expanded(
//               //         flex: 1,
//               //         child: pw.Text(template.email,
//               //             style: pw.TextStyle(
//               //                 font: font, color: PdfColors.white, fontSize: 10),
//               //             textAlign: pw.TextAlign.right),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//             ],
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }

//   static pw.Widget _buildTotalRow(
//       String label, String amount, pw.Font font, String currency) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 2),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10)),
//           pw.Text('$currency${_formatAmount(amount)}',
//               style: pw.TextStyle(font: font, fontSize: 10)),
//         ],
//       ),
//     );
//   }
//   // static pw.Widget _buildItemsTable(
//   //   GetSalesPaginatedResponseValue sale,
//   //   pw.Font font,
//   //   pw.Font boldFont,
//   //   String currency,
//   // ) {
//   //   return pw.Table(
//   //     border: pw.TableBorder.all(color: PdfColors.grey400),
//   //     columnWidths: {
//   //       0: const pw.FlexColumnWidth(0.5),  // Sl
//   //       1: const pw.FlexColumnWidth(2.5),  // Item
//   //       2: const pw.FlexColumnWidth(1),    // HSN
//   //       3: const pw.FlexColumnWidth(0.5),  // Pc
//   //       4: const pw.FlexColumnWidth(1),    // Wt.
//   //       5: const pw.FlexColumnWidth(1.5),  // Amount
//   //     },
//   //     children: [
//   //       pw.TableRow(
//   //         decoration: const pw.BoxDecoration(color: PdfColors.grey200),
//   //         children: [
//   //           'Sl',
//   //           'Item',
//   //           'HSN',
//   //           'Pc',
//   //           'Wt.',
//   //           'Amount',
//   //         ].map((text) => pw.Padding(
//   //           padding: const pw.EdgeInsets.all(5),
//   //           child: pw.Text(text, style: pw.TextStyle(font: boldFont)),
//   //         )).toList(),
//   //       ),
//   //       pw.TableRow(
//   //         children: [
//   //           '1',
//   //           'GOLD ORNAMENTS',
//   //           '711319',
//   //           '1',
//   //           sale.oldGoldNetWeight ?? '-',
//   //           '$currency${_formatAmount(sale.invoiceAmount)}',
//   //         ].map((text) => pw.Padding(
//   //           padding: const pw.EdgeInsets.all(5),
//   //           child: pw.Text(text, style: pw.TextStyle(font: font)),
//   //         )).toList(),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // static pw.Widget _buildTotals(
//   //   GetSalesPaginatedResponseValue sale,
//   //   pw.Font font,
//   //   pw.Font boldFont,
//   //   String currency,
//   // ) {
//   //   final amount = double.tryParse(sale.invoiceAmount ?? '0') ?? 0;
//   //   return pw.Container(
//   //     alignment: pw.Alignment.centerRight,
//   //     child: pw.Column(
//   //       crossAxisAlignment: pw.CrossAxisAlignment.end,
//   //       children: [
//   //         pw.Row(
//   //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             pw.Text('Taxable Amount:', style: pw.TextStyle(font: font)),
//   //             pw.Text('$currency${_formatAmount(amount.toString())}',
//   //                 style: pw.TextStyle(font: font)),
//   //           ],
//   //         ),
//   //         pw.Divider(color: PdfColors.grey400),
//   //         pw.Row(
//   //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             pw.Text('CGST 1.5%:', style: pw.TextStyle(font: font)),
//   //             pw.Text('$currency${_calculateGST(sale.invoiceAmount)}',
//   //                 style: pw.TextStyle(font: font)),
//   //           ],
//   //         ),
//   //         pw.Row(
//   //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             pw.Text('SGST 1.5%:', style: pw.TextStyle(font: font)),
//   //             pw.Text('$currency${_calculateGST(sale.invoiceAmount)}',
//   //                 style: pw.TextStyle(font: font)),
//   //           ],
//   //         ),
//   //         pw.Divider(color: PdfColors.grey400),
//   //         pw.Row(
//   //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             pw.Text('Nett:', style: pw.TextStyle(font: boldFont)),
//   //             pw.Text('$currency${_formatAmount(sale.invoiceAmount)}',
//   //                 style: pw.TextStyle(font: boldFont)),
//   //           ],
//   //         ),
//   //         pw.Row(
//   //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             pw.Text('Balance:', style: pw.TextStyle(font: boldFont)),
//   //             pw.Text('$currency${_formatAmount(sale.invoiceAmount)}',
//   //                 style: pw.TextStyle(font: boldFont)),
//   //           ],
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // static pw.Widget _buildFooter(InvoiceTemplate template, pw.Font font) {
//   //   return pw.Column(
//   //     children: [
//   //       pw.Row(
//   //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //         children: [
//   //           pw.Text('E.& O.E', style: pw.TextStyle(font: font)),
//   //           pw.Text(template.footerText, style: pw.TextStyle(font: font)),
//   //           pw.Text('Authorized Sign.', style: pw.TextStyle(font: font)),
//   //         ],
//   //       ),
//   //       pw.SizedBox(height: 20),
//   //       pw.Container(
//   //         padding: const pw.EdgeInsets.all(10),
//   //         decoration: const pw.BoxDecoration(
//   //           color: PdfColors.purple900,
//   //           borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
//   //         ),
//   //         child: pw.Row(
//   //           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             pw.Text(template.address,
//   //                 style: pw.TextStyle(font: font, color: PdfColors.white)),
//   //             pw.Text(template.phone,
//   //                 style: pw.TextStyle(font: font, color: PdfColors.white)),
//   //             pw.Text(template.email,
//   //                 style: pw.TextStyle(font: font, color: PdfColors.white)),
//   //           ],
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   static String _formatDate(DateTime? date) {
//     if (date == null) return '-';
//     return '${date.day}-${date.month}-${date.year}';
//   }

//   static String _formatAmount(String? amount) {
//     if (amount == null) return '0.00';
//     final value = double.tryParse(amount) ?? 0;
//     return value.toStringAsFixed(2);
//   }

//   static String _calculateGST(String? amount) {
//     if (amount == null) return '0.00';
//     final double amt = double.tryParse(amount) ?? 0;
//     return (amt * 0.015).toStringAsFixed(2);
//   }
// }
