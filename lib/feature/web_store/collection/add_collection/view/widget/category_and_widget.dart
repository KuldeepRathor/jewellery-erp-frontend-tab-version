import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/view_model/add_collection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class CategoryAndDesignWidget extends StatelessWidget {
  const CategoryAndDesignWidget({
    super.key,
    required this.categoryTextFieldFocus,
    required this.controller,
    required this.designTextFieldFocus,
  });

  final FocusNode categoryTextFieldFocus;
  final AddCollectionController controller;
  final FocusNode designTextFieldFocus;

  @override
  Widget build(BuildContext context) {
    String getMetalTypeName(String? metalType) {
      if (metalType == null) return '-';

      switch (metalType) {
        case '1':
          return 'Gold';
        case '2':
          return 'Platinum';
        case '3':
          return 'Silver';

        default:
          return '-';
      }
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FocusScope(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Row(
                            children: [
                              Flexible(
                                child: CustomTextField(
                                  name: "Choose Category",
                                  focusNode: categoryTextFieldFocus,
                                  controller: controller.categoryController,
                                  onChanged: controller.searchCategories,
                                  suffixIcon:
                                      controller
                                                  .categoriesResponse
                                                  .value
                                                  .status ==
                                              Status.LOADING
                                          ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: controller.toggleSelectAllCategories,
                                child: Text(
                                  controller.isAllCategoriesSelected
                                      ? 'Deselect All'
                                      : 'Select All',
                                  style: const TextStyle(color: secondaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          final response = controller.categoriesResponse.value;

                          if (response.status == Status.LOADING) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (response.status == Status.ERROR) {
                            return Center(
                              child: Text(
                                'Error: ${response.message}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.categories.length,
                              itemBuilder: (context, index) {
                                final category = controller.categories[index];
                                return Obx(
                                  () => CheckboxListTile(
                                    title: Text(
                                      category.categoryName ?? '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    value: controller.isCategorySelected(
                                      category,
                                    ),
                                    onChanged: (value) {
                                      controller.toggleCategorySelection(
                                        category,
                                      );
                                      if (value == true &&
                                          controller
                                                  .selectedCategories
                                                  .length ==
                                              1) {
                                        designTextFieldFocus.requestFocus();
                                      }
                                    },
                                    activeColor: primaryColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    dense: true,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FocusScope(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Row(
                            children: [
                              Flexible(
                                child: CustomTextField(
                                  name: "Choose Design",
                                  controller: controller.designController,
                                  focusNode: designTextFieldFocus,
                                  enabled:
                                      controller.selectedCategories.isNotEmpty,
                                  suffixIcon:
                                      controller.designsResponse.value.status ==
                                              Status.LOADING
                                          ? const SizedBox(
                                            height: 10,
                                            width: 10,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: controller.toggleSelectAllDesigns,
                                child: Text(
                                  controller.isAllDesignsSelected
                                      ? 'Deselect All'
                                      : 'Select All',
                                  style: const TextStyle(color: secondaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          final response = controller.designsResponse.value;

                          if (response.status == Status.LOADING) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (response.status == Status.ERROR) {
                            return Center(
                              child: Text(
                                'Error: ${response.message}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          if (controller.designs.isEmpty &&
                              response.status == Status.COMPLETED) {
                            return const Expanded(
                              child: Center(
                                child: Text(
                                  'No designs found for selected categories',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }

                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.designs.length,
                              itemBuilder: (context, index) {
                                final design = controller.designs[index];
                                return Obx(
                                  () => Column(
                                    children: [
                                      CheckboxListTile(
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${design.code ?? '-'}   ${design.name ?? '-'}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            Text(
                                              getMetalTypeName(
                                                design.metalType,
                                              ),
                                            ),
                                            const SizedBox(width: 18),
                                            // Add the type button here
                                            if (design.type?.toLowerCase() ==
                                                'design')
                                              TextButton(
                                                onPressed:
                                                    () {}, // Add functionality if needed
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.blue,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  minimumSize: const Size(0, 0),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: const Text(
                                                  'Design',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            else if (design.type
                                                    ?.toLowerCase() ==
                                                'web_only_design')
                                              TextButton(
                                                onPressed:
                                                    () {}, // Add functionality if needed
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.green,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  minimumSize: const Size(0, 0),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: const Text(
                                                  'Web Only Design',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        value: controller.isDesignSelected(
                                          design,
                                        ),
                                        onChanged: (value) {
                                          controller.toggleDesignSelection(
                                            design,
                                          );
                                        },
                                        activeColor: primaryColor,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                        dense: true,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                      // Separator line
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),
                                        child: CustomDashedLineWidget(
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
