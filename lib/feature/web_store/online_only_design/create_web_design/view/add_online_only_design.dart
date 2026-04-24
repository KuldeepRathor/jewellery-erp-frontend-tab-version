// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_settings_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view/widgets/online_design_details_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view/widgets/online_design_image_upload_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view/widgets/online_design_table_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view_model/online_only_design_details_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view_model/online_only_design_table_widget_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view_model/online_only_design_view_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/online_only_design_listing/view_model/web_only_products_view_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_footer_add_discard_remarks_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';

// class AddOnlineOnlyDesign extends StatefulWidget {
//   final String? id;
//   const AddOnlineOnlyDesign({super.key, this.id});

//   @override
//   State<AddOnlineOnlyDesign> createState() => _AddOnlineOnlyDesignState();
// }

// class _AddOnlineOnlyDesignState extends State<AddOnlineOnlyDesign> {
//   late OnlineOnlyDesignViewModel designViewModel;
//   late OnlineOnlyTableController tableMakingChargesController;
//   late OnlineOnlyDesignDetailsController designDetailsController;
//   late DesignSettingsController designSettingsController;
//   late DesignImageGalleryController designImageGalleryController;
//   bool dataPopulated = false;
//   final RemarksController remarksController = Get.find<RemarksController>();

//   @override
//   void initState() {
//     super.initState();
//     designViewModel = Get.put(OnlineOnlyDesignViewModel());
//     tableMakingChargesController = Get.put(OnlineOnlyTableController());
//     designDetailsController = Get.put(OnlineOnlyDesignDetailsController());
//     designSettingsController = Get.put(DesignSettingsController());
//     designImageGalleryController = Get.put(DesignImageGalleryController());
//     _clearAllControllers();

//     tableMakingChargesController.addRow();

//     if (widget.id != null) {
//       _loadWebstoreStockData();
//     }
//   }

//   void _loadWebstoreStockData() {
//     designViewModel.getWebstoreStockById(
//       id: widget.id!,
//       tableMakingChargesController: tableMakingChargesController,
//       designDetailsController: designDetailsController,
//       designImageGalleryController: designImageGalleryController,
//     );
//   }

//   int counter = 0;

//   @override
//   Widget build(BuildContext context) {
//     log("build called $counter");
//     counter++;

//     return Scaffold(
//       backgroundColor: grey1,
//       body: Actions(
//         actions: <Type, Action<Intent>>{
//           SaveDesignIntent: CallbackAction<SaveDesignIntent>(
//             onInvoke: (intent) {
//               bool isLoading =
//                   designViewModel.createWebstoreStockResponse.value.status ==
//                       Status.LOADING ||
//                   designViewModel.editWebstoreStockResponse.value.status ==
//                       Status.LOADING;
//               if (!isLoading) {
//                 _handleSaveOrUpdate();
//               }
//               return;
//             },
//           ),
//           DiscardIntent: CallbackAction<DiscardIntent>(
//             onInvoke: (intent) {
//               _clearAllControllers(shouldAddRow: true);
//               setState(() {});
//               return;
//             },
//           ),
//         },
//         child: Shortcuts(
//           shortcuts: <LogicalKeySet, Intent>{
//             LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
//                 const SaveDesignIntent(),
//             LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
//                 const DiscardIntent(),
//           },
//           child: FocusScope(
//             autofocus: true,
//             child: Stack(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     HeaderWidget(
//                       header:
//                           widget.id != null
//                               ? "Edit Online Only Design"
//                               : "Add Online Only Design",
//                       wantBackButton: true,
//                       onBackButtonTap: () {
//                         SidebarController sidebarController = Get.find();
//                         log("Popping values from ");
//                         sidebarController.popBackSelectedWidget();

//                         // Ensure the controller exists and refresh with resetList: true
//                         if (Get.isRegistered<
//                           WebOnlyProductsListingController
//                         >()) {
//                           WebOnlyProductsListingController
//                           onlineDesignListingController = Get.find();
//                           onlineDesignListingController
//                               .getProductListingDetails(resetList: true);
//                         }

//                         Get.back();
//                       },
//                     ),
//                     Expanded(child: _buildContent()),
//                   ],
//                 ),
//                 Positioned(bottom: 0, left: 0, right: 0, child: _buildFooter()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContent() {
//     if (widget.id != null) {
//       return Obx(() {
//         final status =
//             designViewModel.getWebstoreStockByIdResponse.value.status;

//         switch (status) {
//           case Status.LOADING:
//             return const Center(child: CircularProgressIndicator());
//           case Status.ERROR:
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error: ${designViewModel.getWebstoreStockByIdResponse.value.message}',
//                   ),
//                   const SizedBox(height: 16),
//                   CustomInkButton(
//                     onPressed: () => _loadWebstoreStockData(),
//                     text: 'Retry',
//                   ),
//                 ],
//               ),
//             );
//           case Status.COMPLETED:
//             log("Data loaded successfully");
//             return _buildWebstoreStockForm();
//           default:
//             return _buildWebstoreStockForm();
//         }
//       });
//     }
//     return _buildWebstoreStockForm();
//   }

//   Widget _buildWebstoreStockForm() {
//     return const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(flex: 2, child: OnlineDesignDetailsWidget()),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Expanded(child: OnlineDesignTableWidget()),
//               ],
//             ),
//           ),
//           SizedBox(width: 16),
//           Expanded(flex: 2, child: OnlineDesignImageGalleryWidget()),
//         ],
//       ),
//     );
//   }

//   Widget _buildFooter() {
//     return Obx(() {
//       bool isLoading =
//           designViewModel.createWebstoreStockResponse.value.status ==
//               Status.LOADING ||
//           designViewModel.editWebstoreStockResponse.value.status ==
//               Status.LOADING;

//       return CustomFooterAddDiscardRemark(
//         onRemarkPressed: () {
//           Get.dialog(const AddRemarkDialog());
//         },
//         onDiscardPressed: () => _clearAllControllers(shouldAddRow: true),
//         onNextPressed: isLoading ? null : _handleSaveOrUpdate,
//         remarkText: "Remarks",
//         discardText: "Discard (Ctrl+D)",
//         nextText: widget.id != null ? "Update" : "Save",
//         saveBtnVisibility: !isLoading,
//         backgroundColor: grey1,
//       );
//     });
//   }

//   void _clearAllControllers({bool shouldAddRow = false}) {
//     tableMakingChargesController.clearControllers(shouldAddRow: shouldAddRow);
//     designDetailsController.clearControllers();
//     designSettingsController.clearControllers();
//     designImageGalleryController.clearControllers();
//     remarksController.designRemarks.value = "";
//     dataPopulated = false;
//     designDetailsController.designNameFocusNode.requestFocus();
//   }

//   void _handleSaveOrUpdate() {
//     if (widget.id != null) {
//       // Update webstore stock
//       _updateWebstoreStock();
//     } else {
//       // Create new webstore stock
//       _createWebstoreStock();
//     }
//   }

//   void _createWebstoreStock() {
//     designViewModel.createWebstoreStock(
//       tableMakingChargesController: tableMakingChargesController,
//       designDetailsController: designDetailsController,
//       designImageGalleryController: designImageGalleryController,
//     );
//   }

//   void _updateWebstoreStock() {
//     designViewModel.editWebstoreStock(
//       id: widget.id!,
//       tableMakingChargesController: tableMakingChargesController,
//       designDetailsController: designDetailsController,
//       designImageGalleryController: designImageGalleryController,
//     );
//   }

//   @override
//   void dispose() {
//     // Clean up controllers
//     Get.delete<OnlineOnlyDesignViewModel>();
//     Get.delete<OnlineOnlyTableController>();
//     Get.delete<OnlineOnlyDesignDetailsController>();
//     Get.delete<DesignSettingsController>();
//     Get.delete<DesignImageGalleryController>();
//     super.dispose();
//   }
// }
