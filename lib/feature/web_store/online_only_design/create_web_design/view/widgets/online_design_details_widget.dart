// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_settings_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/get_stock_head_dropdown_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view/widgets/rich_text_editor_field.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view_model/online_only_design_details_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

// class OnlineDesignDetailsWidget extends StatefulWidget {
//   final bool isEditMode;

//   const OnlineDesignDetailsWidget({super.key, this.isEditMode = false});

//   @override
//   State<OnlineDesignDetailsWidget> createState() =>
//       _OnlineDesignDetailsWidgetState();
// }

// class _OnlineDesignDetailsWidgetState extends State<OnlineDesignDetailsWidget> {
//   // final controller = Get.find<OnlineOnlyDesignDetailsController>();
//   final designSettingsController = Get.find<DesignSettingsController>();

//   @override
//   void initState() {
//     super.initState();

//     // Only fetch ornaments and stock heads if not in edit mode
//     if (!widget.isEditMode) {
//       controller.fetchOrnaments();
//       controller.getStockHeadListingDetails(query: "");
//     }

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.designNameFocusNode.requestFocus();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Focus(
//       canRequestFocus: false,
//       onKeyEvent:
//           (node, event) => onNormalKeyEvent(node, event, [
//             controller.designNameFocusNode,
//             if (!widget.isEditMode) controller.metalServiceTypeFocusNode,
//             if (!widget.isEditMode) controller.stockHeadFocusNode,
//             controller.descriptionFocusNode,
//           ]),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: ShapeDecoration(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             side: const BorderSide(
//               width: 1,
//               strokeAlign: BorderSide.strokeAlignOutside,
//               color: Color(0xFFE5E5E5),
//             ),
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         child: Form(
//           key: controller.formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Details',
//                 style: TextStyle(
//                   color: Color(0xFF111111),
//                   fontSize: 16,
//                   fontFamily: 'Satoshi',
//                   fontWeight: FontWeight.w700,
//                   height: 0,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: CustomTextField(
//                       name: "Title",
//                       autofocus: true,
//                       isRequired: true,
//                       controller: controller.titleNameController,
//                       focusNode: controller.designNameFocusNode,
//                       onEditingComplete: () {
//                         if (!widget.isEditMode) {
//                           controller.metalServiceTypeFocusNode.requestFocus();
//                         } else {
//                           controller.descriptionFocusNode.requestFocus();
//                         }
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Enter Title";
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     flex: 1,
//                     child:
//                         widget.isEditMode
//                             ? CustomTextField(
//                               name: "Ornament Type",
//                               enabled: false,
//                               controller: controller.metalController,
//                             )
//                             : Column(
//                               children: [
//                                 const Row(
//                                   children: [
//                                     CustomText(
//                                       text: 'Ornament Type',
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 12,
//                                     ),
//                                     Text(
//                                       ' *',
//                                       style: TextStyle(
//                                         color: Colors.red,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Obx(
//                                   () => GenericAutocompleteDropdown<
//                                     GetAllOrnamentsResponseValue
//                                   >(
//                                     controller: TextEditingController(
//                                       text:
//                                           controller
//                                               .selectedOrnament
//                                               .value
//                                               ?.name ??
//                                           '',
//                                     ),
//                                     focusNode:
//                                         controller.metalServiceTypeFocusNode,
//                                     items: controller.ornamentsList,
//                                     getDisplayValue:
//                                         (
//                                           GetAllOrnamentsResponseValue ornament,
//                                         ) => ornament.name ?? "",
//                                     maxWidthForOptions:
//                                         DROPDOWN_OPTIONS_MAX_WIDTH,
//                                     onSelected: (
//                                       GetAllOrnamentsResponseValue value,
//                                     ) {
//                                       controller.setSelectedOrnament(value);
//                                       // Move focus to stock head dropdown
//                                       controller.stockHeadFocusNode
//                                           .requestFocus();
//                                     },
//                                     isLastRow: true,
//                                     padding: const EdgeInsets.only(top: 8),
//                                     fieldHeight: 38.0,
//                                     borderColor: secondaryColor,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Ornament Type is required';
//                                       }
//                                       return null;
//                                     },
//                                     keyboardType: TextInputType.text,
//                                     onEditingComplete: () {
//                                       // This will be handled by onSelected
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     flex: 1,
//                     child:
//                         widget.isEditMode
//                             ? CustomTextField(
//                               name: "Stock Head",
//                               enabled: false,
//                               controller: controller.stockHeadController,
//                             )
//                             : Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Row(
//                                   children: [
//                                     CustomText(
//                                       text: "Stock Head",
//                                       color: blackColor,
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 12,
//                                     ),
//                                     Text(
//                                       ' *',
//                                       style: TextStyle(
//                                         color: Colors.red,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Obx(() {
//                                   return GenericAutocompleteDropdown<
//                                     GetStockHeadDropdownValue
//                                   >(
//                                     controller: TextEditingController(
//                                       text:
//                                           controller
//                                               .selectedStockHead
//                                               .value
//                                               ?.name ??
//                                           '',
//                                     ),
//                                     focusNode: controller.stockHeadFocusNode,
//                                     padding: const EdgeInsets.only(top: 8),
//                                     items:
//                                         controller
//                                             .getStockHeadListingResponse
//                                             .value
//                                             .data
//                                             ?.values ??
//                                         [],
//                                     maxWidthForOptions:
//                                         DROPDOWN_OPTIONS_MAX_WIDTH,
//                                     getDisplayValue:
//                                         (GetStockHeadDropdownValue head) =>
//                                             head.name ?? '',
//                                     onSelected: (
//                                       GetStockHeadDropdownValue value,
//                                     ) {
//                                       controller.setStockHead(value.id ?? '');
//                                       controller.descriptionFocusNode
//                                           .requestFocus();
//                                     },
//                                     isLastRow: true,
//                                     fieldHeight: 38.0,
//                                     maxHeight: 150.0,
//                                     borderColor: secondaryColor,
//                                     onEditingComplete: () {},
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Stock Head is required';
//                                       }
//                                       return null;
//                                     },
//                                   );
//                                 }),
//                               ],
//                             ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     flex: 1,
//                     child: CustomTextField(
//                       name: "Category",
//                       enabled: false,
//                       controller: controller.categoryController,
//                       onChanged: (value) => {},
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // Row(
//               //   children: [
//               //     Expanded(
//               //       flex: 2,
//               //       child: RichTextDescriptionField(
//               //         controller: controller,
//               //         focusNode: controller.descriptionFocusNode,
//               //         onEditingComplete: () {
//               //           // Handle editing complete if needed
//               //         },
//               //       ),
//               //     ),
//               //   ],
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
