import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view/widget/animated_outward_report_bottom_sticky_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view/widget/outward_report_detail_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view_model/outward_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class OutwardReportDetailsWidget extends StatefulWidget {
  const OutwardReportDetailsWidget({super.key});

  @override
  State<OutwardReportDetailsWidget> createState() =>
      _OutwardReportDetailsWidgetState();
}

class _OutwardReportDetailsWidgetState
    extends State<OutwardReportDetailsWidget> {
  final OutwardReportViewmodel controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.isDetailsVisible.value = false;
    // Clear the search query for details page
    controller.searchQueryDetails.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              HeaderWidget(
                header: "Outward Report",
                wantBackButton: true,
                onBackButtonTap: () {
                  Get.back();
                  // SidebarController sidebarController = Get.find();
                  // sidebarController.popBackSelectedWidget();
                },
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: getDeviceWidth(context) * 0.25,
                      child: _buildSearchField(),
                    ),
                    const OutwardReportDetailFilterWidget(),
                    const Spacer(),
                    CustomButton2(
                      backgroundColor: grey1,
                      textColor: primaryBtnColor,
                      onTap: () async {
                        await controller.downloadReportDetails();
                      },
                      image: 'assets/svgs/download.svg',
                      buttonName: 'Download',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Item-wise Outward Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Obx(() {
                              final response =
                                  controller.getOutwardDetailsResponse.value;

                              if (response.status == Status.LOADING) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (response.status == Status.ERROR) {
                                return Center(
                                  child: Text(
                                    response.message ?? 'Something went wrong',
                                  ),
                                );
                              }

                              if (response.status == Status.COMPLETED) {
                                final data = response.data?.values ?? [];

                                if (data.isEmpty) {
                                  return const Center(
                                    child: Text('No details available'),
                                  );
                                }

                                // Filter data based on search query
                                final filteredData =
                                    controller.searchQueryDetails.value.isEmpty
                                        ? data
                                        : data.where((item) {
                                          final query =
                                              controller
                                                  .searchQueryDetails
                                                  .value
                                                  .toLowerCase();
                                          return (item.code
                                                      ?.toLowerCase()
                                                      .contains(query) ??
                                                  false) ||
                                              (item.description
                                                      ?.toLowerCase()
                                                      .contains(query) ??
                                                  false) ||
                                              (item.voucherNumber
                                                      ?.toLowerCase()
                                                      .contains(query) ??
                                                  false) ||
                                              (item.transactionType
                                                      ?.toLowerCase()
                                                      .contains(query) ??
                                                  false);
                                        }).toList();

                                if (filteredData.isEmpty) {
                                  return const Center(
                                    child: Text('No items match your search'),
                                  );
                                }

                                return CustomTableWidget(
                                  headers: [_buildTableHeaders()],
                                  columnWidths: const [
                                    0.3, // Date
                                    0.3, // Tag No.
                                    0.4, // Description
                                    0.2, // Pcs
                                    0.3, // Purity
                                    0.3, // Gr.Wt
                                    0.3, // N.Wt
                                    0.3, // VA
                                    0.3, // MC
                                    0.3, // St.wt(cts)
                                    0.3, // St.Amount
                                    0.4, // Transaction Type
                                    0.3, // Voucher No.
                                  ],
                                  rows: _buildTableRows(filteredData),
                                  isLoadingMore: false,
                                  addSizedBox: true,
                                );
                              }

                              return const SizedBox();
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => AnimatedOutwardReportDetailsBottomWidget(
                isVisible: controller.isDetailsVisible.value,
                onClose: controller.hideItemDetails,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        onChanged: controller.setSearchQueryDetails,
        autofocus: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(color: greyTextColor),
          suffixIcon: Icon(Icons.search, size: 16),
        ),
      ),
    );
  }

  TableRow _buildTableHeaders() {
    return TableRow(
      children:
          [
                'Date',
                'Tag No.',
                'Description',
                'Pcs',
                'Purity',
                'Gr.Wt',
                'N.Wt',
                'VA (Out)',
                'MC (Out)',
                'St.wt(cts)',
                'St.Amount',
                'Transaction Type',
                'Voucher No.',
              ]
              .map(
                (header) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Text(
                    header,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  List<TableRow> _buildTableRows(
    List<GetOutwardReportDetailsResponseValue> data,
  ) {
    List<TableRow> rows = [];

    data.asMap().forEach((index, item) {
      rows.add(
        TableRow(
          children: [
            // Date
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(
                item.createdAt != null
                    ? convertDateTimeToString(item.createdAt)
                    : '-',
              ),
            ),
            // Tag No. (using code)
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell("${item.code} - ${item.tagNumber}"),
            ),
            // Description
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(item.description ?? '-'),
            ),
            // Pcs (pieces)
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(item.pieces.toString()),
            ),
            // Purity - You might need to add this field to your model or calculate it
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(item.purity ?? '-'),
            ),
            // Gr.Wt (Gross Weight)
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(item.grossWeight ?? '-'),
            ),
            // N.Wt (Net Weight)
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(item.netWeight ?? '-'),
            ),
            // VA (using finalVa or taggingVa)
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(item.va ?? '-'),
            ),
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(item.mc ?? '-'),
            ),
            // St.wt(cts) - Stone weight in carats
            // You'll need to add this field to your model or fetch it from stone data
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(
                item.stoneCarats ?? '-',
              ), // Update based on your stone data
            ),
            // St.Amount - Stone amount
            // You'll need to add this field to your model or fetch it from stone data
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(
                item.stoneAmount ?? '-',
              ), // Update based on your stone data
            ),
            // Transaction Type
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(item.transactionType ?? '-'),
            ),
            // Voucher No. (using invoiceNumber)
            GestureDetector(
              onTap: () => controller.showItemDetails(item),
              child: _buildTableCell(item.voucherNumber ?? '-'),
            ),
          ],
        ),
      );
    });

    return rows;
  }

  Widget _buildTableCell(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Tooltip(
          message: text,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
