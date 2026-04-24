import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/view_model/view_stock_issue_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

import '../model/get_stock_issue_by_id.dart';

class ViewStockIssueBottomStickyWidget extends StatefulWidget {
  const ViewStockIssueBottomStickyWidget({super.key});

  @override
  ViewStockIssueBottomStickyWidgetState createState() =>
      ViewStockIssueBottomStickyWidgetState();
}

class ViewStockIssueBottomStickyWidgetState
    extends State<ViewStockIssueBottomStickyWidget> {
  final f = Get.put(CreateSalesEstimationSearchPartyController());
  final ff = Get.put(CreateSalesItemDetailsController());

  final estimationItemDetailsController =
      Get.find<CreateSalesItemDetailsController>();

  final CreateSalesEstimationSearchPartyController
  createSalesEstimationSearchPartyController =
      Get.find<CreateSalesEstimationSearchPartyController>();

  final ViewApprovalIssueController stockIssueController = Get.put(
    ViewApprovalIssueController(),
  );

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final response = stockIssueController.getInvoiceDetailsResponse.value;

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
                    ? lineItems[stockIssueController.currentRowIndex.value]
                    : null;
            // final taggingRecord = selectedLineItem?.taggingLineItem;

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
                                    // taggingRecord
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(color: grey2, thickness: 3),
                        Expanded(
                          flex: 3,
                          child: _buildStoneDetails(selectedLineItem),
                        ),
                        const VerticalDivider(
                          color: primaryColor,
                          thickness: 3,
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

  Widget _buildItemDetails(
    GetStockIssueByIdResponseLineItem? lineItem,
    // TaggingRecord? taggingRecord
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
            _buildDetailRow('ID', lineItem?.taggingLineItem?.code ?? ''),
            _buildDetailRow(
              'Item Name/ Design',
              lineItem?.taggingLineItem?.design?.name ?? "",
              // taggingRecord?.design?.name ?? ''
            ),
            _buildDetailRow(
              'MC',
              '${lineItem?.taggingLineItem?.mc ?? "0"} ${lineItem?.taggingLineItem?.designLineItem?.makingChargesType ?? "-"}',
            ),
            _buildDetailRow(
              'Pcs',
              lineItem?.taggingLineItem?.pieces?.toString() ?? '0',
            ),
            _buildDetailRow(
              'G.Wt. (gm)',
              lineItem?.taggingLineItem?.grossWeight ?? '0',
            ),
            _buildDetailRow(
              'N.Wt. (gm)',
              lineItem?.taggingLineItem?.netWeight ?? '0',
            ),
            _buildDetailRow(
              'VA',
              '${lineItem?.taggingLineItem?.va ?? "0"} ${lineItem?.taggingLineItem?.designLineItem?.wastageType ?? "-"}',
            ),
            _buildDetailRow(
              'Stone Cost (₹)',
              lineItem
                      ?.taggingLineItem
                      ?.designLineItem
                      ?.ornament
                      ?.openingAmount ??
                  '0',
            ),
            _buildDetailRow(
              'Barcode No',
              lineItem?.taggingLineItem?.tagBarcode ?? '0',
            ),
            _buildDetailRow(
              'Vendor Code',
              lineItem?.taggingLineItem?.vendorId ?? '0',
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

  Widget _buildStoneDetails(GetStockIssueByIdResponseLineItem? lineItem) {
    List<StoneDetailsTableData> stoneDetails =
        lineItem?.taggingLineItem?.lineStones
            ?.map(
              (v) => StoneDetailsTableData(
                name: TextEditingController(text: v["name"]),
                carat_weight: TextEditingController(text: v["carat_weight"]),
                pcs: TextEditingController(text: "${v["pieces"] ?? ""}"),
                rate: TextEditingController(text: v["rate"]),
                total: TextEditingController(text: v["total"]),
                weightUnit: "${v["weight"] ?? "-"}",
                id: v["id"] ?? "",
              ),
            )
            .toList() ??
        [];

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
                  4: FixedColumnWidth(80),
                  5: FixedColumnWidth(80),
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
}
