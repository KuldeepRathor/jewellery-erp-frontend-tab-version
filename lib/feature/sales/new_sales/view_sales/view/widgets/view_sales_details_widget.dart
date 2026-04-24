import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view/widgets/view_sales_customer_info_card_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view/widgets/view_sales_search_mobile_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view_model/view_sales_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class ViewSalesDetailsWidget extends StatelessWidget {
  ViewSalesDetailsWidget({super.key});

  final CreateSalesEstimationSearchPartyController
  createSalesEstimationSearchPartyController =
      Get.find<CreateSalesEstimationSearchPartyController>();
  final CreateSalesViewModel createSalesViewModel =
      Get.find<CreateSalesViewModel>();
  final ViewSalesController viewSalesController =
      Get.find<ViewSalesController>();

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
                const Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: ViewSalesSearchPartyDropdown(
                        // controller: createSalesEstimationSearchPartyController,
                      ),
                    ),
                  ],
                ),

                // mode estimate number
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(color: grey2, height: 60, width: 2),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const CustomText(
                          text: "Sales Number:",
                          fontSize: 12,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Obx(() {
                              final response =
                                  viewSalesController
                                      .getSalesRecordByIdAggregateResponse
                                      .value;
                              final salesNumber =
                                  response.data?.saleNumber ?? '-';
                              return CustomText(
                                text: salesNumber,
                                fontSize: 16,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              final response =
                  viewSalesController.getSalesRecordByIdAggregateResponse.value;

              if (response.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }

              if (response.status == Status.ERROR) {
                return const Center(
                  child: Text('Error loading customer details'),
                );
              }

              final salesRecord = response.data;
              if (salesRecord == null) {
                return const SizedBox.shrink();
              }

              return CustomerInfoCard(
                customerName: salesRecord.partyDetails?.name ?? '-',
                sgstNumber: salesRecord.partyDetails?.gstNumber ?? "-",
                address:
                    salesRecord
                        .partyDetails
                        ?.address
                        ?.firstOrNull
                        ?.addressLine1 ??
                    '-',
                balancePayment: ((double.tryParse(
                          salesRecord
                                  .paymentDetails
                                  ?.firstOrNull
                                  ?.balanceAmount ??
                              "0",
                        ) ??
                        0)
                    .toStringAsFixed(2)),
                onViewLedger: () {},
              );
            }),
          ],
        ),
      ),
    );
  }
}
