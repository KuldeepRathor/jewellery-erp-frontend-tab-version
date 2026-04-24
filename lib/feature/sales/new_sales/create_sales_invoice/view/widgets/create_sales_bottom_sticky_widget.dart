import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/widgets/create_sales_payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/advance_booking/sales_advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/jewellery_plan/sales_jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/old_gold/sales_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/orders/sales_add_order_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/decimal_textinput_formatter.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

class CreateSalesBottomStickyWidget extends StatefulWidget {
  const CreateSalesBottomStickyWidget({super.key});

  @override
  CreateSalesBottomStickyWidgetState createState() =>
      CreateSalesBottomStickyWidgetState();
}

class CreateSalesBottomStickyWidgetState
    extends State<CreateSalesBottomStickyWidget> {
  final CreateSalesItemDetailsController estimationItemDetailsController =
      Get.find<CreateSalesItemDetailsController>();
  final CreateSalesEstimationSearchPartyController
  createSalesEstimationSearchPartyController =
      Get.find<CreateSalesEstimationSearchPartyController>();
  final CreateSalesItemDetailsController createSalesItemDetailsController =
      Get.find<CreateSalesItemDetailsController>();

  final SalesPaymentDetailsController salesPaymentDetailsController =
      Get.find<SalesPaymentDetailsController>();

  final SalesOldGoldController oldGoldController =
      Get.find<SalesOldGoldController>();
  final SalesAdvanceBookingController advanceBookingController =
      Get.find<SalesAdvanceBookingController>();
  final SalesJewelleryPlanController jewelleryPlanController =
      Get.find<SalesJewelleryPlanController>();
  final SalesAddOrdersDialogController salesAddOrdersDialogController =
      Get.find<SalesAddOrdersDialogController>();
  final RBACController rbacController = Get.find<RBACController>();
  final CreateSalesViewModel createSalesViewModel =
      Get.find<CreateSalesViewModel>();
  final RateCaratInputController rateController =
      Get.find<RateCaratInputController>();

  // final RxBool isRateValid = true.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.4,
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
                            SizedBox(height: 163, child: _buildImageGallery()),
                            Padding(
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
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: primaryColor,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Sales Person: ',
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
                                    final index =
                                        estimationItemDetailsController
                                            .currentRowIndex
                                            .value;
                                    final itemData =
                                        estimationItemDetailsController
                                            .controllers[index];
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
                                    // final employees =
                                    //     createSalesEstimationSearchPartyController
                                    //             .getEmployeesResponse
                                    //             .value
                                    //             .data
                                    //             ?.values ??
                                    //         [];
                                    // return CustomDropdownField<
                                    //     GetEmployeesValue>(
                                    //   name: 'Approver Name/ ID',
                                    //   nameFont: 12,
                                    //   textColor: primaryColor,
                                    //   width: Get.width * .145,
                                    //   items: employees,
                                    //   selectedItem:
                                    //       createSalesEstimationSearchPartyController
                                    //           .selectedEmployee.value,
                                    //   onChanged: (GetEmployeesValue? value) {
                                    //     if (value != null) {
                                    //       createSalesEstimationSearchPartyController
                                    //           .setSelectedEmployee(value);
                                    //     }
                                    //   },
                                    //   itemAsString: (GetEmployeesValue?
                                    //           employee) =>
                                    //       '${employee?.firstName ?? ''} ${employee?.lastName ?? ''}',
                                    // );
                                  }),
                                ],
                              ),
                            ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  final total =
                                      estimationItemDetailsController
                                          .totalHeadersValue[length - 2];
                                  final gst = (double.parse(total) -
                                          double.parse(subTotal))
                                      .toStringAsFixed(2);
                                  final oldGoldDiscount =
                                      oldGoldController
                                          .totalHeadersValue[oldGoldController
                                              .totalHeadersValue
                                              .length -
                                          2];
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
                                      advanceBookingController.totalAdvancePaid
                                          .toStringAsFixed(2);

                                  final ordersAdvanceAmount =
                                      salesAddOrdersDialogController
                                          .totalAdvancePaid
                                          .value;
                                  final additionalLess =
                                      salesPaymentDetailsController
                                          .additional_less
                                          .value;
                                  final finalTotal =
                                      double.parse(total) -
                                      (double.tryParse(
                                            advanceBookingDiscount,
                                          ) ??
                                          0) -
                                      (double.tryParse(jewelleryPlanDiscount) ??
                                          0) -
                                      (double.tryParse(oldGoldDiscount) ?? 0) -
                                      ordersAdvanceAmount -
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
                                        header: "Purchase",
                                        value: formatCurrency(oldGoldDiscount),
                                      ),
                                      Visibility(
                                        visible:
                                            (double.tryParse(
                                                  jewelleryPlanDiscount,
                                                ) ??
                                                0) !=
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
                                            (double.tryParse(
                                                  advanceBookingDiscount,
                                                ) ??
                                                0) !=
                                            0,
                                        child: _buildBillingSummaryRow(
                                          // header: "Advance Booking Discount",
                                          header: "Advance paid",
                                          value: formatCurrency(
                                            advanceBookingDiscount,
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
                                            ordersAdvanceAmount.toStringAsFixed(
                                              2,
                                            ),
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
                                            readOnly:
                                                !rbacController.hasAction(1105),
                                            controller:
                                                salesPaymentDetailsController
                                                    .jewellerDiscount,
                                            focusNode:
                                                salesPaymentDetailsController
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

                                      // Row(
                                      //   children: [
                                      //     CustomInkButton(
                                      //       onPressed: () {
                                      //         Get.dialog(const AdditionalLessDialog());
                                      //       },
                                      //       text: "Apply (Ctrl+T)",
                                      //       backgroundColor: primaryColor,
                                      //       textColor: Colors.white,
                                      //     ),
                                      //   ],
                                      // ),
                                      // _buildBillingSummaryRow(
                                      //     header: "Additional Less",
                                      //     value: formatCurrency(additionalLess
                                      //         .toStringAsFixed(2))),
                                      // const SizedBox(height: 8),
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
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [
                                  CustomInkButton(
                                    onPressed: () {
                                      createSalesItemDetailsController
                                          .clearControllers();
                                      createSalesEstimationSearchPartyController
                                          .clearControllers();
                                      createSalesViewModel.clearControllers();
                                      oldGoldController.clearTextController();
                                      createSalesViewModel.clearControllers();
                                      jewelleryPlanController
                                          .clearControllers();
                                      advanceBookingController
                                          .clearControllers();
                                      // final RateCaratInputController
                                      //     rateController =
                                      //     Get.find<RateCaratInputController>();
                                      rateController.clearController();

                                      salesPaymentDetailsController
                                          .clearAllControllers(
                                            invoiceType: "sales",
                                          );

                                      // Reset to initial state
                                      createSalesViewModel.fetchSalesNumber();

                                      // Request focus back to party search
                                      createSalesEstimationSearchPartyController
                                          .partySearchFocusNode
                                          .requestFocus();
                                    },
                                    text: "Discard (ctrl+D)",
                                    backgroundColor: grey1,
                                    textColor: primaryColor,
                                  ),
                                  CustomInkButton(
                                    onPressed: () async {
                                      if (createSalesItemDetailsController
                                              .controllers
                                              .length >
                                          1) {
                                        createSalesItemDetailsController
                                            .controllers
                                            .removeWhere(
                                              (element) =>
                                                  element.code.text.isEmpty,
                                            );

                                        // Reset current indices to safe values
                                        createSalesItemDetailsController
                                                .currentRowIndex
                                                .value =
                                            createSalesItemDetailsController
                                                    .controllers
                                                    .isEmpty
                                                ? 0
                                                : createSalesItemDetailsController
                                                        .controllers
                                                        .length -
                                                    1;

                                        createSalesItemDetailsController
                                            .currentColIndex
                                            .value = 0;
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
                                        await Future.delayed(
                                          const Duration(milliseconds: 100),
                                        );
                                      }

                                      // Collect validation errors
                                      List<String> validationErrors = [];
                                      bool isItemsDataValid =
                                          createSalesItemDetailsController
                                              .validateRow();
                                      if (isItemsDataValid == false) {
                                        validationErrors.add(
                                          "Invalid Item Data",
                                        );
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

                                      final GlobalSettingsViewModel
                                      globalSettingsViewModel =
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
                                          validationErrors.add(
                                            "Select the Sale Person ",
                                          );
                                        }
                                      }
                                      if (createSalesItemDetailsController
                                              .hasSoldItems() ==
                                          true) {
                                        validationErrors.add(
                                          "Sales contains Sold Items",
                                        );
                                      }
                                      // check if jewellery plan otp is added

                                      if (jewelleryPlanController
                                              .selectedJewelleryPlans
                                              .isNotEmpty &&
                                          jewelleryPlanController
                                                  .jewelleryPlanOtp ==
                                              null) {
                                        validationErrors.add(
                                          "Add otp for Jewellery Plans",
                                        );
                                      }
                                      if (createSalesViewModel
                                                  .selectedSequence
                                                  .value ==
                                              null ||
                                          createSalesViewModel
                                              .sequencesDropdownList
                                              .isEmpty) {
                                        validationErrors.add(
                                          "Valid sales number sequence is required",
                                        );
                                      }

                                      if (createSalesViewModel.isRateInvalid) {
                                        showErrorToast(
                                          message: "Please update the rates",
                                        );
                                        return;
                                      }

                                      // Show dialog if all validations pass, otherwise show errors
                                      if (validationErrors.isEmpty) {
                                        Get.dialog(
                                          const SalesPaymentDetailsDialog(),
                                        );
                                      } else {
                                        for (String error in validationErrors) {
                                          showErrorToast(message: error);
                                        }
                                      }
                                    },
                                    text: "Next (ctrl+S)",
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
    );
  }

  void applyJewelleryDiscount({
    required String subTotal,
    required String gstAmount,
    required String finalTotal,
  }) {
    var value = salesPaymentDetailsController.jewellerDiscount.text;
    if (value.isNotEmpty && value != "0") {
      final discount = double.tryParse(value) ?? 0;
      final salesAmount = double.tryParse(subTotal) ?? 0;
      final gst = double.tryParse(gstAmount) ?? 0;
      final gstPercent = ((gst / salesAmount) * 100);
      final salesAmountForDiscount = (discount * 100) / (gstPercent + 100);
      double jewellerDiscount =
          discount != 0 ? salesAmount - salesAmountForDiscount : 0;

      estimationItemDetailsController.distributeJewellerDiscount(
        jewellerDiscount: jewellerDiscount.toPrecision(3),
        vaFirst: true,
        gstPercent: gstPercent,
      );
    } else {
      // When discount is removed, reset and apply rounding
      estimationItemDetailsController.distributeJewellerDiscount(
        jewellerDiscount: 0,
        vaFirst: true,
        gstPercent: 0,
      );

      // Recalculate all items with rounding
      for (
        int i = 0;
        i < estimationItemDetailsController.controllers.length;
        i++
      ) {
        estimationItemDetailsController.addSalesAndTotalAmount(index: i);
      }
    }
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
              _buildDetailRow('Barcode', itemData.barcode),
              _buildDetailRow('Purity', itemData.purity ?? "-"),
              _buildDetailRow(
                'Mc',
                "${itemData.originalMc.toStringAsFixed(2)} ${itemData.makingChargesType ?? "-"}",
              ),
              _buildDetailRow('MC Total', getMcTotalValue(index: index)),
              // _buildDetailRow('Wastage', '-'),
              // _buildDetailRow('HUID', itemData.hallMark),
              _buildDetailRow('Pcs', itemData.pcs.text),
              _buildDetailRow('G.Wt. (gm)', itemData.gwt.text),
              _buildDetailRow('N.Wt. (gm)', itemData.nwt.text),
              _buildDetailRow(
                'VA',
                "${itemData.originalVa.toStringAsFixed(2)} ${itemData.wastageType ?? "-"}",
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
    final makingChargesType = itemData.makingChargesType?.toLowerCase();

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
          Container(
            constraints: const BoxConstraints(maxWidth: 160, minWidth: 80),
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

      return Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
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
        ),
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
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return GlobalImageView(imagePath: imageUrl ?? "");
          },
        );
      },
      child: Container(
        constraints: const BoxConstraints(minWidth: 163, maxWidth: 200),
        width: 163,
        height: 226,
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
          Text(
            header,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
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
