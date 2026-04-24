import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/gemstones_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class GemstonesDropdownWidget extends StatelessWidget {
  const GemstonesDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<GemstonesController>(GemstonesController());
    final dropdownKey = GlobalKey();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Gemstones",
          color: primaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: Get.height * 0.0125),

        // Dropdown header - when clicked, shows/hides the gemstone options
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
                    if (controller.isGemstoneDropdownOpen.value) {
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
                          controller.selectedGemstones.isEmpty
                              ? 'Select gemstones'
                              : controller.selectedGemstones.length == 1
                              ? controller.selectedGemstones.first.name ?? ''
                              : '${controller.selectedGemstones.length} gemstones selected',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Icon(
                          controller.isGemstoneDropdownOpen.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Show selected gemstones as chips/tags
              if (controller.selectedGemstones.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        controller.selectedGemstones.map((stone) {
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
                                Text(stone.name ?? 'Unknown'),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => controller.removeGemstone(stone),
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
    GemstonesController controller,
    GlobalKey dropdownKey,
  ) {
    final RenderBox renderBox =
        dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Close the overlay when clicking outside
    void dismissOverlay() {
      controller.isGemstoneDropdownOpen.value = false;
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
                        // Gemstone options
                        SizedBox(
                          height: 200,
                          child: Obx(() {
                            if (controller.isLoadingGemstones.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: controller.filteredGemstones.length,
                              itemBuilder: (context, index) {
                                final stone =
                                    controller.filteredGemstones[index];
                                return _GemstoneListItem(
                                  controller: controller,
                                  stone: stone,
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
class _GemstoneListItem extends StatelessWidget {
  final GemstonesController controller;
  final GetStoneRatesValue stone;

  const _GemstoneListItem({required this.controller, required this.stone});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // This needs to be inside Obx to properly update when selectedGemstones changes
      final bool isSelected = controller.selectedGemstones.any(
        (selected) => selected.id == stone.id,
      );

      return InkWell(
        onTap: () {
          controller.toggleSelection(stone);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) {
                  controller.toggleSelection(stone);
                },
                activeColor: secondaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stone.name ?? 'Unknown',
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    // if (stone.currentPrice != null)
                    //   Text(
                    //     '₹${stone.currentPrice?.toStringAsFixed(2)}/ct',
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.grey[600],
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
