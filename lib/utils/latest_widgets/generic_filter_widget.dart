// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items_report/view/widgets/tagged_item_report_basic_filter_widget.dart';
// import 'package:svg_flutter/svg_flutter.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_checkbox_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

// class GenericFilterWidget extends StatefulWidget {
//   final String label;
//   final List<DropdownItem> items;
//   final List<DropdownItem> selectedItems;
//   final Function(DropdownItem) onItemSelected;
//   final VoidCallback onSubmit;
//   final String? iconAsset;

//   const GenericFilterWidget({
//     super.key,
//     required this.label,
//     required this.items,
//     required this.selectedItems,
//     required this.onItemSelected,
//     required this.onSubmit,
//     this.iconAsset = 'assets/svgs/filter.svg',
//   });

//   @override
//   State<GenericFilterWidget> createState() => _GenericFilterWidgetState();
// }

// class _GenericFilterWidgetState extends State<GenericFilterWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Close Header
//           Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x1428328B),
//                   blurRadius: 12,
//                   offset: Offset(0, 2),
//                   spreadRadius: 1,
//                 )
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 focusColor: Colors.grey.shade300,
//                 onTap: () => Get.back(),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   topRight: Radius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         widget.iconAsset!,
//                         // ignore: deprecated_member_use
//                         color: redTextColor,
//                       ),
//                       const SizedBox(width: 8),
//                       const CustomText(
//                         text: "Close",
//                         color: redTextColor,
//                         fontSize: 14,
//                         fontFamily: 'Satoshi',
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Filter Content
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 16),
//                 Text(
//                   widget.label,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Wrap(
//                   spacing: 16,
//                   runSpacing: 8,
//                   children: widget.items.map((item) {
//                     return Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CustomCheckBoxWidget(
//                           value: widget.selectedItems.contains(item),
//                           onChanged: (value) {
//                             widget.onItemSelected(item);

//                             setState(() {});
//                           },
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           item.name!,
//                           style: const TextStyle(
//                             color: primaryColor,
//                             fontSize: 16,
//                             fontFamily: 'Satoshi',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 16),
//                 CustomButton1(
//                   buttonName: "Submit",
//                   onTap: widget.onSubmit,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
