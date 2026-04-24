import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter/view/add_new_counter_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter/view_model/counter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view/counter_transfer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer_listing/view_model/counter_transfer_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage>
    with SingleTickerProviderStateMixin {
  final CounterController counterController = Get.put(CounterController());
  final CounterTransferListingController counterTransferController = Get.put(
    CounterTransferListingController(),
  );

  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _scrollController.addListener(_scrollListener);

    // Initialize the first tab
    counterController.setInitialConditions(isSearch: false);
    counterController.getCounterListingDetails(resetList: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _tabController.removeListener(_handleTabChange);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        counterTransferController
            .getCounterTransferListingResponse
            .value = ApiResponse.loading("Loading");
        counterController.setInitialConditions(isSearch: false);
        counterController.getCounterListingDetails(resetList: true);
      } else {
        counterController.getCounterResponse.value = ApiResponse.loading(
          "Loading",
        );
        counterTransferController.setInitialConditions(isSearch: false);
        counterTransferController.getCounterTransferListingDetails(
          resetList: true,
        );
      }
    }
    setState(() {});
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_tabController.index == 0) {
        counterController.loadMoreItems();
      } else {
        counterTransferController.loadMoreItems();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap: () {
          onNewCounterTap();
        },
        // Additional shortcuts for Buy Coin and Delivery
        additionalShortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyT):
              const NewCounterDialogIntent(),
        },
        // Additional actions for Buy Coin and Delivery
        additionalActions: {
          NewCounterDialogIntent: CallbackAction<NewCounterDialogIntent>(
            onInvoke: (intent) {
              onCounterTransferTap();
              return null;
            },
          ),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              header:
                  _tabController.index == 0
                      ? 'Create Counter'
                      : 'Counter Transfer',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(context),
                    const SizedBox(height: 16),
                    // _buildTabBar(),
                    // Expanded(
                    //   child: TabBarView(
                    //     controller: _tabController,
                    //     children: [
                    //       _buildCounterListTable(counterController),
                    //       _buildCounterTransferListTable(
                    //           counterTransferController)

                    //       // _buildCounterListTable(controller),
                    //     ],
                    //   ),
                    // ),
                    Expanded(child: _buildCounterListTable(counterController)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTabBar() {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(14),
  //         topRight: Radius.circular(14),
  //       ),
  //     ),
  //     child: Material(
  //       borderRadius: const BorderRadius.only(
  //         topLeft: Radius.circular(14),
  //         topRight: Radius.circular(14),
  //       ),
  //       clipBehavior: Clip.hardEdge,
  //       color: Colors.transparent,
  //       child: Ink(
  //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
  //         child: TabBar(
  //           controller: _tabController,
  //           isScrollable: true,
  //           tabs: const [
  //             Tab(text: 'Counter List'),
  //             Tab(text: 'Counter Transfer List'),
  //           ],
  //           labelColor: primaryColor,
  //           unselectedLabelColor: Colors.grey,
  //           indicatorColor: primaryColor,
  //           tabAlignment: TabAlignment.start,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),

        const Spacer(),
        CustomButton2(
          onTap: onNewCounterTap,
          image: 'assets/svgs/add.svg',
          buttonName: 'New Counter',
        ),
        const SizedBox(width: 16),
        // PermissionGuard(
        //   actionCode: 4201,
        //   child: CustomButton2(
        //     onTap: onCounterTransferTap,
        //     image: 'assets/svgs/add.svg',
        //     buttonName: 'Counter Transfer (CTRL+T)',
        //   ),
        // ),
      ],
    );
  }

  void onNewCounterTap() {
    Get.dialog(const AddCounterDialog());
  }

  void onCounterTransferTap() {
    PermissionGuardUtil.withActionPermission(5202, () {
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(newChild: const CounterTransfer());
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
        onChanged: counterController.setSearchQuery,
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

  // ignore: unused_element
  Widget _buildCounterListTable(CounterController controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14.0),
          bottomRight: Radius.circular(14.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: Text(
          //     "Counter List",
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontFamily: 'Satoshi',
          //       fontWeight: FontWeight.w700,
          //     ),
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCounterListTableStates(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterListTableStates() {
    return Obx(() {
      final apiStatus = counterController.getCounterResponse.value.status;
      log("API Status: $apiStatus");
      if (apiStatus == Status.COMPLETED) {
        final data = counterController.getCounterResponse.value.data;
        if (data?.values?.isEmpty ?? true) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTableWidget(
                headers: [counterController.buildTableHeaders()],
                columnWidths: counterController.columnWidths,
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
          headers: [counterController.buildTableHeaders()],
          columnWidths: counterController.columnWidths,
          rows: counterController.buildRows(context),
          addSizedBox: true,
        );
      } else if (apiStatus == Status.LOADING) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTableWidget(
              headers: [counterController.buildTableHeaders()],
              columnWidths: counterController.columnWidths,
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
              headers: [counterController.buildTableHeaders()],
              columnWidths: counterController.columnWidths,
              rows: const [],
              addSizedBox: false,
            ),
            Expanded(
              child: Center(
                child: Text(
                  counterController.getCounterResponse.value.message ??
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

  // ignore: unused_element
  Widget _buildCounterTransferListTable(
    CounterTransferListingController controller,
  ) {
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
        child: _buildCounterTransferTableStates(controller),
      ),
    );
  }

  Widget _buildCounterTransferTableStates(
    CounterTransferListingController controller,
  ) {
    return Obx(() {
      final apiStatus =
          controller.getCounterTransferListingResponse.value.status;
      log("API Status: $apiStatus");
      if (apiStatus == Status.COMPLETED) {
        final data = controller.getCounterTransferListingResponse.value.data;
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  controller.getCounterTransferListingResponse.value.message ??
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
