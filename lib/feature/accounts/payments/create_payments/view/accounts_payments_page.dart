import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/account_payments_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/account_payments_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/account_payments_line_item_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view_model/account_payment_details_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view_model/account_payment_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view_model/accounts_payment_line_item_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

class AccountsPaymentsPage extends StatefulWidget {
  const AccountsPaymentsPage({super.key, this.partyDetails});
  final dynamic partyDetails; // Can be CustomerSearchValue or VendorSearchValue

  @override
  State<AccountsPaymentsPage> createState() => _AccountsPaymentsPageState();
}

class _AccountsPaymentsPageState extends State<AccountsPaymentsPage> {
  final AccountPaymentViewmodel accountPaymentViewmodel = Get.put(
    AccountPaymentViewmodel(),
  );
  final AccountPaymentDetailsController accountPaymentDetailsController =
      Get.put(AccountPaymentDetailsController());
  final AccountsPaymentLineItemController controller = Get.put(
    AccountsPaymentLineItemController(),
  );

  void _showPaymentDetailsDialog() {
    List<String> errors = [];

    // Check all conditions and collect errors
    // if (accountPaymentViewmodel.selectedSelfParty.value == null) {
    //   errors.add("Please select From Party");
    // }

    if (accountPaymentViewmodel.selectedVendorParty.value == null) {
      errors.add("Please select To Party");
    }

    if (accountPaymentViewmodel.paymentDateController.text.trim().isEmpty) {
      errors.add("Please select Payment Date");
    }

    if (accountPaymentViewmodel.getPartyDetailsResponse.value.status !=
        Status.COMPLETED) {
      errors.add("Please wait for party details to load");
    }

    // If there are errors, show them all in a single toast
    if (errors.isNotEmpty) {
      for (var element in errors) {
        showErrorToast(message: element);
      }
      return;
    }

    // All validations passed, show dialog
    Get.dialog(const AccountPaymentDetailsDialog());
  }

  @override
  void initState() {
    super.initState();
    accountPaymentDetailsController.clearAllControllers();
    accountPaymentViewmodel.fetchPaymentNumber();
    accountPaymentViewmodel.setCurrentDate();
    accountPaymentViewmodel.fetchPartyItems(query: "");

    if (widget.partyDetails != null) {
      if (widget.partyDetails is CustomerSearchValue) {
        accountPaymentViewmodel.onVendorPartyChanged(
          widget.partyDetails as CustomerSearchValue,
        );
      } else if (widget.partyDetails is VendorSearchValue) {
        accountPaymentViewmodel.onVendorPartyChanged(
          widget.partyDetails as VendorSearchValue,
        );
      }
    }
  }

  @override
  void dispose() {
    accountPaymentViewmodel.clearControllers();

    accountPaymentDetailsController.clearAllControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const SaveAccountPaymentDetailsIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
            const DiscardIntent(),
      },
      child: Actions(
        actions: {
          SaveAccountPaymentDetailsIntent:
              CallbackAction<SaveAccountPaymentDetailsIntent>(
                onInvoke: (intent) {
                  _showPaymentDetailsDialog();
                  return null;
                },
              ),
          DiscardIntent: CallbackAction<DiscardIntent>(
            onInvoke: (intent) {
              accountPaymentViewmodel.clearControllers();
              return;
            },
          ),
        },
        child: FocusScope(
          autofocus: true,
          child: Scaffold(
            body: Column(
              children: [
                HeaderWidget(
                  header: "Payments",
                  wantBackButton: true,
                  onBackButtonTap: () {
                    SidebarController sidebarController = Get.find();
                    sidebarController.popBackSelectedWidget();
                  },
                ),
                const AccountPaymentsDetailsWidget(),
                Expanded(child: AccountsPaymentLineItemTableWidget()),
                _footerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: whiteColor,
      child: Row(
        children: [
          Container(
            height: 38,
            width: 140,
            decoration: BoxDecoration(
              color: grey1,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                Get.dialog(const AddRemarkDialog());
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, color: primaryColor),
                  SizedBox(width: 6),
                  CustomText(
                    text: "Remarks",
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(width: Get.width * 0.01),
          InkWell(
            onTap: () {
              accountPaymentViewmodel.clearControllers();
            },
            child: Container(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: CustomText(
                  text: "Discard",
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: Get.width * 0.01),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showPaymentDetailsDialog,
              borderRadius: BorderRadius.circular(8),
              child: Ink(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 38,
                width: 140,
                child: Center(
                  child: ButtonShortcutWidget(
                    buttonName: "Next",
                    shortcut: "Ctrl + S",
                    buttonsize: 16,
                    color: whiteColor,
                    shortcutButtonColor: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
