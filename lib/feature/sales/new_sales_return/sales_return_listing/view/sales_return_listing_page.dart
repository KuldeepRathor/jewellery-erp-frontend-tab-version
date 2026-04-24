import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view/sales_return_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/view/widget/sales_return_basic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/view_model/sales_return_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class SalesReturnListingPage extends StatefulWidget {
  final bool wantBackButton;
  const SalesReturnListingPage({super.key, this.wantBackButton = false});

  @override
  State<SalesReturnListingPage> createState() => _SalesReturnListingPageState();
}

class _SalesReturnListingPageState extends State<SalesReturnListingPage> {
  final SalesReturnListingController controller = Get.put(
    SalesReturnListingController(),
  );
  String? selectedMetalType;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.setInitialConditions(isSearch: false);
    controller.getApprovalListingDetails(resetList: true);
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
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: PermissionGuard(
        pageCode: 3050,
        child: ActionScopeWidget(
          onNewButtonTap: addNewSalesReturnTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                header: 'Sales Return',
                wantBackButton: widget.wantBackButton,
                onBackButtonTap: () {
                  Get.back();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildActionBar(context),
                      const SizedBox(height: 16),
                      _buildApprovalListTable(controller),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        const SalesReturnFilterWidget(),
        // Theme(
        //   data: Theme.of(context).copyWith(
        //       focusColor: primaryColor.withBlue(190),
        //       tooltipTheme: const TooltipThemeData(
        //         decoration: BoxDecoration(
        //           color: Colors.transparent,
        //         ),
        //       )),
        //   child: PopupMenuButton(
        //     offset: const Offset(0, 45),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     style: ButtonStyle(
        //       padding: WidgetStateProperty.all(EdgeInsets.zero),
        //       shape: WidgetStateProperty.all(
        //         RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //     ),
        //     color: Colors.transparent,
        //     elevation: 4,
        //     itemBuilder: (context) {
        //       return [
        //         PopupMenuItem(
        //           enabled: false,
        //           height: 0,
        //           padding: const EdgeInsets.all(0),
        //           child: AvailableFilterWidget(
        //             onSelectionChanged: (selectedTypes) {},
        //           ),
        //         ),
        //       ];
        //     },
        //     child: const CustomPopUpIcon(
        //       buttonName: 'Filter',
        //       image: 'assets/svgs/filter.svg',
        //     ),
        //   ),
        // ),
        const Spacer(),
        CustomButton2(
          onTap: addNewSalesReturnTap,
          image: 'assets/svgs/add.svg',
          buttonName: 'Add New Sales Return',
        ),
      ],
    );
  }

  void addNewSalesReturnTap() {
    SidebarController sidebarController = Get.find<SidebarController>();
    sidebarController.navigateToWidget(newChild: const SalesReturnPage());
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
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

  Widget _buildApprovalListTable(SalesReturnListingController controller) {
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
                "Sales",
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
      final apiStatus = controller.getApprovalListingResponse.value.status;
      log("API Status: $apiStatus");
      if (apiStatus == Status.COMPLETED) {
        final data = controller.getApprovalListingResponse.value.data;
        if (data?.values?.isEmpty ?? true) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTableWidget(
                headers: [controller.buildTableHeaders()],
                columnWidths: controller.columnWidths,
                rows: const [],
                isLoadingMore: false,
                addSizedBox: false,
              ),
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svgs/error/no_records_found.svg',
                  ),
                ),
              ),
            ],
          );
        }
        return CustomTableWidget(
          controller: _scrollController,
          headers: [controller.buildTableHeaders()],
          columnWidths: controller.columnWidths,
          rows: controller.buildRows(context),
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
            const Expanded(child: Center(child: CircularProgressIndicator())),
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
                  controller.getApprovalListingResponse.value.message ??
                      "Something went wrong",
                ),
              ),
            ),
          ],
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}

class CustomFilterDropdown extends StatelessWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;

  const CustomFilterDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text(
            'Filter Metal Type',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
          isExpanded: true,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          elevation: 8,
          // Removed itemHeight property
        ),
      ),
    );
  }
}
