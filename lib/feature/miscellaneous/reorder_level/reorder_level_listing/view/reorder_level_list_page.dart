import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view/reorder_level_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_listing/view_model/reorder_list_view_model.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class ReorderLevelListPage extends StatefulWidget {
  const ReorderLevelListPage({super.key, this.id});
  final String? id;

  @override
  State<ReorderLevelListPage> createState() => _ReorderLevelListPageState();
}

class _ReorderLevelListPageState extends State<ReorderLevelListPage> {
  final ReorderLevelViewModel wantedListViewModel = Get.put(
    ReorderLevelViewModel(),
  );
  final SidebarController sidebarController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    wantedListViewModel.setInitialConditions(isSearch: false);
    wantedListViewModel.getWantedListings(resetList: true);
    // wantedListViewModel.fetchAllDropdownData();
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
      wantedListViewModel.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap: () {
          sidebarController.navigateToWidget(
            newChild: const ReorderLevelPage(),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: "Reorder Level"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(context),
                    // const SizedBox(height: 16),

                    // ReorderLevelFilterWidget(
                    // controller: wantedListViewModel,
                    // ),
                    const SizedBox(height: 16),
                    _buildWantedListTable(wantedListViewModel),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        // Expanded(
        //   child: _buildSearchField(),
        // ),
        const SizedBox(width: 16),
        const Spacer(),
        CustomButton2(
          onTap: onCounterTransferTap,
          image: 'assets/svgs/add.svg',
          buttonName: 'Re Order Level',
        ),
      ],
    );
  }

  void onCounterTransferTap() {
    PermissionGuardUtil.withActionPermission(5302, () {
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(newChild: const ReorderLevelPage());
    });
  }

  Widget _buildWantedListTable(ReorderLevelViewModel wantedListViewModel) {
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
                "Reorder Level",
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
      final apiStatus = wantedListViewModel.getWantedListResponse.value.status;
      log("API Status: $apiStatus");

      if (apiStatus == Status.COMPLETED) {
        final dataList =
            wantedListViewModel.getWantedListResponse.value.data?.values ?? [];
        if (dataList.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTableWidget(
                headers: [wantedListViewModel.buildTableHeaders()],
                columnWidths: wantedListViewModel.columnWidths,
                rows: const [],
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
          headers: [wantedListViewModel.buildTableHeaders()],
          columnWidths: wantedListViewModel.columnWidths,
          rows: wantedListViewModel.buildRows(context),
          controller: _scrollController,
          isLoadingMore: wantedListViewModel.isLoadingMore.value,
          addSizedBox: true,
        );
      } else if (apiStatus == Status.LOADING) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTableWidget(
              headers: [wantedListViewModel.buildTableHeaders()],
              columnWidths: wantedListViewModel.columnWidths,
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
              headers: [wantedListViewModel.buildTableHeaders()],
              columnWidths: wantedListViewModel.columnWidths,
              rows: const [],
              addSizedBox: false,
            ),
            Expanded(
              child: Center(
                child: Text(
                  wantedListViewModel.getWantedListResponse.value.message ??
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
