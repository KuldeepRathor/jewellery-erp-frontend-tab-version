import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/networks/api_response.dart';
import '../../../../repository/inventory_repository.dart';
import '../../../../utils/textstyle.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/custom_dashed_line_widget.dart';
import '../model/purity_types_model.dart';

class MasterSettingsViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getPurityTypes();
  }

  final purityTypesResponse =
      Rx<ApiResponse<PurityData>>(ApiResponse.initial("Initial"));
  final InventoryRepository inventoryRepository = InventoryRepository();
  final headers = ['Status', "Purity Type", 'Display Name', ""].obs;
  final columnWidths = [
    0.2, //Status
    0.28, // Purity Type
    0.40, // Display Name
    0.90, // Actions
  ].obs;
  final isLoadingMore = false.obs;
  final isUpdatingStatus = false.obs;
  final isUpdatingDisplayName = false.obs;

  TableRow buildTableHeaders() {
    log("The controllers length : ${headers.length}");
    List<Widget> cells = [];

    for (int i = 0; i < headers.length; i++) {
      String header = headers.elementAt(i);

      cells.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          alignment: Alignment.center,
          child: Tooltip(
            message: header,
            child: CustomText(
              text: header,
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return TableRow(children: cells);
  }

  List<TableRow> buildRows(BuildContext context) {
    return List.generate(purityTypesResponse.value.data?.values?.length ?? 0,
        (index) => buildTableRow(index));
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final approvalDetails =
        purityTypesResponse.value.data?.values?.elementAt(index);

    if (approvalDetails != null) {
      for (int i = 0; i < headers.length; i++) {
        String? cellContent = "-";
        Widget cellWidget;

        switch (i) {
          case 0:
            cellWidget = Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                  height: 35,
                  alignment: Alignment.center,
                  child: Checkbox(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: approvalDetails.status,
                    onChanged: (v) => _handleStatusChange(v, approvalDetails),
                  )),
            );
            break;

          case 1:
            cellContent = approvalDetails.purityName ?? "-";
            cellWidget = _buildTextCell(cellContent);
            break;

          case 2:
            cellContent = approvalDetails.secondaryName.toString();

            cellWidget = approvalDetails.isEditing
                ? Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: SizedBox(
                            width: 200,
                            height: 55,
                            child: TextField(
                              controller: approvalDetails.textController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                              onChanged: (value) {
                                if (value != "" && value.isNotEmpty) {
                                  approvalDetails.secondaryName = value;
                                }
                              },
                            ),
                          )),
                    ],
                  )
                : _buildTextCell(cellContent);
            break;

          case 3:
            cellWidget = Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _handleDisplayNameEdit(approvalDetails),
                    child: SizedBox(
                      height: 55,
                      width: 20,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: approvalDetails.isEditing
                            ? const Icon(
                                Icons.done,
                                color: Colors.green,
                              )
                            : Image.asset(
                                'assets/pngs/display_name_print_setting_icon.png',
                                height: 55,
                                width: 20,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            );
            break;

          default:
            cellWidget = const SizedBox();
        }

        cells.add(
          Column(
            children: [
              cellWidget,
              CustomDashedLineWidget(
                width: Get.width,
              ),
            ],
          ),
        );
      }
    }

    return TableRow(children: cells);
  }

  // Helper to build a text cell
  Widget _buildTextCell(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CustomText(
        text: content,
        fontSize: 16,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // API Function: Get Purity Types
  Future<void> getPurityTypes() async {
    try {
      purityTypesResponse.value = ApiResponse.loading('Loading..');
      final types = await inventoryRepository.getVendorTypes();
      purityTypesResponse.value = ApiResponse.completed(types);
    } catch (e, stack) {
      log('Error fetching vendor types: $e $stack');
      purityTypesResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load vendor types");
    }
  }

  // API Function: Update Purity Status
  Future<void> updatePurityStatus({
    required String purityType,
    required bool status,
    String? purityId,
  }) async {
    try {
      isUpdatingStatus.value = true;

      final success = await inventoryRepository.updatePurityStatus(
        purityId, // Optional now
        status,
        purityType,
      );

      if (success) {
        showSuccessToast(message: "Status updated successfully");
        // Optionally refresh the list
        // await getPurityTypes();
      } else {
        showErrorToast(message: "Failed to update status");
      }
    } catch (e, stack) {
      log('Error updating purity status: $e $stack');
      showErrorToast(message: "Failed to update status");
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  // API Function: Update Display Name
  Future<void> updatePurityDisplayName({
    required String purityType,
    required String displayName,
  }) async {
    try {
      isUpdatingDisplayName.value = true;

      final success = await inventoryRepository.updatePurityAndDisplayName(
        purityType,
        displayName,
      );

      if (success) {
        showSuccessToast(message: "Display name updated successfully");
        // Optionally refresh the list
        // await getPurityTypes();
      } else {
        showErrorToast(message: "Failed to update display name");
      }
    } catch (e, stack) {
      log('Error updating display name: $e $stack');
      showErrorToast(message: "Failed to update display name");
    } finally {
      isUpdatingDisplayName.value = false;
    }
  }

  // Handler for status checkbox change
  void _handleStatusChange(bool? newValue, PurityValue purityDetails) async {
    if (newValue == null) return;

    // Update local state immediately for better UX
    purityDetails.status = newValue;
    update();

    // Call API
    await updatePurityStatus(
      purityType: purityDetails.purityType ?? "",
      status: newValue,
      purityId: purityDetails.id, // Optional
    );
  }

  // Handler for display name edit
  void _handleDisplayNameEdit(PurityValue purityDetails) async {
    purityDetails.isEditing = !purityDetails.isEditing;

    if (!purityDetails.isEditing) {
      // User clicked save
      final newDisplayName = purityDetails.textController.text.trim();

      if (newDisplayName.isEmpty) {
        showErrorToast(message: "Display name cannot be empty");
        purityDetails.isEditing = true;
        update();
        return;
      }

      purityDetails.secondaryName = newDisplayName;
      update();

      // Call API
      await updatePurityDisplayName(
        purityType: purityDetails.purityType ?? "",
        displayName: newDisplayName,
      );
    } else {
      // User clicked edit - just toggle editing mode
      update();
    }
  }
}
