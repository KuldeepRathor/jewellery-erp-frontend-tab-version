// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_making_charges_table_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response_v2.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class TableMakingChargesWidget extends StatefulWidget {
  const TableMakingChargesWidget({super.key, this.isEditMode});
  final bool? isEditMode;

  @override
  State<TableMakingChargesWidget> createState() =>
      _TableMakingChargesWidgetState();
}

class _TableMakingChargesWidgetState extends State<TableMakingChargesWidget> {
  final controller = Get.find<TableMakingChargesController>();
  final designDetailsController = Get.find<DesignDetailsController>();

  @override
  void initState() {
    super.initState();

    controller.getPurityDetails();
    controller.fetchOrnaments();
    if (widget.isEditMode == false) {
      controller.addRow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildRadioButtons(controller: controller),
                  const SizedBox(height: 16),
                  Expanded(child: _buildTableContent()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onNormalKeyEvent(node, event, []),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Making Charges',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              _buildActionButton(
                label: '+ Add',
                shortcut: 'Enter',
                textColor: const Color(0xFF28328B),
                backgroundColor: const Color(0x1928328B),
                onTap: () => controller.addRow(),
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                label: 'Remove',
                shortcut: 'Esc',
                textColor: const Color(0xFFFC3A20),
                backgroundColor: const Color(0x19FC3A20),
                onTap:
                    () => controller.removeRow(
                      index: controller.controllers.length - 1,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButtons({
    required TableMakingChargesController controller,
  }) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onNormalKeyEvent(node, event, []),
      child: Row(
        children: [
          _buildRadioButton(
            label: 'VA, MC',
            option: MakingChargesOption.VaMc,
            controller: controller,
          ),
          const SizedBox(width: 16),
          _buildRadioButton(
            label: 'Weight, Rate/gm',
            option: MakingChargesOption.WeightRate,
            controller: controller,
          ),
          const SizedBox(width: 16),
          _buildRadioButton(
            label: 'Weight, PC rate',
            option: MakingChargesOption.WeightPcRate,
            controller: controller,
          ),
          const SizedBox(width: 16),
          _buildRadioButton(
            label: 'PC Rate',
            option: MakingChargesOption.PcRate,
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent() {
    return Obx(() {
      final option = controller.selectedOption.value;
      return _buildTable(
        headers: _getHeadersForOption(option),
        columnWidths: _getColumnWidthsForOption(option),
        showWeightRange: option != MakingChargesOption.PcRate,
        showVaMc: option == MakingChargesOption.VaMc,
      );
    });
  }

  List<String> _getHeadersForOption(MakingChargesOption option) {
    switch (option) {
      case MakingChargesOption.VaMc:
        return [
          "Sr",
          'Purity',
          'Ornament Type',
          'Weight Range (gm)',
          'VA',
          'MC',
          'Min VA',
          'Min MC',
          '',
        ];
      case MakingChargesOption.WeightRate:
      case MakingChargesOption.WeightPcRate:
        return ["Sr", 'Purity', 'Ornament Type', 'Weight Range (gm)', ''];
      case MakingChargesOption.PcRate:
        return ["Sr", 'Purity', 'Ornament Type', ''];
    }
  }

  List<double> _getColumnWidthsForOption(MakingChargesOption option) {
    switch (option) {
      case MakingChargesOption.VaMc:
        return [0.15, 0.3, 0.4, 0.6, 0.33, 0.33, 0.33, 0.33, 0.1];
      case MakingChargesOption.WeightRate:
      case MakingChargesOption.WeightPcRate:
        return [0.15, 0.3, 0.4, 0.6, 0.1];
      case MakingChargesOption.PcRate:
        return [0.15, 0.3, 0.4, 0.1];
    }
  }

  Widget _buildTable({
    required List<String> headers,
    required List<double> columnWidths,
    required bool showWeightRange,
    required bool showVaMc,
  }) {
    return CustomTableWidget(
      headers: [_buildTableHeaders(headers: headers)],
      columnWidths: columnWidths,
      rows: _buildRows(showWeightRange: showWeightRange, showVaMc: showVaMc),
      isLoadingMore: false,
      controller: controller.scrollController,
      addSizedBox: false,
    );
  }

  TableRow _buildTableHeaders({required List<String> headers}) {
    return TableRow(
      children:
          headers
              .map(
                (header) => Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      color: secondaryColor,
                      child: CustomText(
                        text: header,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Satoshi",
                      ),
                    ),
                    Visibility(
                      visible: header == 'VA' || header == 'MC',
                      child: Tooltip(
                        message: getTooltipMessage(header),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: toolTipBgColor,
                        ),
                        triggerMode: TooltipTriggerMode.tap,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }

  String getTooltipMessage(String header) {
    if (header == "Stone (₹)") {
      return "Alt + D to add Stone details";
    } else {
      return "Alt + C or Double Click to Change";
    }
  }

  List<TableRow> _buildRows({
    required bool showWeightRange,
    required bool showVaMc,
  }) {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(
        index: index,
        showWeightRange: showWeightRange,
        showVaMc: showVaMc,
      ),
    );
  }

  TableRow _buildTableRow({
    required int index,
    required bool showWeightRange,
    required bool showVaMc,
  }) {
    final row = controller.controllers[index];
    List<Widget> cells = [
      // Sr No
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 4, 13),
            child: CustomText(
              text: (index + 1).toString(),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),

      // Purity dropdown
      _buildPurityDropdown(
        index: index,
        focusNode: controller.controllers[index].tableFocusNodes[0],
        controller: controller,
      ),

      // Ornament Type dropdown
      _buildOrnamentTypeDropdown(
        index: index,
        focusNode: controller.controllers[index].tableFocusNodes[1],
        controller: controller,
      ),
    ];

    // Add Weight Range if needed
    if (showWeightRange) {
      cells.add(
        _buildWeightRangeCell(
          minController: row.weightRangeMin,
          maxController: row.weightRangeMax,
          rowIndex: index,
          minFocusNode: controller.controllers[index].tableFocusNodes[2],
          maxFocusNode: controller.controllers[index].tableFocusNodes[3],
        ),
      );
    }

    // Add VA/MC fields if needed
    if (showVaMc) {
      cells.addAll([
        _buildVAMCCell(
          index: index,
          textController: row.va,
          label: 'VA',
          changeUnitFunction: (index) => controller.setVaUnit(index: index),
          suffixText: row.vaUnit,
          textFocusNode: controller.controllers[index].tableFocusNodes[4],
          controller: controller,
        ),
        _buildVAMCCell(
          index: index,
          textController: row.mc,
          label: 'MC',
          changeUnitFunction: (index) => controller.setMcUnit(index: index),
          suffixText: row.mcUnit,
          textFocusNode: controller.controllers[index].tableFocusNodes[5],
          controller: controller,
        ),
        _buildVAMCCell(
          index: index,
          textController: row.minVa,
          label: 'Min VA',
          changeUnitFunction: (index) {},
          suffixText: row.vaUnit,
          textFocusNode: controller.controllers[index].tableFocusNodes[6],
          controller: controller,
        ),
        _buildVAMCCell(
          index: index,
          textController: row.minMc,
          label: 'Min MC',
          changeUnitFunction: (index) {},
          suffixText: row.mcUnit,
          textFocusNode: controller.controllers[index].tableFocusNodes[7],
          controller: controller,
        ),
      ]);
    }

    // Add delete button
    cells.add(
      controller.controllers.elementAt(index).id == null
          ? _buildDeleteCell(
            onDelete: () {
              if (controller.controllers.elementAt(index).id == null) {
                controller.removeRow(index: index);
              }
            },
          )
          : const SizedBox(),
    );

    return TableRow(children: cells);
  }

  Widget _buildWeightRangeCell({
    required TextEditingController minController,
    required TextEditingController maxController,
    required int rowIndex,
    required FocusNode? minFocusNode,
    required FocusNode? maxFocusNode,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Focus(
                  canRequestFocus: false,
                  onKeyEvent:
                      (node, event) => onTableKeyEvent(node, event, rowIndex),
                  child: TextFormField(
                    onTap: () {
                      controller.currentRowIndex.value = rowIndex;
                      // Find the index of the current focusNode in the tableFocusNodes list
                      controller.currentColIndex.value = controller
                          .controllers[rowIndex]
                          .tableFocusNodes
                          .indexOf(minFocusNode!);
                    },
                    controller: minController,
                    focusNode: minFocusNode,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: _getWeightRangeInputDecoration(
                      hint: 'min',
                      rowIndex: rowIndex,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    inputFormatters: [WeightInputFormatter()],
                    validator:
                        (value) => _validateWeightRange(
                          value,
                          maxController.text,
                          "Min weight",
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const CustomText(text: "-"),
              const SizedBox(width: 8),
              Expanded(
                child: Focus(
                  canRequestFocus: false,
                  onKeyEvent:
                      (node, event) => onTableKeyEvent(node, event, rowIndex),
                  child: TextFormField(
                    onTap: () {
                      controller.currentRowIndex.value = rowIndex;
                      // Find the index of the current focusNode in the tableFocusNodes list
                      controller.currentColIndex.value = controller
                          .controllers[rowIndex]
                          .tableFocusNodes
                          .indexOf(maxFocusNode!);
                    },
                    controller: maxController,
                    focusNode: maxFocusNode,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: _getWeightRangeInputDecoration(
                      hint: 'max',
                      rowIndex: rowIndex,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    inputFormatters: [WeightInputFormatter()],
                    validator: (value) {
                      final minValidation = _validateWeightRange(
                        minController.text,
                        value,
                        "Max weight",
                      );
                      if (minValidation != null) return minValidation;
                      return _validatePositiveDouble(value, "Max weight");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _getWeightRangeInputDecoration({
    required String hint,
    required int rowIndex,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      isDense: true,
      hintText: hint,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:
              controller.controllers.length == rowIndex + 1
                  ? secondaryColor
                  : Colors.transparent,
          // color: Colors.transparent,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: secondaryColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }

  Widget _buildVAMCCell({
    required int index,
    FocusNode? textFocusNode,
    required String label,
    required TableMakingChargesController controller,
    required void Function(int index) changeUnitFunction,
    required TextEditingController textController,
    required String suffixText,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Focus(
            onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
            canRequestFocus: false,
            child: Focus(
              canRequestFocus: false,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.keyC &&
                    HardwareKeyboard.instance.isAltPressed) {
                  changeUnitFunction(index);
                  // controller.updateTotals();
                  setState(() {});
                  log('I am here');
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => TextFormField(
                        // enabled: widget.isDisabled == true ? false : true,
                        // onTap: () => setState(() {
                        //   controller.currentRowIndex.value = index;
                        //   controller.currentColIndex.value = 2;
                        // }),
                        onTap: () {
                          controller.currentRowIndex.value = index;
                          // Find the index of the current focusNode in the tableFocusNodes list
                          controller.currentColIndex.value = controller
                              .controllers[index]
                              .tableFocusNodes
                              .indexOf(textFocusNode!);
                        },
                        keyboardType: TextInputType.number,
                        controller: textController,
                        focusNode: textFocusNode,
                        decoration: InputDecoration(
                          suffix: CustomText(text: suffixText),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  controller.controllers.length == index + 1
                                      ? secondaryColor
                                      : Colors.transparent,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: secondaryColor,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$'),
                          ),
                        ],
                        validator: (value) {
                          // Safety check - if index is out of bounds, skip validation
                          if (index >= controller.controllers.length) {
                            return null;
                          }

                          if (label == 'Min VA') {
                            return _validateMinVA(
                              value,
                              controller.controllers[index].va.text,
                            );
                          } else if (label == 'Min MC') {
                            return _validateMinMC(
                              value,
                              controller.controllers[index].mc.text,
                            );
                          } else {
                            return _validatePositiveDouble(value, label);
                          }
                        },
                        onChanged: (value) {
                          // _showVaMcChangedDialog();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // CustomDashedLineWidget(
        //   width: Get.width,
        // )
      ],
    );
  }

  List<GetPurityValue> getSelectedPurityValues(
    String? selectedMetalID,
    GetPurityResponseV2? purityResponse,
  ) {
    if (selectedMetalID == null || purityResponse == null) return [];

    switch (selectedMetalID) {
      case "1": // Gold
        return purityResponse.gold ?? [];
      case "2": // Platinum
        return purityResponse.platinum ?? [];
      case "3": // Silver
        return purityResponse.silver ?? [];
      default: // Combined
        final List<GetPurityValue> combinedList = [
          ...(purityResponse.gold ?? []),
          ...(purityResponse.silver ?? []),
          ...(purityResponse.platinum ?? []),
        ];
        return combinedList;
    }
  }

  Widget _buildPurityDropdown({
    required int index,
    required TableMakingChargesController controller,
    required FocusNode focusNode,
  }) {
    return Obx(() {
      final selectedMetalID =
          designDetailsController.selectedMetalType.value?.id;
      final purityResponse = controller.getPurityResponse.value.data;

      final purityValues = getSelectedPurityValues(
        selectedMetalID,
        purityResponse,
      );
      log("The purity values are $purityValues");

      return GenericAutocompleteDropdown<GetPurityValue>(
        controller: controller.controllers[index].purity,
        focusNode: focusNode,
        items: const [],
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
        getDisplayValue:
            (GetPurityValue item) =>
                item.purityName ?? "", // Display purity_name
        onSelected: (GetPurityValue value) {
          // Store both the display name and the GetPurityValue object
          controller.controllers[index].purity.text = value.purityName ?? "";
          controller.controllers[index].purityValue =
              value; // Store the full object
          controller.controllers[index].tableFocusNodes[1].requestFocus();
          controller.currentColIndex.value = 1;
        },
        enabled:
            controller.controllers.elementAt(index).id == null &&
            controller.getPurityResponse.value.status == Status.COMPLETED,
        isLastRow: index == controller.controllers.length - 1,
        borderColor: secondaryColor,
        fieldHeight: 38,
        maxHeight: 150,
        onTap: () {
          controller.currentRowIndex.value = index;
          controller.currentColIndex.value = controller
              .controllers[index]
              .tableFocusNodes
              .indexOf(focusNode);
        },
        customOptionsBuilder: (value) async {
          final selectedMetalID =
              designDetailsController.selectedMetalType.value?.id;
          final purityResponse = controller.getPurityResponse.value.data;

          final purityValues = getSelectedPurityValues(
            selectedMetalID,
            purityResponse,
          );

          var list =
              purityValues
                  .where(
                    (element) => element.purityName!.toLowerCase().contains(
                      value.text.toLowerCase(),
                    ),
                  )
                  .toList();
          return list;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Purity is required';
          }
          return null;
        },
      );
    });
  }

  Widget _buildOrnamentTypeDropdown({
    required int index,
    required TableMakingChargesController controller,
    required FocusNode focusNode,
  }) {
    return Obx(() {
      final selectedMetalID =
          designDetailsController.selectedMetalType.value?.id;

      // Get the purityType from the stored GetPurityValue object
      final selectedPurityType =
          controller.controllers[index].purityValue?.purityType;

      // For display purposes, we still use the purity.text (which contains purityName)
      // final selectedPurityDisplay = controller.controllers[index].purity.text;

      return GenericAutocompleteDropdown<GetAllOrnamentsResponseValue>(
        controller: controller.controllers[index].ornamentType,
        focusNode: focusNode,
        items: const [],
        onKeyEvent: (node, event) => onTableKeyEvent(node, event, index),
        maxWidthForOptions: DROPDOWN_OPTIONS_MAX_WIDTH,
        getDisplayValue: (GetAllOrnamentsResponseValue item) => item.name ?? "",
        onSelected: (value) {
          controller.setOrnament(index: index, value: value);
          // Add a small delay to ensure the widget tree has updated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Ensure we're focusing the min weight field (index 2)
            if (controller.controllers[index].tableFocusNodes.length > 2) {
              controller.controllers[index].tableFocusNodes[2].requestFocus();
              controller.currentColIndex.value = 2;
            }
          });
        },
        enabled:
            controller.ornamentsResponse.value.status == Status.COMPLETED &&
            controller.controllers.elementAt(index).id == null,
        isLastRow: index == controller.controllers.length - 1,
        borderColor: secondaryColor,
        fieldHeight: 38,
        maxHeight: 150,
        onTap: () {
          controller.currentRowIndex.value = index;
          // Find the index of the current focusNode in the tableFocusNodes list
          controller.currentColIndex.value = controller
              .controllers[index]
              .tableFocusNodes
              .indexOf(focusNode);
        },
        customOptionsBuilder: (value) async {
          print("The list required ");
          setState(() {});

          // Use purityType for filtering instead of the display name
          if (selectedMetalID != null &&
              selectedPurityType != null &&
              selectedPurityType.isNotEmpty) {
            List<GetAllOrnamentsResponseValue> list =
                controller.ornamentsResponse.value.data?.values ?? [];

            // Filter using purityType (e.g., "22k") instead of purityName (e.g., "Gold 22k")
            List<GetAllOrnamentsResponseValue> requiredList =
                list
                    .where(
                      (element) =>
                          element.purity?.toLowerCase() ==
                              selectedPurityType.toLowerCase() &&
                          element.metalType?.id == selectedMetalID,
                    )
                    .where(
                      (element) => element.name!.toLowerCase().contains(
                        value.text.toLowerCase(),
                      ),
                    )
                    .toList();

            print("The list is $requiredList");
            print(
              "Filtering with purityType: $selectedPurityType, metalType: $selectedMetalID",
            );
            return requiredList;
          }
          return [];
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ornament is required';
          }
          return null;
        },
      );
    });
  }

  Widget _buildDeleteCell({required VoidCallback onDelete}) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 28,
            color: redTextColor,
          ),
          onPressed: onDelete,
        ),
        const SizedBox(height: 8),
        // CustomDashedLineWidget(width: Get.width),
      ],
    );
  }

  Widget _buildRadioButton({
    required String label,
    required MakingChargesOption option,
    required TableMakingChargesController controller,
  }) {
    return Obx(
      () => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.isEditMode == false) {
              controller.setSelectedOption(option);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFE6E8FF)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: ShapeDecoration(
                    color:
                        controller.selectedOption.value == option
                            ? secondaryColor
                            : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: secondaryColor),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child:
                      controller.selectedOption.value == option
                          ? Center(
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          )
                          : null,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required String shortcut,
    required Color textColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              shortcut,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    // print("table key event called ${event.logicalKey} $rowIndex");
    if (event is KeyDownEvent) {
      print(
        "table key event called ${event.logicalKey} $rowIndex ${HardwareKeyboard.instance.isShiftPressed}",
      );
      if ((controller.currentColIndex.value == 0 ||
              controller.currentColIndex.value == 1) &&
          event.logicalKey == LogicalKeyboardKey.enter) {
        return KeyEventResult.ignored;
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          return KeyEventResult.ignored;
        } else {
          controller.moveNextFocus();
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.tab &&
          HardwareKeyboard.instance.isShiftPressed) {
        // controller.movePreviousFocus(addButtonFocusNode);
        controller.movePreviousFocus(node);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        controller.moveNextFocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        return controller.moveFocus(
          KeyEventResult.handled,
          LogicalKeyboardKey.arrowUp,
          nextFocusNode: node,
          previousFocusNode: node,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        return controller.moveFocus(
          KeyEventResult.handled,
          LogicalKeyboardKey.arrowDown,
          nextFocusNode: node,
          previousFocusNode: node,
        );
      }

      if (event.logicalKey == LogicalKeyboardKey.escape &&
          HardwareKeyboard.instance.isShiftPressed) {
        controller.removeCurrentRow(rowIndex);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        controller.currentColIndex.value = 0;
        controller.controllers[rowIndex].tableFocusNodes[0].requestFocus();
        controller.resetRow(rowIndex);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  };

  String? _validatePositiveDouble(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return null; // Field is not required
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return '$fieldName must be a valid number';
    }
    if (doubleValue < 0) {
      return '$fieldName must be positive';
    }
    return null;
  }

  String? _validateMinVA(String? value, String? vaValue) {
    // First check basic validation
    final baseValidation = _validatePositiveDouble(value, "Min VA");
    if (baseValidation != null) return baseValidation;

    if (value != null &&
        value.isNotEmpty &&
        vaValue != null &&
        vaValue.isNotEmpty) {
      final minVA = double.tryParse(value);
      final va = double.tryParse(vaValue);

      if (minVA != null && va != null) {
        if (minVA == 0 && va == 0) return null;
        if (minVA >= va) {
          return 'Min VA must be less than VA';
        }
      }
    }
    return null;
  }

  String? _validateMinMC(String? value, String? mcValue) {
    // First check basic validation
    final baseValidation = _validatePositiveDouble(value, "Min MC");
    if (baseValidation != null) return baseValidation;

    if (value != null &&
        value.isNotEmpty &&
        mcValue != null &&
        mcValue.isNotEmpty) {
      final minMC = double.tryParse(value);
      final mc = double.tryParse(mcValue);

      if (minMC != null && mc != null) {
        if (minMC == 0 && mc == 0) return null;
        if (minMC >= mc) {
          return 'Min MC must be less than MC';
        }
      }
    }
    return null;
  }

  String? _validateWeightRange(
    String? minValue,
    String? maxValue,
    String fieldName,
  ) {
    // First check basic validation
    final baseValidation = _validatePositiveDouble(minValue, fieldName);
    if (baseValidation != null) return baseValidation;

    if (minValue != null &&
        minValue.isNotEmpty &&
        maxValue != null &&
        maxValue.isNotEmpty) {
      final min = double.tryParse(minValue);
      final max = double.tryParse(maxValue);

      if (min != null && max != null) {
        if (min == 0 && max == 0) return null;
        if (min > max) {
          return 'Min weight must be less than max weight';
        }
      }
    }
    return null;
  }
}
