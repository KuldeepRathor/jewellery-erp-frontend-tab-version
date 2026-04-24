import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/view_model/settlements_accounts_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class SettlementsAccountsPage extends StatefulWidget {
  const SettlementsAccountsPage({super.key});

  @override
  State<SettlementsAccountsPage> createState() =>
      _SettlementsAccountsPageState();
}

class _SettlementsAccountsPageState extends State<SettlementsAccountsPage> {
  late final SettlementsAccountsController controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(SettlementsAccountsController());
  }

  @override
  void dispose() {
    Get.delete<SettlementsAccountsController>();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildAccountsTable()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.all(16.0)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTableStates(),
          ),
        ),
      ],
    );
  }

  Widget _buildTableStates() {
    return Obx(() {
      final apiStatus = controller.settlementDetailsResponse.value.status;
      log("API Status: $apiStatus");

      if (apiStatus == Status.COMPLETED) {
        final data = controller.settlementDetailsResponse.value.data;
        if (data == null) {
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/error/no_records_found.svg',
                      ),
                    ],
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
          isLoadingMore: false,
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
            const Expanded(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.settlementDetailsResponse.value.message ??
                          "Something went wrong",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        return Container(height: 10, width: 10, color: Colors.red);
      }
    });
  }
}
