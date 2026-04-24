import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/model/get_settlement_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class SettlementsAccountsController extends GetxController {
  final isUpdating = false.obs;
  final isLoading = false.obs;

  final OrganizationRepository _organizationRepository =
      OrganizationRepository();

  final headers = ['Account Name', 'Account No', 'IFSC'].obs;

  final columnWidths =
      [
        0.5, // Account Name
        0.5, // Account No
        0.5, // IFSC
      ].obs;

  // Updated to handle GetSettlementDetailsResponse
  final settlementDetailsResponse =
      Rx<ApiResponse<GetSettlementDetailsResponse>>(
        ApiResponse.initial("INITIAL"),
      );

  @override
  void onInit() {
    super.onInit();
    log("Settlement Accounts Controller initiated");
    getSettlementDetails();
  }

  @override
  void onClose() {
    log("Settlement Accounts Controller Deleted");
    super.onClose();
  }

  TableRow buildTableHeaders() {
    log("The controllers length : ${headers.length} ");
    List<Widget> cells = [];

    for (int i = 0; i < headers.length; i++) {
      cells.add(
        Row(
          children: [
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  List<TableRow> buildRows(BuildContext context) {
    // Since we're dealing with a single settlement detail, return single row
    if (settlementDetailsResponse.value.data != null) {
      return [buildTableRow(0)];
    }
    return [];
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final settlementDetail = settlementDetailsResponse.value.data;

    log("The settlement value is : ${settlementDetail?.toJson()}");

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      Color textColor = Colors.black;
      Widget cellWidget;

      switch (i) {
        case 0:
          // Account Name
          cellContent = settlementDetail?.accountName ?? "-";
          cellWidget = Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Tooltip(
              message: cellContent,
              child: CustomText(
                text: cellContent,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          );
          break;

        case 1:
          // Account Number
          cellContent = settlementDetail?.accountNumber ?? "-";
          cellWidget = Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Tooltip(
              message: cellContent,
              child: CustomText(
                text: cellContent,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          );
          break;

        case 2:
          // IFSC
          cellContent = settlementDetail?.ifsc ?? "-";
          cellWidget = Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Tooltip(
              message: cellContent,
              child: CustomText(
                text: cellContent,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          );
          break;

        default:
          cellWidget = Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Tooltip(
              message: cellContent,
              child: CustomText(
                text: cellContent,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          );
      }

      cells.add(
        Column(
          children: [
            Row(
              children: [
                if (i != 0) const SizedBox(width: 4),
                Flexible(child: cellWidget),
              ],
            ),
            if (i <
                headers.length - 1) // Don't add dashed line after last column
              CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  // Method to get settlement details
  Future<void> getSettlementDetails() async {
    settlementDetailsResponse.value = ApiResponse.loading("LOADING");
    isLoading.value = true;

    try {
      final response = await _organizationRepository.getSettlementDetails();
      settlementDetailsResponse.value = ApiResponse.completed(response);
      log("Successfully loaded settlement details");
    } catch (e) {
      log("Error getting settlement details: $e");
      settlementDetailsResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
