// feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view/head_wise_listing_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/design_wise_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/view_model/webstore_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class DesignWiseListingPage extends StatefulWidget {
  const DesignWiseListingPage({super.key});

  @override
  State<DesignWiseListingPage> createState() => _DesignWiseListingPageState();
}

class _DesignWiseListingPageState extends State<DesignWiseListingPage> {
  late final DesignWiseListingController controller;

  @override
  void initState() {
    super.initState();
    // Try to find existing controller first, create only if not found
    try {
      controller = Get.find<DesignWiseListingController>(
        tag: 'designWiseListing',
      );
      log('Found existing DesignWiseListingController');
    } catch (e) {
      controller = Get.put(
        DesignWiseListingController(),
        tag: 'designWiseListing',
      );
      log('Created new DesignWiseListingController');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final webstoreController = Get.find<WebstoreSettingsController>(
      tag: 'webstoreSettings',
    );

    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back button
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: primaryColor),
                    onPressed: () => webstoreController.goBackToGeneral(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Design Wise Listing',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                // Show loading indicator
                if (controller.isLoading.value) {
                  return Container(
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
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                // Show empty state if no designs
                if (controller.design.isEmpty) {
                  return Container(
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
                    child: const Center(
                      child: Text(
                        'No stock heads found',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  );
                }

                return Container(
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
                    children: [
                      // Header with action buttons
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Design",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => controller.enableAll(),
                                  child: const Text(
                                    'Enable All',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () => controller.disableAll(),
                                  child: const Text(
                                    'Disable All',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),

                      // Stock heads list
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                height: 40,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: secondaryColor),
                                ),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: grey2),
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: grey2,
                                    ),
                                  ),
                                  onChanged: controller.searchDesigns,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.all(16.0),
                                itemCount: controller.filteredDesigns.length,
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final design =
                                      controller.filteredDesigns[index];
                                  return _buildDesignRow(design, index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom action buttons
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.discardChanges();
                              },
                              child: Container(
                                height: 38,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: grey1,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Center(
                                  child: CustomText(
                                    text: "Discard",
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => CustomButton1(
                                buttonName: "Save (Ctrl + S)",
                                onTap:
                                    controller.isUpdating.value
                                        ? null
                                        : () => controller.saveChanges(),
                                isLoading: controller.isUpdating.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignRow(DesignToggleState design, int index) {
    return Obx(
      () => Row(
        children: [
          // Stock head name
          Expanded(
            child: Text(
              design.name,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),

          // Yes/No text
          Text(
            design.isWebstore.value ? 'Yes' : 'No',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          const SizedBox(width: 12),

          // Toggle switch
          CustomToggleSwitch(
            value: design.isWebstore.value,
            onChanged: (_) => controller.toggleDesign(index),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
