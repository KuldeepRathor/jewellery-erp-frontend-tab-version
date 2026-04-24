import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_listing/view_model/design_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view/invoice_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/design_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_listing/view_model/gold_jewellery_tab_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_listing/view_model/platinum_jewellery_tab_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_listing/view_model/silver_jewellery_tab_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_icons_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class DesignListingPage extends StatefulWidget {
  const DesignListingPage({super.key});

  @override
  State<DesignListingPage> createState() => _DesignListingPageState();
}

class _DesignListingPageState extends State<DesignListingPage>
    with SingleTickerProviderStateMixin {
  final designStateController = Get.put(DesignListingViewModel());
  SidebarController sidebarController = Get.find<SidebarController>();
  final silverJewelleryTabController = Get.put(SilverJewelleryTabViewModel());
  final goldJewelleryTabController = Get.put(GoldJewelleryTabViewModel());
  final platinumJewelleryTabController = Get.put(
    PlatinumJewelleryTabViewModel(),
  );
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  String _headerText = 'Gold Jewellery';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: designStateController.currentTabIndex.value,
    );

    _headerText = getHeaderText();
    _scrollController.addListener(_scrollListener);
    initialize();
  }

  Future<void> initialize() async {
    goldJewelleryTabController.setInitialConditions(isSearch: false);
    silverJewelleryTabController.setInitialConditions(isSearch: false);
    platinumJewelleryTabController.setInitialConditions(isSearch: false);

    _tabController.addListener(_handleTabSelection);

    if (_tabController.index == 0) {
      await goldJewelleryTabController.getGoldJewellery(
        resetList: true,
        isSearch: false,
      );
    } else if (_tabController.index == 1) {
      await silverJewelleryTabController.getSilverJewellery(
        resetList: true,
        isSearch: false,
      );
    } else {
      await platinumJewelleryTabController.getPlatinumJewellery(
        resetList: true,
        isSearch: false,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  String getHeaderText() {
    switch (_tabController.index) {
      case 0:
        return "Gold Jewellery";

      case 1:
        return "Silver Jewellery";
      case 2:
        return "Platinum Jewellery";

      default:
        return "Design";
    }
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      designStateController.currentTabIndex.value = _tabController.index;

      setState(() {
        _headerText = getHeaderText();
      });

      if (_tabController.index == 0) {
        goldJewelleryTabController.getGoldJewellery(
          resetList: true,
          isSearch: false,
        );
      } else if (_tabController.index == 1) {
        silverJewelleryTabController.getSilverJewellery(
          resetList: true,
          isSearch: false,
        );
      } else if (_tabController.index == 2) {
        platinumJewelleryTabController.getPlatinumJewellery(
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
        goldJewelleryTabController.goldLoadMoreItems();
      } else if (_tabController.index == 1) {
        silverJewelleryTabController.silverLoadMoreItems();
      } else if (_tabController.index == 2) {
        platinumJewelleryTabController.platinumLoadMoreItems();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap: addNewDesignTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: _headerText),
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
                          _buildGoldTable(context),
                          _buildSilverTable(context),
                          _buildPlatinumTable(context),
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
              Tab(text: 'Gold Jewellery'),
              Tab(text: 'Silver Jewellery'),
              Tab(text: 'Platinum Jewellery'),
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
        Material(
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: Theme(
            data: Theme.of(context).copyWith(
              focusColor: primaryColor.withBlue(190),
              tooltipTheme: const TooltipThemeData(
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
            child: PopupMenuButton(
              offset: const Offset(0, 45), // SET THE (X,Y) POSITION
              // iconSize: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              color: Colors.transparent,
              elevation: 4,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    enabled: false, // DISABLED THIS ITEM
                    height: 0,
                    padding: const EdgeInsets.all(0),
                    child: AvailableFilterWidget(
                      onSelectionChanged: (selectedTypes) {},
                    ),
                  ),
                ];
              },
              child: const CustomPopUpIcon(
                buttonName: 'Filter',
                image: 'assets/svgs/filter.svg',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        PermissionGuard(
          actionCode: 4255,
          child: CustomButton2(
            onTap: () async {
              await PermissionGuardUtil.withActionPermissionAsync(
                4255,
                () async {
                  await goldJewelleryTabController
                      .downloadownloadAllDesignsCSVdReport();
                },
              );
            },
            image: 'assets/svgs/download.svg',
            buttonName: 'Download',
          ),
        ),
        const Spacer(),
        PermissionGuard(
          actionCode: 3052,
          child: CustomButton2(
            onTap: addNewDesignTap,
            image: 'assets/svgs/add.svg',
            buttonName: 'Add Design',
          ),
        ),
      ],
    );
  }

  void addNewDesignTap() {
    String designType = '';
    String metal_type = '1';
    switch (_tabController.index) {
      case 0:
        designType = 'Gold';
        metal_type = '1';
        break;
      case 1:
        designType = 'Silver';
        metal_type = '3';
        break;
      case 2:
        designType = 'Platinum';
        metal_type = '2';
        break;
    }

    PermissionGuardUtil.withActionPermission(4251, () {
      sidebarController.navigateToWidget(
        newChild: DesignView(designType: designType, metal_type: metal_type),
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
          if (_tabController.index == 0) {
            goldJewelleryTabController.setSearchQuery(value);
          } else if (_tabController.index == 1) {
            silverJewelleryTabController.setSearchQuery(value);
          } else if (_tabController.index == 2) {
            platinumJewelleryTabController.setSearchQuery(value);
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

  Widget _buildSilverTable(BuildContext context) {
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
        child: GetBuilder<SilverJewelleryTabViewModel>(
          builder:
              (controller) => Obx(() => _buildSilverTableStates(controller)),
        ),
      ),
    );
  }

  Widget _buildGoldTable(BuildContext context) {
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
        child: GetBuilder<GoldJewelleryTabViewModel>(
          builder: (controller) => Obx(() => _buildGoldTableStates(controller)),
        ),
      ),
    );
  }

  Widget _buildPlatinumTable(BuildContext context) {
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
        child: GetBuilder<PlatinumJewelleryTabViewModel>(
          builder:
              (controller) => Obx(() => _buildPlatinumTableStates(controller)),
        ),
      ),
    );
  }

  Widget _buildSilverTableStates(SilverJewelleryTabViewModel controller) {
    final apiStatus = controller.getCustomerInvoiceResponse.value.status;
    if (apiStatus == Status.COMPLETED) {
      final data = controller.getCustomerInvoiceResponse.value.data;
      log("Printing data: $data");
      if (data?.values?.isEmpty ?? true) {
        return Column(
          children: [
            CustomTableWidget(
              headers: [controller.buildCustomerInvoiceTableHeaders()],
              columnWidths: controller.silver_jewellery_column_widths,
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
        columnWidths: controller.silver_jewellery_column_widths,
        rows: controller.build_customer_invoice_rows(Get.context!),
        controller: _scrollController,
        isLoadingMore: controller.isLoadingMore.value,
      );
    } else if (apiStatus == Status.LOADING) {
      return const Center(child: CircularProgressIndicator());
    } else if (apiStatus == Status.ERROR) {
      return Center(
        child: Text(
          controller.getCustomerInvoiceResponse.value.message ??
              "Something went wrong",
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildGoldTableStates(GoldJewelleryTabViewModel controller) {
    final apiStatus = controller.getPurchaseInvoiceResponse.value.status;
    if (apiStatus == Status.COMPLETED) {
      final data = controller.getPurchaseInvoiceResponse.value.data;
      log("Printing data: $data");
      if (data?.values?.isEmpty ?? true) {
        return Column(
          children: [
            CustomTableWidget(
              headers: [controller.buildVendorInvoiceTableHeaders()],
              columnWidths: controller.gold_jewellery_column_widths,
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
          columnWidths: controller.gold_jewellery_column_widths,
          rows: controller.build_vendor_invoice_rows(Get.context!),
          controller: _scrollController,
          isLoadingMore: controller.isLoadingMore.value,
        );
      }
    } else if (apiStatus == Status.LOADING) {
      return const Center(child: CircularProgressIndicator());
    } else if (apiStatus == Status.ERROR) {
      return Center(
        child: Text(
          controller.getPurchaseInvoiceResponse.value.message ??
              "Something went wrong",
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildPlatinumTableStates(PlatinumJewelleryTabViewModel controller) {
    final apiStatus = controller.getCustomerInvoiceResponse.value.status;
    if (apiStatus == Status.COMPLETED) {
      final data = controller.getCustomerInvoiceResponse.value.data;
      log("Printing data: $data");
      if (data?.values?.isEmpty ?? true) {
        return Column(
          children: [
            CustomTableWidget(
              headers: [controller.buildCustomerInvoiceTableHeaders()],
              columnWidths: controller.platinum_jewellery_column_widths,
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
        columnWidths: controller.platinum_jewellery_column_widths,
        rows: controller.build_customer_invoice_rows(Get.context!),
        controller: _scrollController,
        isLoadingMore: controller.isLoadingMore.value,
      );
    } else if (apiStatus == Status.LOADING) {
      return const Center(child: CircularProgressIndicator());
    } else if (apiStatus == Status.ERROR) {
      return Center(
        child: Text(
          controller.getCustomerInvoiceResponse.value.message ??
              "Something went wrong",
        ),
      );
    } else {
      return Container();
    }
  }
}
