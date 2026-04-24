import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/view/changes_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/view/history_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/view_model/edit_tagged_items_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';

class EditTaggedItems extends StatefulWidget {
  const EditTaggedItems({super.key, this.id});
  final String? id;

  @override
  State<EditTaggedItems> createState() => _EditTaggedItemsState();
}

class _EditTaggedItemsState extends State<EditTaggedItems> {
  final EditTaggedItemsViewModel controller = Get.put(
    EditTaggedItemsViewModel(),
  );

  @override
  void initState() {
    super.initState();
    controller.init(widget.id);
    controller.fetchTaggingLineItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: FocusScope(
        autofocus: true,
        child: Focus(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    header: "Edit Item List",
                    wantBackButton: true,
                    onBackButtonTap: () {
                      Get.back(result: true);
                    },
                  ),
                  Expanded(
                    child: Obx(() {
                      // Show loading state while fetching data
                      if (controller.getTaggingItemResponse.value.status ==
                          Status.LOADING) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Show error state if fetch failed
                      if (controller.getTaggingItemResponse.value.status ==
                          Status.ERROR) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 60,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load item details',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller
                                        .getTaggingItemResponse
                                        .value
                                        .message ??
                                    'Unknown error',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  controller.fetchTaggingLineItem();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      // Show main content when data is loaded
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildActionBar(context),
                            const SizedBox(height: 16),
                            Expanded(child: _buildCustomTable()),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    }),
                  ),
                  FooterWidget(controller: controller),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable() {
    return Row(
      children: [
        ChangesWidget(context: context),
        const SizedBox(width: 16),
        HistoryWidget(context: context),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [Flexible(flex: 2, child: _buildSearchField()), const Spacer()],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        autofocus: false,
        onChanged: (value) {
          controller.setSearchQuery(value);
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(color: greyTextColor),
          suffixIcon: Icon(Icons.search, size: 16),
        ),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  final EditTaggedItemsViewModel controller;
  final SidebarController sidebarController = Get.find();

  FooterWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            SizedBox(width: Get.width * 0.02),
            SingleChildScrollView(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
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
                  SizedBox(width: Get.width * 0.01),
                  Material(
                    color: Colors.transparent,
                    child: Obx(() {
                      final isSaving =
                          controller.saveResponse.value.status ==
                          Status.LOADING;

                      return InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap:
                            isSaving
                                ? null
                                : () async {
                                  await controller.saveTaggingLineItem();
                                },
                        child: Ink(
                          height: 38,
                          width: 140,
                          decoration: BoxDecoration(
                            color:
                                isSaving
                                    ? primaryColor.withOpacity(0.6)
                                    : primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child:
                              isSaving
                                  ? const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              whiteColor,
                                            ),
                                      ),
                                    ),
                                  )
                                  : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: "Save",
                                        fontSize: 16,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      CustomText(
                                        text: " (ctrl + s)",
                                        fontSize: 16,
                                        color: whiteColor,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
