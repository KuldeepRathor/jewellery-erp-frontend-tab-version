// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch/model/branch_in_report_model.dart'
//     as model;
// import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch/view_model/branch_report_view_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

// class BranchInItemPreviewWidget extends GetView<BranchReportViewModel> {
//   const BranchInItemPreviewWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BranchReportViewModel>(
//       builder: (_) {
//         if (controller.selectedLineItemBranchIn?.isEmpty ?? true) {
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
//                   itemCount: controller.selectedLineItemBranchIn?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     final lineItem =
//                         controller.selectedLineItemBranchIn?[index];
//                     if (lineItem == null) return const SizedBox.shrink();

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 16),
//                       child: Card(
//                         color: Colors.white,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     width: 100,
//                                     height: 100,
//                                     child: Image.network(
//                                       _getImageUrl(lineItem),
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                         return Container(
//                                           color: Colors.grey[300],
//                                           child: const Icon(
//                                               Icons.image_not_supported),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: _buildLineItemDetails(lineItem),
//                                   ),
//                                 ],
//                               ),
//                               CustomDashedLineWidget(width: Get.width),
//                               const SizedBox(height: 8),
//                               if (lineItem.lineStones != null &&
//                                   lineItem.lineStones!.isNotEmpty)
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(
//                                       width: 100,
//                                       height: 100,
//                                       child: Image.network(
//                                         _getImageUrl(lineItem),
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) {
//                                           return Container(
//                                             color: Colors.grey[300],
//                                             child: const Icon(
//                                                 Icons.image_not_supported),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Expanded(
//                                       child: _buildStoneDetails(
//                                         lineItem.lineStones ?? [],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
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

//   String _getImageUrl(model.ValueLineItem lineItem) {
//     if (lineItem.design?.images != null &&
//         lineItem.design!.images!.isNotEmpty &&
//         lineItem.design!.images!.first.presignedUrl != null) {
//       return lineItem.design!.images!.first.presignedUrl!;
//     }
//     return 'https://via.placeholder.com/100';
//   }

//   Widget _buildStoneDetails(List<model.LineStone> stones) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 4),
//         const Text(
//           "Stone Details",
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 4),
//         ...stones.map((stone) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   children: [
//                     const SizedBox(height: 4),
//                     const Text(
//                       'Stone Name',
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       stone.name ?? "-",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4758EC),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     const SizedBox(height: 4),
//                     const Text(
//                       'Pcs',
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       stone.pieces?.toString() ?? "-",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4758EC),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     const SizedBox(height: 4),
//                     const Text(
//                       'Carat / Weight',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       stone.carat ?? "-",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4758EC),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Column(
//                   children: [
//                     SizedBox(height: 4),
//                     Text(
//                       'Size',
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "-",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4758EC),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     const SizedBox(height: 4),
//                     const Text(
//                       'Rate',
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       stone.rate ?? "-",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4758EC),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     const SizedBox(height: 4),
//                     const Text(
//                       'Total',
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       stone.total ?? "-",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4758EC),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildLineItemDetails(model.ValueLineItem lineItem) {
//     final details = [
//       {"title": "Item Name / Design", "value": lineItem.design?.name ?? "-"},
//       {"title": "PCs", "value": lineItem.pieces?.toString() ?? "-"},
//       {"title": "Size", "value": lineItem.sizeGroup?.size ?? "-"},
//       {
//         "title": "Wast",
//         "value": lineItem.design?.lineItems?.isNotEmpty == true
//             ? (lineItem.design!.lineItems!.first.wastage ?? "-")
//             : "-"
//       },
//       {"title": "Mc", "value": lineItem.mc ?? "-"},
//       {"title": "Stock", "value": lineItem.status ?? "-"},
//     ];

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         ...details.map(
//           (detail) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const SizedBox(height: 4),
//                   Text(
//                     detail['title'] ?? "",
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     detail['value'] ?? "-",
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF4758EC),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
