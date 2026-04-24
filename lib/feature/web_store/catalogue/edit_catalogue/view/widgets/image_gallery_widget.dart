import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/view_model/catalogue_image_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:svg_flutter/svg.dart';

class ImageGalleryWidget extends StatelessWidget {
  const ImageGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageUploadController controller = Get.find<ImageUploadController>();

    return Obx(() {
      if (controller.imagePaths.isEmpty) {
        return _buildUploadButton(controller);
      } else {
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  height: Get.height * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _buildMainImageDisplay(controller),
                ),
                if (controller.imagePaths.length > 1)
                  Positioned(
                    left: 10,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (controller.selectedImageIndex.value > 0) {
                          controller.selectedImageIndex.value--;
                        } else {
                          controller.selectedImageIndex.value =
                              controller.imagePaths.length - 1;
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                if (controller.imagePaths.length > 1)
                  Positioned(
                    right: 10,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (controller.selectedImageIndex.value <
                            controller.imagePaths.length - 1) {
                          controller.selectedImageIndex.value++;
                        } else {
                          controller.selectedImageIndex.value = 0;
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Image counter and Add More button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total images counter
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Total Image - ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: '${controller.imagePaths.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Add more button
                GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 20),
                        SizedBox(width: 4),
                        Text(
                          'Add More',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      }
    });
  }

  Widget _buildMainImageDisplay(ImageUploadController controller) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // The image/video display
        Obx(() {
          final selectedImage =
              controller.imagePaths.isNotEmpty
                  ? controller.imagePaths[controller.selectedImageIndex.value]
                  : null;

          if (selectedImage == null) {
            return Container(
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('No image selected')),
            );
          }

          // Check if it's an MP4 video
          final isVideo = selectedImage.fileType?.toLowerCase() == 'mp4';

          if (isVideo) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            );
          } else {
            // Image display
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image:
                      selectedImage.isFile
                          ? FileImage(File(selectedImage.path)) as ImageProvider
                          : NetworkImage(selectedImage.path),
                  fit: BoxFit.contain,
                ),
              ),
            );
          }
        }),

        // Delete button
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

        // Image indicator (showing current image number out of total)
        if (controller.imagePaths.length > 1) _buildImageIndicator(controller),
      ],
    );
  }

  Widget _buildImageIndicator(ImageUploadController controller) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(
              () => Text(
                '${controller.selectedImageIndex.value + 1}/${controller.imagePaths.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(ImageUploadController controller) {
    return InkWell(
      onTap: () => controller.pickImage(),
      child: Container(
        width: double.infinity,
        height: Get.height * 0.25,
        decoration: BoxDecoration(
          color: grey1,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svgs/upload.svg',
              color: primaryColor,
              width: 40,
              height: 40,
            ),
            SizedBox(height: Get.height * 0.0125),
            const Text(
              'Upload Image',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Supported formats are JPEG, PNG, SVG\nRecommended Size 5mb per image',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
