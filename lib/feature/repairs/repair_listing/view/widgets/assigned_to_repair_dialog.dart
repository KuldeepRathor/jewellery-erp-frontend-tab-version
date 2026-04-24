import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/model/get_repairs_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/view_model/repair_assigned_to_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_mult_select_dropdown_widget.dart';

class AssignedToRepairDialog extends StatelessWidget {
  final GetRepairsListingValue repairDetails;
  const AssignedToRepairDialog({super.key, required this.repairDetails});

  @override
  Widget build(BuildContext context) {
    final RepairAssignedToController controller =
        Get.put<RepairAssignedToController>(RepairAssignedToController());

    controller.setRepairDetails(
      repairLineItemId: repairDetails.id ?? '',
      repairNumber: repairDetails.repairNumber ?? '',
      ornamentName: repairDetails.itemDescription ?? '',
      grossWeight: double.parse(repairDetails.grossWeight ?? '0'),
      netWeight: double.parse(repairDetails.netWeight ?? '0'),
      pieces: 1,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveQuickOldGoldEstimateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveQuickOldGoldEstimateIntent:
                CallbackAction<SaveQuickOldGoldEstimateIntent>(
                  onInvoke: (SaveQuickOldGoldEstimateIntent intent) {
                    return;
                  },
                ),
          },
          child: Focus(
            autofocus: true,
            child: Container(
              height: Get.height * .25,
              width: Get.width * .25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildAssignedToForm(controller)),
                    _buildFooter(controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 54,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Assigned To',
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedToForm(RepairAssignedToController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  controller.loadMoreItems();
                }
                return true;
              },
              child: Obx(() {
                final vendors =
                    controller
                        .getVendorListingDetailsResponse
                        .value
                        .data
                        ?.values ??
                    [];
                final selectedVendors = controller.selectedVendors;

                return CustomMultiSelectDropdown<String>(
                  name: 'Vendor Name/ ID',
                  width: Get.width * .2,
                  items: vendors.map((vendor) => vendor.name ?? '').toList(),
                  selectedItems:
                      selectedVendors
                          .map((vendor) => vendor.name ?? '')
                          .toList(),
                  onChanged: (List<String> selections) {
                    final selectedVendorsList =
                        selections
                            .map(
                              (selection) => vendors.firstWhere(
                                (vendor) => vendor.name == selection,
                              ),
                            )
                            .toList();
                    controller.setSelectedVendors(selectedVendorsList);
                  },
                  validator: (List<String>? values) {
                    if (values == null || values.isEmpty) {
                      return "Select at least one vendor";
                    }
                    return null;
                  },
                  displayStringForOption: (value) => value,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(RepairAssignedToController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              controller.assignOrderToVendors();
            },
            child: Container(
              width: 120,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Done",
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: " (ctrl + s)",
                      color: whiteColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
