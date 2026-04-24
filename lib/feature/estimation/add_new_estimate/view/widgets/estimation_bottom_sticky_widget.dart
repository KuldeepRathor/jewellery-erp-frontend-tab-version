import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/advance_booking/advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/digital_coin/estimation_digital_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/jewellery_plan/jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/old_gold/old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/orders/add_orders_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

import '../../view_model/estimation_payment_details_controller.dart';

class EstimationBottomStickyWidget extends StatefulWidget {
  const EstimationBottomStickyWidget({super.key});

  @override
  EstimationBottomStickyWidgetState createState() =>
      EstimationBottomStickyWidgetState();
}

class EstimationBottomStickyWidgetState
    extends State<EstimationBottomStickyWidget> {
  final EstimationViewModel estimationViewModel =
      Get.find<EstimationViewModel>();
  final EstimationItemDetailsController estimationItemDetailsController =
      Get.find<EstimationItemDetailsController>();
  final EstimationSearchPartyController estimationSearchPartyController =
      Get.find<EstimationSearchPartyController>();

  final EstimationDigitalGoldController estimationDigitalGoldController =
      Get.find<EstimationDigitalGoldController>();

  final OldGoldController oldGoldController = Get.find<OldGoldController>();
  final AdvanceBookingController advanceBookingController =
      Get.find<AdvanceBookingController>();
  final JewelleryPlanController jewelleryPlanController =
      Get.find<JewelleryPlanController>();
  final AddOrdersDialogController addOrdersDialogController =
      Get.find<AddOrdersDialogController>();
  final EstimationPaymentDetailsController estimationPaymentDetailsController =
      Get.find<EstimationPaymentDetailsController>();
  final RateCaratInputController rateController =
      Get.find<RateCaratInputController>();

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        // AddPurchaseDetailsIntent: CallbackAction<AddPurchaseDetailsIntent>(
        //   onInvoke: (intent) => controller.validateAndAddRow(),
        // ),
        SaveEstimate: CallbackAction<SaveEstimate>(
          onInvoke: (intent) async {
            if (estimationItemDetailsController.controllers.length > 1) {
              estimationItemDetailsController.controllers.removeWhere(
                (element) => element.code.text.isEmpty,
              );

              // Reset current indices to safe values
              estimationItemDetailsController.currentRowIndex.value =
                  estimationItemDetailsController.controllers.isEmpty
                      ? 0
                      : estimationItemDetailsController.controllers.length - 1;

              estimationItemDetailsController.currentColIndex.value = 0;
              if (estimationItemDetailsController.controllers.isNotEmpty) {
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
                .checkForValidationErrors(estimationItemDetailsController);
            if (hasValidationErrors) {
              return;
            } else {
              estimationViewModel.validateAndSubmitEstimateRecord();
            }
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
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          // LogicalKeySet(LogicalKeyboardKey.enter):
          //     const AddPurchaseDetailsIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveEstimate(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                _buildItemDetails(),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 163,
                                  child: _buildImageGallery(),
                                ),
                                _buildSalesPersonDropdown(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(color: grey2, thickness: 3),
                      Expanded(flex: 3, child: _buildStoneDetails()),
                      const VerticalDivider(color: primaryColor, thickness: 3),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Obx(() {
                                      final length =
                                          estimationItemDetailsController
                                              .totalHeadersValue
                                              .length;
                                      final subTotal =
                                          estimationItemDetailsController
                                              .totalHeadersValue[length - 3];

                                      // final costDiscount =
                                      //     estimationItemDetailsController
                                      //         .totalHeadersValue[length - 4];
                                      // final stoneCost =
                                      //     estimationItemDetailsController
                                      //         .totalHeadersValue[length - 6];
                                      // final makingCharges =
                                      //     estimationItemDetailsController
                                      //         .totalHeadersValue[length - 7];

                                      // final total =
                                      //     estimationItemDetailsController
                                      //         .totalHeadersValue[length - 2];
                                      // final gst = (double.parse(total) -
                                      //         double.parse(subTotal))
                                      //     .toStringAsFixed(2);

                                      // Calculate GST as 3% of subtotal and round off

                                      final gstRaw =
                                          double.parse(subTotal) * 0.03;
                                      final gst = gstRaw.ceil().toString();
                                      final oldGoldDiscount =
                                          oldGoldController
                                              .totalHeadersValue[oldGoldController
                                                  .totalHeadersValue
                                                  .length -
                                              2];

                                      final total = (double.parse(subTotal) +
                                              double.parse(gst))
                                          .toStringAsFixed(2);

                                      final jewelleryPlayPrinciple =
                                          jewelleryPlanController
                                              .selectedJewelleryPlans
                                              .toList()
                                              .fold<double>(
                                                0,
                                                (sum, plan) =>
                                                    sum +
                                                    (double.tryParse(
                                                          plan.amount ?? "0",
                                                        ) ??
                                                        0),
                                              );
                                      final jewelleryPlanDiscount =
                                          (jewelleryPlanController
                                                      .totalRedeemableAmount
                                                      .value +
                                                  jewelleryPlayPrinciple)
                                              .toStringAsFixed(2);

                                      final advanceBookingDiscount =
                                          advanceBookingController
                                              .totalAdvancePaid
                                              .value
                                              // ?.cost
                                              .toStringAsFixed(2);

                                      final digitalCoinAmount =
                                          estimationDigitalGoldController
                                              .calculatedAmount
                                              .value;
                                      final ordersAdvanceAmount =
                                          addOrdersDialogController
                                              .totalAdvancePaid
                                              .value;
                                      final additionalLess =
                                          estimationPaymentDetailsController
                                              .additional_less
                                              .value;
                                      final finalTotal =
                                          double.parse(total) -
                                          (double.tryParse(
                                                advanceBookingDiscount,
                                              ) ??
                                              0) -
                                          (double.tryParse(
                                                jewelleryPlanDiscount,
                                              ) ??
                                              0) -
                                          (double.tryParse(oldGoldDiscount) ??
                                              0) -
                                          digitalCoinAmount -
                                          additionalLess;
                                      return Column(
                                        children: [
                                          _buildBillingSummaryRow(
                                            header: "Sub Total",
                                            value: formatCurrency(subTotal),
                                          ),
                                          _buildBillingSummaryRow(
                                            header: "GST",
                                            value: formatCurrency(gst),
                                          ),
                                          // _buildBillingSummaryRow(
                                          //     header: "Stone Cost",
                                          //     value: stoneCost),
                                          // _buildBillingSummaryRow(
                                          //     header: "Making Charges",
                                          //     value: makingCharges),
                                          // _buildBillingSummaryRow(
                                          //     header: "Cost Discount",
                                          //     value: costDiscount),
                                          _buildBillingSummaryRow(
                                            header: "Old Gold Discount",
                                            value: formatCurrency(
                                              oldGoldDiscount,
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                double.tryParse(
                                                  jewelleryPlanDiscount,
                                                ) !=
                                                0,
                                            child: _buildBillingSummaryRow(
                                              header:
                                                  "Jewellery Plan Discount with Principle",
                                              value: formatCurrency(
                                                jewelleryPlanDiscount,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                double.tryParse(
                                                  advanceBookingDiscount,
                                                ) !=
                                                0,
                                            child: _buildBillingSummaryRow(
                                              // header:
                                              //     "Advance Booking Discount",
                                              header: "Advance paid",
                                              value: formatCurrency(
                                                advanceBookingDiscount,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                double.tryParse(
                                                  digitalCoinAmount
                                                      .toStringAsFixed(2),
                                                ) !=
                                                0,
                                            child: _buildBillingSummaryRow(
                                              header: "Digital Gold",
                                              value: formatCurrency(
                                                digitalCoinAmount
                                                    .toStringAsFixed(2),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                (double.tryParse(
                                                      ordersAdvanceAmount
                                                          .toStringAsFixed(2),
                                                    ) ??
                                                    0) !=
                                                0,
                                            child: _buildBillingSummaryRow(
                                              header: "Orders Advance",
                                              value: formatCurrency(
                                                ordersAdvanceAmount
                                                    .toStringAsFixed(2),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Overall Amount (Ctrl+T)",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Satoshi',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              CustomTextField(
                                                width: 120,
                                                controller:
                                                    estimationViewModel
                                                        .jewellerDiscount,
                                                focusNode:
                                                    estimationViewModel
                                                        .jewellerDiscountFocusNode,
                                                inputFormatters: [
                                                  AmountInputFormatter(),
                                                ],
                                                onEditingComplete: () {
                                                  applyJewelleryDiscount(
                                                    subTotal: subTotal,
                                                    gstAmount: gst,
                                                    finalTotal:
                                                        finalTotal.toString(),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          _buildBillingSummaryRow(
                                            header: "Additional Less",
                                            value: formatCurrency(
                                              additionalLess.toStringAsFixed(2),
                                            ),
                                          ),
                                          _buildBillingSummaryRow(
                                            header: "Total",
                                            value: formatCurrency(
                                              finalTotal
                                                  .roundToDouble()
                                                  .toStringAsFixed(2),
                                            ),
                                            isTotal: true,
                                          ),
                                        ],
                                      );
                                    }),
                                    const SizedBox(height: 100),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.white,
                                  child: Wrap(
                                    spacing: 16,
                                    runSpacing: 6,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.horizontal,
                                    children: [
                                      CustomInkButton(
                                        onPressed: () {
                                          estimationViewModel
                                              .clearAllControllers(
                                                invoiceType:
                                                    "invoice_number_vendor",
                                              );
                                          // Get.dialog(EstimateDialogPrinter(
                                          //   estimate: PostEstimateResponse(),
                                          // ));
                                        },
                                        text: "Discard (ctrl+D)",
                                        backgroundColor: grey1,
                                        textColor: primaryColor,
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () async {
                                            if (estimationItemDetailsController
                                                    .controllers
                                                    .length >
                                                1) {
                                              estimationItemDetailsController
                                                  .controllers
                                                  .removeWhere(
                                                    (element) =>
                                                        element
                                                            .code
                                                            .text
                                                            .isEmpty,
                                                  );

                                              // Reset current indices to safe values
                                              estimationItemDetailsController
                                                      .currentRowIndex
                                                      .value =
                                                  estimationItemDetailsController
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
                                                const Duration(
                                                  milliseconds: 100,
                                                ),
                                              );
                                            }

                                            if (estimationViewModel
                                                .isRateInvalid) {
                                              showErrorToast(
                                                message:
                                                    "Please update the rates",
                                              );
                                              return;
                                            }

                                            bool hasValidationErrors =
                                                estimationViewModel
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Ink(
                                            // color: primaryColor,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            height: 38,
                                            width: 140,
                                            child: Center(
                                              child: Obx(
                                                () =>
                                                    estimationViewModel
                                                                .postEstimateResponse
                                                                .value
                                                                .status ==
                                                            Status.LOADING
                                                        ? const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                        )
                                                        : ButtonShortcutWidget(
                                                          buttonName: "Save",
                                                          shortcut: "Ctrl + S",
                                                          buttonsize: 16,
                                                          color: whiteColor,
                                                          shortcutButtonColor:
                                                              primaryColor,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void applyJewelleryDiscount({
    required String subTotal,
    required String gstAmount,
    required String finalTotal,
  }) {
    var value = estimationViewModel.jewellerDiscount.text;
    if (value.isNotEmpty) {
      final discount = double.tryParse(value) ?? 0;
      final salesAmount = double.tryParse(subTotal) ?? 0;
      final gst = double.tryParse(gstAmount) ?? 0;
      final gstPercent = ((gst / salesAmount) * 100);
      final salesAmountForDiscount = (discount * 100) / (gstPercent + 100);
      // final finalTotalValue = double.tryParse(finalTotal) ?? 0;
      double jewellerDiscount =
          discount != 0 ? salesAmount - salesAmountForDiscount : 0;
      log(
        "the discount value is $discount: $gstPercent : $salesAmountForDiscount : $jewellerDiscount",
      );

      estimationItemDetailsController.distributeJewellerDiscount(
        jewellerDiscount: jewellerDiscount.toPrecision(3),
        vaFirst: true,
        gstPercent: gstPercent,
      );
    } else {
      estimationItemDetailsController.distributeJewellerDiscount(
        jewellerDiscount: 0,
        vaFirst: true,
        gstPercent: 0,
      );
    }
  }

  Padding _buildSalesPersonDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Column(
            children: [
              // SizedBox(
              //   height: 24,
              // ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'Sales Person (Ctrl+E): ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
          Obx(() {
            final index = estimationItemDetailsController.currentRowIndex.value;
            final itemData = estimationItemDetailsController.controllers[index];
            // final employees = estimationSearchPartyController
            //         .getEmployeesResponse.value.data?.values ??
            //     [];

            final employee = itemData.employeeDetails;
            return Text(
              '${employee?.firstName ?? ''} ${employee?.lastName ?? ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            );
            // return CustomDropdownField<GetEmployeesValue>(
            //   name: 'Approver Name/ ID',
            //   nameFont: 12,
            //   textColor: primaryColor,
            //   width: Get.width * .145,
            //   items: employees,
            //   enabled: true,
            //   selectedItem: itemData.employeeDetails,
            //   onChanged: (GetEmployeesValue? value) {
            //     if (value != null) {
            //       estimationItemDetailsController.onEmployeeSelected(
            //           rowIndex: index, employee: value);
            //     }
            //   },
            //   itemAsString: (GetEmployeesValue? employee) =>
            //       '${employee?.firstName ?? ''} ${employee?.lastName ?? ''}',
            // );
          }),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF28328B),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Item Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          VerticalDivider(color: Colors.transparent, thickness: 3),
          Expanded(flex: 3, child: SizedBox()),
          VerticalDivider(color: Colors.transparent, thickness: 3),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Billing Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetails() {
    return Obx(() {
      final index = estimationItemDetailsController.currentRowIndex.value;
      final itemData = estimationItemDetailsController.controllers[index];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildDetailRow('ID', itemData.code.text),
              _buildDetailRow(
                'Item Name/ Design',
                itemData.item_description.text,
              ),
              // _buildDetailRow('Size', '-'),
              // _buildDetailRow('Dealer', '-'),
              // _buildDetailRow('Grade', '-'),
              _buildDetailRow('Barcode', itemData.barcode),
              _buildDetailRow(
                'Purity',
                itemData.itemResponse?.designLineItem?.purity ?? "-",
              ),
              _buildDetailRow(
                'Mc',
                "${itemData.itemResponse?.mc ?? "-"} ${itemData.itemResponse?.designLineItem?.makingChargesType ?? "-"}",
              ),

              _buildDetailRow('MC Total', getMcTotalValue(index: index)),
              // _buildDetailRow('Wastage', '-'),
              // _buildDetailRow('HUID', itemData.hallMark),
              _buildDetailRow('Pcs', itemData.pcs.text),
              _buildDetailRow('G.Wt. (gm)', itemData.gwt.text),
              _buildDetailRow('N.Wt. (gm)', itemData.nwt.text),
              _buildDetailRow(
                'VA',
                "${itemData.itemResponse?.va ?? "-"} ${itemData.itemResponse?.designLineItem?.wastageType ?? "-"}",
              ),
              _buildDetailRow('Stone Cost (₹)', itemData.stone.text),
            ],
          ),
        ],
      );
    });
  }

  String getMcTotalValue({required int index}) {
    final index = estimationItemDetailsController.currentRowIndex.value;
    final itemData = estimationItemDetailsController.controllers[index];

    final mcValue = double.tryParse(itemData.mc.text) ?? 0;
    final makingChargesType =
        itemData.itemResponse?.designLineItem?.makingChargesType?.toLowerCase();

    double mcTotalValue = 0;
    if (makingChargesType == "gwt") {
      final gwt = double.tryParse(itemData.gwt.text) ?? 0;
      mcTotalValue = mcValue * gwt;
    } else if (makingChargesType == "nwt") {
      final nwt = double.tryParse(itemData.nwt.text) ?? 0;
      mcTotalValue = mcValue * nwt;
    } else {
      mcTotalValue = mcValue;
    }

    return mcTotalValue.toStringAsFixed(2);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 160, minWidth: 80),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            // constraints: const BoxConstraints(maxWidth: 160, minWidth: 80),
            child: Tooltip(
              message: value,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoneDetails() {
    return Obx(() {
      final index = estimationItemDetailsController.currentRowIndex.value;
      final stoneDetails =
          estimationItemDetailsController
              .controllers[index]
              .stoneDetailsTableData;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Stone Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(120 - 15),
                  1: FixedColumnWidth(50 - 20),
                  2: FixedColumnWidth(80 - 15),
                  3: FixedColumnWidth(80 - 20),
                  4: FixedColumnWidth(80 - 10),
                  5: FixedColumnWidth(80 - 10),
                },
                children: [
                  _buildTableRow([
                    'Stone Name',
                    'Pcs',
                    'Weight',
                    'Unit',
                    'Rate',
                    'Value',
                  ], isHeader: true),
                  if (stoneDetails.isEmpty)
                    _buildTableRow(['-', '-', '-', '-', '-', '-'])
                  else
                    ...stoneDetails.map(
                      (stone) => _buildTableRow([
                        stone.name.text,
                        stone.pcs.text,
                        stone.carat_weight.text,
                        stone.weightUnitFromBackend,
                        stone.rate.text,
                        stone.total.text,
                      ]),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children:
          cells
              .map(
                (cell) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Text(
                    cell,
                    style: TextStyle(
                      color: isHeader ? Colors.black : secondaryColor,
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal,
                      fontSize: isHeader ? 12 : 14,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildImageGallery() {
    return Obx(() {
      final index = estimationItemDetailsController.currentRowIndex.value;
      final images = estimationItemDetailsController.controllers[index].images;
      log("The images are $images");

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.isEmpty ? 1 : images.length,
        itemBuilder: (context, index) {
          if (images.isEmpty) {
            return _buildImageCard();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildImageCard(imageUrl: images[index]),
          );
        },
      );
    });
  }

  Widget _buildImageCard({String? imageUrl}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return GlobalImageView(imagePath: imageUrl ?? "");
          },
        );
      },
      child: Container(
        width: 163,
        height: 163,
        decoration: ShapeDecoration(
          image:
              imageUrl != null
                  ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                  : null,
          color: imageUrl == null ? primaryColor : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            imageUrl == null
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/svgs/error/no_image_found.svg',
                  ),
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildBillingSummaryRow({
    required String header,
    required String value,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              header,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '₹ $value',
            style: TextStyle(
              fontSize: 16,
              color: isTotal ? secondaryColor : null,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
