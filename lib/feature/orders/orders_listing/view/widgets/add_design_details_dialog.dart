// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/get_orders_listing_response.dart';
import 'package:svg_flutter/svg_flutter.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view/widgets/design_order_details_row.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view_model/design_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddDesignDetailsDialog extends StatelessWidget {
  final String? designId;
  final GetOrderListingValue orderDetails;
  const AddDesignDetailsDialog({
    super.key,
    this.designId,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    final AddDesignDetailsViewModel controller =
        Get.put<AddDesignDetailsViewModel>(AddDesignDetailsViewModel());

    if (orderDetails.designImages != null &&
        orderDetails.designImages!.isNotEmpty) {
      final validImageUrls =
          orderDetails.designImages!
              .where(
                (e) => e.presignedUrl != null && e.presignedUrl!.isNotEmpty,
              )
              .map((e) => e.presignedUrl!)
              .toList();

      String? existingNotes;
      if (orderDetails.designImages!.isNotEmpty) {
        existingNotes = orderDetails.designImages!.first.notes;
      }

      controller.populateWithFetchedData(validImageUrls, existingNotes);
    }
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
                    return;
                  },
                ),
          },
          child: Focus(
            autofocus: true,
            child: Container(
              height: Get.height * .675,
              width: Get.width * .55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                // key: controller.quickOldGoldFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildDesignDetailsForm(controller)),
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

  Widget _buildImageGallery(AddDesignDetailsViewModel controller) {
    return Container(
      height: Get.height * 0.45,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Get.height * 0.33,
              child:
                  controller.imagePaths.isEmpty
                      ? _buildUploadButton(controller)
                      : _buildMainImageDisplay(controller),
            ),
            if (controller.imagePaths.isNotEmpty)
              SizedBox(
                height: Get.height * 0.11,
                child: _buildThumbnailList(controller),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainImageDisplay(AddDesignDetailsViewModel controller) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Obx(
          () => Container(
            decoration: ShapeDecoration(
              image: DecorationImage(
                image:
                    controller.imagePaths.isNotEmpty
                        ? (controller
                                    .imagePaths[controller
                                        .selectedImageIndex
                                        .value]
                                    .isFile
                                ? FileImage(
                                  File(
                                    controller
                                        .imagePaths[controller
                                            .selectedImageIndex
                                            .value]
                                        .path,
                                  ),
                                )
                                : NetworkImage(
                                  controller
                                      .imagePaths[controller
                                          .selectedImageIndex
                                          .value]
                                      .path,
                                ))
                            as ImageProvider
                        : const AssetImage('assets/placeholder.png'),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
            onTap:
                () =>
                    controller.removeImage(controller.selectedImageIndex.value),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(int index, AddDesignDetailsViewModel controller) {
    final imageData = controller.imagePaths[index];
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectImage(index),
        child: Container(
          decoration: BoxDecoration(
            border:
                controller.selectedImageIndex.value == index
                    ? Border.all(color: primaryColor, width: 2)
                    : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image:
                        imageData.isFile
                            ? FileImage(File(imageData.path)) as ImageProvider
                            : NetworkImage(imageData.path),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                right: 2,
                top: 2,
                child: GestureDetector(
                  onTap: () => controller.removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.close, color: Colors.red, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailList(AddDesignDetailsViewModel controller) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min, // Changed to min
          children: [
            ...List.generate(
              controller.imagePaths.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildThumbnail(index, controller),
              ),
            ),
            _buildAddMoreButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMoreButton(AddDesignDetailsViewModel controller) {
    return InkWell(
      onTap: () => controller.pickImage(),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: primaryColor),
            SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(AddDesignDetailsViewModel controller) {
    return InkWell(
      onTap: () => controller.pickImage(),
      child: Container(
        decoration: BoxDecoration(
          color: grey1,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgs/upload.svg',
                color: primaryColor,
                width: 22,
                height: 22,
              ),
              const SizedBox(height: 8),
              const CustomText(
                text: "Upload Image",
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ],
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
            text: 'Add Design Details',
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

  Widget _buildDesignDetailsForm(AddDesignDetailsViewModel controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildImageGallery(controller),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(text: 'Order Details', fontSize: 16),
                        SizedBox(height: Get.height * 0.01),
                        DesignOrderDetailsRow(
                          label: "Weight",
                          value: "${orderDetails.netWeight ?? '0'} gm",
                          hasBackground: true,
                        ),
                        DesignOrderDetailsRow(
                          label: "Metal & Purity",
                          value: orderDetails.purity ?? 'N/A',
                        ),
                        DesignOrderDetailsRow(
                          label: "Size",
                          value: orderDetails.size ?? 'N/A',
                          hasBackground: true,
                        ),
                        DesignOrderDetailsRow(
                          label: "Pieces",
                          value: orderDetails.itemDescription ?? 'N/A',
                        ),
                        DesignOrderDetailsRow(
                          label: "Order No",
                          value: orderDetails.orderNumber ?? 'N/A',
                          hasBackground: true,
                        ),
                        SizedBox(height: Get.height * 0.01),
                        const CustomText(
                          text: 'Add Order Note',
                          fontSize: 12,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                        CustomTextField(
                          maxLines: 5,
                          controller: controller.notesController,
                          onChanged: controller.setNotes,
                        ),
                      ],
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

  Widget _buildFooter(AddDesignDetailsViewModel controller) {
    // final NewDeliveryController newDeliveryController =
    //     Get.put<NewDeliveryController>(NewDeliveryController());
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
            () =>
                controller.isUploading.value
                    ? const CircularProgressIndicator()
                    : InkWell(
                      onTap: () {
                        controller.saveDesignDetails(
                          orderDetails.id.toString(),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 38,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Row(
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
