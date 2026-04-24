import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view/widgets/sales_return_bottom_sticky_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view/widgets/sales_return_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view/widgets/sales_return_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view/widgets/sales_return_payment_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view/widgets/sales_return_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

// Define Intent
class SaveSalesReturnIntent extends Intent {
  const SaveSalesReturnIntent();
}

class DiscardSalesReturnIntent extends Intent {
  const DiscardSalesReturnIntent();
}

class SaveAction extends Action<SaveSalesReturnIntent> {
  SaveAction(this.onSave);

  final VoidCallback onSave;

  @override
  void invoke(SaveSalesReturnIntent intent) {
    onSave();
  }
}

class DiscardAction extends Action<DiscardSalesReturnIntent> {
  DiscardAction(this.onDiscard);

  final VoidCallback onDiscard;

  @override
  void invoke(DiscardSalesReturnIntent intent) {
    onDiscard();
  }
}

class SalesReturnPage extends StatefulWidget {
  const SalesReturnPage({super.key});

  @override
  State<SalesReturnPage> createState() => _SalesReturnPageState();
}

class _SalesReturnPageState extends State<SalesReturnPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final SalesReturnViewmodel salesReturnViewmodel = Get.put(
    SalesReturnViewmodel(),
  );
  final SalesReturnSearchPartyController salesReturnSearchPartyController =
      Get.put(SalesReturnSearchPartyController());
  final SalesReturnItemDetailsController salesReturnItemDetailsController =
      Get.put(SalesReturnItemDetailsController());
  final SalesReturnPaymentDetailsController controller = Get.put(
    SalesReturnPaymentDetailsController(),
  );
  final RateCaratInputController rateCaratInputController = Get.put(
    RateCaratInputController(),
  );

  void handleSaveAction() {
    bool isItemListEmpty = false;
    isItemListEmpty =
        salesReturnItemDetailsController.controllers
            .where((element) => element.isSelected)
            .isEmpty;

    bool isEmployeeSelected =
        salesReturnSearchPartyController.selectedEmployee.value != null;

    if (salesReturnSearchPartyController.selectedParty.value != null &&
        isItemListEmpty == false &&
        isEmployeeSelected == true) {
      Get.dialog(const SalesReturnPaymentDetailsDialog());
    } else {
      if (isItemListEmpty) {
        showErrorToast(message: "No Items selected !");
      }
      if (salesReturnSearchPartyController.selectedParty.value == null) {
        showErrorToast(message: "Please select a Party");
      }
      if (isEmployeeSelected == false) {
        showErrorToast(message: "Please select Sales Person !");
      }
    }
  }

  void handleDiscardAction() {
    salesReturnItemDetailsController.clearControllers();
    salesReturnSearchPartyController.clearControllers();
    salesReturnViewmodel.clearControllers();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    salesReturnViewmodel.fetchSalesReturnNumber();
    salesReturnViewmodel.clearControllers();
    salesReturnItemDetailsController.clearControllers();
    salesReturnSearchPartyController.clearControllers();
    salesReturnSearchPartyController.searchEmployees('');
    salesReturnViewmodel.searchSalesInvoices('');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      salesReturnViewmodel.salesInvoiceFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {}
    if (_tabController.index == 0) {
      // vendorController.getPurchaseInvoice(resetList: true, isSearch: false);
    } else {
      // customerController.getCustomerPurchaseInvoice(
      //   resetList: true,
      //   isSearch: false,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define shortcuts
    final Map<ShortcutActivator, Intent> shortcuts = {
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
          const SaveSalesReturnIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
          const DiscardSalesReturnIntent(),
    };

    // Define actions
    final Map<Type, Action<Intent>> actions = {
      SaveSalesReturnIntent: SaveAction(handleSaveAction),
      DiscardSalesReturnIntent: DiscardAction(handleDiscardAction),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Focus(
          autofocus: true,
          child: Scaffold(
            backgroundColor: grey1,
            body: FocusScope(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SalesReturnHeaderWidget(),
                  // _buildTabBar(),
                  SalesReturnDetailsWidget(),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                      child: SalesReturnTableWidget(),
                    ),
                  ),
                  const Expanded(child: SalesReturnBottomStickyWidget()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
