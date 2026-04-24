import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view_model/orders_shipped_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddSaveIntent extends Intent {
  const AddSaveIntent();
}

class OrdersShippedDialog extends StatefulWidget {
  const OrdersShippedDialog({super.key, this.selectedOrderId});
  final String? selectedOrderId;

  @override
  State<OrdersShippedDialog> createState() => _OrdersShippedDialogState();
}

class _OrdersShippedDialogState extends State<OrdersShippedDialog> {
  late final OrdersShippedDialogController controller;

  @override
  void initState() {
    controller = Get.put(OrdersShippedDialogController());

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<OrdersShippedDialogController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const AddSaveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            AddSaveIntent: CallbackAction<AddSaveIntent>(
              onInvoke: (AddSaveIntent intent) {
                controller.saveShippingDetails(widget.selectedOrderId);
                return null;
              },
            ),
          },
          child: FocusScope(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildHeader(), _buildBody(), _buildFooter()],
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: 'Shipped',
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Upload section
              _buildUploadSection(),
              const SizedBox(width: 24),
              // Right side - Images section
              Expanded(child: _buildImagesSection()),
            ],
          ),
          const SizedBox(height: 24),
          _buildTrackingDetailsSection(),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: controller.pickImage,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upload_file, color: Colors.indigo, size: 40),
            SizedBox(height: 16),
            Text(
              'Upload a Photo of Package',
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Supported formats are JPEG & PNG',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              'Recommended Size Upto 5mb per image',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Image',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.images.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No images uploaded yet',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            );
          }

          return SizedBox(
            height: 260,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: controller.images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            controller.images[index].isFile
                                ? Image.file(
                                  File(controller.images[index].path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/placeholder_image.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                                : Image.network(
                                  controller.images[index].path,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/placeholder_image.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => controller.removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTrackingDetailsSection() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Tracking Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  name: 'Company',
                  autofocus: true,
                  controller: controller.companyController,
                  isRequired: true,
                  hintText: 'Enter shipping company name',
                  validator: controller.validateCompany,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  name: 'Tracking Number',
                  controller: controller.trackingNumberController,
                  hintText: 'Enter tracking number',
                  isRequired: true,
                  validator: controller.validateTrackingNumber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
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
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () =>
                controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : CustomInkButton(
                      onPressed:
                          () => controller.saveShippingDetails(
                            widget.selectedOrderId,
                          ),
                      text: "Save (CTRL+S)",
                    ),
          ),
        ],
      ),
    );
  }
}
