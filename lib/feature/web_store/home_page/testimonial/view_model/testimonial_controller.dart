import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/image_cropper_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/model/customer_feedback_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/model/get_all_customer_feedback_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/model/update_customer_feedback_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class TestimonialData {
  final String id;
  final String name;
  final String description;
  final String? imagePath;
  final bool isLocal;
  final bool isVisible;
  final String? emailId;
  final List<GetAllCustomerFeedbackImage>? images;

  TestimonialData({
    required this.id,
    required this.name,
    required this.description,
    this.imagePath,
    required this.isLocal,
    required this.isVisible,
    this.emailId,
    this.images,
  });
}

class TestimonialController extends GetxController {
  final WebstoreRepository _webstoreRepository = WebstoreRepository();
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  // Store testimonials
  final RxList<TestimonialData> testimonials = <TestimonialData>[].obs;

  // Controllers for each testimonial
  final nameControllers = <String, TextEditingController>{};
  final descriptionControllers = <String, TextEditingController>{};

  // Track visibility status for each testimonial
  final testimonialVisibility = RxMap<String, bool>();

  // Track updated images
  final updatedImages = RxMap<String, String>();

  @override
  void onInit() {
    super.onInit();
    fetchTestimonials();
  }

  Future<void> fetchTestimonials() async {
    try {
      isLoading.value = true;

      final response = await _webstoreRepository.getAllCustomerFeedback();

      if (testimonials.isNotEmpty) {
        testimonials.clear();
      }

      if (response.values != null && response.values!.isNotEmpty) {
        for (var feedback in response.values!) {
          if (feedback.isWebstore == true) {
            String? imagePath;

            if (feedback.images != null &&
                feedback.images!.isNotEmpty &&
                feedback.images!.first.presignedUrl != null) {
              imagePath = feedback.images!.first.presignedUrl;
            }

            final testimonial = TestimonialData(
              id:
                  feedback.id ??
                  'unknown_${DateTime.now().millisecondsSinceEpoch}',
              name: feedback.customerName ?? '',
              description: feedback.comment ?? '',
              imagePath: imagePath,
              isLocal: false,
              isVisible: true,
              emailId: feedback.emailId,
              images: feedback.images,
            );

            testimonials.add(testimonial);
          }
        }
      }

      _initControllersForTestimonials();
    } catch (e, stack) {
      log('Error fetching testimonials: $e $stack');
      showErrorToast(message: "Failed to fetch testimonials");

      if (testimonials.isEmpty) {
        _initControllersForTestimonials();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _initControllersForTestimonials() {
    for (final controller in nameControllers.values) {
      controller.dispose();
    }
    for (final controller in descriptionControllers.values) {
      controller.dispose();
    }

    nameControllers.clear();
    descriptionControllers.clear();
    testimonialVisibility.clear();

    for (final testimonial in testimonials) {
      nameControllers[testimonial.id] = TextEditingController(
        text: testimonial.name,
      );
      descriptionControllers[testimonial.id] = TextEditingController(
        text: testimonial.description,
      );
      testimonialVisibility[testimonial.id] = testimonial.isVisible;
    }
  }

  TextEditingController getNameController(String testimonialId) {
    if (!nameControllers.containsKey(testimonialId)) {
      nameControllers[testimonialId] = TextEditingController();
    }
    return nameControllers[testimonialId]!;
  }

  TextEditingController getDescriptionController(String testimonialId) {
    if (!descriptionControllers.containsKey(testimonialId)) {
      descriptionControllers[testimonialId] = TextEditingController();
    }
    return descriptionControllers[testimonialId]!;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<TestimonialData> get filteredTestimonials {
    if (searchQuery.value.isEmpty) {
      return testimonials;
    }

    return testimonials.where((testimonial) {
      return testimonial.name.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          testimonial.description.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
    }).toList();
  }

  Future<void> _uploadTestimonialImage(
    String testimonialId,
    String imagePath,
  ) async {
    try {
      log("Starting image upload for testimonial $testimonialId");

      // Get file name and extension
      final fileName = path.basename(imagePath);
      final fileType = path.extension(fileName).replaceFirst(".", "");

      // Create request for presigned URL
      final presignedUrlRequest = FeedbackPresignedUrlSaveRequest(
        images: [
          FeedbackPresignedUrlSaveImage(fileName: fileName, fileType: fileType),
        ],
      );

      // Get the presigned URL
      final presignedUrlResponse = await _webstoreRepository
          .customerFeedbackImagePresignedUrl(presignedUrlRequest);

      if (presignedUrlResponse.images != null &&
          presignedUrlResponse.images!.isNotEmpty &&
          presignedUrlResponse.images!.first.presignedUrl != null) {
        final putUrl = presignedUrlResponse.images!.first.presignedUrl!;
        final s3Key = presignedUrlResponse.images!.first.s3Key;
        final imageId = presignedUrlResponse.images!.first.id;

        // Upload the image to S3 using the presigned URL
        await _webstoreRepository.putCustomerFeedbackImages(
          putUrl: putUrl,
          imagePath: imagePath,
        );

        // Store the uploaded image reference to use in update request
        final index = testimonials.indexWhere((t) => t.id == testimonialId);
        if (index >= 0) {
          // Create or update the images list
          List<GetAllCustomerFeedbackImage> updatedImages = [];

          // Add the newly uploaded image
          updatedImages.add(
            GetAllCustomerFeedbackImage(
              id: imageId,
              fileName: fileName,
              fileType: fileType,
              s3Key: s3Key,
              presignedUrl: putUrl,
              isWebstore: true,
            ),
          );

          // Update the testimonial with the new image data
          final updatedTestimonial = TestimonialData(
            id: testimonials[index].id,
            name: testimonials[index].name,
            description: testimonials[index].description,
            imagePath: putUrl, // Use the presigned URL as the image path
            isLocal: false, // It's now on the server
            isVisible: testimonialVisibility[testimonialId] ?? true,
            emailId: testimonials[index].emailId,
            images: updatedImages,
          );

          testimonials[index] = updatedTestimonial;
          testimonials.refresh();
        }

        log("Image uploaded successfully for testimonial $testimonialId");
      } else {
        throw Exception("Failed to get presigned URL for image upload");
      }
    } catch (e) {
      log("Error uploading image: $e");
      rethrow;
    }
  }

  Future<void> saveChanges() async {
    try {
      isLoading.value = true;
      log("Starting to save changes");

      // List to collect all update requests
      List<UpdateCustomerFeedbackRequest> updateRequests = [];

      // Process each testimonial
      for (var testimonial in testimonials) {
        // Skip sample testimonials
        if (testimonial.id.startsWith('sample_')) {
          log("Skipping sample testimonial: ${testimonial.id}");
          continue;
        }

        final nameController = nameControllers[testimonial.id];
        final descriptionController = descriptionControllers[testimonial.id];

        if (nameController != null && descriptionController != null) {
          // Track if image was uploaded in this iteration
          bool imageWasUploaded = false;

          // If there's a new image to upload, do it first
          if (updatedImages.containsKey(testimonial.id)) {
            String imagePath = updatedImages[testimonial.id]!;
            await _uploadTestimonialImage(testimonial.id, imagePath);
            imageWasUploaded = true;
            // Remove from the updatedImages map since we've processed it
            updatedImages.remove(testimonial.id);
          }

          // Get the current testimonial data after potential image upload
          final currentTestimonial = testimonials.firstWhere(
            (t) => t.id == testimonial.id,
            orElse: () => testimonial,
          );

          // Check if we need to include this testimonial in the update
          final hasNameChanged = nameController.text != currentTestimonial.name;
          final hasDescriptionChanged =
              descriptionController.text != currentTestimonial.description;
          final hasVisibilityChanged =
              testimonialVisibility.containsKey(testimonial.id) &&
              testimonialVisibility[testimonial.id] !=
                  currentTestimonial.isVisible;

          if (hasNameChanged ||
              hasDescriptionChanged ||
              hasVisibilityChanged ||
              testimonial.id.startsWith('temp_') ||
              imageWasUploaded) {
            // ← Changed from updatedImages.containsKey()
            var updateRequest = UpdateCustomerFeedbackRequest(
              id: testimonial.id.startsWith('temp_') ? null : testimonial.id,
              customerName: nameController.text,
              emailId: currentTestimonial.emailId,
              comment: descriptionController.text,
              isWebstore: testimonialVisibility[testimonial.id] ?? true,
              images:
                  currentTestimonial.images?.map((img) {
                    return UpdateCustomerFeedbackImage(
                      id: img.id,
                      fileName: img.fileName,
                      fileType: img.fileType,
                      s3Key: img.s3Key,
                      presignedUrl: img.presignedUrl,
                    );
                  }).toList() ??
                  [],
            );

            updateRequests.add(updateRequest);
            log("Added update request for testimonial: ${testimonial.id}");
          }
        }
      }

      if (updateRequests.isNotEmpty) {
        log("Sending ${updateRequests.length} update requests");
        await _webstoreRepository.updateCustomerFeedback(updateRequests);
      } else {
        log("No changes to save");
      }

      await fetchTestimonials();

      showSuccessToast(message: "Testimonials updated successfully");
    } catch (e) {
      log("Error saving changes: $e");
      showErrorToast(message: "Failed to save changes");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndCropImage(String testimonialId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.first.path;

        if (filePath != null) {
          final croppedPath = await Get.dialog(
            ImageCropDialog(
              imagePath: filePath,
              onCropped: (path) => Get.back(result: path),
              aspectRatio: 1.0,
              useCircleUi: true,
            ),
            barrierDismissible: false,
          );

          if (croppedPath != null) {
            File file = File(croppedPath);
            int fileSize = await file.length();
            double maxSizeInBytes = 5 * 1024 * 1024;

            if (fileSize <= maxSizeInBytes) {
              final index = testimonials.indexWhere(
                (t) => t.id == testimonialId,
              );
              if (index >= 0) {
                final updatedTestimonial = TestimonialData(
                  id: testimonials[index].id,
                  name: testimonials[index].name,
                  description: testimonials[index].description,
                  imagePath: croppedPath,
                  isLocal: true,
                  isVisible: testimonialVisibility[testimonialId] ?? true,
                  emailId: testimonials[index].emailId,
                  images: testimonials[index].images,
                );

                testimonials[index] = updatedTestimonial;
                updatedImages[testimonialId] = croppedPath;
                testimonials.refresh();
              }
            } else {
              showErrorToast(message: "Image size should be less than 5MB");
            }
          }
        }
      }
    } catch (e) {
      log("Error picking/cropping image: $e");
      showErrorToast(message: "Failed to process image");
    }
  }

  void clearTestimonialImage(String testimonialId) {
    final index = testimonials.indexWhere((t) => t.id == testimonialId);
    if (index >= 0) {
      final updatedTestimonial = TestimonialData(
        id: testimonials[index].id,
        name: testimonials[index].name,
        description: testimonials[index].description,
        imagePath: null,
        isLocal: testimonials[index].isLocal,
        isVisible: testimonialVisibility[testimonialId] ?? true,
        emailId: testimonials[index].emailId,
        images: [],
      );

      testimonials[index] = updatedTestimonial;

      if (updatedImages.containsKey(testimonialId)) {
        updatedImages.remove(testimonialId);
      }

      testimonials.refresh();
      log("Cleared image for testimonial $testimonialId");
    }
  }

  void toggleVisibilityStatus(String testimonialId) {
    if (testimonialVisibility.containsKey(testimonialId)) {
      testimonialVisibility[testimonialId] =
          !testimonialVisibility[testimonialId]!;
    } else {
      final testimonial = testimonials.firstWhere(
        (t) => t.id == testimonialId,
        orElse:
            () => TestimonialData(
              id: testimonialId,
              name: '',
              description: '',
              isLocal: false,
              isVisible: false,
            ),
      );

      testimonialVisibility[testimonialId] = !testimonial.isVisible;
    }

    testimonialVisibility.refresh();
    log(
      "Toggled visibility status for testimonial $testimonialId to: ${testimonialVisibility[testimonialId]}",
    );
  }

  bool getVisibilityStatus(String testimonialId) {
    if (testimonialVisibility.containsKey(testimonialId)) {
      return testimonialVisibility[testimonialId]!;
    }

    final testimonial = testimonials.firstWhere(
      (t) => t.id == testimonialId,
      orElse:
          () => TestimonialData(
            id: testimonialId,
            name: '',
            description: '',
            isLocal: false,
            isVisible: false,
          ),
    );

    return testimonial.isVisible;
  }

  void addNewTestimonial() {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final newTestimonial = TestimonialData(
      id: tempId,
      name: '',
      description: '',
      imagePath: null,
      isLocal: true,
      isVisible: true,
    );

    testimonials.add(newTestimonial);
    nameControllers[tempId] = TextEditingController(text: '');
    descriptionControllers[tempId] = TextEditingController(text: '');
    testimonialVisibility[tempId] = true;
    testimonials.refresh();

    log("Added new testimonial with ID: $tempId");
  }
}
