import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/metal_purity_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class MetalPurityFilter extends StatelessWidget {
  MetalPurityFilter({super.key});

  final MetalPurityFilterController controller = Get.put(
    MetalPurityFilterController(),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Purity:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildFilterDropdown(),
        const SizedBox(height: 16),
        _buildSelectedPuritiesList(),
      ],
    );
  }

  Widget _buildFilterDropdown() {
    return Obx(() {
      return Column(
        children: [
          // Dropdown header
          InkWell(
            onTap: controller.toggleDropdown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: grey2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.selectedPurities.isEmpty
                        ? 'Select purity'
                        : '${controller.selectedPurities.length} selected',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Icon(
                    controller.isDropdownOpen.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),

          // Dropdown content
          if (controller.isDropdownOpen.value)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Metal tabs
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            controller.metalPurities.keys.map((metal) {
                              final isSelected = controller.selectedMetals
                                  .contains(metal);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () => controller.toggleMetal(metal),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected ? secondaryColor : grey1,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      metal,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),

                  // Purity options
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          controller.selectedMetals.map((metal) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8,
                                    top: 8,
                                  ),
                                  child: Text(
                                    metal,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      controller.metalPurities[metal]!.map((
                                        purity,
                                      ) {
                                        final fullPurity = '$metal $purity';
                                        final isSelected = controller
                                            .selectedPurities
                                            .contains(fullPurity);
                                        return InkWell(
                                          onTap:
                                              () => controller.togglePurity(
                                                metal,
                                                purity,
                                              ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                value: isSelected,
                                                onChanged:
                                                    (_) =>
                                                        controller.togglePurity(
                                                          metal,
                                                          purity,
                                                        ),
                                                activeColor: secondaryColor,
                                                side: const BorderSide(
                                                  color: Colors.black,
                                                  style: BorderStyle.solid,
                                                  width: 1,
                                                ),
                                              ),
                                              Text(purity),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSelectedPuritiesList() {
    return Obx(() {
      if (controller.selectedPurities.isEmpty) {
        return const SizedBox.shrink();
      }

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            controller.selectedPurities.map((fullPurity) {
              // Extract only the purity part for display
              final purityParts = fullPurity.split(' ');
              final metal = purityParts[0];
              final purityValue =
                  purityParts.length > 1 ? purityParts[1] : fullPurity;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: secondaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Display only the purity value, not the metal name
                    Text(purityValue),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        controller.selectedPurities.remove(fullPurity);
                        if (!controller.selectedPurities.any(
                          (p) => p.startsWith(metal),
                        )) {
                          controller.selectedMetals.remove(metal);
                        }
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      );
    });
  }
}
