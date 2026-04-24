import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/view_model/testimonial_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_icons_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:svg_flutter/svg.dart';

class TestimonialPage extends StatefulWidget {
  const TestimonialPage({super.key});

  @override
  State<TestimonialPage> createState() => _TestimonialPageState();
}

class _TestimonialPageState extends State<TestimonialPage> {
  late final TestimonialController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TestimonialController());
  }

  @override
  void dispose() {
    Get.delete<TestimonialController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActionBar(context),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return _buildTestimonialGrid();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        autofocus: true,
        onChanged: controller.updateSearchQuery,
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

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: _buildSearchField()),
          const SizedBox(width: 16),
          Material(
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: Theme(
              data: Theme.of(context).copyWith(
                focusColor: primaryColor.withBlue(190),
                tooltipTheme: const TooltipThemeData(
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
              child: PopupMenuButton(
                offset: const Offset(0, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                color: Colors.transparent,
                elevation: 4,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      enabled: false,
                      height: 0,
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("Filter options go here"),
                      ),
                    ),
                  ];
                },
                child: const CustomPopUpIcon(
                  buttonName: 'Filter',
                  image: 'assets/svgs/filter.svg',
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Spacer(),
          Obx(
            () => Material(
              color: Colors.transparent,
              child: InkWell(
                onTap:
                    controller.isLoading.value ? null : controller.saveChanges,
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  decoration: BoxDecoration(
                    color:
                        controller.isLoading.value ? Colors.grey : primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 38,
                  width: 140,
                  child: Center(
                    child:
                        controller.isLoading.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : ButtonShortcutWidget(
                              buttonName: "Save",
                              shortcut: "Ctrl + S",
                              buttonsize: 16,
                              color: whiteColor,
                              shortcutButtonColor: primaryColor,
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialGrid() {
    return Obx(() {
      final filteredTestimonials = controller.filteredTestimonials;

      if (filteredTestimonials.isEmpty &&
          controller.searchQuery.value.isNotEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No testimonials found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // Add +1 to include the "Add Testimonial" card
          itemCount: filteredTestimonials.length + 1,
          itemBuilder: (context, index) {
            // If it's the last item, show the "Add Testimonial" card
            if (index == filteredTestimonials.length) {
              return _buildAddTestimonialCard();
            }
            // Otherwise, show a regular testimonial card
            return _buildTestimonialCard(filteredTestimonials[index]);
          },
        ),
      );
    });
  }

  Widget _buildTestimonialCard(TestimonialData testimonial) {
    final testimonialId = testimonial.id;
    final nameController = controller.getNameController(testimonialId);
    final descriptionController = controller.getDescriptionController(
      testimonialId,
    );

    return Obx(() {
      final isVisible = controller.getVisibilityStatus(testimonialId);
      final hasImage = testimonial.imagePath != null;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () => controller.pickAndCropImage(testimonialId),
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration: const BoxDecoration(
                            color: grey1,
                            shape: BoxShape.circle,
                          ),
                          child:
                              hasImage
                                  ? _buildImagePreview(testimonial)
                                  : _buildEmptyImageState(),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          name: "Name",
                          controller: nameController,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          name: "Write Description",
                          controller: descriptionController,
                          maxLines: 5,
                        ),
                        const SizedBox(height: 16),
                        _buildActionButtons(testimonialId, isVisible, hasImage),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildImagePreview(TestimonialData testimonial) {
    final imagePath = testimonial.imagePath!;
    final isLocal = testimonial.isLocal;

    return Stack(
      children: [
        ClipOval(
          child:
              isLocal
                  ? Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                  : Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      log("Error loading image: $error");
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 30,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Failed to load',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => controller.pickAndCropImage(testimonial.id),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 16, color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyImageState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svgs/upload.svg',
          color: primaryColor,
          width: 30,
          height: 30,
        ),
        SizedBox(height: Get.height * 0.0125),
        const Text(
          'Upload Photo',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'JPEG & PNG formats\nUp to 5MB',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    String testimonialId,
    bool isVisible,
    bool hasImage,
  ) {
    return Container(
      height: 35,
      width: 134,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => controller.toggleVisibilityStatus(testimonialId),
                child: Container(
                  color: isVisible ? primaryColor : Colors.grey,
                  child: Center(
                    child: Tooltip(
                      message:
                          isVisible
                              ? "Visible on Website"
                              : "Hidden on Website",
                      child: const Icon(
                        Icons.visibility,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap:
                    hasImage
                        ? () => controller.clearTestimonialImage(testimonialId)
                        : null,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: hasImage ? Colors.red : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildAddTestimonialCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.addNewTestimonial(),
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: primaryColor, size: 36),
              ),
              const SizedBox(height: 16),
              const CustomText(
                text: "Add New Testimonial",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Create a new customer testimonial",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
