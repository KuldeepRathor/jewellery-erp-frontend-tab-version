import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view_model/counter_transfer_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view_model/counter_transfer_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/counter/counter_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class CounterTransferHeader extends StatelessWidget {
  const CounterTransferHeader({super.key});

  @override
  Widget build(BuildContext context) {
    CounterTransferController controller = Get.find();
    CounterTransferItemDetailsController itemDetailsController = Get.find();
    return Container(
      // height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final counters =
                      controller.getCountersResponse.value.data?.values ?? [];
                  return SizedBox(
                    width: Get.width * 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            CustomText(
                              text: 'Transfer To',
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        GenericAutocompleteDropdown<CounterValue>(
                          controller: TextEditingController(
                            text:
                                controller.selectedCounter.value?.counterName ??
                                '',
                          ),
                          focusNode: controller.transerToFocusNode,
                          items: counters,
                          getDisplayValue:
                              (CounterValue counter) =>
                                  counter.counterName ?? '',
                          // autofocus: true,
                          onSelected: (CounterValue value) {
                            controller.setSelectedCounter(value);
                            controller.transerByFocusNode.requestFocus();
                          },
                          enabled: true,
                          isLastRow: true,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          fieldHeight: 38.0,
                          borderColor: secondaryColor,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Transfer To is required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(width: 12),
                Obx(() {
                  final employees =
                      controller.getEmployeesResponse.value.data?.values ?? [];
                  return SizedBox(
                    width: Get.width * 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            CustomText(
                              text: 'Transfer By',
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        GenericAutocompleteDropdown<GetEmployeesValue>(
                          controller: TextEditingController(
                            text:
                                controller.selectedEmployee.value != null
                                    ? '${controller.selectedEmployee.value?.firstName ?? ''} ${controller.selectedEmployee.value?.lastName ?? ''}'
                                    : '',
                          ),
                          focusNode: controller.transerByFocusNode,
                          items: employees,
                          getDisplayValue:
                              (GetEmployeesValue employee) =>
                                  '${employee.firstName ?? ''} ${employee.lastName ?? ''}',
                          onSelected: (GetEmployeesValue value) {
                            controller.setSelectedEmployee(value);
                            itemDetailsController
                                .controllers
                                .firstOrNull
                                ?.tableFocusNodes
                                .firstOrNull
                                ?.requestFocus();
                            itemDetailsController.currentColIndex.value = 0;
                            itemDetailsController.currentRowIndex.value = 0;
                          },
                          enabled: true,
                          isLastRow: true,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          fieldHeight: 38.0,
                          borderColor: secondaryColor,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Transfer By is required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                        ),
                      ],
                    ),
                  );
                }),
                const Spacer(),
                const CustomText(text: "Item Scanning", color: greenColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ... rest of the code
}
