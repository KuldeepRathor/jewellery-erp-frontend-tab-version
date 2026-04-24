import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/model/get_inward_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/view/widget/inward_report_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/view/inward_report_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/view/widget/inward_stone_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/view_model/inward_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg.dart';

class InwardReportPage extends StatefulWidget {
  const InwardReportPage({super.key});

  @override
  State<InwardReportPage> createState() => _InwardReportPageState();
}

class _InwardReportPageState extends State<InwardReportPage> {
  final InwardReportViewmodel controller = Get.put(InwardReportViewmodel());

  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getInwardReportListing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: GetBuilder<InwardReportViewmodel>(
        init: controller,
        builder: (_) {
          return FocusScope(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  header: 'Inward Report',
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
                        _buildInwardReport(context),
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
        const InwardReportFilterWidget(),
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

  Widget _buildInwardReport(BuildContext context) {
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
                    "Inward Report Details",
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
      final apiStatus = controller.customerListingResponse.value.status;

      if (apiStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      if (apiStatus == Status.ERROR) {
        return Center(
          child: Text(
            controller.customerListingResponse.value.message ??
                "Something went wrong",
          ),
        );
      }

      if (apiStatus == Status.COMPLETED) {
        final data = controller.customerListingResponse.value.data;
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
            // Use grand total from API response
            if (data!.values!.isNotEmpty && data.values!.first.total != null)
              _buildGrandTotalRow(data.values!.first.total!, data),
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
            Expanded(flex: 4, child: _headerText("Item")),
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
              child: _headerText("Stone Cost", textAlign: TextAlign.right),
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

  Widget _buildStockHeadView(GetInwardReportResponse data) {
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

  Widget _buildWeightGroupView(GetInwardReportResponse data) {
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

  Widget _buildStockHeadRow(StockHead stockHead) {
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

              controller.getInwardReportDetails(
                taggingCode: stockHeadTaggingCode,
              );
              // Get.find<SidebarController>().navigateToWidget(
              //   newChild: const InwardReportsDetailsWidget(),
              // );
              Get.to(() => const InwardReportsDetailsWidget());
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
                    (double.tryParse(stockHead.total?.inwardQt ?? '0') ?? 0)
                        .toInt()
                        .toString(),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.inwardGrossWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    stockHead.total?.inwardNetWeight ?? '0',
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
  // Update the _buildWeightGroupRow method:

  Widget _buildWeightGroupRow(TaggingCode taggingCode, StockHead stockHead) {
    return InkWell(
      onTap: () {
        // Pass the taggingCode object
        controller.getInwardReportDetails(taggingCode: taggingCode);
        Get.find<SidebarController>().navigateToWidget(
          newChild: const InwardReportsDetailsWidget(),
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
                    (double.tryParse(taggingCode.inwardQt ?? '0') ?? 0)
                        .toInt()
                        .toString(),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    taggingCode.inwardGrossWeight ?? '0',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    taggingCode.inwardNetWeight ?? '0',
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

  Widget _buildGrandTotalRow(Total total, GetInwardReportResponse data) {
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
                total.inwardQt ?? '0',
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
                total.inwardGrossWeight ?? '0',
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
                total.inwardNetWeight ?? '0',
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

  void _showStoneDetailsDialog(GetInwardReportResponse data) {
    if (data.stoneData != null || data.stoneTotal != null) {
      Get.dialog(
        InwardReportStoneDetailsDialog(
          stoneData: data.stoneData,
          stoneTotal: data.stoneTotal,
        ),
      );
    } else {
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
}
