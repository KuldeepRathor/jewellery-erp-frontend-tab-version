import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/model/get_outward_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view/widget/outward_report_stone_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view/outward_report_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view/widget/outward_report_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view_model/outward_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg.dart';

class OutwardReportPage extends StatefulWidget {
  const OutwardReportPage({super.key});

  @override
  State<OutwardReportPage> createState() => _OutwardReportPageState();
}

class _OutwardReportPageState extends State<OutwardReportPage> {
  final OutwardReportViewmodel controller = Get.put(OutwardReportViewmodel());

  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getOutwardReportListing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: GetBuilder<OutwardReportViewmodel>(
        init: controller,
        builder: (_) {
          return FocusScope(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  header: 'Outward Report',
                  isReport: true,
                  wantBackButton: true,
                  onBackButtonTap: () {
                    Get.back();
                  },
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
                        _buildOutwardReport(context),
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
        const OutwardReportFilterWidget(),
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
              child: Obx(
                () => DropdownButtonHideUnderline(
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
            ),
          ],
        ),
        const SizedBox(width: 20),
        CustomButton2(
          backgroundColor: grey1,
          textColor: primaryBtnColor,
          onTap: () async {
            await controller.downloadReport();
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

  Widget _buildOutwardReport(BuildContext context) {
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
                    "Outward Report Details",
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
      final apiStatus = controller.outwardReportListingResponse.value.status;

      if (apiStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      if (apiStatus == Status.ERROR) {
        return Center(
          child: Text(
            controller.outwardReportListingResponse.value.message ??
                "Something went wrong",
          ),
        );
      }

      if (apiStatus == Status.COMPLETED) {
        final data = controller.outwardReportListingResponse.value.data;
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
            // Use grand total from API response or calculate if not available
            if (_getGrandTotal(data!) != null)
              _buildGrandTotalRow(_getGrandTotal(data)!, data),
          ],
        );
      }

      return const Center(child: CircularProgressIndicator());
    });
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
            Expanded(flex: 2, child: _headerText("Item")),
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

  Widget _buildStockHeadView(GetOutwardReportResponse data) {
    // Stock Head view - only show stock heads with their totals
    List<Widget> allItems = [];

    for (var value in data.values!) {
      if (value.stockHeads != null) {
        for (var stockHead in value.stockHeads!) {
          allItems.add(_buildStockHeadRow(stockHead));
        }
      }
    }

    return ListView(shrinkWrap: true, children: allItems);
  }

  Widget _buildWeightGroupView(GetOutwardReportResponse data) {
    // Weight Group view - show stock heads and their tagging codes (weight groups)
    List<Widget> allItems = [];

    for (var value in data.values!) {
      if (value.stockHeads != null) {
        for (var stockHead in value.stockHeads!) {
          // Add stock head row with grey background
          allItems.add(
            Container(
              color: Colors.grey[100],
              child: _buildStockHeadRow(stockHead),
            ),
          );

          // Add tagging codes (weight groups) for this stock head
          if (stockHead.taggingCodes != null &&
              stockHead.taggingCodes!.isNotEmpty) {
            for (var taggingCode in stockHead.taggingCodes!) {
              allItems.add(_buildWeightGroupRow(taggingCode, stockHead));
            }
          }
        }
      }
    }

    return ListView(shrinkWrap: true, children: allItems);
  }

  Widget _buildStockHeadRow(GetOutwardReportResponseStockHead stockHead) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Create a synthetic TaggingCode object for the stock head
            if (stockHead.stockHead != null) {
              final stockHeadTaggingCode = TaggingCode(
                codeType: "stock_head",
                codeId: stockHead.stockHead,
              );

              controller.getOutwardReportDetails(
                taggingCode: stockHeadTaggingCode,
              );

              Get.to(() => const OutwardReportDetailsWidget());
              // Get.find<SidebarController>().navigateToWidget(
              //   newChild: const OutwardReportDetailsWidget(),
              // );
            }
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
                  child: Text(''), // Empty for Item Group
                ),
                Expanded(
                  child: Text(
                    (double.tryParse(stockHead.total?.outwardQt ?? '0') ?? 0)
                        .toInt()
                        .toString(),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.outwardGrossWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.outwardNetWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.linestoneWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.taggingVa ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.linestoneAmount ?? '0',
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

  Widget _buildWeightGroupRow(
    TaggingCode taggingCode,
    GetOutwardReportResponseStockHead stockHead,
  ) {
    return InkWell(
      onTap: () {
        // Pass the taggingCode object
        controller.getOutwardReportDetails(taggingCode: taggingCode);
        Get.find<SidebarController>().navigateToWidget(
          newChild: const OutwardReportDetailsWidget(),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(""), // Empty for Stock Head
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    taggingCode.weightGroupName ??
                        taggingCode.taggingCode ??
                        '',
                  ),
                ),
                Expanded(
                  child: Text(
                    (double.tryParse(taggingCode.outwardQt ?? '0') ?? 0)
                        .toInt()
                        .toString(),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    taggingCode.outwardGrossWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    taggingCode.outwardNetWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    taggingCode.linestoneWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    taggingCode.taggingVa ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    taggingCode.linestoneAmount ?? '0',
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

  Total? _getGrandTotal(GetOutwardReportResponse data) {
    return _calculateGrandTotal(data);
  }

  Widget _buildGrandTotalRow(Total total, GetOutwardReportResponse data) {
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
              child: Text(''), // Empty for Item Group
            ),
            Expanded(
              child: Text(
                total.outwardQt ?? '0',
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
                total.outwardGrossWeight ?? '0',
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
                total.outwardNetWeight ?? '0',
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
                  _showStoneDetailsDialog(data);
                },
                child: Text(
                  total.linestoneWeight ?? '0',
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
                total.taggingVa ?? '0',
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
                total.linestoneAmount ?? '0',
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

  // Add the stone details dialog method
  void _showStoneDetailsDialog(GetOutwardReportResponse data) {
    if (data.stoneData != null || data.stoneTotal != null) {
      Get.dialog(
        OutwardReportStoneDetailsDialog(
          stoneData: data.stoneData,
          stoneTotal: data.stoneTotal,
        ),
      );
    } else {
      // If no stone data available, show a message
      Get.snackbar(
        'No Stone Data',
        'Stone details are not available for this report',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Helper method to calculate grand total
  Total? _calculateGrandTotal(GetOutwardReportResponse data) {
    if (data.values == null || data.values!.isEmpty) return null;

    final grandTotal = Total();

    double totalQt = 0;
    double totalGrossWeight = 0;
    double totalNetWeight = 0;
    double totalLinestoneWeight = 0;
    double totalVa = 0;
    double totalLinestoneAmount = 0;

    // Sum up all stock head totals
    for (var value in data.values!) {
      if (value.stockHeads != null) {
        for (var stockHead in value.stockHeads!) {
          if (stockHead.total != null) {
            totalQt += double.tryParse(stockHead.total!.outwardQt ?? '0') ?? 0;
            totalGrossWeight +=
                double.tryParse(stockHead.total!.outwardGrossWeight ?? '0') ??
                0;
            totalNetWeight +=
                double.tryParse(stockHead.total!.outwardNetWeight ?? '0') ?? 0;
            totalLinestoneWeight +=
                double.tryParse(stockHead.total!.linestoneWeight ?? '0') ?? 0;
            totalVa += double.tryParse(stockHead.total!.taggingVa ?? '0') ?? 0;
            totalLinestoneAmount +=
                double.tryParse(stockHead.total!.linestoneAmount ?? '0') ?? 0;
          }
        }
      }
    }

    grandTotal.outwardQt = totalQt.toStringAsFixed(0);
    grandTotal.outwardGrossWeight = totalGrossWeight.toStringAsFixed(3);
    grandTotal.outwardNetWeight = totalNetWeight.toStringAsFixed(3);
    grandTotal.linestoneWeight = totalLinestoneWeight.toStringAsFixed(3);
    grandTotal.taggingVa = totalVa.toStringAsFixed(2);
    grandTotal.linestoneAmount = totalLinestoneAmount.toStringAsFixed(2);

    return grandTotal;
  }
}
