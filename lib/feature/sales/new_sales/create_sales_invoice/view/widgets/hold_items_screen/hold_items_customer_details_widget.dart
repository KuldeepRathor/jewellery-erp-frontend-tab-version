import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class HoldItemsCustomerDetailsWidget extends StatelessWidget {
  HoldItemsCustomerDetailsWidget({super.key});

  final CreateSalesEstimationSearchPartyController
  createSalesEstimationSearchPartyController =
      Get.find<CreateSalesEstimationSearchPartyController>();
  final CreateSalesViewModel createSalesViewModel =
      Get.find<CreateSalesViewModel>();
  final SalesPaymentDetailsController salesPaymentDetailsController =
      Get.find<SalesPaymentDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        // height: 90,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // CustomTextField(
                    //   name: "Rate/gm",
                    //   width: 250,
                    //   autofocus: true,
                    //   // controller: controller.designCodeController,
                    //   // onChanged: (value) => _showRetagDialog(),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Enter Design Code";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    CustomTextField(
                      name: "Customer Name",
                      width: 250,
                      controller: TextEditingController(
                        text:
                            createSalesEstimationSearchPartyController
                                .selectedParty
                                .value
                                ?.name,
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(width: 16),
                    CustomTextField(
                      name: "Phone Number",
                      width: 250,
                      controller: TextEditingController(
                        text:
                            createSalesEstimationSearchPartyController
                                .selectedParty
                                .value
                                ?.phoneNumber ??
                            "",
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(width: 16),
                    CustomTextField(
                      name: "PAN",
                      width: 250,
                      controller: TextEditingController(
                        text:
                            createSalesEstimationSearchPartyController
                                .selectedParty
                                .value
                                ?.panNumber ??
                            "",
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(width: 16),
                    CustomTextField(
                      name: "Balance",
                      width: 250,
                      controller: TextEditingController(
                        text:
                            salesPaymentDetailsController
                                .balanceAmountController
                                .text,
                      ),
                      readOnly: true,
                    ),
                  ],
                ),

                // mode estimate number
              ],
            ),
          ],
        ),
      ),
    );
  }
}
