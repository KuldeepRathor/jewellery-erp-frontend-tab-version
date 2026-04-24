import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/advance_booking/sales_advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/jewellery_plan/sales_jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/old_gold/sales_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/orders/sales_add_order_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view_model/view_sales_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:svg_flutter/svg.dart';

class ViewSalesBottomStickyWidget extends StatefulWidget {
  const ViewSalesBottomStickyWidget({super.key});

  @override
  ViewSalesBottomStickyWidgetState createState() =>
      ViewSalesBottomStickyWidgetState();
}

class ViewSalesBottomStickyWidgetState
    extends State<ViewSalesBottomStickyWidget> {
  final estimationItemDetailsController =
      Get.find<CreateSalesItemDetailsController>();

  final CreateSalesEstimationSearchPartyController
  createSalesEstimationSearchPartyController =
      Get.find<CreateSalesEstimationSearchPartyController>();
  // final CreateSalesItemDetailsController createSalesItemDetailsController =
  //     Get.find<CreateSalesItemDetailsController>();

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
  final ViewSalesController viewSalesController =
      Get.find<ViewSalesController>();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final response =
              viewSalesController.getSalesRecordByIdAggregateResponse.value;

          if (response.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (response.status == Status.ERROR) {
            return Center(child: Text('Error: ${response.message}'));
          }

          if (response.status == Status.COMPLETED && response.data != null) {
            final lineItems = response.data?.lineItems ?? [];
            final selectedLineItem =
                lineItems.isNotEmpty
                    ? lineItems[estimationItemDetailsController
                        .currentRowIndex
                        .value]
                    : null;
            final taggingRecord = selectedLineItem?.taggingRecord;

            return Column(
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
                                  _buildItemDetails(
                                    selectedLineItem,
                                    taggingRecord,
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 100,
                                    child: _buildImageGallery(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            const SizedBox(height: 24),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  color: primaryColor,
                                                ),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Sales Person: ',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  " ${selectedLineItem?.salesPerson?.firstName} ${selectedLineItem?.salesPerson?.lastName}",
                                                  style: const TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
                        const VerticalDivider(
                          color: primaryColor,
                          thickness: 3,
                        ),
                        Expanded(
                          flex: 3,
                          child: _buildBillingSummary(response.data),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        }),
      ),
    );
  }

  Widget _buildBillingSummary(GetSalesRecordByIdAggregateResponse? data) {
    if (data == null) return const SizedBox();

    final payment = data.paymentDetails?.firstOrNull;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Billing Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildBillingSummaryRow('Sub Total', payment?.subTotal ?? '0'),
          _buildBillingSummaryRow('GST', payment?.nettGst ?? '0'),
          _buildBillingSummaryRow(
            'Old Gold Discount',
            payment?.purchaseOldGold ?? '0',
          ),
          _buildBillingSummaryRow(
            'Jeweller Discount',
            data.jewellerDiscount?.toString() ?? '0',
          ),
          _buildBillingSummaryRow(
            'Total',
            payment?.finalAmount ?? '0',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingSummaryRow(
    String header,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            '₹ ${formatCurrency(value)}',
            style: TextStyle(
              fontSize: 16,
              color: isTotal ? secondaryColor : null,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetails(
    GetSalesRecordByIdAggregateResponseLineItem? lineItem,
    TaggingRecord? taggingRecord,
  ) {
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
            _buildDetailRow('ID', lineItem?.taggingRecord?.tagBarcode ?? '0'),
            _buildDetailRow(
              'Item Name/ Design',
              taggingRecord?.design?.name ?? '',
            ),
            _buildDetailRow('Size', taggingRecord?.sizeGroup?.size ?? '-'),
            _buildDetailRow(
              'MC',
              '${lineItem?.finalMc ?? "0"} ${lineItem?.makingChargesType ?? "-"}',
            ),
            _buildDetailRow('Pcs', lineItem?.finalPieces?.toString() ?? '0'),
            _buildDetailRow('G.Wt. (gm)', lineItem?.finalGrossWeight ?? '0'),
            _buildDetailRow('N.Wt. (gm)', lineItem?.finalNetWeight ?? '0'),
            _buildDetailRow(
              'VA',
              '${lineItem?.finalVa ?? "0"} ${lineItem?.wastageType ?? "-"}',
            ),
            _buildDetailRow('Stone Cost (₹)', lineItem?.stoneCost ?? '0'),
            _buildDetailRow(
              'Vendor Code',
              lineItem?.taggingRecord?.vendorCode ?? '0',
            ),
            _buildDetailRow('Purity', lineItem?.taggingRecord?.purity ?? '0'),
            _buildDetailRow('HUID', lineItem?.taggingRecord?.huid ?? '-'),
            _buildDetailRow(
              'Stock Head',
              lineItem?.taggingRecord?.design?.stockHead?.name ?? '-',
            ),
            _buildDetailRow(
              'Stock Head',
              lineItem
                      ?.taggingRecord
                      ?.design
                      ?.stockHead
                      ?.category
                      ?.categoryName ??
                  '-',
            ),
          ],
        ),
      ],
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
        ],
      ),
    );
  }

  Widget _buildStoneDetails() {
    return Obx(() {
      final response =
          viewSalesController.getSalesRecordByIdAggregateResponse.value;

      if (response.status != Status.COMPLETED || response.data == null) {
        return const SizedBox();
      }

      final lineItems = response.data?.lineItems ?? [];
      final index = estimationItemDetailsController.currentRowIndex.value;

      // Get the line stones from the selected line item
      List<LineStone>? lineStones;
      if (index >= 0 && index < lineItems.length) {
        lineStones = lineItems[index].taggingRecord?.lineStones;
      }

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
                    if (lineStones == null || lineStones.isEmpty)
                      _buildTableRow(['-', '-', '-', '-', '-', '-'])
                    else
                      ...lineStones.map(
                        (stone) => _buildTableRow([
                          stone.name ?? '-',
                          stone.pieces?.toString() ?? '-',
                          stone.carat ?? stone.weight?.toString() ?? '-',
                          stone.carat != null ? 'CT' : 'GM',
                          stone.rate ?? '-',
                          stone.total ?? '-',
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
      final response =
          viewSalesController.getSalesRecordByIdAggregateResponse.value;

      if (response.status != Status.COMPLETED || response.data == null) {
        return const SizedBox();
      }

      final lineItems = response.data?.lineItems ?? [];
      final selectedLineItem =
          lineItems.isNotEmpty
              ? lineItems[estimationItemDetailsController.currentRowIndex.value]
              : null;

      // Safely extract images, handling different response structures
      List<dynamic> allImages = [];

      // Add design images if they exist
      final designImages = selectedLineItem?.taggingRecord?.design?.images;
      if (designImages != null) {
        allImages.addAll(designImages);
      }

      // Add tagging images if they exist
      final taggingImages = selectedLineItem?.taggingRecord?.images;
      if (taggingImages != null) {
        allImages.addAll(taggingImages);
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allImages.isEmpty ? 1 : allImages.length,
        itemBuilder: (context, index) {
          if (allImages.isEmpty) {
            return _buildImageCard();
          }

          // Safely extract presignedUrl
          String? imageUrl;
          try {
            final imageData = allImages[index];
            // Check if it's a map with presignedUrl
            if (imageData is Map) {
              imageUrl = imageData['presignedUrl']?.toString();
            } else if (imageData != null) {
              // Try accessing as a property if it's not a map
              imageUrl = imageData.presignedUrl?.toString();
            }
          } catch (e) {
            // Handle any errors gracefully
            log('Error extracting image URL: $e');
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildImageCard(imageUrl: imageUrl),
          );
        },
      );
    });
  }

  Widget _buildImageCard({String? imageUrl}) {
    return Container(
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
                child: SvgPicture.asset('assets/svgs/error/no_image_found.svg'),
              )
              : const SizedBox.shrink(),
    );
  }

  // Widget _buildBillingSummaryRow(
  //     {required String header, required String value, bool isTotal = false}) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text(
  //           header,
  //           style: const TextStyle(
  //             fontSize: 16,
  //             fontFamily: 'Satoshi',
  //             fontWeight: FontWeight.w700,
  //           ),
  //         ),
  //         Text(
  //           '₹ $value',
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: isTotal ? secondaryColor : null,
  //             fontFamily: 'Satoshi',
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
