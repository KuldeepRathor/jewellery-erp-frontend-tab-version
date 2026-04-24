// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view/size_group_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view/weight_group_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view_model/stock_head_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddNewStockHead extends StatefulWidget {
  final String? stockHeadId;
  final int tabIndex;

  const AddNewStockHead({super.key, this.stockHeadId, required this.tabIndex});

  @override
  State<AddNewStockHead> createState() => _AddNewStockHeadState();
}

class _AddNewStockHeadState extends State<AddNewStockHead>
    with SingleTickerProviderStateMixin {
  final StockHeadController controller = Get.put(StockHeadController());
  late TabController _tabController;
  final FocusNode stockHeadCodeFocusNode = FocusNode();
  final FocusNode hallmarkChargesFocusNode = FocusNode();
  final FocusNode stockHeadCategoryFocusNode = FocusNode();
  final FocusNode metalFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    controller.getStockHeadMetalTypes(tabIndex: widget.tabIndex);
    // controller.setMetalType(tabIndex: widget.tabIndex);
    controller.getCategories();
    _tabController = TabController(length: 2, vsync: this);
    // if (widget.stockHeadId != null) {
    //   controller.getStockHeadListingDetails(stockHeadName: widget.stockHeadId);
    // }
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
                await controller.addStockHead();
                return null;
              },
            ),
            DiscardIntent: CallbackAction<DiscardIntent>(
              onInvoke: (intent) {
                controller.onDiscardStockHead();
                return;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: FocusScope(
              onKeyEvent:
                  (node, event) => onNormalKeyEvent(node, event, [
                    metalFocusNode,
                    stockHeadCategoryFocusNode,
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    header: 'Add New Stock Head',
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

  Widget _buildDetailsTab(StockHeadController controller) {
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

  Widget _buildMetalSection(StockHeadController controller) {
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
          return SizedBox(
            width: Get.width * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CustomText(
                      text: 'Select Metal',
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GenericAutocompleteDropdown<StockHeadMetalTypesResponse>(
                  controller: TextEditingController(
                    text:
                        controller.selectedStockHeadMetalType.value?.typeName ??
                        '',
                  ),
                  padding: const EdgeInsets.only(top: 6),
                  focusNode: metalFocusNode,
                  items: controller.stockHeadMetalTypes,
                  getDisplayValue:
                      (StockHeadMetalTypesResponse type) => type.typeName ?? '',
                  maxWidthForOptions: DROPDOWN_OPTIONS_MAX_WIDTH,
                  onSelected: (StockHeadMetalTypesResponse value) {
                    controller.setSelectedStockHeadMetalType(value);
                    stockHeadCodeFocusNode.requestFocus();
                    log('Selected category: ${value.id}');
                  },
                  enabled: true,
                  isLastRow: true,
                  borderColor: secondaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Metal Type is required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDetailsSection(StockHeadController controller) {
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
          // spacing: 16,
          // runSpacing: 16,
          children: [
            CustomTextField(
              controller: controller.stockHeadCodeController,
              autovalidateMode: AutovalidateMode.always,
              autofocus: true,
              isRequired: true,
              focusNode: stockHeadCodeFocusNode,
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
              isRequired: true,
              nameColor: primaryColor,
              width: Get.width * 0.2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Stock Head Name";
                }
                return null;
              },
            ),
            const SizedBox(width: 16),
            Obx(() {
              return SizedBox(
                width: Get.width * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CustomText(
                          text: 'Stock Head Category',
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GenericAutocompleteDropdown<CategoriesResponse>(
                      controller: TextEditingController(
                        text:
                            controller.selectedCategories.value?.categoryName ??
                            '',
                      ),
                      padding: const EdgeInsets.only(top: 6),
                      focusNode: stockHeadCategoryFocusNode,
                      items: controller.categories,
                      maxWidthForOptions: DROPDOWN_OPTIONS_MAX_WIDTH,
                      getDisplayValue:
                          (CategoriesResponse type) => type.categoryName ?? '',
                      onSelected: (CategoriesResponse value) {
                        controller.setSelectedCategories(value);
                        hallmarkChargesFocusNode.requestFocus();
                        log('Selected category: ${value.id}');
                      },
                      onEditingComplete: () {
                        FocusManager.instance.primaryFocus?.nextFocus();
                      },
                      enabled: true,
                      isLastRow: true,
                      borderColor: secondaryColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Category is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(width: 16),

            // CustomHallmarkChargesWidget(
            //   controller: controller.hallMarkChargesController,
            //   focusNode: hallmarkChargesFocusNode,
            //   width: Get.width * 0.1,
            //   initialValue: controller.isHallMarkRequired.value,
            //   onChanged: (isYes, chargeNumber) {
            //     controller.isHallMarkRequired.value = isYes;
            //     if (isYes) {
            //       controller.hallMarkChargesController.text = chargeNumber;
            //     } else {
            //       controller.hallMarkChargesController.clear();
            //     }
            //   },
            //   validator: (value) {
            //     if (controller.isHallMarkRequired.value &&
            //         (value == null || value.isEmpty)) {
            //       return 'Please enter a value';
            //     }
            //     return null;
            //   },
            // ),
            CustomTextField(
              controller: controller.hallMarkChargesController,
              name: "Hallmark Charges",

              // isRequired: true,
              nameColor: primaryColor,
              inputFormatters: [numbersWithDecimalFormatter],
              width: Get.width * 0.1,
              focusNode: hallmarkChargesFocusNode,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  controller.isHallMarkRequired.value = true;
                } else {
                  controller.isHallMarkRequired.value = false;
                }
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
          Focus(
            canRequestFocus: false,
            descendantsAreFocusable:
                false, // This prevents focus for all children of TabBar

            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: const [Tab(text: 'Weight Group'), Tab(text: 'Size Group')],
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
            ),
          ),
          SizedBox(
            height: 650, // Adjust this height as needed
            child: TabBarView(
              controller: _tabController,
              children: [const WeightGroupTable(), SizeGroupTable()],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  final StockHeadController controller = Get.put(StockHeadController());
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
                  InkWell(
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
                  SizedBox(width: Get.width * 0.01),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        await controller.addStockHead();
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
