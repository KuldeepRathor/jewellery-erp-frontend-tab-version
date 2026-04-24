import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';

class CreateSalesSalesPersonDialog extends StatelessWidget {
  final int? rowIndex;
  final Function(GetEmployeesValue)? onEmployeeSelected;
  final String title;

  const CreateSalesSalesPersonDialog({
    super.key,
    this.rowIndex,
    this.onEmployeeSelected,
    this.title = 'Select Sales Person',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: CreateSalesContentBox(
        rowIndex: rowIndex,
        onEmployeeSelected: onEmployeeSelected,
        title: title,
      ),
    );
  }

  // Static method to show the dialog - makes it more reusable
  static Future<void> show({
    required BuildContext context,
    int? rowIndex,
    Function(GetEmployeesValue)? onEmployeeSelected,
    String title = 'Select Sales Person',
  }) {
    return showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return CreateSalesSalesPersonDialog(
          rowIndex: rowIndex,
          onEmployeeSelected: onEmployeeSelected,
          title: title,
        );
      },
    );
  }
}

class CreateSalesContentBox extends StatefulWidget {
  final int? rowIndex;
  final Function(GetEmployeesValue)? onEmployeeSelected;
  final String title;

  const CreateSalesContentBox({
    super.key,
    this.rowIndex,
    this.onEmployeeSelected,
    required this.title,
  });

  @override
  State<CreateSalesContentBox> createState() => _ContentBoxState();
}

class _ContentBoxState extends State<CreateSalesContentBox> {
  late final CreateSalesItemDetailsController itemDetailsController;
  late final CreateSalesEstimationSearchPartyController searchPartyController;
  final TextEditingController employeeSearchController =
      TextEditingController();
  final FocusNode employeeFocusNode = FocusNode();
  GetEmployeesValue? selectedEmployee;

  @override
  void initState() {
    super.initState();
    itemDetailsController = Get.find<CreateSalesItemDetailsController>();
    searchPartyController =
        Get.find<CreateSalesEstimationSearchPartyController>();

    // Initialize selected employee if rowIndex is provided
    if (widget.rowIndex != null) {
      selectedEmployee =
          itemDetailsController.controllers[widget.rowIndex!].employeeDetails;
    }

    // Focus the search field immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      employeeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    employeeSearchController.dispose();
    employeeFocusNode.dispose();
    super.dispose();
  }

  void _confirmSelection() {
    if (selectedEmployee != null) {
      if (widget.onEmployeeSelected != null) {
        widget.onEmployeeSelected!(selectedEmployee!);
      } else if (widget.rowIndex != null) {
        itemDetailsController.onEmployeeSelected(
          rowIndex: widget.rowIndex!,
          employee: selectedEmployee!,
        );
      }
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const ConfirmSalesPersonIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ConfirmSalesPersonIntent: CallbackAction<ConfirmSalesPersonIntent>(
            onInvoke: (ConfirmSalesPersonIntent intent) {
              _confirmSelection();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: Get.width * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: GenericAutocompleteDropdown<GetEmployeesValue>(
                    controller: employeeSearchController,
                    focusNode: employeeFocusNode,
                    items: const [],
                    getDisplayValue:
                        (employee) =>
                            '${employee.firstName ?? ''} ${employee.lastName ?? ''}',
                    onSelected: (value) {
                      setState(() {
                        selectedEmployee = value;
                      });
                      employeeFocusNode.requestFocus();
                    },
                    customOptionsBuilder: (textEditingValue) async {
                      await searchPartyController.searchEmployees(
                        textEditingValue.text,
                      );
                      return searchPartyController
                              .getEmployeesResponse
                              .value
                              .data
                              ?.values
                              ?.toList() ??
                          [];
                    },
                    borderColor: secondaryColor,
                    isLastRow: true,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomInkButton(
                      onPressed: () {
                        Get.back();
                      },
                      text: "Cancel",
                    ),
                    const SizedBox(width: 20),
                    CustomInkButton(
                      onPressed: _confirmSelection,
                      text: "Confirm (Ctrl+S)",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
