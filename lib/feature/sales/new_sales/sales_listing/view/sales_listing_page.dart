import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/create_sales_invoice_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view/widget/sales_listing_basic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view_model/sales_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/metal_type_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg_flutter.dart';

class SalesListingPage extends StatefulWidget {
  final bool wantBackButton;
  const SalesListingPage({super.key, this.wantBackButton = false});

  @override
  State<SalesListingPage> createState() => _SalesListingPageState();
}

class _SalesListingPageState extends State<SalesListingPage>
    with SingleTickerProviderStateMixin {
  late SalesListingController controller;

  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: MetalTypeUtils.tabLabels.length,
      vsync: this,
    );
    controller = Get.put(SalesListingController());

    controller.setInitialConditions(isSearch: false);

    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedIndex = controller.selectedTabIndex.value;

      _tabController.animateTo(savedIndex);
      Future.delayed(const Duration(milliseconds: 300), () {
        final metalType = MetalTypeUtils.getMetalTypeFromTabIndex(savedIndex);
        controller.applyMetalTypeFilter(metalType);
      });
    });
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
        pageCode: 1050,
        child: ActionScopeWidget(
          onNewButtonTap: addNewSalesTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                header: 'Sales',
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
        const SalesListingBasicFilterWidget(),
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
        //     CustomButton2(
        //       onTap: (){
        //         SidebarController sidebarController = Get.find<SidebarController>();
        // sidebarController.navigateToWidget(
        //     newChild:  ViewSalesInvoicePage(id: ,));
        //       },
        //       image: 'assets/svgs/add.svg',
        //       buttonName: 'View Sales',
        //     ),
        //     const SizedBox(
        //       width: 16,
        //     ),
        PermissionGuard(
          actionCode: 1101,
          child: CustomButton2(
            onTap: addNewSalesTap,
            image: 'assets/svgs/add.svg',
            buttonName: 'Add New Sales',
          ),
        ),
      ],
    );
  }

  void addNewSalesTap() {
    PermissionGuardUtil.withActionPermission(1101, () {
      final metalType = MetalTypeUtils.getMetalTypeFromTabIndex(
        _tabController.index,
      );
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(
        newChild: CreateSalesInvoicePage(initialTabIndex: metalType),
      );

      final newMetalType = MetalTypeUtils.getMetalTypeFromTabIndex(
        _tabController.index,
      );

      controller.applyMetalTypeFilter(newMetalType);
    });
  }

  Widget _buildSearchField() {
    return CustomTextField(
      onChanged: controller.setSearchQuery,
      autofocus: true,
      hintText: 'Search',
      // hintStyle: TextStyle(color: greyTextColor),
      suffixIcon: const Icon(Icons.search, size: 16),
    );
  }

  Widget _buildApprovalListTable(SalesListingController controller) {
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
            // const Padding(
            //   padding: EdgeInsets.all(16.0),
            //   child: Text(
            //     "Sales",
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontFamily: 'Satoshi',
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),
            // ),
            _buildTabBar(),
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

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            onTap: (value) {
              final metalType = MetalTypeUtils.getMetalTypeFromTabIndex(
                _tabController.index,
              );

              controller.applyMetalTypeFilter(metalType);

              controller.selectedTabIndex.value = _tabController.index;
            },
            tabs:
                MetalTypeUtils.tabLabels
                    .map((label) => Tab(text: label))
                    .toList(),
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            tabAlignment: TabAlignment.start,
          ),
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
