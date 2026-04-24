import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view_model/view_sales_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class ViewSalesSearchPartyDropdown extends StatelessWidget {
  // final CreateSalesEstimationSearchPartyController controller;

  const ViewSalesSearchPartyDropdown({
    super.key,
    // required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ViewSalesController viewSalesController =
        Get.find<ViewSalesController>();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Customer Details",
              color: blackColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            const SizedBox(height: 8),
            Container(
              width: constraints.maxWidth,
              height: 38,
              decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF5F5F5),
              ),
              child: Obx(() {
                final response =
                    viewSalesController
                        .getSalesRecordByIdAggregateResponse
                        .value;

                if (response.status == Status.LOADING) {
                  return const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                if (response.status == Status.ERROR) {
                  return const Center(
                    child: Text(
                      'Error loading customer details',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final salesRecord = response.data;
                if (salesRecord == null) {
                  return const Center(
                    child: Text('No customer details available'),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor:
                              salesRecord.partyType == 'CUSTOMER'
                                  ? primaryColor
                                  : tertiaryColor,
                          child: Text(
                            salesRecord.partyType?.substring(0, 1) ?? '-',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${salesRecord.partyDetails?.name ?? 'No Name'} - ${salesRecord.partyDetails?.phoneNumber ?? 'No Phone'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
