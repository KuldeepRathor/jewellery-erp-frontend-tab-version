// import 'package:flutter/material.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/payment_method_detail_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

// class ExpandablePaymentMethodDetailsWidget extends StatefulWidget {
//   final List<PaymentMethodDetail> paymentMethodDetails;

//   const ExpandablePaymentMethodDetailsWidget({
//     super.key,
//     required this.paymentMethodDetails,
//   });

//   @override
//   ExpandablePaymentMethodDetailsWidgetState createState() =>
//       ExpandablePaymentMethodDetailsWidgetState();
// }

// class ExpandablePaymentMethodDetailsWidgetState
//     extends State<ExpandablePaymentMethodDetailsWidget> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       right: 16,
//       bottom: 16, // Positioned above payment details
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         height: _isExpanded ? 300 : 56, // Adjust height as needed
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
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _isExpanded = !_isExpanded;
//                 });
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Payment Method Details',
//                       style: TextStyle(fontWeight: FontWeight.w700),
//                     ),
//                     Text(
//                       _isExpanded ? 'Hide -' : 'View +',
//                       style: TextStyle(
//                         color: _isExpanded ? redTextColor : primaryColor,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (_isExpanded) ...[
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         // Header Row
//                         const Padding(
//                           padding: EdgeInsets.only(bottom: 8),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                   'Method',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                   'Amount',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                   'Date',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const CustomDashedLineWidget(width: double.infinity),
//                         const SizedBox(height: 8),
//                         ...widget.paymentMethodDetails.map((detail) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     detail.method ?? '-',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     detail.amount ?? '-',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     detail.date != null
//                                         ? convertDateTimeToString(detail.date)
//                                         : '-',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
