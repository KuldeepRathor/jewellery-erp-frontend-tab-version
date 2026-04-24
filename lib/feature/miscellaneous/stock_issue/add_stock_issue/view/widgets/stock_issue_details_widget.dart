import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/add_stock_issue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/view_model/stock_issue_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_calendar.dart';

class StockIssueDetailsWidget extends StatefulWidget {
  const StockIssueDetailsWidget({super.key, this.focusNode});
  final FocusNode? focusNode;

  @override
  State<StockIssueDetailsWidget> createState() =>
      _StockIssueDetailsWidgetState();
}

class _StockIssueDetailsWidgetState extends State<StockIssueDetailsWidget> {
  final StockIssueDetailsController controller =
      Get.find<StockIssueDetailsController>();

  final AddStockIssueController approvalController =
      Get.put<AddStockIssueController>(AddStockIssueController());
  @override
  void initState() {
    super.initState();
    controller.setDefaultDate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      approvalController.employeeFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      // onKeyEvent: onNormalKeyEvent,
      canRequestFocus: false,
      child: Form(
        key: controller.formKey,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomDateField(
                      controller: controller.approvalDateController,
                      labelText: "Issue Date",
                      onTap:
                          (context) => controller.selectDate(
                            context,
                            controller.approvalDateController,
                          ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Issue Number",
                          color: primaryTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Container(
                            height: 38,
                            decoration: BoxDecoration(
                              border: Border.all(color: grey1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  CustomText(
                                    text: controller.stockIssueNumber.value,
                                    fontSize: 16,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Issued by",
                          color: primaryTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        Obx(() {
                          return SizedBox(
                            width: Get.width * .145,
                            child: GenericAutocompleteDropdown<
                              GetEmployeesValue
                            >(
                              controller:
                                  approvalController
                                      .employeeSearchController
                                      .value,
                              focusNode: approvalController.employeeFocusNode,
                              items: const [],
                              getDisplayValue:
                                  (employee) =>
                                      '${employee.firstName ?? ''} ${employee.lastName ?? ''}',
                              onSelected: (value) async {
                                approvalController.setSelectedEmployee(value);
                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                controller.reasonFocusNode.requestFocus();
                              },
                              customOptionsBuilder: (textEditingValue) async {
                                await approvalController.searchEmployees(
                                  textEditingValue.text,
                                );
                                return approvalController.employeeOptions
                                    .toList();
                              },
                              borderColor: secondaryColor,
                              isLastRow: true,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Reason",
                          color: primaryTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        Obx(() {
                          return SizedBox(
                            width: Get.width * .1,
                            child: GenericAutocompleteDropdown<String>(
                              controller:
                                  controller.reasonSearchController.value,
                              focusNode: controller.reasonFocusNode,
                              items: const [],
                              getDisplayValue: (reason) => reason,
                              onSelected: (value) async {
                                controller.setSelectedReason(value);
                              },
                              customOptionsBuilder: (textEditingValue) async {
                                return await controller.searchReasons(
                                  textEditingValue.text,
                                );
                              },
                              borderColor: secondaryColor,
                              isLastRow: true,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(flex: 2, child: SizedBox()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
