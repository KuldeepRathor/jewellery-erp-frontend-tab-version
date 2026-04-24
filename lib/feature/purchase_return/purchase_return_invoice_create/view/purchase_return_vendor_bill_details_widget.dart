import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/view_model/purchase_return_bill_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sequences_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_calendar.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class PurchaseReturnVendorBillDetailsWidget extends StatefulWidget {
  const PurchaseReturnVendorBillDetailsWidget({super.key, this.focusNode});
  final FocusNode? focusNode;

  @override
  State<PurchaseReturnVendorBillDetailsWidget> createState() =>
      _PurchaseReturnVendorBillDetailsWidgetState();
}

class _PurchaseReturnVendorBillDetailsWidgetState
    extends State<PurchaseReturnVendorBillDetailsWidget> {
  final PurchaseReturnBillDetailsController controller =
      Get.find<PurchaseReturnBillDetailsController>();

  @override
  void initState() {
    super.initState();

    controller.setDefaultDates();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: onNormalKeyEvent,
      canRequestFocus: false,
      child: Form(
        key: controller.formKey,
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: 'Vendor Bill Details',
                        color: blackColor,
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CustomText(
                            text: "Invoice Number:",
                            color: blackColor,
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 200,
                            child: _buildSalesNumberDropdown(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Invoice No.",
                              color: primaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            CustomTextField(
                              borderColor: grey1,
                              width: double.infinity,
                              controller: controller.invoiceNoController,
                              focusNode: controller.invoiceNumberFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Invoice Number";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomDateField(
                          controller: controller.invoiceCreatedController,
                          labelText: "Invoice Created",
                          onTap: (context) {
                            PermissionGuardUtil.withActionPermission(6053, () {
                              controller.selectDate(
                                context,
                                controller.invoiceCreatedController,
                              );
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomDateField(
                          controller: controller.invoiceReceivedController,
                          labelText: "Invoice Received",
                          onTap: (context) {
                            PermissionGuardUtil.withActionPermission(6053, () {
                              controller.selectDate(
                                context,
                                controller.invoiceReceivedController,
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSalesNumberDropdown() {
    return Obx(() {
      final status = controller.sequencesDropdownResponse.value.status;

      if (status == Status.LOADING) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              CustomText(text: 'Loading...', fontSize: 12, color: Colors.grey),
            ],
          ),
        );
      }

      if (status == Status.ERROR) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.red[50],
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[600], size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: CustomText(
                  text: 'Failed to load',
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
              InkWell(
                onTap: () {
                  controller.loadSequencesDropdown();
                },
                child: Icon(Icons.refresh, color: Colors.red[600], size: 16),
              ),
            ],
          ),
        );
      }

      return GenericAutocompleteDropdown<GetSequencesDropdownValue>(
        controller: controller.sequencesDropdownController,
        focusNode: controller.sequencesDropdownFocusNode,
        items: controller.sequencesDropdownList,
        getDisplayValue: (item) => item.value ?? '',
        borderColor: primaryColor,
        onSelected: (item) {
          controller.setSelectedSequence(item);
        },
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.nextFocus();
        },
        validator: (value) {
          if (controller.selectedSequence.value == null ||
              (value?.trim().isEmpty ?? true)) {
            return 'Invoice Number is required';
          }
          return null;
        },
        enabled: controller.sequencesDropdownList.isNotEmpty,
      );
    });
  }
}
