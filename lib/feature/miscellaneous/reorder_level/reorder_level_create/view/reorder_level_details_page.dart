import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view/widgets/reorder_details_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view_model/reorder_detail_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view_model/reorder_level_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';

class ReorderLevelDetailsPage extends StatefulWidget {
  const ReorderLevelDetailsPage({super.key});

  @override
  State<ReorderLevelDetailsPage> createState() =>
      _ReorderLevelDetailsPageState();
}

class _ReorderLevelDetailsPageState extends State<ReorderLevelDetailsPage> {
  final ReorderLevelController reorderLevelController = Get.find();
  final SidebarController sidebarController = Get.find<SidebarController>();
  final ReorderDetailsController reorderDetailsController = Get.put(
    ReorderDetailsController(),
  );

  void _handleSaveShortcut() {
    // Add your save logic here
    log("Save called");
    reorderDetailsController.saveReorderItems();
  }

  void _handleEscape() {
    sidebarController.popBackSelectedWidget();
  }

  void _handleSupplierShortcut() {
    log("Set supplier called");
    // Add your supplier logic hereGet.dialog(
    // Get.dialog(
    //   const SupplierDialog(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const SaveReOrderShortcutIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const EscapeIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyC):
            const SupplierShortcutIntent(),
      },
      child: Actions(
        actions: {
          SaveReOrderShortcutIntent: CallbackAction<SaveReOrderShortcutIntent>(
            onInvoke: (intent) {
              _handleSaveShortcut();
              return null;
            },
          ),
          EscapeIntent: CallbackAction<EscapeIntent>(
            onInvoke: (intent) {
              _handleEscape();
              return null;
            },
          ),
          SupplierShortcutIntent: CallbackAction<SupplierShortcutIntent>(
            onInvoke: (intent) {
              _handleSupplierShortcut();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: FocusScope(
              autofocus: true,
              child: Column(
                children: [
                  HeaderWidget(header: "Re-Order Level"),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CustomInkButton(
                            width: 70,
                            autofocus: true,
                            onPressed: _handleEscape,
                            text: "< ESC",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Design:',
                                style: TextStyle(
                                  color: Color(0xFF28328B),
                                  fontSize: 12,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                reorderLevelController
                                        .selectedDesign
                                        .value
                                        ?.name ??
                                    "-",
                                style: const TextStyle(
                                  color: Color(0xFF28328B),
                                  fontSize: 16,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          CustomInkButton(
                            width: 200,
                            backgroundColor: greyTextColor,
                            focusColor: grey2,
                            textColor: secondaryColor,
                            onPressed: _handleSupplierShortcut,
                            text: "Set supplier (ALT+S)",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ReorderDetailsTable(
                        designId:
                            reorderLevelController.selectedDesign.value!.id!,
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(
                            () => CustomInkButton(
                              onPressed: _handleSaveShortcut,
                              text: "Next (Ctrl+S)",
                              isLoading:
                                  reorderDetailsController
                                      .saveReorderResponse
                                      .value
                                      .status ==
                                  Status.LOADING,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
