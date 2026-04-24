import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/customer_purchase/view/widgets/customer_purchase_listing_basic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/customer_purchase/view/widgets/party_customer_purchase_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/customer_purchase/view_model/customer_purchase_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/metal_type_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class CustomerPurchasePage extends StatefulWidget {
  final bool? wantBackButton;
  const CustomerPurchasePage({super.key, this.wantBackButton = false});

  @override
  State<CustomerPurchasePage> createState() => _CustomerPurchasePageState();
}

class _CustomerPurchasePageState extends State<CustomerPurchasePage>
    with SingleTickerProviderStateMixin {
  final customerController = Get.put(CustomerPurchaseViewModel());
  final SidebarController sidebarController = Get.find<SidebarController>();
  final ScrollController _scrollController = ScrollController();
  final String _headerText = 'Customer Purchase';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: MetalTypeUtils.tabLabels.length,
      vsync: this,
      initialIndex: customerController.selectedTabIndex.value,
    );
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedIndex = customerController.selectedTabIndex.value;
      _tabController.animateTo(savedIndex);
      Future.delayed(const Duration(milliseconds: 300), () {
        final metalType = MetalTypeUtils.getMetalTypeFromTabIndex(savedIndex);
        customerController.applyMetalTypeFilter(metalType);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      customerController.customerLoadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(
            header: _headerText,
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
                  _buildActionBar(),
                  const SizedBox(height: 16),
                  _buildTabBar(),
                  Expanded(child: _buildCustomerTable(context)),
                ],
              ),
            ),
          ),
        ],
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
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (value) {
            final metalType = MetalTypeUtils.getMetalTypeFromTabIndex(
              _tabController.index,
            );
            customerController.applyMetalTypeFilter(metalType);
            customerController.selectedTabIndex.value = _tabController.index;
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
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        const CustomerPurchaseListingFilterWidget(),
        const SizedBox(width: 16),
        PermissionGuard(
          actionCode: 5051,
          child: CustomButton2(
            onTap: () {},
            image: 'assets/svgs/download.svg',
            buttonName: 'Download',
          ),
        ),
        const Spacer(),
        PermissionGuard(
          actionCode: 5052,
          child: CustomButton2(
            onTap: onPurchaseTapped,
            image: 'assets/svgs/add.svg',
            buttonName: 'New Purchase',
          ),
        ),
        // const SizedBox(
        //   width: 16,
        // ),
        // PermissionGuard(
        //   actionCode: 5052,
        //   child: CustomButton2(
        //     onTap: onServicePurchaseTapped,
        //     image: 'assets/svgs/add.svg',
        //     buttonName: 'New Service Purchase',
        //   ),
        // ),
      ],
    );
  }

  // void onServicePurchaseTapped() {
  //   PermissionGuardUtil.withActionPermission(
  //     6154,
  //     () {
  //       sidebarController.navigateToWidget(
  //           newChild: const ServicePurchasePage());
  //     },
  //   );
  // }

  void onPurchaseTapped() {
    PermissionGuardUtil.withActionPermission(6104, () {
      sidebarController.navigateToWidget(
        newChild: PartyCustomerPurchasePage(
          initialIndex: customerController.selectedTabIndex.value,
        ),
      );
    });
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
        onChanged: (value) {
          customerController.setSearchQuery(value);
        },
        // onChanged: (value) {
        //   // Fix: Only update the search for the current active tab
        //   if (_tabController.index == 0) {
        //     vendorController.setSearchQuery(value);
        //   } else if (_tabController.index == 1) {
        //     customerController.setSearchQuery(value);
        //   } else if (_tabController.index == 2) {
        //     otherController.setSearchQuery(value);
        //   }
        // },
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

  Widget _buildCustomerTable(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14.0),
          bottomRight: Radius.circular(14.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<CustomerPurchaseViewModel>(
          builder:
              (controller) => Obx(() => _buildCustomerTableStates(controller)),
        ),
      ),
    );
  }

  Widget _buildCustomerTableStates(CustomerPurchaseViewModel controller) {
    final apiStatus = controller.getCustomerInvoiceResponse.value.status;
    if (apiStatus == Status.COMPLETED) {
      final data = controller.getCustomerInvoiceResponse.value.data;
      log("Printing data: $data");
      if (data?.values?.isEmpty ?? true) {
        return Column(
          children: [
            CustomTableWidget(
              headers: [controller.buildCustomerInvoiceTableHeaders()],
              columnWidths: controller.customer_column_widths,
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
        headers: [controller.buildCustomerInvoiceTableHeaders()],
        columnWidths: controller.customer_column_widths,
        rows: controller.build_customer_invoice_rows(Get.context!),
        controller: _scrollController,
        isLoadingMore: controller.isLoadingMore.value,
      );
    } else if (apiStatus == Status.LOADING) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTableWidget(
            headers: [controller.buildCustomerInvoiceTableHeaders()],
            columnWidths: controller.customer_column_widths,
            rows: const [],
            isLoadingMore: false,
            addSizedBox: false,
          ),
          const Expanded(
            child: Center(child: Center(child: CircularProgressIndicator())),
          ),
        ],
      );
    } else if (apiStatus == Status.ERROR) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTableWidget(
            headers: [controller.buildCustomerInvoiceTableHeaders()],
            columnWidths: controller.customer_column_widths,
            rows: const [],
            isLoadingMore: false,
            addSizedBox: false,
          ),
          Expanded(
            child: Center(
              child: Text(
                controller.getCustomerInvoiceResponse.value.message ??
                    "Something went wrong",
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
