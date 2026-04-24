import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/advance_booking/advance_booking_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/jewellery_plan/jewellery_plan_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/old_gold/old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/quick_estimate/quick_estimate_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/quick_old_gold/quick_old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/add_more_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/estimation_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/estimation_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/estimation_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/overall_amount_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/advance_booking/advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/digital_coin/estimation_digital_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/jewellery_plan/jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/old_gold/old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/orders/add_orders_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/quick_estimate/quick_estimate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/quick_old_gold/quick_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/metal_type_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

import '../view_model/estimation_payment_details_controller.dart';
import 'widgets/estimation_payment_details_dialog.dart';

class EstimationPage extends StatefulWidget {
  final int initialTabIndex;
  const EstimationPage({super.key, this.initialTabIndex = 0});

  @override
  State<EstimationPage> createState() => _EstimationPageState();
}

class _EstimationPageState extends State<EstimationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FocusNode partySearchFocusNode = FocusNode();
  final EstimationViewModel estimationViewModel = Get.put<EstimationViewModel>(
    EstimationViewModel(),
  );
  final RateCaratInputController controller = Get.put(
    RateCaratInputController(),
  );
  final EstimationSearchPartyController estimationSearchPartyController =
      Get.put(EstimationSearchPartyController());
  final EstimationItemDetailsController estimationItemDetailsController =
      Get.put(EstimationItemDetailsController());

  final OldGoldController oldGoldController = Get.put(OldGoldController());
  final AdvanceBookingController advanceBookingController = Get.put(
    AdvanceBookingController(),
  );
  final JewelleryPlanController jewelleryPlanController = Get.put(
    JewelleryPlanController(),
  );
  final QuickEstimateController quickEstimateController = Get.put(
    QuickEstimateController(),
  );
  final QuickOldGoldController quickOldGoldController = Get.put(
    QuickOldGoldController(),
  );

  final EstimationDigitalGoldController estimationDigitalGoldController =
      Get.put<EstimationDigitalGoldController>(
        EstimationDigitalGoldController(),
      );
  final AddOrdersDialogController addOrdersDialogController = Get.put(
    AddOrdersDialogController(),
  );
  final EstimationPaymentDetailsController estimationPaymentDetailsController =
      Get.put(EstimationPaymentDetailsController());

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

    estimationViewModel.onResetTab = resetToDefaultTab;
    estimationViewModel.setMetalType(widget.initialTabIndex);
    // ever(estimationViewModel.selectedMetalType, (metalType) {
    //   final tabIndex = MetalTypeUtils.getTabIndexFromMetalType(metalType);
    //   if (_tabController.index != tabIndex) {
    //     _tabController.index = tabIndex;
    //   }
    // });
    estimationSearchPartyController.clearControllers();
    estimationSearchPartyController.fetchestimationNumber();
    estimationSearchPartyController.searchEmployees('');
    estimationViewModel.isFastMode.value = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // partySearchFocusNode.requestFocus();
      estimationItemDetailsController.controllers.last.tableFocusNodes.first
          .requestFocus();
    });
  }

  @override
  void dispose() {
    log("Disposing estimation page");
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();

    estimationViewModel.onResetTab = null;

    super.dispose();
    estimationItemDetailsController.clearControllers();
    estimationDigitalGoldController.clearControllers();
    oldGoldController.clearTextController();
    jewelleryPlanController.clearControllers();
    advanceBookingController.clearControllers();
    quickEstimateController.clearControllers();
    quickOldGoldController.clearControllers();
    estimationDigitalGoldController.clearControllers();
    addOrdersDialogController.clearControllers();
    estimationPaymentDetailsController.clearControllers();
    estimationViewModel.clearAllControllers(invoiceType: "");
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Use the constant to get metal type from tab index
      int metalType = MetalTypeUtils.getMetalTypeFromTabIndex(
        _tabController.index,
      );
      estimationViewModel.setMetalType(metalType);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (estimationItemDetailsController.controllers.isNotEmpty) {
          estimationItemDetailsController.controllers.last.tableFocusNodes.first
              .requestFocus();
          // Also update the current indices
          estimationItemDetailsController.currentRowIndex.value =
              estimationItemDetailsController.controllers.length - 1;
          estimationItemDetailsController.currentColIndex.value = 0;
        }
      });
    }

    // Optional: Logging with proper names
    log(
      '${MetalTypeUtils.getTabDisplayName(_tabController.index)} tab selected',
    );
  }

  void resetToDefaultTab() {
    _tabController.index = 0;
  }

  @override
  Widget build(BuildContext context) {
    // ADDED: Page-level permission guard
    return PermissionGuard(
      pageCode: 2100, // estimate page permission
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: grey1,
        body: Actions(
          actions: <Type, Action<Intent>>{
            // FIXED: Added permission check for create_estimate (2101)
            SaveEstimate: CallbackAction<SaveEstimate>(
              onInvoke: (intent) async {
                await PermissionGuardUtil.withActionPermissionAsync(
                  2101, // create_estimate permission
                  () async {
                    if (estimationItemDetailsController.controllers.length >
                        1) {
                      estimationItemDetailsController.controllers.removeWhere(
                        (element) => element.code.text.isEmpty,
                      );

                      // Reset current indices to safe values
                      estimationItemDetailsController.currentRowIndex.value =
                          estimationItemDetailsController.controllers.isEmpty
                              ? 0
                              : estimationItemDetailsController
                                      .controllers
                                      .length -
                                  1;

                      estimationItemDetailsController.currentColIndex.value = 0;
                      if (estimationItemDetailsController
                          .controllers
                          .isNotEmpty) {
                        estimationItemDetailsController
                            .controllers[estimationItemDetailsController
                                .currentRowIndex
                                .value]
                            .tableFocusNodes[estimationItemDetailsController
                                .currentColIndex
                                .value]
                            .requestFocus();
                      }
                      await Future.delayed(const Duration(milliseconds: 100));
                    }
                    if (estimationViewModel.isRateInvalid) {
                      showErrorToast(message: "Please update the rates");
                      return;
                    }
                    bool hasValidationErrors = estimationViewModel
                        .checkForValidationErrors(
                          estimationItemDetailsController,
                        );
                    if (hasValidationErrors) {
                      return;
                    } else {
                      estimationViewModel.validateAndSubmitEstimateRecord();
                    }
                  },
                );
                return;
              },
            ),
            OldGoldDialogIntent: CallbackAction<OldGoldDialogIntent>(
              onInvoke: (intent) async {
                Get.dialog(const OldGoldDialog());
                return;
              },
            ),
            AdvanceBookingDialogIntent:
                CallbackAction<AdvanceBookingDialogIntent>(
                  onInvoke: (intent) async {
                    bool isItemsDataValid =
                        estimationItemDetailsController.validateRow();
                    if (isItemsDataValid == false) {
                      showErrorToast(message: "Invalid Item Data");
                      return;
                    }
                    Get.dialog(const AdvanceBookingDialog());
                    return;
                  },
                ),
            JewelleryPlanDialogIntent:
                CallbackAction<JewelleryPlanDialogIntent>(
                  onInvoke: (intent) async {
                    bool isItemsDataValid =
                        estimationItemDetailsController.validateRow();
                    if (isItemsDataValid == false) {
                      showErrorToast(message: "Invalid Item Data");
                      return;
                    }
                    Get.dialog(const JewelleryPlanDialog());
                    return;
                  },
                ),
            QuickOldGoldEstimateDialogIntent:
                CallbackAction<QuickOldGoldEstimateDialogIntent>(
                  onInvoke: (intent) async {
                    // bool isItemsDataValid =
                    //     estimationItemDetailsController.validateRow();
                    // if (isItemsDataValid == false) {
                    //   showErrorToast(message: "Invalid Item Data");
                    //   return;
                    // }
                    Get.dialog(const QuickOldGoldDialog());
                    return;
                  },
                ),
            QuickEstimateIntent: CallbackAction<QuickEstimateIntent>(
              onInvoke: (intent) async {
                Get.dialog(const QuickEstimateDialog());
                return;
              },
            ),
            ToggleCorrectionModeIntent:
                CallbackAction<ToggleCorrectionModeIntent>(
                  onInvoke: (intent) async {
                    PermissionGuardUtil.withActionPermission(
                      2103, // correction_mode permission
                      () {
                        estimationViewModel.toggleFastMode();
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
                estimationViewModel.clearAllControllers(
                  invoiceType: "invoice_number_vendor",
                );

                return;
              },
            ),
            AddEstimateRowIntent: CallbackAction<AddEstimateRowIntent>(
              onInvoke: (intent) {
                estimationItemDetailsController.validateAndAddRow();
                estimationItemDetailsController.getLatestRowInFocus();

                return;
              },
            ),
            TradeDiscountIntent: CallbackAction<TradeDiscountIntent>(
              onInvoke: (intent) {
                estimationViewModel.jewellerDiscountFocusNode.requestFocus();
                return;
              },
            ),
            // FIXED: Added permission check for create_estimate (2101)
            AddEstimatePaymentDetailsIntent: CallbackAction<
              AddEstimatePaymentDetailsIntent
            >(
              onInvoke: (intent) async {
                await PermissionGuardUtil.withActionPermissionAsync(
                  2101, // create_estimate permission (payment details are part of creating estimate)
                  () async {
                    if (estimationItemDetailsController.controllers.length >
                        1) {
                      estimationItemDetailsController.controllers.removeWhere(
                        (element) => element.code.text.isEmpty,
                      );

                      // Reset current indices to safe values
                      estimationItemDetailsController.currentRowIndex.value =
                          estimationItemDetailsController.controllers.isEmpty
                              ? 0
                              : estimationItemDetailsController
                                      .controllers
                                      .length -
                                  1;

                      estimationItemDetailsController.currentColIndex.value = 0;
                      if (estimationItemDetailsController
                          .controllers
                          .isNotEmpty) {
                        estimationItemDetailsController
                            .controllers[estimationItemDetailsController
                                .currentRowIndex
                                .value]
                            .tableFocusNodes[estimationItemDetailsController
                                .currentColIndex
                                .value]
                            .requestFocus();
                      }
                      await Future.delayed(const Duration(milliseconds: 100));
                    }
                    bool hasValidationErrors = estimationViewModel
                        .checkForValidationErrors(
                          estimationItemDetailsController,
                        );
                    if (hasValidationErrors) {
                      return;
                    } else {
                      Get.dialog(const EstimationPaymentDetailsDialog());
                    }
                  },
                );
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
              LogicalKeySet(LogicalKeyboardKey.f3): const AddCustomerIntent(),
              LogicalKeySet(
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.keyD,
                  ):
                  const DiscardIntent(),
              LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.enter):
                  const AddEstimateRowIntent(),
              LogicalKeySet(
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.keyT,
                  ):
                  const TradeDiscountIntent(),
              LogicalKeySet(
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.keyP,
                  ):
                  const AddEstimatePaymentDetailsIntent(),
            },
            child: FocusScope(
              autofocus: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const EstimationHeaderWidget(),
                  Flexible(
                    child: Column(
                      children: [
                        EstimationDetailsWidget(
                          partySearchFocusNode: partySearchFocusNode,
                        ),
                        const Flexible(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                            child: EstimationTableWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedPadding(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const FooterWidget(),
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

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  final EstimationViewModel estimationViewModel = Get.put<EstimationViewModel>(
    EstimationViewModel(),
  );
  final EstimationItemDetailsController estimationItemDetailsController =
      Get.find<EstimationItemDetailsController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.01,
              vertical: Get.height * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AddMoreDialogWidget(),
                SizedBox(width: Get.width * 0.02),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const OverallAmountDialogWidget(),
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Overall Amount",
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: Get.width * 0.02),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const EstimationPaymentDetailsDialog(),
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Payment Summary",
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(width: Get.width * 0.02),
                SingleChildScrollView(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
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
                          borderRadius: BorderRadius.circular(8),
                          onTap: () async {
                            if (estimationItemDetailsController
                                    .controllers
                                    .length >
                                1) {
                              estimationItemDetailsController.controllers
                                  .removeWhere(
                                    (element) => element.code.text.isEmpty,
                                  );

                              // Reset current indices to safe values
                              estimationItemDetailsController
                                  .currentRowIndex
                                  .value = estimationItemDetailsController
                                          .controllers
                                          .isEmpty
                                      ? 0
                                      : estimationItemDetailsController
                                              .controllers
                                              .length -
                                          1;

                              estimationItemDetailsController
                                  .currentColIndex
                                  .value = 0;
                              if (estimationItemDetailsController
                                  .controllers
                                  .isNotEmpty) {
                                estimationItemDetailsController
                                    .controllers[estimationItemDetailsController
                                        .currentRowIndex
                                        .value]
                                    .tableFocusNodes[estimationItemDetailsController
                                        .currentColIndex
                                        .value]
                                    .requestFocus();
                              }
                              await Future.delayed(
                                const Duration(milliseconds: 100),
                              );
                            }

                            bool hasValidationErrors = estimationViewModel
                                .checkForValidationErrors(
                                  estimationItemDetailsController,
                                );
                            if (hasValidationErrors) {
                              return;
                            } else {
                              // Get.dialog(
                              //     const EstimationPaymentDetailsDialog());
                              estimationViewModel
                                  .validateAndSubmitEstimateRecord();
                            }
                          },
                          child: Ink(
                            height: 38,
                            width: 140,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child:
                                  estimationViewModel
                                              .postEstimateResponse
                                              .value
                                              .status ==
                                          Status.LOADING
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                      : const CustomText(
                                        text: "Print",
                                        fontSize: 16,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
