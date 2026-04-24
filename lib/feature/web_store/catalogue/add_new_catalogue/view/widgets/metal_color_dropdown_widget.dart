import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/get_catalogue_metal_color_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/metal_color_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class MetalColorDropdownWidget extends StatelessWidget {
  const MetalColorDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<MetalColorController>(MetalColorController());
    final dropdownKey = GlobalKey();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Metal color:",
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: Get.height * 0.0125),

        // Dropdown header - when clicked, shows/hides the color options
        Obx(() {
          return Column(
            children: [
              // Dropdown field
              Container(
                key: dropdownKey,
                child: InkWell(
                  onTap: () {
                    controller.toggleDropdown();

                    // If opening the dropdown, show an overlay
                    if (controller.isMetalColorDropdownOpen.value) {
                      _showDropdownOverlay(context, controller, dropdownKey);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.selectedMetalColors.isEmpty
                              ? 'Select metal color'
                              : controller.selectedMetalColors.length == 1
                              ? controller
                                      .selectedMetalColors
                                      .first
                                      .colourName ??
                                  ''
                              : '${controller.selectedMetalColors.length} colors selected',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Icon(
                          controller.isMetalColorDropdownOpen.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Show selected colors as chips/tags
              if (controller.selectedMetalColors.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        controller.selectedMetalColors.map((color) {
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
                                Text(color.colourName ?? 'Unknown'),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap:
                                      () => controller.removeMetalColor(color),
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
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  void _showDropdownOverlay(
    BuildContext context,
    MetalColorController controller,
    GlobalKey dropdownKey,
  ) {
    final RenderBox renderBox =
        dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Close the overlay when clicking outside
    void dismissOverlay() {
      controller.isMetalColorDropdownOpen.value = false;
      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // Invisible layer to detect taps outside
              GestureDetector(
                onTap: dismissOverlay,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),

              // Position the dropdown
              Positioned(
                top: position.dy + size.height + 2,
                left: position.dx,
                width: size.width,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        // Color options
                        SizedBox(
                          height: 200,
                          child: Obx(() {
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: controller.filteredMetalColors.length,
                              itemBuilder: (context, index) {
                                final color =
                                    controller.filteredMetalColors[index];
                                return _ColorListItem(
                                  controller: controller,
                                  color: color,
                                );
                              },
                            );
                          }),
                        ),

                        // Done button
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: dismissOverlay,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Done',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Created a separate widget for each list item to properly handle reactivity
class _ColorListItem extends StatelessWidget {
  final MetalColorController controller;
  final GetCatalogMetalColorResponse color;

  const _ColorListItem({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isSelected = controller.selectedMetalColors.any(
        (selected) => selected.id == color.id,
      );

      return InkWell(
        onTap: () {
          controller.toggleSelection(color);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) {
                  controller.toggleSelection(color);
                },
                activeColor: secondaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  color.colourName ?? 'Unknown',
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
