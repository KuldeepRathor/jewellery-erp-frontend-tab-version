import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/vendor_purchase/view/party_vendor_purchase_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view/widget/purchase_listing_basic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view_model/invoice_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view_model/other_service_purchase_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view_model/vendor_purchase_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_service_create/view/service_purchase_page.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_checkbox_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

import 'package:svg_flutter/svg_flutter.dart';

class InvoiceListingPage extends StatefulWidget {
  final bool? isToday;
  final bool? wantBackButton;
  const InvoiceListingPage({
    super.key,
    this.isToday,
    this.wantBackButton = false,
  });

  @override
  State<InvoiceListingPage> createState() => _InvoiceListingPageState();
}

class _InvoiceListingPageState extends State<InvoiceListingPage>
    with SingleTickerProviderStateMixin {
  final vendorController = Get.put(VendorPurchaseListingViewmodel());
  final otherController = Get.put(OtherServicePurchaseListingViewmodel());
  final invoiceController = Get.put(InvoiceListingViewModel());
  final SidebarController sidebarController = Get.find<SidebarController>();

  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  final String _headerText = 'Purchase Invoice Register';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    vendorController.setInitialConditions(isSearch: false);
    otherController.setInitialConditions(isSearch: false);
    _tabController.addListener(_handleTabSelection);
    // controller.getCustomerInvoice(resetList: true);

    vendorController.getPurchaseInvoice(
      resetList: true,
      isSearch: false,
      comingFrom: "initstate",
      isTodayOnly: widget.isToday ?? false,
    );
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        otherController.getCustomerInvoiceResponse.value = ApiResponse.loading(
          "LOADING",
        );
        vendorController.getPurchaseInvoice(
          resetList: true,
          isSearch: false,
          comingFrom: "Vendor handler",
          isTodayOnly: widget.isToday ?? false,
        );
      } else {
        // For Other Purchases tab - using same data as Customer Purchases
        vendorController.getPurchaseInvoiceResponse.value = ApiResponse.loading(
          "LOADING",
        );
        otherController.getCustomerPurchaseInvoice(
          resetList: true,
          isSearch: false,
        );
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_tabController.index == 0) {
        //TODO: use enums
        vendorController.vendorLoadMoreItems();
      } else if (_tabController.index == 1) {
        otherController.customerLoadMoreItems();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap: onPurchaseTapped,
        additionalShortcuts: {
          LogicalKeySet(
                LogicalKeyboardKey.control,
                LogicalKeyboardKey.alt,
                LogicalKeyboardKey.keyN,
              ):
              const NewServicePurchaseClickIntent(),
        },
        additionalActions: {
          NewServicePurchaseClickIntent:
              CallbackAction<NewServicePurchaseClickIntent>(
                onInvoke: (intent) {
                  // Handle search
                  onServicePurchaseTapped();
                  return null;
                },
              ),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildVendorTable(context),
                          // _buildCustomerTable(context),
                          _buildOtherPurchasesTable(context),
                        ],
                      ),
                    ),
                  ],
                ),
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
            tabs: const [
              Tab(text: 'Vendor Purchases'),
              // Tab(text: 'Customer Purchases'),
              Tab(text: 'Other Purchases'),
            ],
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            tabAlignment: TabAlignment.start,
          ),
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        const PurchaseListingBasicFilterWidget(),
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
        const SizedBox(width: 16),
        PermissionGuard(
          actionCode: 5052,
          child: CustomButton2(
            onTap: onServicePurchaseTapped,
            image: 'assets/svgs/add.svg',
            buttonName: 'New Service Purchase',
          ),
        ),
      ],
    );
  }

  void onServicePurchaseTapped() {
    PermissionGuardUtil.withActionPermission(6154, () {
      sidebarController.navigateToWidget(newChild: const ServicePurchasePage());
    });
  }

  void onPurchaseTapped() {
    PermissionGuardUtil.withActionPermission(6104, () {
      sidebarController.navigateToWidget(
        newChild: const PartyVendorPurchasePage(),
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
          // Fix: Only update the search for the current active tab
          if (_tabController.index == 0) {
            vendorController.setSearchQuery(value);
          }
          // else if (_tabController.index == 1) {
          //   customerController.setSearchQuery(value);
          // }
          else if (_tabController.index == 1) {
            otherController.setSearchQuery(value);
          }
        },
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

  Widget _buildVendorTable(BuildContext context) {
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
        child: GetBuilder<VendorPurchaseListingViewmodel>(
          builder:
              (controller) => Obx(() => _buildVendorTableStates(controller)),
        ),
      ),
    );
  }

  Widget _buildOtherPurchasesTable(BuildContext context) {
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
        child: GetBuilder<OtherServicePurchaseListingViewmodel>(
          builder:
              (controller) => Obx(() => _buildOtherTableStates(controller)),
        ),
      ),
    );
  }

  Widget _buildOtherTableStates(
    OtherServicePurchaseListingViewmodel controller,
  ) {
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

  Widget _buildVendorTableStates(VendorPurchaseListingViewmodel controller) {
    final apiStatus = controller.getPurchaseInvoiceResponse.value.status;

    if (apiStatus == Status.COMPLETED) {
      final data = controller.getPurchaseInvoiceResponse.value.data;
      log("Printing data: $data");
      if (data?.values?.isEmpty ?? true) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTableWidget(
              headers: [controller.buildVendorInvoiceTableHeaders()],
              columnWidths: controller.vendor_column_widths,
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
      } else {
        return CustomTableWidget(
          headers: [controller.buildVendorInvoiceTableHeaders()],
          columnWidths: controller.vendor_column_widths,
          rows: controller.build_vendor_invoice_rows(Get.context!),
          controller: _scrollController,
          isLoadingMore: controller.isLoadingMore.value,
        );
      }
    } else if (apiStatus == Status.LOADING) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTableWidget(
            headers: [controller.buildVendorInvoiceTableHeaders()],
            columnWidths: controller.vendor_column_widths,
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
            headers: [controller.buildVendorInvoiceTableHeaders()],
            columnWidths: controller.vendor_column_widths,
            rows: const [],
            isLoadingMore: false,
            addSizedBox: false,
          ),
          Expanded(
            child: Center(
              child: Text(
                controller.getPurchaseInvoiceResponse.value.message ??
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
