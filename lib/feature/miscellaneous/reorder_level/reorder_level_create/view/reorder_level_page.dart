import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view/reorder_level_details_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view_model/reorder_level_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class ReorderLevelPage extends StatefulWidget {
  const ReorderLevelPage({super.key});

  @override
  State<ReorderLevelPage> createState() => _ReorderLevelPageState();
}

class _ReorderLevelPageState extends State<ReorderLevelPage> {
  final ReorderLevelController controller = Get.put(ReorderLevelController());
  final SidebarController sidebarController = Get.find<SidebarController>();
  final FocusNode headTextFieldFocus = FocusNode();

  final FocusNode designTextFieldFocus = FocusNode();
  void _handleSaveShortcut() {
    if (controller.isFormValid()) {
      // Add your save logic here
      sidebarController.navigateToWidget(
        newChild: const ReorderLevelDetailsPage(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    controller.clearControllers();
    controller.initializeTextController();
    controller.searchStockHeads("");
  }

  // @override
  // void dispose() {
  //   controller.clearControllers();
  //   headTextFieldFocus.dispose();
  //   designTextFieldFocus.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const NextReOrderIntent(),
      },
      child: Actions(
        actions: {
          NextReOrderIntent: CallbackAction<NextReOrderIntent>(
            onInvoke: (intent) {
              _handleSaveShortcut();
              return null;
            },
          ),
        },
        child: Scaffold(
          backgroundColor: secondaryColor.withOpacity(0.15),
          body: FocusScope(
            autofocus: true,
            child: Column(
              children: [
                HeaderWidget(
                  header: "Re-Order Level",
                  wantBackButton: true,
                  onBackButtonTap: () {
                    SidebarController sidebarController = Get.find();
                    sidebarController.popBackSelectedWidget();
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FocusScope(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                    text: "Head",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(
                                    () => CustomTextField(
                                      name: "Choose head",
                                      autofocus: true,
                                      focusNode: headTextFieldFocus,
                                      controller:
                                          controller.stockHeadController,
                                      onChanged: controller.searchStockHeads,
                                      suffixIcon:
                                          controller
                                                      .stockHeadsResponse
                                                      .value
                                                      .status ==
                                                  Status.LOADING
                                              ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                              : null,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(() {
                                    final response =
                                        controller.stockHeadsResponse.value;

                                    if (response.status == Status.LOADING) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (response.status == Status.ERROR) {
                                      return Center(
                                        child: Text(
                                          'Error: ${response.message}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    }

                                    return Expanded(
                                      child: ListView.builder(
                                        itemCount: controller.stockHeads.length,
                                        itemBuilder: (context, index) {
                                          final head =
                                              controller.stockHeads[index];
                                          return Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              focusColor: greyTextColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              onTap: () {
                                                controller.selectStockHead(
                                                  head,
                                                  designTextFieldFocus,
                                                );
                                              },
                                              child: Obx(
                                                () => Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    color:
                                                        controller
                                                                    .selectedStockHead
                                                                    .value
                                                                    ?.id ==
                                                                head.id
                                                            ? greyTextColor
                                                            : Colors
                                                                .transparent,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          head.name ?? '-',
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        CustomDashedLineWidget(
                                                          width: Get.width,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FocusScope(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                    text: "Design",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(
                                    () => CustomTextField(
                                      name: "Choose Design",
                                      controller: controller.designController,
                                      focusNode: designTextFieldFocus,
                                      enabled:
                                          controller.selectedStockHead.value !=
                                          null,
                                      suffixIcon:
                                          controller
                                                      .designsResponse
                                                      .value
                                                      .status ==
                                                  Status.LOADING
                                              ? const SizedBox(
                                                height: 10,
                                                width: 10,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                              : null,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(() {
                                    final response =
                                        controller.designsResponse.value;

                                    if (response.status == Status.LOADING) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (response.status == Status.ERROR) {
                                      return Center(
                                        child: Text(
                                          'Error: ${response.message}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    }

                                    return Expanded(
                                      child: ListView.builder(
                                        itemCount: controller.designs.length,
                                        itemBuilder: (context, index) {
                                          final design =
                                              controller.designs[index];
                                          return Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              focusColor: greyTextColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              onTap:
                                                  () => controller.selectDesign(
                                                    design,
                                                  ),
                                              child: Obx(
                                                () => Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    color:
                                                        controller
                                                                    .selectedDesign
                                                                    .value
                                                                    ?.id ==
                                                                design.id
                                                            ? greyTextColor
                                                            : Colors
                                                                .transparent,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${design.code ?? '-'}   ${design.name ?? '-'}",
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        CustomDashedLineWidget(
                                                          width: Get.width,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                        CustomInkButton(
                          onPressed: () {
                            // Handle next action
                            _handleSaveShortcut();
                          },
                          text: "Next (Ctrl+S)",
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
    );
  }
}
