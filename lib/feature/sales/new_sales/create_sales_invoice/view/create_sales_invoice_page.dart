import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/advance_booking/sales_advance_booking_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/jewellery_plan/sales_jewellery_plan_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/old_gold/sales_old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/quick_estimate/sales_quick_estimate_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/quick_old_gold/sales_quick_old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/additional_less_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_bottom_sticky_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_table_widget.dart';
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
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view_model/sales_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/metal_type_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CreateSalesInvoicePage extends StatefulWidget {
  final int initialTabIndex;
  const CreateSalesInvoicePage({super.key, this.initialTabIndex = 0});

  @override
  State<CreateSalesInvoicePage> createState() => _CreateSalesInvoicePageState();
}

class _CreateSalesInvoicePageState extends State<CreateSalesInvoicePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: MetalTypeUtils.tabLabels.length,
      vsync: this,
      initialIndex: MetalTypeUtils.getTabIndexFromMetalType(
        widget.initialTabIndex,
      ),
    );

    _tabController.addListener(_handleTabSelection);
    createSalesViewModel.setMetalType(widget.initialTabIndex);

    createSalesEstimationSearchPartyController.clearControllers();
    // createSalesViewModel.fetchSalesNumber();
    createSalesEstimationSearchPartyController.searchEmployees("");
    jewelleryPlanController.jewelleryPlanOtp = null;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      createSalesEstimationSearchPartyController.partySearchFocusNode
          .requestFocus();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    // partySearchFocusNode.dispose();
    // change to dispose when shell routing is implemented
    createSalesItemDetailsController.clearControllers();
    oldGoldController.clearTextController();
    jewelleryPlanController.clearControllers();
    advanceBookingController.clearControllers();
    salesQuickEstimateController.clearControllers();
    salesQuickOldGoldController.clearControllers();
    // holdItemDetailsController.clearControllers();
    // holdItemsReferencePartyController.clearControllers();
    createSalesViewModel.clearControllers();
    salesPaymentDetailsController.clearAllControllers(
      invoiceType: "invoiceType",
    );

    salesAddOrdersDialogController.clearControllers();
    // till here
    Get.delete<RateCaratInputController>();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Use the constant to get metal type from tab index
      Get.find<SalesListingController>().selectedTabIndex.value =
          _tabController.index;
      int metalType = MetalTypeUtils.getMetalTypeFromTabIndex(
        _tabController.index,
      );

      createSalesViewModel.setMetalType(metalType);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        createSalesEstimationSearchPartyController.partySearchFocusNode
            .requestFocus();
      });
    }

    // Optional: Logging with proper names
    log(
      '${MetalTypeUtils.getTabDisplayName(_tabController.index)} tab selected',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: PermissionGuard(
        pageCode: 1100, // sales invoice page permission
        child: FocusScope(
          autofocus: true,
          child: Actions(
            actions: <Type, Action<Intent>>{
              // FIXED: Added permission check for create_invoice (1101)
              SaveEstimate: CallbackAction<SaveEstimate>(
                onInvoke: (intent) async {
                  await PermissionGuardUtil.withActionPermissionAsync(
                    1101, // create_invoice permission
                    () async {
                      // final salesController = createSalesItemDetailsController;
                      if (createSalesItemDetailsController.controllers.length >
                          1) {
                        createSalesItemDetailsController.controllers
                            .removeWhere(
                              (element) => element.code.text.isEmpty,
                            );

                        // Reset current indices to safe values
                        createSalesItemDetailsController.currentRowIndex.value =
                            createSalesItemDetailsController.controllers.isEmpty
                                ? 0
                                : createSalesItemDetailsController
                                        .controllers
                                        .length -
                                    1;

                        createSalesItemDetailsController.currentColIndex.value =
                            0;
                        if (createSalesItemDetailsController
                            .controllers
                            .isNotEmpty) {
                          createSalesItemDetailsController
                              .controllers[createSalesItemDetailsController
                                  .currentRowIndex
                                  .value]
                              .tableFocusNodes[createSalesItemDetailsController
                                  .currentColIndex
                                  .value]
                              .requestFocus();
                        }
                        await Future.delayed(const Duration(milliseconds: 100));
                      }

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
                      // if (partyController.selectedParty.value == null) {
                      //   validationErrors.add("Please select a Party");
                      // }

                      final GlobalSettingsViewModel globalSettingsViewModel =
                          Get.find<GlobalSettingsViewModel>();

                      final askSalesPersonDetails =
                          globalSettingsViewModel
                              .getGlobalSettingsResponse
                              .value
                              .data
                              ?.estimatePreference
                              ?.askSalesPersonDetails ??
                          false;
                      // Check if employee is selected
                      if (askSalesPersonDetails) {
                        if (createSalesItemDetailsController
                                .hasNoSalesPerson() ==
                            true) {
                          validationErrors.add("Select the Sale Person ");
                        }
                      }

                      if (createSalesItemDetailsController.hasSoldItems() ==
                          true) {
                        validationErrors.add("Sales contains Sold Items");
                      }

                      if (createSalesViewModel.isRateInvalid) {
                        showErrorToast(message: "Please update the rates");
                        return;
                      }

                      // Show dialog if all validations pass, otherwise show errors
                      if (validationErrors.isEmpty) {
                        Get.dialog(const SalesPaymentDetailsDialog());
                      } else {
                        for (String error in validationErrors) {
                          showErrorToast(message: error);
                        }
                      }
                    },
                  );
                  return;
                },
              ),
              // CORRECT: Already has permission check for manual_tag_entry (1104)
              OldGoldDialogIntent: CallbackAction<OldGoldDialogIntent>(
                onInvoke: (intent) async {
                  PermissionGuardUtil.withActionPermission(
                    1101, // manual_tag_entry permission
                    () async {
                      // Make this function async
                      final result = await Get.dialog(
                        const SalesOldGoldDialog(),
                      );
                      // Now we can safely check the result
                      if (result == true) {
                        // Request focus to the first item code field
                        if (createSalesItemDetailsController
                            .controllers
                            .isNotEmpty) {
                          createSalesItemDetailsController
                              .currentRowIndex
                              .value = 0;
                          createSalesItemDetailsController
                              .currentColIndex
                              .value = 0;
                          createSalesItemDetailsController
                              .controllers
                              .first
                              .tableFocusNodes[0]
                              .requestFocus();
                        }
                      }
                    },
                  );
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
                      Get.dialog(const SalesAdvanceBookingDialog());
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
                      Get.dialog(const SalesJewelleryPlanDialog());
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
                      Get.dialog(const SalesQuickOldGoldDialog());
                      return;
                    },
                  ),
              QuickEstimateIntent: CallbackAction<QuickEstimateIntent>(
                onInvoke: (intent) async {
                  Get.dialog(const SalesQuickEstimateDialog());
                  return;
                },
              ),
              // CORRECT: Already has permission check for correction_mode (1103)
              ToggleCorrectionModeIntent:
                  CallbackAction<ToggleCorrectionModeIntent>(
                    onInvoke: (intent) async {
                      PermissionGuardUtil.withActionPermission(
                        1103, // correction_mode permission
                        () {
                          createSalesViewModel.toggleFastMode();
                        },
                      );
                      return;
                    },
                  ),
              AddCustomerIntent: CallbackAction<AddCustomerIntent>(
                onInvoke: (intent) async {
                  Get.dialog(const AddCustomerDialog());
                  return;
                },
              ),
              DiscardIntent: CallbackAction<DiscardIntent>(
                onInvoke: (intent) {
                  createSalesItemDetailsController.clearControllers();
                  createSalesEstimationSearchPartyController.clearControllers();
                  createSalesViewModel.clearControllers();
                  oldGoldController.clearTextController();
                  jewelleryPlanController.clearControllers();
                  advanceBookingController.clearControllers();
                  salesQuickEstimateController.clearControllers();
                  salesQuickOldGoldController.clearControllers();
                  createSalesViewModel.clearControllers();
                  salesPaymentDetailsController.clearAllControllers(
                    invoiceType: "sales",
                  );

                  controller.clearController();

                  // Reset to initial state
                  createSalesViewModel.fetchSalesNumber();

                  // Request focus back to party search
                  createSalesEstimationSearchPartyController
                      .partySearchFocusNode
                      .requestFocus();
                  return;
                },
              ),
              AddEstimateRowIntent: CallbackAction<AddEstimateRowIntent>(
                onInvoke: (intent) {
                  createSalesItemDetailsController.validateAndAddRow();
                  createSalesItemDetailsController.getLatestRowInFocus();

                  return;
                },
              ),
              EditCustomerIntent: CallbackAction<EditCustomerIntent>(
                onInvoke: (intent) {
                  String? customerId =
                      createSalesEstimationSearchPartyController
                          .selectedParty
                          .value
                          ?.id;
                  Get.dialog(AddCustomerDialog(customerId: customerId));

                  return;
                },
              ),
              TradeDiscountIntent: CallbackAction<TradeDiscountIntent>(
                onInvoke: (intent) {
                  salesPaymentDetailsController.jewellerDiscountFocusNode
                      .requestFocus();

                  return;
                },
              ),
              AdditionalLessIntent: CallbackAction<AdditionalLessIntent>(
                onInvoke: (intent) {
                  Get.dialog(const AdditionalLessDialog());

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
                LogicalKeySet(
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.f4,
                    ):
                    const OldGoldDialogIntent(),
                LogicalKeySet(LogicalKeyboardKey.f8):
                    const QuickOldGoldEstimateDialogIntent(),
                LogicalKeySet(LogicalKeyboardKey.f9):
                    const AdvanceBookingDialogIntent(),
                LogicalKeySet(LogicalKeyboardKey.f10):
                    const JewelleryPlanDialogIntent(),
                LogicalKeySet(
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.f5,
                    ):
                    const QuickEstimateIntent(),
                LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyF):
                    const ToggleCorrectionModeIntent(),
                LogicalKeySet(LogicalKeyboardKey.f3): const AddCustomerIntent(),
                LogicalKeySet(
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.keyD,
                    ):
                    const DiscardIntent(),
                LogicalKeySet(
                      LogicalKeyboardKey.shift,
                      LogicalKeyboardKey.enter,
                    ):
                    const AddEstimateRowIntent(),
                LogicalKeySet(
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.keyC,
                    ):
                    const EditCustomerIntent(),
                LogicalKeySet(
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.keyT,
                    ):
                    const TradeDiscountIntent(),
                LogicalKeySet(
                      LogicalKeyboardKey.control,
                      LogicalKeyboardKey.keyT,
                    ):
                    const AdditionalLessIntent(),
              },
              child: Focus(
                autofocus: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CreateSalesHeaderWidget(),
                    _buildTabBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CreateSalesDetailsWidget(
                              partySearchFocusNode:
                                  createSalesEstimationSearchPartyController
                                      .partySearchFocusNode,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                                child: CreateSalesTableWidget(),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: const CreateSalesBottomStickyWidget(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          // topLeft: Radius.circular(14),
          // topRight: Radius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: const BorderRadius.only(
              // topLeft: Radius.circular(14),
              // topRight: Radius.circular(14),
            ),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs:
                    MetalTypeUtils.tabLabels
                        .map((label) => Tab(text: label))
                        .toList(),
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                tabAlignment: TabAlignment.start,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  height: 38,
                  decoration: BoxDecoration(
                    color: grey1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                    child: Row(
                      children: [
                        Icon(Icons.print_outlined, color: primaryColor),
                        SizedBox(width: 8),
                        Text(
                          "Print",
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          " CTRL + P",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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
