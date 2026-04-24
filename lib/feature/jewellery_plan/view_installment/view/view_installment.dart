// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg_flutter.dart';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/view_installment/view_model/view_installment_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_checkbox_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class ViewInstallment extends StatefulWidget {
  final String id;
  const ViewInstallment({super.key, required this.id});

  @override
  State<ViewInstallment> createState() => _ViewInstallmentState();
}

class _ViewInstallmentState extends State<ViewInstallment> {
  late final ViewInstallmentViewModel controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ViewInstallmentViewModel(id: widget.id));
    controller.setInitialConditions(isSearch: false);
    controller.getJewelleryPlanDetails(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  @override
  Widget build(BuildContext context) {
    // final controllerCreation =
    //     Get.create<CustomerListingViewmodel>(() => CustomerListingViewmodel());
    // final controller = Get.find<CustomerListingViewmodel>();

    return Scaffold(
      backgroundColor: grey1,
      body: FocusScope(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              header: 'Installment Details',
              wantBackButton: true,
              onBackButtonTap: () {
                SidebarController sidebarController = Get.find();
                sidebarController.popBackSelectedWidget();
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      // height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Plan Details",
                              fontSize: 16,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _planDetailsWidget(
                                    "Plan ID",
                                    controller
                                            .jewelleryPlanResponse
                                            .value
                                            .data
                                            ?.subscription
                                            ?.code ??
                                        "-",
                                  ),
                                  const CustomDashedLineWidget(
                                    width: 50,
                                    orientation: DashOrientation.vertical,
                                  ),
                                  _planDetailsWidget(
                                    "Plan Type",
                                    controller
                                            .jewelleryPlanResponse
                                            .value
                                            .data
                                            ?.subscription
                                            ?.type ??
                                        "-",
                                  ),
                                  const CustomDashedLineWidget(
                                    width: 50,
                                    orientation: DashOrientation.vertical,
                                  ),
                                  _planDetailsWidget(
                                    "Total Weight",
                                    controller
                                            .jewelleryPlanResponse
                                            .value
                                            .data
                                            ?.subscription
                                            ?.totalWeight ??
                                        "-",
                                  ),
                                  const CustomDashedLineWidget(
                                    width: 50,
                                    orientation: DashOrientation.vertical,
                                  ),
                                  _planDetailsWidget(
                                    "Total Amount",
                                    controller
                                            .jewelleryPlanResponse
                                            .value
                                            .data
                                            ?.subscription
                                            ?.amount ??
                                        "-",
                                  ),
                                  const CustomDashedLineWidget(
                                    width: 50,
                                    orientation: DashOrientation.vertical,
                                  ),
                                  _planDetailsWidget(
                                    "Duration ",
                                    "${controller.jewelleryPlanResponse.value.data?.subscription?.duration ?? '-'} Months",
                                  ),
                                  const CustomDashedLineWidget(
                                    width: 50,
                                    orientation: DashOrientation.vertical,
                                  ),
                                  _planDetailsWidget(
                                    "Installments",
                                    controller
                                            .jewelleryPlanResponse
                                            .value
                                            .data
                                            ?.subscription
                                            ?.installments ??
                                        "-",
                                  ),
                                  const CustomDashedLineWidget(
                                    width: 50,
                                    orientation: DashOrientation.vertical,
                                  ),
                                  _planDetailsWidget(
                                    "Start Date",
                                    controller
                                            .jewelleryPlanResponse
                                            .value
                                            .data
                                            ?.subscription
                                            ?.startDate ??
                                        "-",
                                  ),
                                  SizedBox(width: Get.width * 0.3),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // _buildActionBar(),
                    const SizedBox(height: 16),
                    _buildCustomerTable(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _planDetailsWidget(String detailType, String detailValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: detailType,
          color: primaryColor,
          fontSize: 12,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          text: detailValue,
          fontSize: 16,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildCustomerTable(ViewInstallmentViewModel controller) {
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Installment Details",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildTableStates(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableStates() {
    return Obx(() {
      final apiStatus = controller.jewelleryPlanResponse.value.status;
      log("API Status: $apiStatus");
      if (apiStatus == Status.COMPLETED) {
        return CustomTableWidget(
          headers: [controller.buildTableHeaders()],
          columnWidths: controller.columnWidths,
          rows: controller.buildRows(context),
          controller: _scrollController,
          isLoadingMore: controller.isLoadingMore.value,
          addSizedBox: true,
        );
      } else if (apiStatus == Status.LOADING) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTableWidget(
              headers: [controller.buildTableHeaders()],
              columnWidths: controller.columnWidths,
              rows: const [],
              addSizedBox: false,
            ),
            const Expanded(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        );
      } else if (apiStatus == Status.ERROR) {
        return Column(
          children: [
            CustomTableWidget(
              headers: [controller.buildTableHeaders()],
              columnWidths: controller.columnWidths,
              rows: const [],
              addSizedBox: false,
            ),
            Expanded(
              child: Center(
                child: Text(
                  controller.jewelleryPlanResponse.value.message ??
                      "Something went wrong",
                ),
              ),
            ),
          ],
        );
      } else {
        return Container(height: 10, width: 10, color: Colors.red);
      }
    });
  }
}

class AvailableFilterWidget extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;

  const AvailableFilterWidget({super.key, required this.onSelectionChanged});

  @override
  AvailableFilterWidgetState createState() => AvailableFilterWidgetState();
}

class AvailableFilterWidgetState extends State<AvailableFilterWidget> {
  final List<String> _metalTypes = [
    'Ring',
    'Chain',
    'Bangle',
    'Earring',
    'New Ornament',
  ];
  final List<String> _selectedTypes = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1428328B),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                focusColor: Colors.grey.shade300,
                onTap: () {
                  Get.back();
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/filter.svg',
                        // ignore: deprecated_member_use
                        color: redTextColor,
                      ),
                      const SizedBox(width: 8),
                      const CustomText(
                        text: "Close",
                        color: redTextColor,
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Metal Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: List.generate(_metalTypes.length, (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCheckBoxWidget(
                          value: _selectedTypes.contains(_metalTypes[index]),
                          onChanged: (value) {
                            setState(() {
                              if (_selectedTypes.contains(_metalTypes[index])) {
                                _selectedTypes.remove(_metalTypes[index]);
                              } else {
                                _selectedTypes.add(_metalTypes[index]);
                              }
                              widget.onSelectionChanged(_selectedTypes);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _metalTypes[index],
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 16),
                CustomButton1(
                  buttonName: "Submit",
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
