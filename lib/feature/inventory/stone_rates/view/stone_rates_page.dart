import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/view/add_stone_rates_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/view_model/stone_rates_page_llisting_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class StoneRatesPage extends StatefulWidget {
  const StoneRatesPage({super.key});

  @override
  State<StoneRatesPage> createState() => _StoneRatesPageState();
}

class _StoneRatesPageState extends State<StoneRatesPage> {
  final StoneRatesListController controller = Get.put(
    StoneRatesListController(),
  );
  String? selectedMetalType;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.setInitialConditions(isSearch: false);
    controller.getStoneRatesDetails(resetList: true);
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
      body: ActionScopeWidget(
        onNewButtonTap: () {
          PermissionGuardUtil.withActionPermission(4302, () {
            Get.dialog(const AddStoneRatesDialog());
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: 'Stone Rates'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(context),
                    const SizedBox(height: 16),
                    _buildOrnamentTypeTable(controller),
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
        // SizedBox(
        //   width: Get.width * 0.1, // Adjust this width as needed
        //   child: CustomFilterDropdown(
        //     items: const ['Ring', 'Necklace', 'Earring', 'Bangle', 'Nosepin'],
        //     value: selectedMetalType,
        //     onChanged: (newValue) {
        //       setState(() {
        //         selectedMetalType = newValue;
        //       });
        //     },
        //   ),
        // ),
        const Spacer(),
        PermissionGuard(
          actionCode: 4302,
          child: CustomButton2(
            onTap: () {
              PermissionGuardUtil.withActionPermission(4302, () {
                Get.dialog(const AddStoneRatesDialog());
              });
            },
            image: 'assets/svgs/add.svg',
            buttonName: 'New Stone',
          ),
        ),
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

  Widget _buildOrnamentTypeTable(StoneRatesListController controller) {
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
                "Stone Rates",
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
      final apiStatus = controller.getStoneRatesResponse.value.status;
      log("API Status: $apiStatus");
      if (apiStatus == Status.COMPLETED) {
        final data = controller.getStoneRatesResponse.value.data;
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
          controller: _scrollController,
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
                  controller.getStoneRatesResponse.value.message ??
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
