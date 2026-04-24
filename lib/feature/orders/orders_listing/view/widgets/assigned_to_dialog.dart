import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/create_vendor_poc_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/get_orders_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view_model/assigned_to_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_mult_select_dropdown_widget.dart';

class AssignedToDialog extends StatelessWidget {
  final GetOrderListingValue orderDetails;
  const AssignedToDialog({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    final AssignedToController controller = Get.put<AssignedToController>(
      AssignedToController(),
    );

    double grossWeight = 0.0;
    double netWeight = 0.0;

    try {
      if (orderDetails.grossWeight != null &&
          orderDetails.grossWeight!.isNotEmpty) {
        grossWeight = double.parse(orderDetails.grossWeight!);
      }
    } catch (e) {
      // Handle parsing error gracefully
      log("Error parsing grossWeight: ${orderDetails.grossWeight}");
    }

    try {
      if (orderDetails.netWeight != null &&
          orderDetails.netWeight!.isNotEmpty) {
        netWeight = double.parse(orderDetails.netWeight!);
      }
    } catch (e) {
      // Handle parsing error gracefully
      log("Error parsing netWeight: ${orderDetails.netWeight}");
    }

    controller.setOrderDetails(
      orderLineItemId: orderDetails.id ?? '',
      orderNumber: orderDetails.orderNumber ?? '',
      ornamentName: orderDetails.itemDescription ?? '',
      grossWeight: grossWeight,
      netWeight: netWeight,
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
                    controller.assignOrderToVendors();
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

  Widget _buildAssignedToForm(AssignedToController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor dropdown with add new vendor button
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
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
                        // Updated to use fullName and optionally show vendorPocCode
                        items:
                            vendors.map((vendor) {
                              final name = vendor.fullName ?? '';
                              final code = vendor.vendorPocCode ?? '';
                              // You can choose to display both name and code
                              return code.isNotEmpty ? '$name ($code)' : name;
                            }).toList(),
                        selectedItems:
                            selectedVendors.map((vendor) {
                              final name = vendor.fullName ?? '';
                              final code = vendor.vendorPocCode ?? '';
                              return code.isNotEmpty ? '$name ($code)' : name;
                            }).toList(),
                        onChanged: (List<String> selections) {
                          final selectedVendorsList =
                              selections.map((selection) {
                                return vendors.firstWhere((vendor) {
                                  final name = vendor.fullName ?? '';
                                  final code = vendor.vendorPocCode ?? '';
                                  final displayName =
                                      code.isNotEmpty ? '$name ($code)' : name;
                                  return displayName == selection;
                                });
                              }).toList();
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
                ),
                const SizedBox(width: 16),
                // Add New Vendor Button
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: InkWell(
                    onTap: () => _showAddVendorDialog(controller),
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: primaryColor),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: primaryColor, size: 18),
                          SizedBox(width: 4),
                          CustomText(
                            text: 'Add New',
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddVendorDialog(AssignedToController controller) {
    Get.dialog(
      AddVendorDialog(controller: controller),
      barrierDismissible: false,
    );
  }

  Widget _buildFooter(AssignedToController controller) {
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
          Obx(
            () => InkWell(
              onTap:
                  controller.isAssigning.value
                      ? null
                      : () {
                        controller.assignOrderToVendors();
                      },
              child: Container(
                width: 120,
                height: 38,
                decoration: BoxDecoration(
                  color:
                      controller.isAssigning.value ? Colors.grey : primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child:
                      controller.isAssigning.value
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: whiteColor,
                              strokeWidth: 2,
                            ),
                          )
                          : const Row(
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
          ),
        ],
      ),
    );
  }
}

// Add New Vendor Dialog
class AddVendorDialog extends StatelessWidget {
  final AssignedToController controller;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddVendorDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: Get.width * 0.4,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Add New Vendor',
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // First Row: Name and Code
              Row(
                children: [
                  // Vendor Name Field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Vendor Name',
                          color: blackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter vendor name',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: secondaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter vendor name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Vendor Code Field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Vendor Code',
                          color: blackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: codeController,
                          decoration: const InputDecoration(
                            hintText: 'Enter vendor code',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: secondaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter vendor code';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Second Row: Phone and Email
              Row(
                children: [
                  // Phone Field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Phone Number',
                          color: blackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Enter phone number',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: secondaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Email Field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Email',
                          color: blackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Enter email address',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: secondaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Button
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const CustomText(
                        text: 'Cancel',
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Save Button
                  Obx(
                    () => InkWell(
                      onTap:
                          controller.isAddingVendor.value
                              ? null
                              : () => _saveVendor(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              controller.isAddingVendor.value
                                  ? Colors.grey
                                  : primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child:
                              controller.isAddingVendor.value
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: whiteColor,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const CustomText(
                                    text: 'Save',
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveVendor() async {
    if (formKey.currentState!.validate()) {
      await controller.addNewVendor(
        CreateVendorPocRequest(
          phoneNumber: phoneController.text.trim(),
          fullName: nameController.text.trim(),
          vendorPocCode: codeController.text.trim(),
          vendorPocEmail: emailController.text.trim(),
        ),
      );
    }
  }
}
