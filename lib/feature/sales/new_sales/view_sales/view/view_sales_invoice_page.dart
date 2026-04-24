import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/advance_booking/sales_advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/hold_items_reference_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/hold_items_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/jewellery_plan/sales_jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/old_gold/sales_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/orders/sales_add_order_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/quick_estimate/sales_quick_estimate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/quick_old_gold/sales_quick_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view/widgets/view_sales_bottom_sticky_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view/widgets/view_sales_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view/widgets/view_sales_payment_details_tab.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view/widgets/view_sales_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view_model/view_sales_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewSalesInvoicePage extends StatefulWidget {
  const ViewSalesInvoicePage({super.key, required this.id});
  final String id;
  @override
  State<ViewSalesInvoicePage> createState() => _ViewSalesInvoicePageState();
}

class _ViewSalesInvoicePageState extends State<ViewSalesInvoicePage> {
  final CreateSalesViewModel createSalesViewModel = Get.put(
    CreateSalesViewModel(),
  );
  final CreateSalesEstimationSearchPartyController
  createSalesEstimationSearchPartyController = Get.put(
    CreateSalesEstimationSearchPartyController(),
  );
  final CreateSalesItemDetailsController createSalesItemDetailsController =
      Get.put(CreateSalesItemDetailsController());
  final SalesPaymentDetailsController salesPaymentDetailsController = Get.put(
    SalesPaymentDetailsController(),
  );
  final SalesOldGoldController oldGoldController = Get.put(
    SalesOldGoldController(),
  );
  final SalesAdvanceBookingController advanceBookingController = Get.put(
    SalesAdvanceBookingController(),
  );
  final SalesJewelleryPlanController jewelleryPlanController = Get.put(
    SalesJewelleryPlanController(),
  );

  final SalesQuickEstimateController salesQuickEstimateController = Get.put(
    SalesQuickEstimateController(),
  );

  final SalesQuickOldGoldController salesQuickOldGoldController = Get.put(
    SalesQuickOldGoldController(),
  );
  final HoldItemsReferencePartyController holdItemsReferencePartyController =
      Get.put(HoldItemsReferencePartyController());
  final HoldItemDetailsController holdItemDetailsController = Get.put(
    HoldItemDetailsController(),
  );
  final RateCaratInputController controller = Get.put(
    RateCaratInputController(),
  );

  final SalesAddOrdersDialogController salesAddOrdersDialogController = Get.put(
    SalesAddOrdersDialogController(),
  );
  final ViewSalesController viewSalesController = Get.put(
    ViewSalesController(),
  );
  final ViewSalesTabController tabController = Get.put<ViewSalesTabController>(
    ViewSalesTabController(),
  );

  @override
  void initState() {
    super.initState();
    createSalesEstimationSearchPartyController.clearControllers();
    createSalesViewModel.fetchSalesNumber();
    createSalesEstimationSearchPartyController.searchEmployees("");

    if (widget.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewSalesController.getSalesRecordByIdAggregate(id: widget.id);
      });
    }
  }

  @override
  void dispose() {
    createSalesItemDetailsController.clearControllers();
    oldGoldController.clearTextController();
    jewelleryPlanController.clearControllers();
    advanceBookingController.clearControllers();
    salesQuickEstimateController.clearControllers();
    salesQuickOldGoldController.clearControllers();
    holdItemDetailsController.clearControllers();
    holdItemsReferencePartyController.clearControllers();
    createSalesViewModel.clearControllers();
    salesPaymentDetailsController.clearAllControllers(
      invoiceType: "invoiceType",
    );
    salesAddOrdersDialogController.clearControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: FocusScope(
        autofocus: true,
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveEstimate: CallbackAction<SaveEstimate>(
              onInvoke: (intent) async {
                // final salesController = createSalesItemDetailsController;
                final partyController =
                    createSalesEstimationSearchPartyController;

                // Collect validation errors
                List<String> validationErrors = [];

                bool isItemsDataValid =
                    createSalesItemDetailsController.validateRow();
                if (isItemsDataValid == false) {
                  validationErrors.add("Invalid Item Data");
                }

                // Check if item list is empty
                bool hasItems =
                    double.parse(
                      createSalesItemDetailsController
                              .controllers
                              .firstOrNull
                              ?.total ??
                          "w",
                    ) !=
                    0;

                if (!hasItems) {
                  validationErrors.add("No Items !");
                }

                // Check if party is selected
                if (partyController.selectedParty.value == null) {
                  validationErrors.add("Please select a Party");
                }

                // Check if employee is selected
                if (partyController.selectedEmployee.value == null) {
                  validationErrors.add("Please select Sales Person !");
                }

                if (createSalesItemDetailsController.hasSoldItems() == true) {
                  validationErrors.add("Sales contains Sold Items");
                }

                // Show dialog if all validations pass, otherwise show errors
                if (validationErrors.isEmpty) {
                  // Get.dialog(const SalesPaymentDetailsDialog());
                } else {
                  for (String error in validationErrors) {
                    showErrorToast(message: error);
                  }
                }
                return;
              },
            ),
            OldGoldDialogIntent: CallbackAction<OldGoldDialogIntent>(
              onInvoke: (intent) async {
                bool isItemsDataValid =
                    createSalesItemDetailsController.validateRow();
                if (isItemsDataValid == false) {
                  showErrorToast(message: "Invalid Item Data");
                  return;
                }
                // Get.dialog(const SalesOldGoldDialog());
                return;
              },
            ),
            AdvanceBookingDialogIntent:
                CallbackAction<AdvanceBookingDialogIntent>(
                  onInvoke: (intent) async {
                    bool isItemsDataValid =
                        createSalesItemDetailsController.validateRow();
                    if (isItemsDataValid == false) {
                      showErrorToast(message: "Invalid Item Data");
                      return;
                    }
                    // Get.dialog(const SalesAdvanceBookingDialog());
                    return;
                  },
                ),
            JewelleryPlanDialogIntent:
                CallbackAction<JewelleryPlanDialogIntent>(
                  onInvoke: (intent) async {
                    bool isItemsDataValid =
                        createSalesItemDetailsController.validateRow();
                    if (isItemsDataValid == false) {
                      showErrorToast(message: "Invalid Item Data");
                      return;
                    }
                    // Get.dialog(const SalesJewelleryPlanDialog());
                    return;
                  },
                ),
            QuickOldGoldEstimateDialogIntent:
                CallbackAction<QuickOldGoldEstimateDialogIntent>(
                  onInvoke: (intent) async {
                    bool isItemsDataValid =
                        createSalesItemDetailsController.validateRow();
                    if (isItemsDataValid == false) {
                      showErrorToast(message: "Invalid Item Data");
                      return;
                    }
                    // Get.dialog(const SalesQuickOldGoldDialog());
                    return;
                  },
                ),
            QuickEstimateIntent: CallbackAction<QuickEstimateIntent>(
              onInvoke: (intent) async {
                // Get.dialog(
                // const SalesQuickEstimateDialog(),
                // );
                return;
              },
            ),
            ToggleCorrectionModeIntent:
                CallbackAction<ToggleCorrectionModeIntent>(
                  onInvoke: (intent) async {
                    PermissionGuardUtil.withActionPermission(1103, () {
                      createSalesViewModel.toggleFastMode();
                    });
                    return;
                  },
                ),
          },
          child: Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.keyS,
                  ):
                  const SaveEstimate(),
              LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.f4):
                  const OldGoldDialogIntent(),
              LogicalKeySet(LogicalKeyboardKey.f8):
                  const QuickOldGoldEstimateDialogIntent(),
              LogicalKeySet(LogicalKeyboardKey.f9):
                  const AdvanceBookingDialogIntent(),
              LogicalKeySet(LogicalKeyboardKey.f10):
                  const JewelleryPlanDialogIntent(),
              LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.f5):
                  const QuickEstimateIntent(),
              LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyF):
                  const ToggleCorrectionModeIntent(),
            },
            child: Focus(
              autofocus: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ViewSalesHeaderWidget(),
                  // _buildTabBar(),
                  ViewSalesDetailsWidget(),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                      child: ViewSalesTabWidget(),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: tabController.currentTabIndex.value == 0,
                      child: const Expanded(
                        child: ViewSalesBottomStickyWidget(),
                      ),
                    ),
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

class ViewSalesTabWidget extends StatefulWidget {
  const ViewSalesTabWidget({super.key});

  @override
  State<ViewSalesTabWidget> createState() => _ViewSalesTabWidgetState();
}

class _ViewSalesTabWidgetState extends State<ViewSalesTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ViewSalesTabController tabController = Get.put(
    ViewSalesTabController(),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        tabController.updateTabIndex(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [Tab(text: 'Item Details'), Tab(text: 'Payments')],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [const ViewSalesTableWidget(), PaymentDetailsWidget()],
          ),
        ),
      ],
    );
  }
}

class ViewSalesHeaderWidget extends StatelessWidget {
  const ViewSalesHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              log("Tapped");
              SidebarController sidebarController = Get.find();
              sidebarController.popBackSelectedWidget();
            },
            child: Container(
              width: 27,
              height: 35,
              decoration: ShapeDecoration(
                color: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const SizedBox(
                width: 15,
                height: 15,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: whiteColor,
                  size: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'View Sales Invoice',
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const Row(
            children: [
              Text(
                'Sales Counter 2',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
