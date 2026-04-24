import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/view/counter_transfer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer_listing/view_model/counter_transfer_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class CounterTransferListingPage extends StatefulWidget {
  const CounterTransferListingPage({super.key});

  @override
  State<CounterTransferListingPage> createState() =>
      _CounterTransferListingPageState();
}

class _CounterTransferListingPageState
    extends State<CounterTransferListingPage> {
  final CounterTransferListingController counterTransferController = Get.put(
    CounterTransferListingController(),
  );

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Initialize counter transfer listing
    counterTransferController.setInitialConditions(isSearch: false);
    counterTransferController.getCounterTransferListingDetails(resetList: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      counterTransferController.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap: () {
          onCounterTransferTap();
        },
        // Additional shortcuts for Counter Transfer
        additionalShortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyT):
              const NewCounterDialogIntent(),
        },
        // Additional actions for Counter Transfer
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
            HeaderWidget(header: 'Counter Transfer'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(context),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildCounterTransferListTable(
                        counterTransferController,
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

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        const Spacer(),
        PermissionGuard(
          actionCode: 4201,
          child: CustomButton2(
            onTap: onCounterTransferTap,
            image: 'assets/svgs/add.svg',
            buttonName: 'New Counter Transfer (CTRL+T)',
          ),
        ),
      ],
    );
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
        onChanged: counterTransferController.setSearchQuery,
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

  Widget _buildCounterTransferListTable(
    CounterTransferListingController controller,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
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
        return ListView(
          controller: _scrollController,
          children: [
            CustomTableWidget(
              headers: [controller.buildTableHeaders()],
              columnWidths: controller.columnWidths,
              rows: controller.buildRows(context),
              addSizedBox: true,
            ),
            Obx(
              () =>
                  controller.isLoadingMore.value
                      ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
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
