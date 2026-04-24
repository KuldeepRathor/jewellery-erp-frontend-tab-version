import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_admin_report/model/get_admin_daily_stock_count_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_admin_report/view/admin_stock_check_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_admin_report/view_model/daily_admin_stock_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg.dart';

class DailyStockAdminReportPage extends StatefulWidget {
  const DailyStockAdminReportPage({super.key});

  @override
  State<DailyStockAdminReportPage> createState() =>
      _DailyStockAdminReportPageState();
}

class _DailyStockAdminReportPageState extends State<DailyStockAdminReportPage> {
  final DailyAdminStockReportViewModel controller = Get.put(
    DailyAdminStockReportViewModel(),
  );
  @override
  void initState() {
    super.initState();
    controller.fetchStockCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusScope(
        autofocus: true,
        child: Column(
          children: [
            HeaderWidget(
              header: "Admin Stock Check",
              isReport: true,
              wantBackButton: true,
              onBackButtonTap: () {
                Get.back();
              },
            ),
            const SizedBox(height: 16),
            // Top section with search and filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildActionBar(context, controller),
            ),
            // All Counter section with frame number
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
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Counter',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Table Header
                        Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _buildHeaderCell('S. No.', flex: 1),
                              _buildHeaderCell('Counter Name', flex: 4),
                              _buildHeaderCell('Employee Count', flex: 2),
                              _buildHeaderCell('System Count', flex: 2),
                              const SizedBox(
                                width: 40,
                              ), // For more options icon space
                            ],
                          ),
                        ),

                        // Table Content
                        Expanded(
                          child: Obx(() {
                            final response =
                                controller.stockCountResponse.value;

                            if (response.status == Status.LOADING) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (response.status == Status.ERROR) {
                              return Center(
                                child: Text(
                                  response.message ?? 'An error occurred',
                                ),
                              );
                            }

                            if (response.status == Status.COMPLETED) {
                              final data = response.data?.values ?? [];
                              if (data.isEmpty) {
                                return Center(
                                  child: SvgPicture.asset(
                                    'assets/svgs/error/no_records_found.svg',
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final counter = data[index];
                                  final hasDiscrepancy =
                                      counter.totalCount !=
                                      counter.totalManualCount;

                                  return InkWell(
                                    onTap:
                                        () => showStockDetailsDialog(
                                          context,
                                          counter,
                                        ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          decoration: BoxDecoration(
                                            color:
                                                hasDiscrepancy
                                                    ? Colors.red.shade100
                                                    : (Colors.white),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              _buildContentCell(
                                                '${index + 1}',
                                                flex: 1,
                                              ),
                                              _buildContentCell(
                                                counter.counterName ?? '',
                                                flex: 4,
                                              ),
                                              _buildContentCell(
                                                counter.totalManualCount
                                                        ?.toString() ??
                                                    '0',
                                                flex: 2,
                                              ),
                                              _buildContentCell(
                                                counter.totalCount
                                                        ?.toString() ??
                                                    '0',
                                                flex: 2,
                                              ),
                                              Container(
                                                width: 40,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                child: const Icon(
                                                  Icons.more_vert,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const CustomDashedLineWidget(
                                          width: double.maxFinite,
                                        ),
                                      ],
                                    ),
                                  );
                                },
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

            // Error message at bottom if needed
            // Obx(() {
            //   if (controller.stockCountResponse.value.status ==
            //       Status.COMPLETED) {
            //     final count =
            //         controller.stockCountResponse.value.data?.values?.length ?? 0;
            //     if (count > 0) {
            //       return Container(
            //         padding: const EdgeInsets.all(8),
            //         color: Colors.red.shade50,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Icon(Icons.error_outline, color: Colors.red.shade700),
            //             const SizedBox(width: 8),
            //             Text(
            //               'Stock Count mismatch',
            //               style: TextStyle(color: Colors.red.shade700),
            //             ),
            //           ],
            //         ),
            //       );
            //     }
            //   }
            //   return const SizedBox();
            // }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(
    BuildContext context,
    DailyAdminStockReportViewModel controller,
  ) {
    return Row(
      children: [
        SizedBox(width: 500, child: _buildSearchField()),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {
            controller.selectDate(context);
          },
          image: 'assets/svgs/filter.svg',
          buttonName: 'Date',
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
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

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildContentCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void showStockDetailsDialog(
    BuildContext context,
    GetAdminDailyStockCountResponseValue counter,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AdminStockCheckDialog(counter: counter);
      },
    );
  }
}
