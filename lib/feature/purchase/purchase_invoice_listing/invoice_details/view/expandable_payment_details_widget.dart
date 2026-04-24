// import 'package:flutter/material.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/payment_detail_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

// class ExpandablePaymentDetailsWidget extends StatefulWidget {
//   final PaymentDetail paymentDetail;

//   const ExpandablePaymentDetailsWidget(
//       {super.key, required this.paymentDetail});

//   @override
//   ExpandablePaymentDetailsWidgetState createState() =>
//       ExpandablePaymentDetailsWidgetState();
// }

// class ExpandablePaymentDetailsWidgetState
//     extends State<ExpandablePaymentDetailsWidget> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: 16,
//       bottom: 16,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         height: _isExpanded ? 522 : 56,
//         width: 370,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _isExpanded = !_isExpanded;
//                   });
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Payment Details',
//                         style: TextStyle(fontWeight: FontWeight.w700),
//                       ),
//                       Text(
//                         _isExpanded ? 'Hide -' : 'View +',
//                         style: TextStyle(
//                           color: _isExpanded ? redTextColor : primaryColor,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               if (_isExpanded) ...[
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildDetailRow(
//                               label: 'Sub Total',
//                               value: widget.paymentDetail.subTotal ?? '-'),
//                           _buildDetailRow(
//                               label: 'Nett',
//                               value: widget.paymentDetail.nett ?? '-'),
//                           _buildDetailRow(
//                               label: 'CGST',
//                               value: widget.paymentDetail.cgst ?? '-'),
//                           _buildDetailRow(
//                               label: 'SGST',
//                               value: widget.paymentDetail.sgst ?? '-'),
//                           _buildDetailRow(
//                               label: 'IGST',
//                               value: widget.paymentDetail.igst ?? '-'),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                             child:
//                                 CustomDashedLineWidget(width: double.infinity),
//                           ),
//                           _buildDetailRow(
//                               label: 'Round Off',
//                               value: widget.paymentDetail.roundOff ?? '-'),
//                           _buildDetailRow(
//                               label: 'Total',
//                               value: widget.paymentDetail.total ?? '-'),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                             child:
//                                 CustomDashedLineWidget(width: double.infinity),
//                           ),
//                           _buildDetailRow(
//                               label: 'TCS',
//                               value: widget.paymentDetail.tcs ?? '-'),
//                           _buildDetailRow(
//                               label: 'TDS',
//                               value: widget.paymentDetail.tds ?? '-'),
//                           _buildDetailRow(
//                             label: 'Nett',
//                             value: calculateTcsTdsTotal(widget.paymentDetail),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                             child:
//                                 CustomDashedLineWidget(width: double.infinity),
//                           ),
//                           _buildDetailRow(
//                               label: 'Paid Amount',
//                               value: widget.paymentDetail.paidAmount ?? '-',
//                               textColor: primaryColor),
//                           _buildDetailRow(
//                               label: 'Balance Amount',
//                               value: widget.paymentDetail.balanceAmount ?? '-',
//                               textColor: primaryColor),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String calculateTcsTdsTotal(PaymentDetail detail) {
//     double tcsTdsTotal = 0.0;

//     tcsTdsTotal += double.tryParse(detail.tcs ?? '0') ?? 0;
//     tcsTdsTotal += double.tryParse(detail.tds ?? '0') ?? 0;

//     // Format the result to 2 decimal places
//     return tcsTdsTotal.toStringAsFixed(2);
//   }

//   Widget _buildDetailRow({
//     required String label,
//     required String value,
//     Color? textColor,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 16,
//               color: textColor,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 16,
//               color: textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
