import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/master_settings/view_model/master_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class MasterSettingsPage extends StatefulWidget {
  const MasterSettingsPage({super.key});

  @override
  State<MasterSettingsPage> createState() => _MasterSettingsPageState();
}

class _MasterSettingsPageState extends State<MasterSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MasterSettingsViewModel>(
      init: MasterSettingsViewModel(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: grey1,
          body: ActionScopeWidget(
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
                      return null;
                    },
                  ),
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(header: 'Master Settings'),
                Expanded(child: _buildPuritySettings(context, controller)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPurityDetails(MasterSettingsViewModel controller) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(14),
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
                "Purity Details",
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
                child: _buildTableStates(controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableStates(MasterSettingsViewModel controller) {
    return Obx(() {
      final apiStatus = controller.purityTypesResponse.value.status;
      log("API Status: $apiStatus");
      if (apiStatus == Status.COMPLETED) {
        return CustomTableWidget(
          headers: [controller.buildTableHeaders()],
          columnWidths: controller.columnWidths,
          rows: controller.buildRows(context),
          isLoadingMore: controller.isLoadingMore.value,
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
                child: Text(
                  controller.purityTypesResponse.value.message ??
                      "Something went wrong",
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

  Widget _buildPuritySettings(
    BuildContext context,
    MasterSettingsViewModel controller,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildPurityDetails(controller)],
    );
  }
}
