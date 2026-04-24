import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view_model/journal_entry_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';

class AccountTableView extends StatelessWidget {
  final AccountTableController controller = Get.find<AccountTableController>();

  AccountTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(
                  () => CustomTableWidget(
                    headers: [_buildTableHeaders()],
                    columnWidths: controller.accountColumnWidths,
                    rows: _buildRows(),
                    isLoadingMore: false,
                    controller: controller.scrollController,
                    addSizedBox: false,
                  ),
                ),
              ),
              Obx(
                () => ItemListHeaderTable(
                  headers: controller.totalHeadersValue.toList(),
                  columnWidthsCustom: getColumnWidths(
                    columnWidths: controller.accountColumnWidths,
                    context: context,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  backgroundColor: totalGreenColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Account Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonShortcutWidget(
              onTap: controller.validateAndAddRow,
              buttonName: "+ Add",
              shortcut: "Enter",
              color: primaryColor,
              shortcutButtonBackgroundColor: shortcutGreyColor,
            ),
            ButtonShortcutWidget(
              onTap: controller.removeLastRow,
              buttonName: "Remove",
              shortcut: "Shift+Esc",
              color: redTextColor,
              shortcutButtonBackgroundColor: shortcutRedColor,
            ),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableHeaders() {
    return TableRow(
      children:
          controller.accountHeaders
              .map(
                (header) => Row(
                  children: [
                    if (header != "Sn") const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        header,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }

  List<TableRow> _buildRows() {
    return List.generate(
      controller.controllers.length,
      (index) => _buildTableRow(index),
    );
  }

  TableRow _buildTableRow(int index) {
    final row = controller.controllers[index];
    return TableRow(
      children: [
        _buildCell(text: (index + 1).toString(), editable: false),
        _buildDropdownCell(
          index: index,
          controller: row.acCode,
          focusNode: row.tableFocusNodes[0],
          items: controller.getAccountCodes(),
          displayName: (item) => item,

          onSelected: (selectedValue) {
            controller.setAccountName(index, selectedValue);
            row.tableFocusNodes[1].requestFocus();
            controller.currentColIndex.value = 1;
          },
          onTap: () {
            controller.currentRowIndex.value = index;
            controller.currentColIndex.value = 0;
          },
          // validator: controller.validateRequired,
        ),
        _buildDropdownCell(
          index: index,
          controller: row.accountName,
          focusNode: row.tableFocusNodes[1],
          items: controller.getAccountNames(),
          displayName: (item) => item,
          onSelected: (selectedValue) {
            controller.setAccountCode(index, selectedValue);
            row.tableFocusNodes[2].requestFocus();
            controller.currentColIndex.value = 2;
          },
          onTap: () {
            controller.currentRowIndex.value = index;
            controller.currentColIndex.value = 1;
          },
          // validator: controller.validateRequired,
        ),
        _buildCell(
          textController: row.remarks,
          rowIndex: index,
          focusNode: row.tableFocusNodes[2],
          // validator: controller.validateRequired,
        ),
        _buildCell(
          textController: row.debit,
          rowIndex: index,
          focusNode: row.tableFocusNodes[3],
          keyboardType: TextInputType.number,
          validator: controller.validateNumber,
        ),
        _buildCell(
          textController: row.credit,
          rowIndex: index,
          focusNode: row.tableFocusNodes[4],
          keyboardType: TextInputType.number,
          validator: controller.validateNumber,
        ),
        _buildActionCell(index),
      ],
    );
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    bool editable = true,
    int rowIndex = 0,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      child:
          editable
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Focus(
                  canRequestFocus: false,
                  onKeyEvent:
                      (node, event) =>
                          controller.handleKeyEvent(node, event, rowIndex),
                  child: TextFormField(
                    focusNode: focusNode,
                    controller: textController,
                    keyboardType: keyboardType,
                    validator: validator,
                    onTap: () {
                      controller.currentRowIndex.value = rowIndex;
                      controller.currentColIndex.value = controller
                          .controllers[rowIndex]
                          .tableFocusNodes
                          .indexOf(focusNode!);
                    },
                    onChanged: (value) {
                      if (keyboardType == TextInputType.number) {
                        controller.onCreditDebitChanged(rowIndex);
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      isDense: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              controller.controllers.length == rowIndex + 1
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
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                child: Text(
                  text!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
    );
  }

  Widget _buildDropdownCell<T extends Object>({
    required int index,
    required TextEditingController controller,
    required FocusNode focusNode,
    required List<T> items,
    required String Function(T) displayName,
    String? Function(String?)? validator,
    required Function(T) onSelected,
    required void Function()? onTap,
  }) {
    return GenericAutocompleteDropdown<T>(
      validator: validator,
      controller: controller,
      focusNode: focusNode,
      items: items,
      getDisplayValue: displayName,
      onSelected: onSelected,
      onKeyEvent:
          (node, event) => this.controller.handleKeyEvent(node, event, index),
      enabled:
          this.controller.getAccountMappingsResponse.value.status ==
          Status.COMPLETED,
      isLastRow: this.controller.controllers.length == index + 1,
      onTap: onTap,
    );
  }

  Widget _buildActionCell(int index) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () => controller.removeRow(index),
    );
  }
}
