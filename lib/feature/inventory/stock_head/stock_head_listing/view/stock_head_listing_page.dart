import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_listing/view/customer_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view/add_new_stock_head.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/stock_head_listing/view_model/stock_head_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_icons_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class StockHeadListingPage extends StatefulWidget {
  const StockHeadListingPage({super.key});

  @override
  State<StockHeadListingPage> createState() => _StockHeadListingPageState();
}

class _StockHeadListingPageState extends State<StockHeadListingPage>
    with SingleTickerProviderStateMixin {
  final StockHeadListingController controller = Get.put(
    StockHeadListingController(),
  );
  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();
  final RxBool _isInitialized = false.obs;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await controller.getStockHeadMetalTypes();
    if (mounted) {
      _tabController = TabController(
        length: controller.stockHeadMetalTypes.length,
        vsync: this,
        initialIndex: controller.currentTabIndex.value,
      );
      _tabController!.addListener(_handleTabSelection);
    }
    _scrollController.addListener(_scrollListener);
    await controller.getStockHeadListingDetails();
    _isInitialized.value = true;
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      controller.currentTabIndex.value = _tabController!.index;
      controller.setSelectedStockHeadMetalType(
        controller.stockHeadMetalTypes[_tabController!.index],
      );
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: PermissionGuard(
        pageCode: 4200,
        child: ActionScopeWidget(
          onNewButtonTap: () {
            navigateToAddNewStockHead();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(header: 'Stock Head'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildActionBar(context),
                      const SizedBox(height: 16),
                      _buildTabBarAndView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToAddNewStockHead() {
    PermissionGuardUtil.withActionPermission(4202, () {
      controller.currentTabIndex.value = _tabController?.index ?? 0;

      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(
        newChild: AddNewStockHead(tabIndex: _tabController?.index ?? 0),
      );
    });
  }

  Widget _buildTabBarAndView() {
    return SizedBox(
      height: Get.height * 0.815,
      child: Obx(() {
        if (!_isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.stockHeadMetalTypes.isEmpty) {
          return const Center(child: Text('No metal types available'));
        }
        return Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:
                    controller.stockHeadMetalTypes
                        .map((type) => _buildStockTable(type.typeName ?? ''))
                        .toList(),
              ),
            ),
          ],
        );
      }),
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
            tabs:
                controller.stockHeadMetalTypes
                    .map((type) => Tab(text: type.typeName))
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

  Widget _buildStockTable(String metal) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildTableStates(),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        _buildFilterButton(context),
        const SizedBox(width: 16),
        PermissionGuard(
          actionCode: 4200,
          child: CustomButton2(
            onTap: () {},
            image: 'assets/svgs/download.svg',
            buttonName: 'Download',
          ),
        ),
        const Spacer(),
        _buildNewStockHeadButton(),
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
        onChanged: controller.setSearchQuery,
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

  Widget _buildFilterButton(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: primaryColor.withBlue(190),
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: PopupMenuButton(
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.transparent,
        elevation: 4,
        itemBuilder:
            (context) => [
              PopupMenuItem(
                enabled: false,
                height: 0,
                padding: EdgeInsets.zero,
                child: AvailableFilterWidget(
                  onSelectionChanged: (selectedTypes) {},
                ),
              ),
            ],
        child: const CustomPopUpIcon(
          buttonName: 'Filter',
          image: 'assets/svgs/filter.svg',
        ),
      ),
    );
  }

  Widget _buildNewStockHeadButton() {
    return PermissionGuard(
      actionCode: 4202,
      child: CustomButton2(
        onTap: () {
          navigateToAddNewStockHead();
        },
        image: 'assets/svgs/add.svg',
        buttonName: 'New Stock Head',
      ),
    );
  }

  Widget _buildTableStates() {
    return Obx(() {
      final apiStatus = controller.getStockHeadListingResponse.value.status;
      if (apiStatus == Status.COMPLETED) {
        final data = controller.getStockHeadListingResponse.value.data;
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
        return ListView(
          controller: _scrollController,
          children: [
            CustomTableWidget(
              headers: [controller.buildTableHeaders()],
              columnWidths: controller.columnWidths,
              rows: controller.buildRows(context),
              addSizedBox: true,
            ),
            if (controller.hasMoreData.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      } else if (apiStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else if (apiStatus == Status.ERROR) {
        return Center(
          child: Text(
            controller.getStockHeadListingResponse.value.message ??
                "Something went wrong",
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
