// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/base/api_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/common_fiter_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view/reorder_level_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_listing/view_model/reorder_list_view_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items_report/view/widgets/tagged_item_report_basic_filter_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_icons_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';

// class ReorderLevelFilterWidget extends StatelessWidget {
//   final ReorderLevelViewModel controller;

//   const ReorderLevelFilterWidget({
//     super.key,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final SidebarController sidebarController = Get.find();
//     return SingleChildScrollView(
//       child: Row(
//         children: [
//           SizedBox(
//             width: getDeviceWidth(context) * 0.25,
//             child: _buildSearchField(),
//           ),
//           const SizedBox(width: 16),
//           _buildMetalFilter(),
//           const SizedBox(width: 16),
//           _buildStockHeadFilter(),
//           const SizedBox(width: 16),
//           _buildVendorFilter(),
//           const SizedBox(width: 16),
//           _buildPurityFilter(),
//           const Spacer(),
//           CustomButton2(
//             onTap: () {
//               sidebarController.navigateToWidget(
//                   newChild: const ReorderLevelPage());
//             },
//             image: 'assets/svgs/add.svg',
//             buttonName: 'New Reorder Level',
//           ),
//           // const Spacer(),
//           // CustomButton2(
//           //   backgroundColor: grey1,
//           //   textColor: primaryBtnColor,
//           //   onTap: () {},
//           //   image: 'assets/svgs/download.svg',
//           //   buttonName: 'Download',
//           // ),
//           // const SizedBox(width: 16),
//           // CustomButton2(
//           //   backgroundColor: grey1,
//           //   textColor: primaryBtnColor,
//           //   onTap: () {},
//           //   image: 'assets/svgs/print.svg',
//           //   buttonName: 'Print',
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Container(
//       height: 38,
//       decoration: BoxDecoration(
//         color: whiteColor,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: TextFormField(
//         onChanged: controller.setSearchQuery,
//         autofocus: true,
//         decoration: const InputDecoration(
//           border: InputBorder.none,
//           contentPadding:
//               EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//           hintText: 'Search',
//           hintStyle: TextStyle(color: greyTextColor),
//           suffixIcon: Icon(Icons.search, size: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildMetalFilter() {
//     return Obx(() {
//       return CommonFilterWidget(
//         menuItems: [
//           PopupMenuItem(
//             enabled: false,
//             height: 0,
//             padding: const EdgeInsets.all(0),
//             child: _buildFilterContent(
//               'Metal Types',
//               controller.designResponse.value,
//               controller.selectedMetal.value,
//               (item) {
//                 controller.setMetal(item);
//                 controller.applyFilters();
//                 Get.back();
//               },
//             ),
//           ),
//         ],
//         popupBackgroundColor: Colors.transparent,
//         offset: const Offset(0, 45),
//         elevation: 4.0,
//         borderRadius: BorderRadius.circular(8),
//         focusColor: Colors.blue.withAlpha(190),
//         child: const CustomPopUpIcon(
//           buttonName: 'Metal Types',
//           image: 'assets/svgs/filter.svg',
//         ),
//       );
//     });
//   }

//   Widget _buildStockHeadFilter() {
//     return Obx(() {
//       return CommonFilterWidget(
//         menuItems: [
//           PopupMenuItem(
//             enabled: false,
//             height: 0,
//             padding: const EdgeInsets.all(0),
//             child: _buildFilterContent(
//               'Stock Head',
//               controller.stockHeadResponse.value,
//               controller.selectedStockHead.value,
//               (item) {
//                 controller.setStockHead(item);
//                 controller.applyFilters();
//                 Get.back();
//               },
//             ),
//           ),
//         ],
//         popupBackgroundColor: Colors.transparent,
//         offset: const Offset(0, 45),
//         elevation: 4.0,
//         borderRadius: BorderRadius.circular(8),
//         focusColor: Colors.blue.withAlpha(190),
//         child: const CustomPopUpIcon(
//           buttonName: 'Stock Head',
//           image: 'assets/svgs/filter.svg',
//         ),
//       );
//     });
//   }

//   Widget _buildVendorFilter() {
//     return Obx(() {
//       return CommonFilterWidget(
//         menuItems: [
//           PopupMenuItem(
//             enabled: false,
//             height: 0,
//             padding: const EdgeInsets.all(0),
//             child: _buildFilterContent(
//               'Vendor',
//               controller.vendorResponse.value,
//               controller.selectedVendor.value,
//               (item) {
//                 controller.setVendor(item);
//                 controller.applyFilters();
//                 Get.back();
//               },
//             ),
//           ),
//         ],
//         popupBackgroundColor: Colors.transparent,
//         offset: const Offset(0, 45),
//         elevation: 4.0,
//         borderRadius: BorderRadius.circular(8),
//         focusColor: Colors.blue.withAlpha(190),
//         child: const CustomPopUpIcon(
//           buttonName: 'Vendor',
//           image: 'assets/svgs/filter.svg',
//         ),
//       );
//     });
//   }

//   Widget _buildPurityFilter() {
//     return Obx(() {
//       return CommonFilterWidget(
//         menuItems: [
//           PopupMenuItem(
//             enabled: false,
//             height: 0,
//             padding: const EdgeInsets.all(0),
//             child: _buildFilterContent(
//               'Purity',
//               controller.purityResponse.value,
//               controller.selectedPurity.value,
//               (item) {
//                 controller.setPurity(item);
//                 controller.applyFilters();
//                 Get.back();
//               },
//             ),
//           ),
//         ],
//         popupBackgroundColor: Colors.transparent,
//         offset: const Offset(0, 45),
//         elevation: 4.0,
//         borderRadius: BorderRadius.circular(8),
//         focusColor: Colors.blue.withAlpha(190),
//         child: const CustomPopUpIcon(
//           buttonName: 'Purity',
//           image: 'assets/svgs/filter.svg',
//         ),
//       );
//     });
//   }

//   Widget _buildFilterContent(
//     String title,
//     ApiResponse<List<DropdownItem>> response,
//     DropdownItem? selectedItem,
//     Function(DropdownItem) onSelected,
//   ) {
//     return Container(
//       width: 300,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
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
//                 child: const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.close, color: redTextColor, size: 20),
//                       SizedBox(width: 8),
//                       Text(
//                         "Close",
//                         style: TextStyle(
//                           color: redTextColor,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 if (response.status == Status.LOADING)
//                   const Center(child: CircularProgressIndicator())
//                 else if (response.status == Status.COMPLETED)
//                   ...response.data!.map((item) => _buildFilterOption(
//                         item,
//                         selectedItem,
//                         onSelected,
//                       )),
//                 if (response.status == Status.ERROR)
//                   Center(child: Text(response.message ?? 'Error loading data')),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterOption(
//     DropdownItem item,
//     DropdownItem? selectedItem,
//     Function(DropdownItem) onSelected,
//   ) {
//     final isSelected = selectedItem?.id == item.id;
//     return InkWell(
//       onTap: () => onSelected(item),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           children: [
//             Icon(
//               isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
//               color: isSelected ? primaryColor : Colors.grey,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               item.name ?? '',
//               style: TextStyle(
//                 color: isSelected ? primaryColor : Colors.black,
//                 fontSize: 14,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
