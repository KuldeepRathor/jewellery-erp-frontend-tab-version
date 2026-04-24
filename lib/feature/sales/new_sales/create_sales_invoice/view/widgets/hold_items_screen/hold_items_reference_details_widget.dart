import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_customer_info_card_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/hold_items_reference_party_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/hold_items_reference_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class HoldItemsReferenceDetailsWidget extends StatelessWidget {
  HoldItemsReferenceDetailsWidget({super.key});

  final HoldItemsReferencePartyController holdItemsReferencePartyController =
      Get.find<HoldItemsReferencePartyController>();
  final CreateSalesViewModel createSalesViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reference Details',
                  style: TextStyle(
                    color: Color(0xFF1C1B1F),
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: getDeviceWidth(context) * 0.45,
                  child: HoldItemsReferencePartyDropdown(
                    controller: holdItemsReferencePartyController,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  CustomerSearchValue? customerSearchValue;
                  VendorSearchValue? vendorSearchValue;
                  if (holdItemsReferencePartyController.selectedParty.value
                      is CustomerSearchValue) {
                    customerSearchValue =
                        holdItemsReferencePartyController.selectedParty.value;
                  } else {
                    vendorSearchValue =
                        holdItemsReferencePartyController.selectedParty.value;
                  }
                  return CustomerInfoCard(
                    width: getDeviceWidth(context) * 0.45,
                    customerName:
                        customerSearchValue?.name ??
                        vendorSearchValue?.name ??
                        '-',
                    sgstNumber:
                        customerSearchValue?.gstNumber ??
                        vendorSearchValue?.gstNumber ??
                        "-",
                    address:
                        customerSearchValue
                            ?.address
                            ?.firstOrNull
                            ?.addressLine1 ??
                        vendorSearchValue?.address?.firstOrNull?.addressLine1 ??
                        '-',
                    balancePayment:
                        holdItemsReferencePartyController
                            .getPartyBalanceResponse
                            .value
                            .data
                            ?.values
                            ?.firstOrNull
                            ?.balanceDifference ??
                        "-",
                    onViewLedger: () {
                      // Handle ledger view action
                    },
                    onEdit: () {
                      // Handle edit action
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
