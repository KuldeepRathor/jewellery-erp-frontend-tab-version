import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/get_tagging_item_report_response.dart'
    as tag_report;
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/weight_group_detail_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view/widget/tagged_item_report_detail_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view/widget/weight_group_detail_page_stone_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view_model/tagged_item_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg.dart';

class StockHeadDetailsPage extends StatefulWidget {
  final tag_report.GetTaggingItemReportValue stockHead;
  final WeightGroupDetailResponse detailsData;

  const StockHeadDetailsPage({
    super.key,
    required this.stockHead,
    required this.detailsData,
  });

  @override
  State<StockHeadDetailsPage> createState() => _StockHeadDetailsPageState();
}

class _StockHeadDetailsPageState extends State<StockHeadDetailsPage> {
  late TaggedItemReportViewModel controller;
  final FocusNode _tableFocusNode = FocusNode();
  final RxInt selectedRowIndex = (-1).obs;
  final Rx<WeightGroupDetailValue?> selectedItem = Rx<WeightGroupDetailValue?>(
    null,
  );
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<TaggedItemReportViewModel>();
    if (widget.detailsData.values != null &&
        widget.detailsData.values!.isNotEmpty) {
      selectedRowIndex.value = 0;
      selectedItem.value = widget.detailsData.values![0];
    }
  }

  @override
  void dispose() {
    _tableFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateSelectedDetails(int index) {
    if (widget.detailsData.values != null &&
        widget.detailsData.values!.isNotEmpty &&
        index >= 0 &&
        index < widget.detailsData.values!.length) {
      selectedItem.value = widget.detailsData.values![index];
    }
  }

  void _selectPreviousRow() {
    if (selectedRowIndex.value > 0) {
      selectedRowIndex.value = selectedRowIndex.value - 1;
      _updateSelectedDetails(selectedRowIndex.value);
      _scrollToSelectedItem();
    }
  }

  void _selectNextRow() {
    final maxIndex = (widget.detailsData.values?.length ?? 0) - 1;
    if (selectedRowIndex.value < maxIndex) {
      selectedRowIndex.value = selectedRowIndex.value + 1;
      _updateSelectedDetails(selectedRowIndex.value);
      _scrollToSelectedItem();
    }
  }

  void _scrollToSelectedItem() {
    final selectedIndex = selectedRowIndex.value;
    if (selectedIndex >= 0 && _scrollController.hasClients) {
      const itemHeight = 60.0; // Approximate height of each row
      final scrollPosition = selectedIndex * itemHeight;

      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showStoneDetailsDialog() {
    if (widget.detailsData.stoneData != null) {
      Get.dialog(
        StoneDetailsDialogForWeightGroup(
          stoneData: widget.detailsData.stoneData,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: FocusScope(
        child: KeyboardListener(
          focusNode: _tableFocusNode,
          onKeyEvent: (KeyEvent event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                _selectPreviousRow();
              } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                _selectNextRow();
              }
            }
          },
          child: Column(
            children: [
              HeaderWidget(
                header: "Stock Head Details",
                wantBackButton: true,
                onBackButtonTap: () {
                  Get.back();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        Expanded(child: _buildItemsList()),
                        _buildDetailsPanel(),
                        // Add total row at the very bottom
                        if (widget.detailsData.total != null)
                          _buildTotalRow(widget.detailsData.total!),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Stock Head Details",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "Stock Head: ${widget.stockHead.stockHeadName}",
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            // Add Expanded to give the Row bounded constraints
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align items to the end
              children: [
                const TaggedItemReportDetailFilterWidget(),
                const SizedBox(width: 16), // Use SizedBox instead of Spacer
                CustomButton2(
                  backgroundColor: grey1,
                  textColor: primaryBtnColor,
                  onTap: () {
                    // Download logic here
                  },
                  image: 'assets/svgs/download.svg',
                  buttonName: 'Download',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    final items = widget.detailsData.values ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(),
          Expanded(
            child:
                items.isEmpty
                    ? Center(
                      child: SvgPicture.asset(
                        'assets/svgs/error/no_records_found.svg',
                      ),
                    )
                    : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Obx(
                                () => _buildItemRow(items[index], index),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: _HeaderText("Sn")),
          Expanded(flex: 1, child: _HeaderText("Code")),
          Expanded(flex: 1, child: _HeaderText("Tag No.")),
          Expanded(flex: 1, child: _HeaderText("Barcode No.")),
          Expanded(flex: 1, child: _HeaderText("Purity")),
          Expanded(flex: 3, child: _HeaderText("Item")),
          Expanded(flex: 1, child: _HeaderText("Pcs")),
          Expanded(flex: 1, child: _HeaderText("G.Wt(gm)")),
          Expanded(flex: 1, child: _HeaderText("N.Wt(gm)")),
          Expanded(flex: 1, child: _HeaderText("VA")),
          Expanded(flex: 1, child: _HeaderText("St.wt(ct)")),
          Expanded(flex: 1, child: _HeaderText("Stone Amt")),
          Expanded(flex: 1, child: _HeaderText("Counter")),
        ],
      ),
    );
  }

  Widget _buildItemRow(WeightGroupDetailValue item, int index) {
    final isSelected = selectedRowIndex.value == index;
    final srNo = index + 1;
    return InkWell(
      onTap: () {
        selectedRowIndex.value = index;
        _updateSelectedDetails(index);
      },
      child: Container(
        color: isSelected ? greyTextColor.withOpacity(0.2) : Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  // Date
                  Expanded(
                    flex: 1,
                    child: Text(
                      srNo.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // Code
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.code ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.tagNumber.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.tagBarcode ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.purity ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // Description
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.design?.name ?? 'N/A',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // Pieces
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.pieces?.toString() ?? '0',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // Gross Weight
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.grossWeight ?? '0',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // Net Weight
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.netWeight ?? '0',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // VA
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.va ?? '0',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // Stone
                  Expanded(
                    flex: 1,
                    child: Text(
                      _calculateTotalStoneCarat(item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      _calculateTotalStoneAmount(item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // MC
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.counter?.counterName.toString() ?? '0',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const CustomDashedLineWidget(width: double.infinity),
          ],
        ),
      ),
    );
  }

  String _calculateTotalStoneCarat(WeightGroupDetailValue item) {
    if (item.lineStones == null || item.lineStones!.isEmpty) {
      return '0';
    }

    double totalCarat = 0;
    for (var stone in item.lineStones!) {
      totalCarat += double.tryParse(stone.carat ?? '0') ?? 0;
    }

    return totalCarat.toStringAsFixed(2);
  }

  String _calculateTotalStoneAmount(WeightGroupDetailValue item) {
    if (item.lineStones == null || item.lineStones!.isEmpty) {
      return '0';
    }

    double totalAmount = 0;
    for (var stone in item.lineStones!) {
      totalAmount += double.tryParse(stone.total ?? '0') ?? 0;
    }

    return totalAmount.toStringAsFixed(2);
  }

  Widget _buildTotalRow(WeightGroupDetailTotal total) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: greenColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        child: Row(
          children: [
            // Date column - empty
            const Expanded(flex: 1, child: Text('')),
            // Code column - empty
            const Expanded(flex: 1, child: Text('')),
            // Description - shows "Total"
            const Expanded(
              flex: 3,
              child: Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Expanded(flex: 1, child: Text('')),
            const Expanded(flex: 1, child: Text('')),
            const Expanded(flex: 1, child: Text('')),
            // Pieces
            Expanded(
              flex: 1,
              child: Text(
                '${total.totalPieces ?? 0}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Gross Weight
            Expanded(
              flex: 1,
              child: Text(
                total.totalGrossWeight ?? '0',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Net Weight
            Expanded(
              flex: 1,
              child: Text(
                total.totalNetWeight ?? '0',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // VA
            Expanded(
              flex: 1,
              child: Text(
                total.totalVa ?? '0',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Stone - Clickable with underline
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  _showStoneDetailsDialog();
                },
                child: Text(
                  total.totalStoneCts ?? '0',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: Text('')),
            // MC - empty
            const Expanded(flex: 1, child: Text('')),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsPanel() {
    return Obx(() {
      final item = selectedItem.value;
      if (item == null) {
        return const SizedBox(height: 180);
      }

      // Get actual data from API response
      // final recNo = item.tagNumber?.toString() ?? "-";
      // final taggedBy = item.tagBarcode ?? "-";
      final code = item.code ?? "-";
      final purity = item.purity ?? "-";
      final itemName = item.design?.name ?? "-";
      final size = item.sizeGroup?.size ?? "NONE";
      final rate = item.rate ?? "-";
      final mc = item.designLineItem?.makingCharges ?? "-";
      final wastage = item.designLineItem?.wastage ?? "-";
      final huid = item.huid ?? "-";

      final vendorCode = item.vendorCode ?? "-";
      final user =
          item.employeeDetails != null
              ? "${item.employeeDetails?.firstName ?? ''} ${item.employeeDetails?.lastName ?? ''}"
                  .trim()
              : "-";

      // Format created date/time if available
      final createdAt = item.designLineItem?.ornament?.createdAt;
      final formattedDate =
          createdAt != null
              ? "${createdAt.day}-${createdAt.month}-${createdAt.year}"
              : "-";

      // Get line stones for stone details
      final lineStones = item.lineStones ?? [];

      // Function to create a detail row similar to TaggedItemReportAnimatedItemDetailsWidget
      Widget detailRow(String label, String value) {
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
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
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

      // Table row builder for stone details
      TableRow buildStoneTableRow(List<String> cells, {bool isHeader = false}) {
        return TableRow(
          children:
              cells
                  .map(
                    (cell) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      child: Tooltip(
                        message: cell,
                        child: Text(
                          cell,
                          style: TextStyle(
                            color:
                                isHeader
                                    ? const Color(0xFF28328B)
                                    : Colors.black,
                            fontWeight:
                                isHeader ? FontWeight.bold : FontWeight.normal,
                            fontSize: isHeader ? 12 : 14,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        );
      }

      // Build images section
      Widget buildImagesSection() {
        if (item.images == null || item.images!.isEmpty) {
          // No images - show placeholder
          return SizedBox(
            width: 226,
            height: 163,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/svgs/error/no_image_found.svg'),
            ),
          );
        }

        return SizedBox(
          height: 163,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: item.images!.length,
            itemBuilder: (context, index) {
              final imageUrl = item.images![index].presignedUrl;
              if (imageUrl == null) {
                return Container(
                  width: 163,
                  height: 163,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return Container(
                width: 163,
                height: 163,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        );
      }

      return Container(
        height: 250, // Increased height to accommodate the new layout
        decoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF28328B),
                // borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'Item Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      selectedItem.value = null;
                      selectedRowIndex.value = -1;
                    },
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Left section - Item Details and Images
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item Details Section
                            const Text(
                              'Item Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                detailRow('Barcode', code),
                                detailRow('Item Name/ Design', itemName),
                                detailRow('Size', size),
                                detailRow('Vendor Code', vendorCode),
                                detailRow('Purity', purity),
                                detailRow('HUID', huid),
                                detailRow('HUID', huid),
                                detailRow('Mc', mc),
                                detailRow('Wastage', wastage),
                                detailRow('Last Scanned At', formattedDate),
                                detailRow('Rate', rate),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Images Section
                            buildImagesSection(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    const VerticalDivider(color: secondaryColor, thickness: 3),
                    const SizedBox(width: 24),
                    // Right section - Stone Details
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Stone Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Table(
                                columnWidths: const {
                                  0: FixedColumnWidth(160),
                                  1: FixedColumnWidth(60),
                                  2: FixedColumnWidth(100),
                                  3: FixedColumnWidth(100),
                                  4: FixedColumnWidth(100),
                                },
                                children: [
                                  buildStoneTableRow([
                                    'Stone Name',
                                    'Pcs',
                                    'Weight',
                                    'Rate',
                                    'Value',
                                  ], isHeader: true),
                                  if (lineStones.isEmpty)
                                    buildStoneTableRow([
                                      '-',
                                      '-',
                                      '-',
                                      '-',
                                      '-',
                                    ])
                                  else
                                    ...lineStones.map(
                                      (stone) => buildStoneTableRow([
                                        stone.name ?? '-',
                                        stone.pieces?.toString() ?? '-',
                                        stone.weight ?? stone.carat ?? '-',
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
                    ),
                  ],
                ),
              ),
            ),
            // Footer with Tagged By information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                // color: Color(0xFFF5F5F5),
                // borderRadius:
                //     BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Text(
                    'Tagged By: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    user,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
