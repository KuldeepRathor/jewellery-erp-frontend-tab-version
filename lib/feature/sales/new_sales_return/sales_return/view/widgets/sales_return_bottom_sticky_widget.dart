import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view/widgets/sales_return_payment_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view_model/sales_return_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/global_image_view/global_image_view.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:svg_flutter/svg.dart';

class SalesReturnBottomStickyWidget extends StatefulWidget {
  const SalesReturnBottomStickyWidget({super.key});

  @override
  SalesReturnBottomStickyWidgetState createState() =>
      SalesReturnBottomStickyWidgetState();
}

class SalesReturnBottomStickyWidgetState
    extends State<SalesReturnBottomStickyWidget> {
  final SalesReturnItemDetailsController salesReturnItemDetailsController =
      Get.find<SalesReturnItemDetailsController>();
  final SalesReturnSearchPartyController salesReturnSearchPartyController =
      Get.find<SalesReturnSearchPartyController>();
  final SalesReturnViewmodel salesReturnViewmodel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                            SizedBox(height: 100, child: _buildImageGallery()),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Column(
                                    children: [
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
                                        salesReturnItemDetailsController
                                            .currentRowIndex
                                            .value;
                                    final itemData =
                                        salesReturnItemDetailsController
                                            .controllers[index]
                                            .itemResponse;
                                    // final employees = estimationSearchPartyController
                                    //         .getEmployeesResponse.value.data?.values ??
                                    //     [];

                                    final employee = itemData?.salesPerson;
                                    return Text(
                                      '${employee?.firstName ?? ''} ${employee?.lastName ?? ''}',
                                      // '$employee',
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
                                  final data =
                                      salesReturnViewmodel
                                          .getSaleBySalesNumberResponse
                                          .value
                                          .data;
                                  final paymentDetails =
                                      data?.paymentDetails?.firstOrNull;
                                  final gst =
                                      (double.tryParse(
                                            paymentDetails?.cgst ?? "0",
                                          ) ??
                                          0) +
                                      (double.tryParse(
                                            paymentDetails?.sgst ?? "0",
                                          ) ??
                                          0) +
                                      (double.tryParse(
                                            paymentDetails?.igst ?? "0",
                                          ) ??
                                          0);

                                  return Column(
                                    children: [
                                      _buildBillingSummaryRow(
                                        header: "Sub Total",
                                        value: paymentDetails?.subTotal ?? "0",
                                      ),
                                      _buildBillingSummaryRow(
                                        header: "GST",
                                        value: gst.toStringAsFixed(2),
                                      ),
                                      _buildBillingSummaryRow(
                                        header: "Old Gold",
                                        // Sum of all old golds total
                                        value: (data?.oldGolds ?? [])
                                            .fold<double>(
                                              0,
                                              (sum, item) =>
                                                  sum +
                                                  (double.tryParse(
                                                        item.total ?? "0",
                                                      ) ??
                                                      0),
                                            )
                                            .toStringAsFixed(2),
                                      ),
                                      _buildBillingSummaryRow(
                                        header: "Jewellery Plan Discount",
                                        // Sum of redeemable amounts from jewellery plans
                                        value: (data?.jewelleryPlans ?? [])
                                            .fold<double>(
                                              0,
                                              (sum, plan) =>
                                                  sum +
                                                  (double.tryParse(
                                                        plan.redeemableAmount ??
                                                            "0",
                                                      ) ??
                                                      0),
                                            )
                                            .toStringAsFixed(2),
                                      ),
                                      _buildBillingSummaryRow(
                                        header: "Advance Booking Discount",
                                        // Sum of advance paid from advance booking details
                                        value: (data?.advanceBookingDetails ??
                                                [])
                                            .fold<double>(
                                              0,
                                              (sum, booking) =>
                                                  sum +
                                                  (double.tryParse(
                                                        booking.advancePaid ??
                                                            "0",
                                                      ) ??
                                                      0),
                                            )
                                            .toStringAsFixed(2),
                                      ),
                                      _buildBillingSummaryRow(
                                        header: "Total",
                                        value: paymentDetails?.nettGst ?? "0",
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
                                      salesReturnItemDetailsController
                                          .clearControllers();
                                      salesReturnSearchPartyController
                                          .clearControllers();
                                      salesReturnViewmodel.clearControllers();
                                    },
                                    text: "Discard",
                                    backgroundColor: grey1,
                                    textColor: primaryColor,
                                  ),
                                  CustomInkButton(
                                    onPressed: () {
                                      // Collect validation errors
                                      List<String> validationErrors = [];

                                      bool isItemListEmpty =
                                          salesReturnItemDetailsController
                                              .controllers
                                              .where(
                                                (element) => element.isSelected,
                                              )
                                              .isEmpty;

                                      if (isItemListEmpty) {
                                        validationErrors.add(
                                          "No Items selected !",
                                        );
                                      }

                                      // Check if party is selected
                                      if (salesReturnSearchPartyController
                                              .selectedParty
                                              .value ==
                                          null) {
                                        validationErrors.add(
                                          "Please select a Party",
                                        );
                                      }

                                      // Get global settings to check if sales person is required
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

                                      // Check if sales person is selected for each item (if required)
                                      if (askSalesPersonDetails) {
                                        if (salesReturnItemDetailsController
                                            .hasNoSalesPerson()) {
                                          validationErrors.add(
                                            "Select the Sales Person for all items",
                                          );
                                        }
                                      }

                                      // Show dialog if all validations pass, otherwise show errors
                                      if (validationErrors.isEmpty) {
                                        Get.dialog(
                                          const SalesReturnPaymentDetailsDialog(),
                                        );
                                      } else {
                                        for (String error in validationErrors) {
                                          showErrorToast(message: error);
                                        }
                                      }
                                    },
                                    text: "Next (ctrl+s)",
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
      final index = salesReturnItemDetailsController.currentRowIndex.value;
      final itemData =
          salesReturnItemDetailsController.controllers[index].itemResponse;

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
              _buildDetailRow('ID', itemData?.code ?? ""),
              _buildDetailRow('Item Name/ Design', itemData?.description ?? ""),
              _buildDetailRow('Size', '-'),
              _buildDetailRow('Dealer', '-'),
              _buildDetailRow('Grade', '-'),
              _buildDetailRow('Rate', '-'),
              _buildDetailRow('Mc', itemData?.finalMc ?? ""),
              _buildDetailRow('Wastage', '-'),
              _buildDetailRow('HUID', itemData?.hallMark ?? ""),
              _buildDetailRow('Pcs', itemData?.finalPieces.toString() ?? ""),
              _buildDetailRow('G.Wt. (gm)', itemData?.finalGrossWeight ?? ""),
              _buildDetailRow('N.Wt. (gm)', itemData?.finalNetWeight ?? ""),
              _buildDetailRow('VA', itemData?.finalVa ?? ""),
              _buildDetailRow('Stone Cost (₹)', itemData?.stoneCost ?? ""),
            ],
          ),
        ],
      );
    });
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
      final index = salesReturnItemDetailsController.currentRowIndex.value;
      final stoneDetails =
          salesReturnItemDetailsController
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
                  0: FixedColumnWidth(120),
                  1: FixedColumnWidth(50),
                  2: FixedColumnWidth(80),
                  3: FixedColumnWidth(80),
                  4: FixedColumnWidth(80),
                },
                children: [
                  _buildTableRow([
                    'Stone Name',
                    'Pcs',
                    'Weight',
                    'Rate',
                    'Value',
                  ], isHeader: true),
                  if (stoneDetails.isEmpty)
                    _buildTableRow(['-', '-', '-', '-', '-'])
                  else
                    ...stoneDetails.map(
                      (stone) => _buildTableRow([
                        stone.name.text,
                        stone.pcs.text,
                        stone.weightUnit,
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
      final index = salesReturnItemDetailsController.currentRowIndex.value;
      final images = salesReturnItemDetailsController.controllers[index].images;

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
