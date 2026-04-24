import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/view_model/tag_print_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class TagPrint extends StatefulWidget {
  const TagPrint({super.key});

  @override
  State<TagPrint> createState() => _TagPrintState();
}

class _TagPrintState extends State<TagPrint> {
  // Controller instance
  late final TagPrintController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TagPrintController());
  }

  @override
  void dispose() {
    Get.delete<TagPrintController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with title and print button
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tag Print Template Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  CustomButton1(buttonName: "Print Sample"),
                ],
              ),

              Text(
                "Note : You can choose up to 3 details per side to be printed on the tag.",
                style: TextStyle(
                  color: Colors.indigo[900],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const CustomDashedLineWidget(width: double.infinity),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Left Side Print',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Right Side Print',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
                  ],
                ),
              ),

              // Option rows in a more compact layout
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCompactRow(
                        'Design Name',
                        controller.leftDesignName,
                        controller.rightDesignName,
                      ),
                      _buildCompactRow(
                        'Vender',
                        controller.leftVender,
                        controller.rightVender,
                      ),
                      _buildCompactRow(
                        'Tag No',
                        controller.leftTagNo,
                        controller.rightTagNo,
                      ),
                      _buildCompactRow(
                        'Net Weight',
                        controller.leftNetWeight,
                        controller.rightNetWeight,
                      ),
                      _buildCompactRow(
                        'Gross Weight',
                        controller.leftGrossWeight,
                        controller.rightGrossWeight,
                      ),
                      _buildCompactRow(
                        'Stone Weight',
                        controller.leftStoneWeight,
                        controller.rightStoneWeight,
                      ),
                      _buildCompactRow(
                        'Purity',
                        controller.leftPurity,
                        controller.rightPurity,
                      ),
                      _buildCompactRow(
                        'VA',
                        controller.leftVAInPercent,
                        controller.rightVAInPercent,
                      ),
                      _buildCompactRow(
                        'Size',
                        controller.leftSize,
                        controller.rightSize,
                      ),
                      _buildCompactRow(
                        'HUID',
                        controller.leftHUID,
                        controller.rightHUID,
                      ),
                      _buildCompactRow(
                        'Barcode Number',
                        controller.leftBarcodeNumber,
                        controller.rightBarcodeNumber,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.resetAllFields();
                      },
                      child: Container(
                        height: 38,
                        width: 140,
                        decoration: BoxDecoration(
                          color: grey1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Center(
                          child: CustomText(
                            text: "Discard",
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => CustomButton1(
                        buttonName: "Save (Ctrl + S)",
                        onTap:
                            controller.isUpdating.value
                                ? null
                                : () => controller.updateTagPrintTemplate(),
                        isLoading: controller.isUpdating.value,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactRow(String label, RxBool leftValue, RxBool rightValue) {
    return Row(
      children: [
        // Left side
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Obx(
                    () => _buildCompactToggle(
                      leftValue.value ? 'Yes' : 'No',
                      leftValue.value,
                      () => controller.toggleLeftOption(
                        leftValue,
                        !leftValue.value,
                      ),
                      controller.getFocusNodeForOption(label, isLeft: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Divider
        Container(width: 1, height: 52, color: Colors.grey.shade200),
        // Right side
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Obx(
                    () => _buildCompactToggle(
                      rightValue.value ? 'Yes' : 'No',
                      rightValue.value,
                      () => controller.toggleRightOption(
                        rightValue,
                        !rightValue.value,
                      ),
                      controller.getFocusNodeForOption(label, isLeft: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }

  // // Compact VA row
  // Widget _buildCompactVARow() {
  //   return Row(
  //     children: [
  //       // Left side
  //       Expanded(
  //         flex: 1,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //           child: Row(
  //             children: [
  //               const Expanded(
  //                 flex: 3,
  //                 child: Text(
  //                   'VA in % or gms',
  //                   style: TextStyle(fontSize: 14),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 flex: 1,
  //                 child: Obx(() => _buildCompactToggle(
  //                       '%',
  //                       controller.leftVAInPercent.value,
  //                       () => controller.toggleLeftOption(
  //                           controller.leftVAInPercent,
  //                           !controller.leftVAInPercent.value),
  //                       controller.leftVAFocusNode,
  //                     )),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       // Divider
  //       Container(
  //         width: 1,
  //         height: 52,
  //         color: Colors.grey.shade200,
  //       ),
  //       // Right side
  //       Expanded(
  //         flex: 1,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //           child: Row(
  //             children: [
  //               const Expanded(
  //                 flex: 3,
  //                 child: Text(
  //                   'VA in % or gms',
  //                   style: TextStyle(fontSize: 14),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 flex: 1,
  //                 child: Obx(() => _buildCompactToggle(
  //                       '%',
  //                       controller.rightVAInPercent.value,
  //                       () => controller.toggleRightOption(
  //                           controller.rightVAInPercent,
  //                           !controller.rightVAInPercent.value),
  //                       controller.rightVAFocusNode,
  //                     )),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         flex: 1,
  //         child: Container(),
  //       )
  //     ],
  //   );
  // }

  // More compact toggle button
  Widget _buildCompactToggle(
    String label,
    bool value,
    VoidCallback onToggle,
    FocusNode focusNode,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              focusNode.hasPrimaryFocus ? Colors.blue : const Color(0xFFE6E8FF),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          CustomToggleSwitch(
            canRequestFocus: false,
            value: value,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }
}
