import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/estimation_rate_carat_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view/widgets/create_order_search_party_dropdown.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view/widgets/order_customer_info_card.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class CreateOrderDetailsWidget extends StatelessWidget {
  final CreateOrderViewModel controller;
  final CreateOrderPartyDetailsController partyDetailsController;
  final RateCaratInputController rateCaratInputController;

  const CreateOrderDetailsWidget({
    super.key,
    required this.controller,
    required this.partyDetailsController,
    required this.rateCaratInputController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * 0.2,
                child: CreateOrderSearchPartyDropdown(
                  controller: partyDetailsController,
                  focusNode: controller.partyDetailsFocusNode,
                  nextFocusNode: controller.employeeFocusNode,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "Order Taken By",
                    color: primaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  Obx(() {
                    return SizedBox(
                      width: Get.width * .125,
                      child: GenericAutocompleteDropdown<GetEmployeesValue>(
                        controller: controller.employeeSearchController.value,
                        focusNode: controller.employeeFocusNode,
                        items: const [],
                        getDisplayValue:
                            (employee) =>
                                '${employee.firstName ?? ''} ${employee.lastName ?? ''}',
                        onSelected: (value) async {
                          controller.setSelectedEmployee(value);
                          // controller.commodityTypeFocusNode.requestFocus();

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (Get.isRegistered<
                              CreateOrderItemDetailsController
                            >()) {
                              final itemDetailsController =
                                  Get.find<CreateOrderItemDetailsController>();
                              itemDetailsController.requestFirstFocus();
                            }
                          });
                        },
                        customOptionsBuilder: (textEditingValue) async {
                          await controller.searchEmployees(
                            textEditingValue.text,
                          );
                          return controller.employeeOptions.toList();
                        },
                        borderColor: secondaryColor,
                        isLastRow: true,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(width: 16),
              Obx(
                () => RateCaratInput(
                  readOnly: !controller.RateFixMode.value,
                  onChanged: (rate, carat) {
                    if (controller.RateFixMode.value) {
                      final itemDetailsController =
                          Get.find<CreateOrderItemDetailsController>();
                      itemDetailsController.onRateChanged(rate, carat);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              CustomDropdownField(
                focusNode: controller.commodityTypeFocusNode,
                name: 'Metal Type',
                width: Get.width * .1,
                items: controller.commodityTypes,
                selectedItem: controller.selectedCommodity.value,
                onChanged: (value) {
                  controller.onCommodityChanged(value);
                  controller.orderDateFocusNode.requestFocus();
                },
              ),
              const SizedBox(width: 16),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const CustomText(
                        text: "Booking Type (ALT+F):",
                        fontSize: 12,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => Row(
                          children: [
                            CustomText(
                              text: "Rate Unfix",
                              fontSize: 14,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                              color:
                                  controller.RateFixMode.value == false
                                      ? redTextColor
                                      : grey2,
                            ),
                            const SizedBox(width: 16),
                            CustomToggleSwitch(
                              // focusNode: focusNode,
                              canRequestFocus: false,
                              value: controller.RateFixMode.value,
                              onChanged: (_) {
                                controller.toggleFastMode();
                              },
                            ),
                            const SizedBox(width: 16),
                            CustomText(
                              text: "Rate Fix",
                              fontSize: 14,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                              color:
                                  controller.RateFixMode.value
                                      ? totalGreenColor
                                      : grey2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: Get.width * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const CustomText(
                        text: "Date: ",
                        fontSize: 12,
                        color: blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: Get.height * 0.01),
                      InkWell(
                        onTap: () {
                          controller.selectDate(
                            context,
                            controller.orderDateController,
                          );
                        },
                        child: Focus(
                          focusNode: controller.orderDateFocusNode,
                          onKeyEvent: (node, event) {
                            if (event is KeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.enter) {
                              controller.employeeFocusNode.requestFocus();
                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                          child: AbsorbPointer(
                            child: SizedBox(
                              height: 34,
                              width: Get.width * 0.1,
                              child: TextField(
                                controller: controller.orderDateController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: secondaryColor,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: secondaryColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPartyDetailsDisplay(),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const CustomText(text: "Order No:"),
                  const SizedBox(height: 4),
                  Obx(
                    () => CustomText(
                      text: controller.invoiceNumber.value,
                      fontSize: 18,
                      color: primaryBtnColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartyDetailsDisplay() {
    return Obx(() {
      final selectedParty = partyDetailsController.selectedParty.value;
      if (selectedParty == null) {
        return const SizedBox.shrink();
      }

      CustomerSearchValue? customerSearchValue;
      VendorSearchValue? vendorSearchValue;

      if (selectedParty is CustomerSearchValue) {
        customerSearchValue = selectedParty;
      } else if (selectedParty is VendorSearchValue) {
        vendorSearchValue = selectedParty;
      }

      return OrderCustomerInfoCard(
        customerName:
            customerSearchValue?.name ?? vendorSearchValue?.name ?? '-',
        sgstNumber:
            customerSearchValue?.gstNumber ??
            vendorSearchValue?.gstNumber ??
            "-",
        address:
            customerSearchValue?.address?.firstOrNull?.addressLine1 ??
            vendorSearchValue?.address?.firstOrNull?.addressLine1 ??
            '-',
        pan:
            customerSearchValue?.panNumber ??
            vendorSearchValue?.panNumber ??
            "-",
        onViewLedger: () {
          // Handle ledger view action
          // You can implement this later or leave it empty for now
        },
        onEdit: () {
          if (selectedParty is CustomerSearchValue) {
            Get.dialog(AddCustomerDialog(customerId: selectedParty.id));
          } else if (selectedParty is VendorSearchValue) {
            Get.dialog(AddVendorDialog(vendorId: selectedParty.id));
          }
        },
      );
    });
  }
}
