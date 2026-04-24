import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/model/get_tagging_item_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view/widget/tagged_item_report_basic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view/widget/tagged_item_report_stone_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view_model/tagged_item_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg.dart';

class TaggedItemReport extends GetView<TaggedItemReportViewModel> {
  const TaggedItemReport({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<TaggedItemReportViewModel>(
      TaggedItemReportViewModel(),
    );
    return Scaffold(
      backgroundColor: grey1,
      body: GetBuilder<TaggedItemReportViewModel>(
        init: controller,
        builder: (_) {
          return FocusScope(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  header: "Tagged Item Details",
                  isReport: true,
                  onBackButtonTap: () {
                    Get.back();
                  },
                  wantBackButton: true,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActionBar(context),
                        const SizedBox(height: 8),
                        _buildItemReport(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: getDeviceWidth(context) * 0.25,
          child: _buildSearchField(),
        ),
        const TaggedItemReportFilterWidget(),
        const Spacer(),
        Row(
          children: <Widget>[
            const Text(
              'Display By: ',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value:
                      controller.isWeightGroupView.value
                          ? 'Weight Group'
                          : 'Stock Head',
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontFamily: 'Satoshi',
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.isWeightGroupView.value =
                          newValue == 'Weight Group';
                      controller.update();
                    }
                  },
                  items:
                      <String>[
                        'Stock Head',
                        'Weight Group',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        CustomButton2(
          backgroundColor: grey1,
          textColor: primaryBtnColor,
          onTap: () async {
            await controller.downloadTaggedItemReport();
          },
          image: 'assets/svgs/download.svg',
          buttonName: 'Download',
        ),
      ],
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
        onChanged: controller.setSearchQuery,
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

  Widget _buildItemReport(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    "Tagged Item Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (controller.pickedDateRange != null)
                    Text(
                      "(${controller.dateFormat.format(controller.pickedDateRange!.start)} - ${controller.dateFormat.format(controller.pickedDateRange!.end)})",
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
            ),
            Expanded(child: _buildTableContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTableContent() {
    return Obx(() {
      final apiStatus = controller.taggingItemReportResponse.value.status;

      if (apiStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      if (apiStatus == Status.ERROR) {
        return Center(
          child: Text(
            controller.taggingItemReportResponse.value.message ??
                "Something went wrong",
          ),
        );
      }

      if (apiStatus == Status.COMPLETED) {
        final data = controller.taggingItemReportResponse.value.data;
        if (data?.values?.isEmpty ?? true) {
          return Center(
            child: SvgPicture.asset('assets/svgs/error/no_records_found.svg'),
          );
        }

        return Column(
          children: [
            _buildTableHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isWeightGroupView.value) {
                  return _buildWeightGroupView(data!);
                } else {
                  return _buildStockHeadView(data!);
                }
              }),
            ),
            // Add total row at the bottom
            if (data?.total != null) _buildTotalRow(data!.total!),
          ],
        );
      }

      return const Center(child: CircularProgressIndicator());
    });
  }

  Widget _buildStockHeadView(GetTaggingItemReportResponse data) {
    // Stock Head view - only show stock heads with their totals (no expandable sections)
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.values!.length,
      itemBuilder: (context, index) {
        final stockHead = data.values![index];
        return _buildStockHeadRow(stockHead);
      },
    );
  }

  Widget _buildWeightGroupView(GetTaggingItemReportResponse data) {
    // Create combined widgets for all stock heads and their weight groups
    List<Widget> allItems = [];

    for (var stockHead in data.values!) {
      // Always add stock head row regardless of whether it has weight groups
      allItems.add(
        Container(
          color: Colors.grey[100],
          child: _buildStockHeadRow(stockHead),
        ),
      );

      // Only add weight groups if they exist
      if (stockHead.weightGroups != null &&
          stockHead.weightGroups!.isNotEmpty) {
        for (var weightGroup in stockHead.weightGroups!) {
          allItems.add(_buildWeightGroupRow(weightGroup, stockHead));
        }
      }
    }

    return ListView(shrinkWrap: true, children: allItems);
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(flex: 2, child: _headerText("Items")),
            Expanded(flex: 2, child: _headerText("")),
            Expanded(child: _headerText("Pc", textAlign: TextAlign.right)),
            Expanded(
              child: _headerText("Gross Wt", textAlign: TextAlign.right),
            ),
            Expanded(child: _headerText("Nett Wt", textAlign: TextAlign.right)),
            Expanded(
              child: _headerText("Stone (cts)", textAlign: TextAlign.right),
            ),
            Expanded(child: _headerText("VA(gms)", textAlign: TextAlign.right)),
            Expanded(
              child: _headerText("Stone Amt", textAlign: TextAlign.right),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerText(String text, {TextAlign textAlign = TextAlign.left}) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      textAlign: textAlign,
    );
  }

  // Stock Head row that shows stock head name and totals
  Widget _buildStockHeadRow(GetTaggingItemReportValue stockHead) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            controller.viewStockHeadDetails(stockHead: stockHead);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    stockHead.stockHeadName ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    '',
                  ), // Empty column for Item Group in Stock Head view
                ),
                Expanded(
                  child: Text(
                    '${stockHead.total?.totalPieces ?? 0}',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.totalGrossWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.totalNetWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.totalStoneCts ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.totalVa ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.totalStoneAmount ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
        const CustomDashedLineWidget(width: double.infinity),
      ],
    );
  }

  // Weight Group row for the weight group view
  Widget _buildWeightGroupRow(
    WeightGroup group,
    GetTaggingItemReportValue stockHead,
  ) {
    return InkWell(
      onTap: () {
        controller.viewWeightGroupDetails(stockHead: stockHead, group: group);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(""), // Empty column for Stock Head
                ),
                Expanded(flex: 2, child: Text(group.weight ?? '')),
                Expanded(
                  child: Text(
                    '${group.pieces ?? 0}',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    group.grossWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    group.netWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    group.stoneCts ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(group.va ?? '0', textAlign: TextAlign.right),
                ),
                Expanded(
                  child: Text(
                    group.stoneAmount ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const CustomDashedLineWidget(width: double.infinity),
        ],
      ),
    );
  }

  // Total row at the bottom of the table
  Widget _buildTotalRow(Total total) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: greenColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            const Expanded(
              flex: 2,
              child: Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Expanded(
              flex: 2,
              child: Text(''), // Empty column for Item Group
            ),
            Expanded(
              child: Text(
                '${total.totalPieces ?? 0}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: Text(
                total.totalGrossWeight ?? '0',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: Text(
                total.totalNetWeight ?? '0',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
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
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Expanded(
              child: Text(
                total.totalVa ?? '0',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: Text(
                total.totalStoneAmount ?? '0',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStoneDetailsDialog() {
    final data = controller.taggingItemReportResponse.value.data;
    if (data?.stoneData != null) {
      Get.dialog(StoneDetailsDialogForReport(stoneData: data!.stoneData));
    }
  }
}
