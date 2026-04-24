import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

class ImageGalleryWidget extends StatelessWidget {
  const ImageGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DesignImageGalleryController>();
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) => onNormalKeyEvent(node, event, []),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Color(0xFFE5E5E5),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Image',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => controller.toggleSameImage(),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Color(0xFFE6E8FF),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Same Image',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Obx(
                                () => CustomToggleSwitch(
                                  canRequestFocus: false,
                                  value: controller.isSameImage.value,
                                  onChanged:
                                      (_) => controller.toggleSameImage(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Obx(
                        () =>
                            controller.imagePaths.isEmpty
                                ? _buildUploadButton(controller)
                                : _buildImageGallery(controller),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }

  Widget _buildUploadButton(DesignImageGalleryController controller) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color: const Color(0xFFE6E8FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.pickImage(),
              borderRadius: BorderRadius.circular(8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_upload_outlined, color: Color(0xFF28328B)),
                  SizedBox(height: 16),
                  Text(
                    'Upload Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF28328B),
                      fontSize: 16,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery(DesignImageGalleryController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildUploadButton(controller),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.imagePaths.length,
            itemBuilder: (context, index) {
              // if (index == controller.imagePaths.length) {
              //   return Padding(
              //     padding: const EdgeInsets.only(top: 16),
              //     child: _buildUploadButton(controller),
              //   );
              // }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildImageCard(index, controller),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(int index, DesignImageGalleryController controller) {
    final imageData = controller.imagePaths[index];
    return Stack(
      children: [
        Center(
          child: Container(
            width: 161,
            height: 161,
            decoration: ShapeDecoration(
              // color: Colors.blue,
              image: DecorationImage(
                image:
                    imageData.isFile
                        ? FileImage(File(imageData.path)) as ImageProvider
                        : NetworkImage(imageData.path),
                fit: BoxFit.contain,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: GestureDetector(
            onTap: () => controller.removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: const Color(0x19FC3A20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Icon(Icons.delete, color: Colors.red, size: 24),
            ),
          ),
        ),
      ],
    );
  }
}
