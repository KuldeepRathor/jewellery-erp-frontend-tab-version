// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/view/edit_size_group_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/view/edit_weight_group_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/view_model/edit_stock_head_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/stock_head_listing/view_model/stock_head_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_gaurd_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_hallmark_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class EditStockHead extends StatefulWidget {
  final String? stockHeadId;

  const EditStockHead({super.key, this.stockHeadId});

  @override
  State<EditStockHead> createState() => _EditStockHeadState();
}

class _EditStockHeadState extends State<EditStockHead>
    with SingleTickerProviderStateMixin {
  final EditStockHeadController controller = Get.put(EditStockHeadController());
  final StockHeadListingController stockHeadListingController = Get.put(
    StockHeadListingController(),
  );
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // controller.getCategories();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.stockHeadId != null) {
      controller.fetchStockHeadDetails(widget.stockHeadId!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.resetFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveStockHeadIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveStockHeadIntent: CallbackAction<SaveStockHeadIntent>(
              onInvoke: (intent) async {
                await PermissionGuardUtil.withActionPermissionAsync(
                  4203,
                  () async {
                    await controller.editStockHead();
                  },
                );
                return null;
              },
            ),
            DiscardIntent: CallbackAction<DiscardIntent>(
              onInvoke: (intent) {
                PermissionGuardUtil.withActionPermission(4203, () {
                  controller.onDiscardStockHead();
                });
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: FocusScope(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    header: 'Edit Stock Head',
                    wantBackButton: true,
                    onBackButtonTap: () {
                      SidebarController sidebarController = Get.find();
                      sidebarController.popBackSelectedWidget();
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailsTab(controller),
                            const SizedBox(height: 16),
                            _buildGroupSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsTab(EditStockHeadController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetalSection(controller),
                  const SizedBox(width: 16),
                  const CustomDashedLineWidget(
                    width: 100,
                    orientation: DashOrientation.vertical,
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDetailsSection(controller)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetalSection(EditStockHeadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Metal",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          return CustomDropdownField<StockHeadMetalTypesResponse>(
            name: 'Select Metal',
            nameFont: 12,
            textColor: primaryColor,
            width: Get.width * 0.1,
            items: controller.stockHeadMetalTypes,
            selectedItem: controller.selectedStockHeadMetalType.value,
            onChanged: (StockHeadMetalTypesResponse? value) {
              controller.setSelectedStockHeadMetalType(value);
              log('Selected category: ${value?.id}');
            },
            itemAsString:
                (StockHeadMetalTypesResponse? type) => type?.typeName ?? '',
          );
        }),
      ],
    );
  }

  Widget _buildDetailsSection(EditStockHeadController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Details",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CustomTextField(
              controller: controller.stockHeadCodeController,
              autovalidateMode: AutovalidateMode.always,
              name: "Stock Head Code",
              nameColor: primaryColor,
              width: Get.width * 0.1,
              onChanged: (p0) {
                final capitalizedValue = p0.toUpperCase();
                final currentCursorPosition =
                    controller.stockHeadCodeController.selection.baseOffset;
                controller.stockHeadCodeController.value = TextEditingValue(
                  text: capitalizedValue,
                  selection: TextSelection.collapsed(
                    offset: currentCursorPosition,
                  ),
                );
                controller.checkCodeAvailability(
                  capitalizedValue,
                  "stock_head",
                );
              },
              suffixIcon: Obx(() {
                if (controller.isCheckingCode.value) {
                  return const SizedBox(
                    width: 10,
                    height: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 4),
                    ),
                  );
                }
                if (!controller.isCodeAvailable.value) {
                  return const Icon(Icons.error, color: Colors.red);
                }
                if (controller.stockHeadCodeController.text.isNotEmpty &&
                    controller.isCodeAvailable.value) {
                  return const Icon(Icons.check_circle, color: Colors.green);
                }
                return const SizedBox.shrink();
              }),
            ),
            const SizedBox(width: 16),
            CustomTextField(
              controller: controller.stockHeadNameController,
              name: "Stock Head Name",
              nameColor: primaryColor,
              width: Get.width * 0.2,
            ),
            const SizedBox(width: 16),
            Obx(() {
              return CustomDropdownField<CategoriesResponse>(
                name: 'Stock Head Category',
                nameFont: 12,
                textColor: primaryColor,
                width: Get.width * 0.1,
                items: controller.categories,
                selectedItem: controller.selectedCategories.value,
                onChanged: (CategoriesResponse? value) {
                  controller.setSelectedCategories(value);
                  log('Selected category: ${value?.id}');
                },
                itemAsString:
                    (CategoriesResponse? type) => type?.categoryName ?? '',
              );
            }),
            const SizedBox(width: 16),
            CustomHallmarkChargesWidget(
              controller: controller.hallMarkChargesController,
              width: Get.width * 0.1,
              initialValue: controller.isHallMarkRequired.value,
              onChanged: (isYes, chargeNumber) {
                controller.isHallMarkRequired.value = isYes;
                if (isYes) {
                  controller.hallMarkChargesController.text = chargeNumber;
                } else {
                  controller.hallMarkChargesController.clear();
                }
              },
              validator: (value) {
                if (controller.isHallMarkRequired.value &&
                    (value == null || value.isEmpty)) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupSection() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [Tab(text: 'Weight Group'), Tab(text: 'Size Group')],
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
          ),
          SizedBox(
            height: 650, // Adjust this height as needed
            child: TabBarView(
              controller: _tabController,
              children: [const EditWeightGroupTable(), EditSizeGroupTable()],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  final EditStockHeadController controller = Get.put(EditStockHeadController());
  final SidebarController sidebarController = Get.find();

  FooterWidget({super.key});

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
                  PermissionGuard(
                    actionCode: 4203,
                    child: InkWell(
                      onTap: () {
                        controller.onDiscardStockHead();
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
                  ),
                  SizedBox(width: Get.width * 0.01),
                  PermissionGuard(
                    actionCode: 4203,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          await controller.editStockHead();
                        },
                        child: Ink(
                          height: 38,
                          width: 140,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Update",
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
                      ),
                    ),
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
