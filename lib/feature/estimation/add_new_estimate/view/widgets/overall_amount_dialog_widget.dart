import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/advance_booking/advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/digital_coin/estimation_digital_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/jewellery_plan/jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/old_gold/old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/orders/add_orders_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class OverallAmountDialogWidget extends StatefulWidget {
  const OverallAmountDialogWidget({super.key});

  @override
  State<OverallAmountDialogWidget> createState() =>
      _OverallAmountDialogWidgetState();
}

class _OverallAmountDialogWidgetState extends State<OverallAmountDialogWidget> {
  final estimationItemDetailsController =
      Get.find<EstimationItemDetailsController>();
  final OldGoldController oldGoldController = Get.find<OldGoldController>();
  final JewelleryPlanController jewelleryPlanController =
      Get.find<JewelleryPlanController>();
  final AdvanceBookingController advanceBookingController =
      Get.find<AdvanceBookingController>();
  final EstimationDigitalGoldController estimationDigitalGoldController =
      Get.find<EstimationDigitalGoldController>();
  final AddOrdersDialogController addOrdersDialogController =
      Get.find<AddOrdersDialogController>();
  final EstimationPaymentDetailsController estimationPaymentDetailsController =
      Get.find<EstimationPaymentDetailsController>();
  final EstimationViewModel estimationViewModel =
      Get.find<EstimationViewModel>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.4,
      width: Get.width * 0.5,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(() {
        final length = estimationItemDetailsController.totalHeadersValue.length;
        final subTotal =
            estimationItemDetailsController.totalHeadersValue[length - 3];

        final gstRaw = double.parse(subTotal) * 0.03;
        final gst = gstRaw.ceil().toString();
        final oldGoldDiscount =
            oldGoldController.totalHeadersValue[oldGoldController
                    .totalHeadersValue
                    .length -
                2];

        final total = (double.parse(subTotal) + double.parse(gst))
            .toStringAsFixed(2);

        final jewelleryPlayPrinciple = jewelleryPlanController
            .selectedJewelleryPlans
            .toList()
            .fold<double>(
              0,
              (sum, plan) => sum + (double.tryParse(plan.amount ?? "0") ?? 0),
            );
        final jewelleryPlanDiscount = (jewelleryPlanController
                    .totalRedeemableAmount
                    .value +
                jewelleryPlayPrinciple)
            .toStringAsFixed(2);

        final advanceBookingDiscount = advanceBookingController
            .totalAdvancePaid
            .value
            // ?.cost
            .toStringAsFixed(2);

        final digitalCoinAmount =
            estimationDigitalGoldController.calculatedAmount.value;
        final ordersAdvanceAmount =
            addOrdersDialogController.totalAdvancePaid.value;
        final additionalLess =
            estimationPaymentDetailsController.additional_less.value;
        final finalTotal =
            double.parse(total) -
            (double.tryParse(advanceBookingDiscount) ?? 0) -
            (double.tryParse(jewelleryPlanDiscount) ?? 0) -
            (double.tryParse(oldGoldDiscount) ?? 0) -
            digitalCoinAmount -
            additionalLess;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close, color: redTextColor),
            ),
            _buildBillingSummaryRow(
              header: "Sub Total",
              value: formatCurrency(subTotal),
            ),
            _buildBillingSummaryRow(header: "GST", value: formatCurrency(gst)),
            _buildBillingSummaryRow(
              header: "Old Gold Discount",
              value: formatCurrency(oldGoldDiscount),
            ),
            Visibility(
              visible: double.tryParse(jewelleryPlanDiscount) != 0,
              child: _buildBillingSummaryRow(
                header: "Jewellery Plan Discount with Principle",
                value: formatCurrency(jewelleryPlanDiscount),
              ),
            ),
            Visibility(
              visible: double.tryParse(advanceBookingDiscount) != 0,
              child: _buildBillingSummaryRow(
                header: "Advance paid",
                value: formatCurrency(advanceBookingDiscount),
              ),
            ),
            Visibility(
              visible:
                  double.tryParse(digitalCoinAmount.toStringAsFixed(2)) != 0,
              child: _buildBillingSummaryRow(
                header: "Digital Gold",
                value: formatCurrency(digitalCoinAmount.toStringAsFixed(2)),
              ),
            ),
            Visibility(
              visible:
                  (double.tryParse(ordersAdvanceAmount.toStringAsFixed(2)) ??
                      0) !=
                  0,
              child: _buildBillingSummaryRow(
                header: "Orders Advance",
                value: formatCurrency(ordersAdvanceAmount.toStringAsFixed(2)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  controller: estimationViewModel.jewellerDiscount,
                  focusNode: estimationViewModel.jewellerDiscountFocusNode,
                  inputFormatters: [AmountInputFormatter()],
                  onEditingComplete: () {
                    applyJewelleryDiscount(
                      subTotal: subTotal,
                      gstAmount: gst,
                      finalTotal: finalTotal.toString(),
                    );
                  },
                ),
              ],
            ),
            _buildBillingSummaryRow(
              header: "Additional Less",
              value: formatCurrency(additionalLess.toStringAsFixed(2)),
            ),
            _buildBillingSummaryRow(
              header: "Total",
              value: formatCurrency(
                finalTotal.roundToDouble().toStringAsFixed(2),
              ),
              isTotal: true,
            ),
          ],
        );
      }),
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
