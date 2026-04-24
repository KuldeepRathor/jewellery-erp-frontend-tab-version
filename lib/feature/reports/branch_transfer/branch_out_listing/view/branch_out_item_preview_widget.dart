// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch/model/branch_out_report_model.dart'
//     as model;
// import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch/view_model/branch_report_view_model.dart';

// class BranchOutItemPreviewWidget extends GetView<BranchReportViewModel> {
//   const BranchOutItemPreviewWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BranchReportViewModel>(
//       builder: (_) {
//         if (controller.selectedLineItem?.isEmpty ?? true) {
//           return const SizedBox.shrink();
//         }
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Obx(() {
//               return SizedBox(
//                 width: MediaQuery.of(context).size.width / 1.4,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: controller.selectedLineItem?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     final lineItem = controller.selectedLineItem?[index];
//                     if (lineItem == null) return const SizedBox.shrink();

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 16),
//                       child: Card(
//                         color: Colors.white,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Item ${index + 1}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               _buildLineItemDetails(lineItem),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildLineItemDetails(model.LineItem lineItem) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildDetailRow('Tag Number', lineItem.tagNumber?.toString() ?? '-'),
//         const SizedBox(height: 8),
//         _buildDetailRow('Code', lineItem.code ?? '-'),
//         const SizedBox(height: 8),
//         _buildDetailRow('Tag Barcode', lineItem.tagBarcode ?? '-'),
//         const SizedBox(height: 8),
//         _buildDetailRow('Code Type', lineItem.codeType ?? '-'),
//         const SizedBox(height: 8),
//         _buildDetailRow('Pieces', lineItem.pieces?.toString() ?? '-'),
//         const SizedBox(height: 8),
//         _buildDetailRow('Status', lineItem.status ?? '-'),
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF4758EC),
//           ),
//         ),
//       ],
//     );
//   }
// }
