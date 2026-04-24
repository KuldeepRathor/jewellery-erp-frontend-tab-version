import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view/widget/branch_transfer_item_preview.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/base_branch_transfer_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/branch_out_transfer_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class BranchTransferItemDetails extends StatelessWidget {
  final BaseBranchTransferViewModel controller;

  const BranchTransferItemDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTable(),
                      _buildTotals(context),
                      _buildItemPreview(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Item Details',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          ButtonShortcutWidget(
            buttonName: "+ Add",
            shortcut: "Enter",
            color: primaryColor,
            shortcutButtonBackgroundColor: shortcutGreyColor,
            onTap: controller.addRow,
          ),
          ButtonShortcutWidget(
            buttonName: "Remove",
            shortcut: "Shift+Esc",
            color: redTextColor,
            shortcutButtonBackgroundColor: shortcutRedColor,
            onTap: controller.removeLastRow,
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => CustomTableWidget(
          headers: [_buildTableHeaders()],
          columnWidths: controller.columnWidths,
          rows: _buildRows(),
          addSizedBox: false,
        ),
      ),
    );
  }

  TableRow _buildTableHeaders() {
    return TableRow(
      children:
          controller.headers.map((header) {
            return Row(
              children: [
                if (header != "Sn") const SizedBox(width: 4),
                Flexible(
                  child: CustomText(
                    text: header,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (header == 'Stone Cost(₹)')
                  Tooltip(
                    message: "Alt + D to add Stone details",
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: toolTipBgColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
    );
  }

  List<TableRow> _buildRows() {
    return List.generate(
      controller.controllers.length,
      (index) => TableRow(
        children: [
          for (int col = 0; col < controller.headers.length - 1; col++)
            _buildCell(
              textController: controller.controllers[index].getController(col),
              rowIndex: index,
              colIndex: col,
            ),
          _buildMoreOptionsCell(index),
        ],
      ),
    );
  }

  Widget _buildCell({
    TextEditingController? textController,
    required int rowIndex,
    required int colIndex,
  }) {
    if (colIndex == 2) {
      return _buildCounterDropdown(index: rowIndex);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: TextFormField(
        controller: textController,
        focusNode: controller.controllers[rowIndex].getFocusNode(colIndex),
        keyboardType: TextInputType.number,
        onFieldSubmitted:
            (_) => controller.moveFocusToNextCell(rowIndex, colIndex),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        onChanged: (val) {
          if (colIndex == 1 && controller is BranchOutTransferViewModel) {
            final outController = controller as BranchOutTransferViewModel;
            if (outController
                .controllers[rowIndex]
                .extistingTagNumber
                .text
                .isNotEmpty) {
              outController.fetchByExistingTag(rowIndex);
            }
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter valid input';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCounterDropdown({required int index}) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Focus(
          canRequestFocus: false,
          child: SizedBox(
            height: 38,
            child: DropdownMenu<String>(
              initialSelection: controller.defaultCounter?.id,
              requestFocusOnTap: true,
              enabled: true,
              menuStyle: const MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                fixedSize: WidgetStatePropertyAll(Size.fromHeight(150)),
              ),
              onSelected: (String? value) {
                if (value != null) {
                  controller.controllers[index].counterId.text = value;
                }
              },
              dropdownMenuEntries:
                  controller.counterList.map((item) {
                    return DropdownMenuEntry<String>(
                      value: item.id ?? '',
                      label: item.counterName!,
                      labelWidget: Column(
                        children: [
                          CustomText(
                            text: '${item.counterName!}(${item.code})',
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          const CustomDashedLineWidget(width: double.infinity),
                        ],
                      ),
                    );
                  }).toList(),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              expandedInsets: EdgeInsets.zero,
              trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
              inputDecorationTheme: InputDecorationTheme(
                isDense: true,
                constraints: const BoxConstraints(
                  maxHeight: 38,
                  minWidth: double.maxFinite,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        controller.controllers.length == index + 1
                            ? secondaryColor
                            : Colors.transparent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreOptionsCell(int rowIndex) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: redTextColor,
          onPressed: () {
            controller.removeCurrentRow(rowIndex);
            controller.update();
          },
        ),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  Widget _buildTotals(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Obx(
        () => ItemListHeaderTable(
          headers: controller.totalHeadersValue.toList(),
          columnWidthsCustom: getColumnWidths(
            columnWidths: controller.columnWidths,
            context: context,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: totalGreenColor,
        ),
      ),
    );
  }

  Widget _buildItemPreview() {
    return Obx(() {
      if (controller.showItemPreview.value &&
          controller.currentItemDetails.value != null) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(40, 50, 139, 0.08),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Item Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomDashedLineWidget(width: Get.width / 1.4),
                const SizedBox(height: 8),
                const SizedBox(height: 120, child: BranchTransferItemPreview()),
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
