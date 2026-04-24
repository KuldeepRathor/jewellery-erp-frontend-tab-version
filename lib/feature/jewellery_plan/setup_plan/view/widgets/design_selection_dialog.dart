import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/design_selection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class DesignSelectionDialog extends StatelessWidget {
  DesignSelectionDialog({super.key});

  final DesignSelectionController controller = Get.put(
    DesignSelectionController(),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
        ),
        width: Get.width * 0.45,
        height: Get.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildSubHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildStockHeadSection(), _buildDesignsSection()],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10),
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
            text: 'Select Design',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          IconButton(
            icon: const Icon(Icons.close, color: redTextColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Flexible(
            child: Obx(() {
              return CustomDropdownField<StockHeadMetalTypesResponse>(
                name: 'Select Metal',
                nameFont: 12,
                textColor: primaryColor,
                width: Get.width * 0.1,
                items: controller.stockHeadMetalTypes,
                selectedItem: controller.selectedStockHeadMetalType.value,
                onChanged: controller.setSelectedStockHeadMetalType,
                itemAsString:
                    (StockHeadMetalTypesResponse? type) => type?.typeName ?? '',
              );
            }),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: CustomTextField(
              controller: controller.metalTypeSearchController,
              name: "Search Design",
              nameColor: blackColor,
              suffixIcon: const Icon(Icons.search, size: 16),
              width: Get.width * 0.3,
              onChanged: controller.searchDesigns,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockHeadSection() {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            width: double.infinity,
            child: const Text(
              'Stock Head',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Obx(() {
                if (controller.getAllStockHeadsResponse.value.status ==
                    Status.LOADING) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.filteredStockHeadValues.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredStockHeadValues[index];
                    return InkWell(
                      onTap:
                          () =>
                              controller.getDesignsByStockHeadId(item.id ?? ''),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(item.name ?? 'No name'),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignsSection() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              width: double.infinity,
              child: const Text(
                'Designs',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(
              () => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('All'),
                value: controller.selectAll.value,
                onChanged: controller.toggleSelectAll,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.designs.length,
                    itemBuilder: (context, index) {
                      final design = controller.designs[index];
                      return Obx(
                        () => CheckboxListTile(
                          title: Text(design.name ?? ''),
                          value: controller.selectedDesigns[index],
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged:
                              (value) => controller.toggleDesignSelection(
                                index,
                                value,
                              ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: controller.handleSave,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Save",
                      fontSize: 16,
                      color: grey1,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(width: 5),
                    CustomText(
                      text: "Ctrl + S",
                      fontSize: 12,
                      color: grey1,
                      fontWeight: FontWeight.normal,
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
