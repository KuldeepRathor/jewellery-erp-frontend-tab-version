import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_service_create/view_model/service_vendor_bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_calendar.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class ServiceVendorBillDetailsWidget extends StatelessWidget {
  const ServiceVendorBillDetailsWidget({super.key, this.focusNode});
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final ServiceVendorBillDetailsWidgetController controller =
        Get.find<ServiceVendorBillDetailsWidgetController>();

    return Focus(
      onKeyEvent: onNormalKeyEvent,
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
                      Obx(
                        () => Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Invoice No: ',
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: controller.invoiceNumber.value,
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                            PermissionGuardUtil.withActionPermission(6154, () {
                              controller.selectDate(
                                context,
                                controller.invoiceCreatedController,
                              );
                            });
                          },
                        ),
                      ),

                      //  Expanded(
                      //   child: buildDateField(
                      //     label: "Invoice Created",
                      //     controller: controller.invoiceCreatedController,
                      //     validationMessage: "Please select invoice date",
                      //   ),
                      // ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: CustomDateField(
                          controller: controller.invoiceReceivedController,
                          labelText: "Invoice Received",
                          onTap: (context) {
                            PermissionGuardUtil.withActionPermission(6154, () {
                              controller.selectDate(
                                context,
                                controller.invoiceReceivedController,
                              );
                            });
                          },
                        ),
                      ),
                      // Expanded(
                      //   child: InvoiceDateField(
                      //     controller: controller,
                      //     dateController: controller.invoiceReceivedController,
                      //     labelText: "Invoice Received",
                      //   ),
                      // ),
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
}
