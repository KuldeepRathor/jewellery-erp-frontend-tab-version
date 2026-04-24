import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/model/get_account_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/view/add_new_bank_acccount_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class BankAccountsController extends GetxController {
  final isUpdating = false.obs;
  final isLoading = false.obs;

  final OrganizationRepository _organizationRepository =
      OrganizationRepository();

  final headers =
      [
        'Payment Code',
        "Account Name",
        'Account No',
        'IFSC',
        'Branch',
        'Status',
        '',
      ].obs;

  final columnWidths =
      [
        0.4, // Payment Code
        0.5, // Account Name
        0.5, // Account No
        0.5, // IFSC
        0.5, // Branch
        0.4, // Status
        0.10, // Actions
      ].obs;

  // Updated to handle list response correctly
  final accountSettingsResponse =
      Rx<ApiResponse<List<GetAccountSettingsResponse>>>(
        ApiResponse.initial("INITIAL"),
      );

  // Add/Update response
  final addAccountResponse = Rx<ApiResponse<GetAccountSettingsResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  // Get single account response
  final getAccountByIdResponse = Rx<ApiResponse<GetAccountSettingsResponse>>(
    ApiResponse.initial("INITIAL"),
  );

  @override
  void onInit() {
    super.onInit();
    log("Bank Accounts Controller initiated");
    getAccountSettingsList();
  }

  @override
  void onClose() {
    log("Bank Accounts Controller Deleted");
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
    return List.generate(
      accountSettingsResponse.value.data?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["Edit", "Delete"];

  void editAccount(String accountId) {
    log("Edit account: $accountId");
    // Open edit dialog with account data
    Get.dialog(AddBankAccountDialog(accountId: accountId));
  }

  void deleteAccount(String accountId) {
    Get.dialog(
      CancelPaymentDialog(
        subtitle: 'Are you sure you want to delete this account?',
        onYesPressed: () async {
          await deleteAccountSettings(accountId);
        },
      ),
    );
  }

  // Method to get account by ID for editing
  Future<void> getAccountById(String accountId) async {
    try {
      getAccountByIdResponse.value = ApiResponse.loading("Loading account...");

      final response = await _organizationRepository.getAccountSettingsById(
        accountId,
      );

      getAccountByIdResponse.value = ApiResponse.completed(response);
      log("Successfully loaded account details for ID: $accountId");
    } catch (e) {
      log("Error getting account by ID: $e");
      getAccountByIdResponse.value = ApiResponse.error(e.toString());
      showErrorToast(
        message: 'Failed to load account details: ${e.toString()}',
      );
    }
  }

  // Method to add bank account using response model
  Future<void> addBankAccount(GetAccountSettingsResponse accountData) async {
    try {
      isLoading.value = true;
      addAccountResponse.value = ApiResponse.loading("Adding account...");

      // Create request model with required fields and account type
      final requestModel = GetAccountSettingsResponse(
        paymentCode: accountData.paymentCode,
        accountName: accountData.accountName,
        accountNumber: accountData.accountNumber,
        ifsc: accountData.ifsc,
        branch: accountData.branch,
        accountType: "bank", // Set account type as bank
      );

      final response = await _organizationRepository.createAccountSettings(
        requestModel,
      );

      addAccountResponse.value = ApiResponse.completed(response);

      // Refresh the list after successful addition
      await getAccountSettingsList();

      showSuccessToast(message: 'Bank account added successfully');
    } catch (e) {
      log("Error adding bank account: $e");
      addAccountResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to add bank account: ${e.toString()}');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Method to update bank account using response model
  Future<void> updateBankAccount(
    String accountId,
    GetAccountSettingsResponse accountData,
  ) async {
    try {
      isLoading.value = true;
      addAccountResponse.value = ApiResponse.loading("Updating account...");

      // Create request model with required fields only (no ID)
      final requestModel = GetAccountSettingsResponse(
        paymentCode: accountData.paymentCode,
        accountName: accountData.accountName,
        accountNumber: accountData.accountNumber,
        ifsc: accountData.ifsc,
        branch: accountData.branch,
      );

      final response = await _organizationRepository.updateAccountSettingsbyId(
        accountId,
        requestModel,
      );

      addAccountResponse.value = ApiResponse.completed(response);

      // Refresh the list after successful update
      await getAccountSettingsList();

      showSuccessToast(message: 'Bank account updated successfully');
    } catch (e) {
      log("Error updating bank account: $e");
      addAccountResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to update bank account: ${e.toString()}');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Updated method to toggle account status using dedicated status API
  Future<void> toggleAccountStatus(String accountId, bool currentStatus) async {
    try {
      isUpdating.value = true;

      // Use the dedicated status update API
      await _organizationRepository.updateStatusAccountSettings(
        accountId,
        !currentStatus, // Toggle the status
      );

      // Find the account in local data and update it
      final accountIndex = accountSettingsResponse.value.data?.indexWhere(
        (account) => account.id == accountId,
      );

      if (accountIndex != null && accountIndex != -1) {
        // Update local data to reflect the change immediately
        accountSettingsResponse.value.data![accountIndex].isActive =
            !currentStatus;
        accountSettingsResponse.refresh();
      }

      showSuccessToast(message: 'Account status updated successfully');
    } catch (e) {
      log("Error updating account status: $e");
      showErrorToast(
        message: 'Failed to update account status: ${e.toString()}',
      );

      // Revert the UI change if API call failed by refreshing the list
      await getAccountSettingsList();
    } finally {
      isUpdating.value = false;
    }
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final accountDetail = accountSettingsResponse.value.data?.elementAt(index);

    log("The account value is : ${accountDetail?.toJson()}");

    for (int i = 0; i < headers.length - 1; i++) {
      String cellContent = "-";
      Color textColor = Colors.black;
      Widget cellWidget;

      switch (i) {
        case 0:
          // Payment Code
          cellContent = accountDetail?.paymentCode ?? "-";
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
          // Account Name
          cellContent = accountDetail?.accountName ?? "-";
          textColor = secondaryColor;
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
          // Account Number
          cellContent = accountDetail?.accountNumber ?? "-";
          textColor = secondaryColor;
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
        case 3:
          // IFSC
          cellContent = accountDetail?.ifsc ?? "-";
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
        case 4:
          // Branch
          cellContent = accountDetail?.branch ?? "-";
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

        case 5:
          // Status - Toggle Switch
          final isActive = accountDetail?.isActive ?? false;
          cellWidget = Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Text(
                  isActive ? "Active" : "Disable",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                CustomToggleSwitch(
                  value: isActive,
                  onChanged:
                      isUpdating.value
                          ? (_) {} // Disable when updating
                          : (newValue) {
                            toggleAccountStatus(
                              accountDetail?.id ?? "",
                              isActive,
                            );
                          },
                ),
              ],
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
            CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }

    // Actions column
    cells.add(
      Column(
        children: [
          const SizedBox(height: 8),
          Theme(
            data: ThemeData(
              focusColor: greyTextColor,
              tooltipTheme: const TooltipThemeData(
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
            child: CustomPopupMenuButtonWidget<String>(
              icon: const Icon(Icons.more_vert),
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    ...popUpValues.map((element) {
                      return PopupMenuItem<String>(
                        value: element,
                        height: 0,
                        child: SizedBox(
                          width: 88,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                element,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (element != popUpValues.last)
                                CustomDashedLineWidget(width: Get.width),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
              onSelected: (String value) {
                switch (value) {
                  case 'Edit':
                    editAccount(accountDetail?.id ?? "");
                    break;
                  case 'Delete':
                    deleteAccount(accountDetail?.id ?? "");
                    break;
                }
              },
            ),
          ),
          const SizedBox(height: 7),
          CustomDashedLineWidget(width: Get.width),
        ],
      ),
    );

    return TableRow(children: cells);
  }

  Future<void> deleteAccountSettings(String accountId) async {
    try {
      await _organizationRepository.deleteAccountSettingsbyId(accountId);

      // Refresh the list after successful deletion
      await getAccountSettingsList();
      showSuccessToast(message: 'Account deleted successfully');
    } catch (e) {
      log("Error deleting account: $e");
      showErrorToast(message: 'Failed to delete account: ${e.toString()}');
    }
  }

  // Method to get list of accounts
  Future<void> getAccountSettingsList() async {
    accountSettingsResponse.value = ApiResponse.loading("LOADING");
    isLoading.value = true;

    try {
      final response = await _organizationRepository.getAccountSettingsList(
        accountType: "bank",
      );

      accountSettingsResponse.value = ApiResponse.completed(response);
      log("Successfully loaded ${response.length} accounts");
    } catch (e) {
      log("Error getting account settings: $e");
      accountSettingsResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
