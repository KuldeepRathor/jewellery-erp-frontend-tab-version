import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/banner_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/get_all_banners_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/hero_slide_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/update_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_categories_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_collection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_page_link_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class HeroSlidesController extends GetxController {
  // Dependencies
  final WebstoreRepository _webstoreRepository = WebstoreRepository();
  late final CollectionController collectionController;
  late final CategoryController categoryController;
  late final PageLinkController pageLinkController;

  // API response state
  final bannersResponse = Rx<ApiResponse<GetAllBannersResponse>>(
    ApiResponse.initial("Initial"),
  );

  final RxList<HeroSlideItem> slides = <HeroSlideItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, bool> slideVisibilityActive = <String, bool>{}.obs;

  final RxBool isUploading = false.obs;
  final RxMap<String, File?> selectedFiles = <String, File?>{}.obs;

  // Map to store original banner data for updates
  final RxMap<String, GetAllBannersValue> originalBannerData =
      <String, GetAllBannersValue>{}.obs;

  // Map to store information about images being uploaded
  final RxMap<String, Map<String, String>> uploadedImageInfo =
      <String, Map<String, String>>{}.obs;

  // Map to track slides with cleared images
  final RxSet<String> clearedImages = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize controllers
    collectionController = Get.put(CollectionController());
    categoryController = Get.put(CategoryController());
    pageLinkController = Get.put(PageLinkController());

    // Load initial data
    fetchBanners();
  }

  @override
  void dispose() {
    Get.delete<CollectionController>();
    Get.delete<CategoryController>();
    Get.delete<PageLinkController>();
    super.dispose();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      bannersResponse.value = ApiResponse.loading("Loading banners...");

      final response = await _webstoreRepository.getAllBanners(
        is_webstore: true,
      );
      log(
        'Received API response for banners. Data present: ${response.values != null}',
      );
      log('Number of banners: ${response.values?.length ?? 0}');

      if (response.values != null && response.values!.isNotEmpty) {
        // Convert banner data to slide items
        List<HeroSlideItem> apiSlides = [];
        originalBannerData.clear();

        for (var banner in response.values!) {
          // Store original banner data for later updates
          if (banner.id != null) {
            originalBannerData[banner.id!] = banner;
          }

          // Determine action type
          ActionType actionType = ActionType.page;
          if (banner.type == 'category') actionType = ActionType.category;
          if (banner.type == 'collection') actionType = ActionType.collection;

          // Get image URL from first image if available
          String imageUrl = '';
          // Check if images is not null, not empty, and first image has a presigned URL
          if (banner.images != null &&
              banner.images!.isNotEmpty &&
              banner.images!.first.presignedUrl != null) {
            imageUrl = banner.images!.first.presignedUrl!;
          }

          // Create a new slide item
          final slide = HeroSlideItem(
            id: banner.id ?? '${apiSlides.length + 1}',
            position: 'Slide ${banner.slidePosition ?? (apiSlides.length + 1)}',
            imageUrl: imageUrl,
            actionType: actionType,
            target:
                actionType == ActionType.page ? banner.typeLink : banner.typeId,
          );

          apiSlides.add(slide);
          // Set visibility based on images, with safeguards
          bool isVisible = true;
          if (banner.images != null &&
              banner.images!.isNotEmpty &&
              banner.images!.first.isWebstore != null) {
            isVisible = banner.images!.first.isWebstore!;
          }
          slideVisibilityActive[slide.id] = isVisible;

          // Pre-select the correct dropdown option based on typeId or typeLink
          if (actionType == ActionType.category && banner.typeId != null) {
            categoryController.preSelectCategory(slide.id, banner.typeId!);
          } else if (actionType == ActionType.collection &&
              banner.typeId != null) {
            collectionController.preSelectCollection(slide.id, banner.typeId!);
          } else if (actionType == ActionType.page && banner.typeLink != null) {
            pageLinkController.preSelectPage(slide.id, banner.typeLink!);
          }
        }

        // Sort slides by position
        apiSlides.sort(
          (a, b) => int.parse(
            a.position.split(' ').last,
          ).compareTo(int.parse(b.position.split(' ').last)),
        );

        // Assign to slides observable
        slides.assignAll(apiSlides);
        log('Successfully loaded ${slides.length} banner slides');
      } else {
        // Create a default empty slide if no data
        slides.assignAll([
          HeroSlideItem(
            id: '1',
            position: 'Slide 1',
            imageUrl: '',
            actionType: ActionType.page,
          ),
        ]);
        slideVisibilityActive['1'] = true;
        log('No banners found, added default empty slide');
      }

      bannersResponse.value = ApiResponse.completed(response);
      log('Set banners response to COMPLETED status');
    } catch (e, stack) {
      log('Error fetching banners: $e $stack');
      bannersResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch banners");

      // Create a default empty slide on error
      slides.assignAll([
        HeroSlideItem(
          id: '1',
          position: 'Slide 1',
          imageUrl: '',
          actionType: ActionType.page,
        ),
      ]);
      slideVisibilityActive['1'] = true;
      log('Error occurred, added default empty slide');
    } finally {
      isLoading.value = false;
      log('Loading state set to false');
    }
  }

  void addNewSlide() {
    final newId = "new_${DateTime.now().millisecondsSinceEpoch}";

    final newPosition = slides.length + 1;

    final newSlide = HeroSlideItem(
      id: newId,
      position: 'Slide $newPosition',
      imageUrl: '',
      actionType: ActionType.page,
    );

    slides.add(newSlide);
    slideVisibilityActive[newId] = true;
  }

  void toggleVisibility(String slideId) {
    if (slideVisibilityActive.containsKey(slideId)) {
      slideVisibilityActive[slideId] = !slideVisibilityActive[slideId]!;
    } else {
      slideVisibilityActive[slideId] = false;
    }
  }

  bool isVisibilityActive(String slideId) {
    return slideVisibilityActive[slideId] ?? true;
  }

  Future<void> uploadImage(String slideId) async {
    log('Picking image for slide $slideId');

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'svg'],
        allowMultiple: false,
      );

      log("Picking image result: $result");

      if (result != null &&
          result.files.isNotEmpty &&
          result.files.first.path != null) {
        String filePath = result.files.first.path!;
        File file = File(filePath);

        // Validate file size (5MB limit)
        int fileSize = await file.length();
        double maxSizeInBytes = 5 * 1024 * 1024;

        if (fileSize > maxSizeInBytes) {
          showErrorToast(message: "File size exceeds 5MB limit");
          return;
        }

        selectedFiles[slideId] = file;
        clearedImages.remove(slideId);

        final index = slides.indexWhere((slide) => slide.id == slideId);
        if (index != -1) {
          final updatedSlide = slides[index].copyWith(
            imageUrl: 'file://${file.path}',
          );
          slides[index] = updatedSlide;
          showSuccessToast(message: "Image selected successfully");
        }
      }
    } catch (e) {
      log("Error selecting image: $e");
      showErrorToast(message: "Failed to select image");
    }
  }

  void clearImage(String slideId) {
    final index = slides.indexWhere((slide) => slide.id == slideId);
    if (index != -1) {
      final updatedSlide = slides[index].copyWith(imageUrl: '');
      slides[index] = updatedSlide;

      selectedFiles.remove(slideId);
      uploadedImageInfo.remove(slideId);
      clearedImages.add(slideId);
    }
  }

  void removeSlide(String slideId) {
    // if (slides.length <= 1) {
    //   showErrorToast(message: "Cannot remove the last slide");
    //   return;
    // }

    slides.removeWhere((slide) => slide.id == slideId);
    slideVisibilityActive.remove(slideId);
    selectedFiles.remove(slideId);
    uploadedImageInfo.remove(slideId);
    originalBannerData.remove(slideId);
    clearedImages.remove(slideId);

    // Clean up resources in the controllers
    collectionController.disposeSlideResources(slideId);
    categoryController.disposeSlideResources(slideId);
    pageLinkController.disposeSlideResources(slideId);

    // Reorder remaining slides to maintain position numbers
    for (int i = 0; i < slides.length; i++) {
      final slidePosition = i + 1;
      slides[i] = slides[i].copyWith(position: 'Slide $slidePosition');
    }
  }

  void updateActionType(String slideId, ActionType type) {
    final index = slides.indexWhere((slide) => slide.id == slideId);
    if (index != -1) {
      final updatedSlide = slides[index].copyWith(actionType: type);
      slides[index] = updatedSlide;

      // Clear selection in controllers that are not related to the selected type
      switch (type) {
        case ActionType.page:
          categoryController.clearSelection(slideId);
          collectionController.clearSelection(slideId);
          break;
        case ActionType.category:
          pageLinkController.clearSelection(slideId);
          collectionController.clearSelection(slideId);
          break;
        case ActionType.collection:
          pageLinkController.clearSelection(slideId);
          categoryController.clearSelection(slideId);
          break;
      }

      // Update target based on the new action type
      updateTargetBasedOnActionType(slideId, type);
    }
  }

  void updateTargetBasedOnActionType(String slideId, ActionType type) {
    String? target;

    switch (type) {
      case ActionType.page:
        target = pageLinkController.getSelectedPageUrl(slideId);
        break;
      case ActionType.category:
        target = categoryController.getSelectedCategoryId(slideId);
        break;
      case ActionType.collection:
        target = collectionController.getSelectedCollectionId(slideId);
        break;
    }

    if (target != null) {
      updateTarget(slideId, target);
    }
  }

  void clearAllFields() {
    selectedFiles.clear();
    uploadedImageInfo.clear();
    clearedImages.clear();
    originalBannerData.clear();

    // Get all current slide IDs before clearing
    final currentSlideIds = slides.map((slide) => slide.id).toList();

    // Clean up resources for all slides
    for (var slideId in currentSlideIds) {
      collectionController.disposeSlideResources(slideId);
      categoryController.disposeSlideResources(slideId);
      pageLinkController.disposeSlideResources(slideId);
    }

    slides.assignAll([
      HeroSlideItem(
        id: '1',
        position: 'Slide 1',
        imageUrl: '',
        actionType: ActionType.page,
      ),
    ]);

    slideVisibilityActive.clear();
    slideVisibilityActive['1'] = true;
  }

  void updateTarget(String slideId, String target) {
    final index = slides.indexWhere((slide) => slide.id == slideId);
    if (index != -1) {
      final updatedSlide = slides[index].copyWith(target: target);
      slides[index] = updatedSlide;
    }
  }

  Future<void> saveChanges() async {
    try {
      isLoading.value = true;

      // 1. Upload any new images first
      for (var slideId in selectedFiles.keys) {
        final file = selectedFiles[slideId];
        if (file != null) {
          await _uploadSlideImage(slideId, file);
        }
      }

      // 2. Process banner updates
      await _updateBanners();

      // 3. Clear temporary state
      selectedFiles.clear();
      uploadedImageInfo.clear();
      clearedImages.clear();

      // 4. Refresh banners from API
      await fetchBanners();

      showSuccessToast(message: "Hero slides saved successfully");
    } catch (e) {
      log("Error saving slides: $e");
      showErrorToast(message: "Failed to save slides: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _uploadSlideImage(String slideId, File file) async {
    try {
      isUploading.value = true;

      final extension = path.extension(file.path).replaceAll(".", "");
      final fileName = path
          .basenameWithoutExtension(file.path)
          .replaceAll(" ", "_");

      final images = [
        BannerImagesPresignedUrlImage(fileName: fileName, fileType: extension),
      ];

      final presignedRequest = BannerImagesPresignedUrlRequest(images: images);

      final presignedResponse = await _webstoreRepository
          .bannerImagePresignedUrl(presignedRequest);

      if (presignedResponse.images != null &&
          presignedResponse.images!.isNotEmpty) {
        final imageInfo = presignedResponse.images!.first;

        if (imageInfo.presignedUrl != null) {
          await _webstoreRepository.putBannerImages(
            putUrl: imageInfo.presignedUrl!,
            imagePath: file.path,
          );

          if (imageInfo.s3Key != null && imageInfo.s3Key!.isNotEmpty) {
            uploadedImageInfo[slideId] = {
              's3Key': imageInfo.s3Key!,
              'fileName': fileName,
              'fileType': extension,
            };
          } else {
            throw Exception("No S3 key returned from server");
          }
        } else {
          throw Exception("Did not receive a valid presigned URL");
        }
      } else {
        throw Exception("Failed to generate presigned URLs");
      }
    } catch (e) {
      log("Error uploading image: $e");
      rethrow;
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> _updateBanners() async {
    try {
      // Create a single list for all update requests
      List<UpdateBannerRequest> updateRequests = [];

      for (var slide in slides) {
        final slideId = slide.id;
        final position = int.tryParse(slide.position.split(' ').last) ?? 1;

        // Determine action type as string
        String actionTypeStr = '';
        switch (slide.actionType) {
          case ActionType.page:
            actionTypeStr = 'page';
            break;
          case ActionType.category:
            actionTypeStr = 'category';
            break;
          case ActionType.collection:
            actionTypeStr = 'collection';
            break;
        }

        // Determine typeId and typeLink based on action type
        String? typeId;
        String? typeLink;
        if (slide.actionType == ActionType.page) {
          typeId = null;
          typeLink = slide.target ?? '';
        } else {
          typeId = slide.target ?? '';
          typeLink = null;
        }

        // Prepare images for update request
        List<UpdateBannerRequestImage> images = [];

        // Check if this is an existing banner
        bool isExistingBanner = originalBannerData.containsKey(slideId);

        // If the image was cleared, send empty array
        if (clearedImages.contains(slideId)) {
          // Leave images as empty array
        }
        // If we have newly uploaded image for this slide
        else if (uploadedImageInfo.containsKey(slideId)) {
          final imageInfo = uploadedImageInfo[slideId]!;
          images.add(
            UpdateBannerRequestImage(
              s3Key: imageInfo['s3Key'],
              fileName: imageInfo['fileName'],
              fileType: imageInfo['fileType'],
            ),
          );
        }
        // If we're keeping the existing images and this is an existing banner
        else if (isExistingBanner &&
            originalBannerData[slideId]!.images != null &&
            originalBannerData[slideId]!.images!.isNotEmpty &&
            slide.imageUrl.isNotEmpty) {
          for (var img in originalBannerData[slideId]!.images!) {
            images.add(
              UpdateBannerRequestImage(
                id: img.id,
                fileName: img.fileName,
                fileType: img.fileType,
                s3Key: img.s3Key,
                presignedUrl: img.presignedUrl,
              ),
            );
          }
        }

        // For new banners, only add them if they have an image
        if (!isExistingBanner && !uploadedImageInfo.containsKey(slideId)) {
          // Skip slides with no images for new banners
          continue;
        }

        // For existing banners use the real ID, for new banners use null
        String? bannerId = isExistingBanner ? slideId : null;

        // Add to update requests
        updateRequests.add(
          UpdateBannerRequest(
            id: bannerId,
            slidePosition: position,
            type: actionTypeStr,
            typeId: typeId,
            typeLink: typeLink,
            images: images,
          ),
        );
      }

      // Send update requests if there are any
      if (updateRequests.isNotEmpty) {
        log("Sending ${updateRequests.length} banner update/create requests");
        await _webstoreRepository.updateBanners(updateRequests);
      } else {
        log("No banner changes detected to send to the server");
      }
    } catch (e) {
      log("Error updating/creating banners: $e");
      rethrow;
    }
  }
}
