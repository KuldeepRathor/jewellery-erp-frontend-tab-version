import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/hold_items_add_more_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/hold_items_customer_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/hold_items_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/hold_items_reference_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/hold_items_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/hold_items_screen/hold_items_total_footer_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/hold_items_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

// Define a new intent for saving
class SaveHoldItemsIntent extends Intent {
  const SaveHoldItemsIntent();
}

class SaveHoldItemsWithOGHeldIntent extends Intent {
  const SaveHoldItemsWithOGHeldIntent();
}

class AddOtherHoldItemsIntent extends Intent {
  const AddOtherHoldItemsIntent();
}

class DiscardHoldItemsIntent extends Intent {
  const DiscardHoldItemsIntent();
}

// Define the action that will be performed
class SaveAction extends Action<SaveHoldItemsIntent> {
  SaveAction(this.onSave);

  final VoidCallback onSave;

  @override
  void invoke(SaveHoldItemsIntent intent) {
    onSave();
  }
}

class CreateSalesHoldItemsScreen extends StatefulWidget {
  const CreateSalesHoldItemsScreen({super.key});

  @override
  State<CreateSalesHoldItemsScreen> createState() =>
      _CreateSalesHoldItemsScreenState();
}

class _CreateSalesHoldItemsScreenState
    extends State<CreateSalesHoldItemsScreen> {
  final HoldItemDetailsController holdItemDetailsController =
      Get.find<HoldItemDetailsController>();

  final SalesPaymentDetailsController salesPaymentDetailsController =
      Get.find<SalesPaymentDetailsController>();

  @override
  Widget build(BuildContext context) {
    // Define the shortcuts
    final Map<ShortcutActivator, Intent> shortcuts = {
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
          const SaveHoldItemsIntent(),
      LogicalKeySet(
            LogicalKeyboardKey.control,
            LogicalKeyboardKey.shift,
            LogicalKeyboardKey.keyS,
          ):
          const SaveHoldItemsWithOGHeldIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.f10):
          const AddOtherHoldItemsIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
          const DiscardHoldItemsIntent(),
    };

    // Define the actions
    final Map<Type, Action<Intent>> actions = {
      SaveHoldItemsIntent: SaveAction(() {
        holdItemDetailsController.submitHoldingData(isHeld: false);
      }),
      SaveHoldItemsWithOGHeldIntent:
          CallbackAction<SaveHoldItemsWithOGHeldIntent>(
            onInvoke: (intent) async {
              // Implement save functionality here
              await holdItemDetailsController.submitHoldingData(isHeld: true);
              return;
            },
          ),
      AddOtherHoldItemsIntent: CallbackAction<AddOtherHoldItemsIntent>(
        onInvoke: (intent) async {
          // Implement save functionality here
          await Get.dialog(AddMoreItemsDialog());
          return;
        },
      ),
      DiscardHoldItemsIntent: CallbackAction<DiscardHoldItemsIntent>(
        onInvoke: (intent) async {
          // Implement save functionality here
          holdItemDetailsController.clearControllers();

          Get.back();
          return;
        },
      ),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: FocusScope(
          autofocus: true,
          child: Scaffold(
            backgroundColor: grey1,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HoldItemsHeaderWidget(),
                HoldItemsCustomerDetailsWidget(),
                HoldItemsReferenceDetailsWidget(),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                    child: HoldItemsTableWidget(),
                  ),
                ),
                Obx(
                  () => HoldItemsFooterWidget(
                    totalPriceValue:
                        holdItemDetailsController.totalHeadersValue[2],
                    onPrimaryBtnTap: () {
                      holdItemDetailsController.submitHoldingData(
                        isHeld: false,
                      );
                    },
                    primaryBtnText: "Save",
                    onDiscardTap: () {
                      // SalesPaymentDetailsController
                      //     salesPaymentDetailsController =
                      //     Get.find<SalesPaymentDetailsController>();
                      // salesPaymentDetailsController.clearAllControllers(
                      //     invoiceType: "");
                      holdItemDetailsController.clearControllers();
                      // SidebarController sidebarController =
                      //     Get.find<SidebarController>();
                      // sidebarController.popBackSelectedWidget();
                      Get.back();
                    },
                    initialRemarksString: "",
                    onRemarksAdded: (remark) {
                      log("The remarks is $remark");
                    },
                    onRemarksDiscarded: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
