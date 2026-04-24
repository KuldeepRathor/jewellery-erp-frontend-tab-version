import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/banner_slide_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/banners_onexone_image_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/get_all_banners_onexone_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/model/update_onexone_banner_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_categories_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_collection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view_model/banner_page_link_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/view_model/webstore_image_cropper_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class BannerOneXOneUploadController extends GetxController {
  final WebstoreRepository _webstoreRepository = WebstoreRepository();
  late final CollectionController collectionController;
  late final CategoryController categoryController;
  late final PageLinkController pageLinkController;

  final bannersResponse = Rx<ApiResponse<GetAllBannersOneXOneResponse>>(
    ApiResponse.initial("Initial"),
  );

  final List<Map<String, String>> bannerPositions = [
    {
      'id': 'position1',
      'position': 'Home Page',
      'subtext': '(At 50%)',
      'fullPosition': 'Home Page(At 50%)',
      'size': '1280 X 396',
      'aspectRatio': '3.23',
    },
    {
      'id': 'position2',
      'position': 'Home Page',
      'subtext': '(At 70%)',
      'fullPosition': 'Home Page(At 70%)',
      'size': '1440 X 509',
      'aspectRatio': '2.83',
    },
    {
      'id': 'position3',
      'position': 'Listing Page',
      'subtext': '(Top)',
      'fullPosition': 'Listing Page(Top)',
      'size': '1440X355',
      'aspectRatio': '4.06',
    },
  ];

  final RxList<BannerSlideItem> slides = <BannerSlideItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, bool> slideVisibilityActive = <String, bool>{}.obs;

  final RxBool isUploading = false.obs;
  final RxMap<String, File?> selectedFiles = <String, File?>{}.obs;

  final RxMap<String, GetAllBannersOneXOneValue> originalBannerData =
      <String, GetAllBannersOneXOneValue>{}.obs;

  final RxMap<String, Map<String, String>> uploadedImageInfo =
      <String, Map<String, String>>{}.obs;

  final RxSet<String> clearedImages = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();

    collectionController = Get.put(CollectionController());
    categoryController = Get.put(CategoryController());
    pageLinkController = Get.put(PageLinkController());

    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      bannersResponse.value = ApiResponse.loading("Loading banners...");

      final response = await _webstoreRepository.getAllOneXOneBanners();
      log(
        'Received API response for 1x1 banners. Data present: ${response.values != null}',
      );
      log('Number of 1x1 banners: ${response.values?.length ?? 0}');

      List<BannerSlideItem> staticSlides = [];

      if (response.values != null && response.values!.isNotEmpty) {
        originalBannerData.clear();

        final bannersToProcess = response.values!.take(3);

        for (var banner in bannersToProcess) {
          if (banner.id != null) {
            originalBannerData[banner.id!] = banner;
          }

          ActionType actionType = ActionType.page;
          if (banner.type == 'category') actionType = ActionType.category;
          if (banner.type == 'collection') actionType = ActionType.collection;

          String imageUrl = '';
          if (banner.images != null && banner.images!.isNotEmpty) {
            imageUrl = banner.images!.first.presignedUrl ?? '';
          }

          int bannerIndex = 0;
          if (banner.slidePosition != null) {
            if (banner.slidePosition == 'Home Page(At 50%)') {
              bannerIndex = 0;
            } else if (banner.slidePosition == 'Home Page(At 70%)') {
              bannerIndex = 1;
            } else if (banner.slidePosition == 'Listing Page(Top)') {
              bannerIndex = 2;
            }
          }

          final slideId = banner.id ?? bannerPositions[bannerIndex]['id']!;
          final slide = BannerSlideItem(
            id: slideId,
            position: bannerPositions[bannerIndex]['fullPosition']!,
            imageUrl: imageUrl,
            actionType: actionType,
            target:
                actionType == ActionType.page ? banner.typeLink : banner.typeId,
          );

          staticSlides.add(slide);

          bool isVisible = true;
          if (banner.images != null && banner.images!.isNotEmpty) {
            isVisible = banner.images!.first.isWebstore ?? true;
          }
          slideVisibilityActive[slide.id] = isVisible;

          if (actionType == ActionType.category && banner.typeId != null) {
            categoryController.preSelectCategory(slide.id, banner.typeId!);
          } else if (actionType == ActionType.collection &&
              banner.typeId != null) {
            collectionController.preSelectCollection(slide.id, banner.typeId!);
          } else if (actionType == ActionType.page && banner.typeLink != null) {
            pageLinkController.preSelectPage(slide.id, banner.typeLink!);
          }
        }
      }

      while (staticSlides.length < 3) {
        int index = staticSlides.length;
        final slideId = 'new_${DateTime.now().millisecondsSinceEpoch}_$index';
        staticSlides.add(
          BannerSlideItem(
            id: slideId,
            position: bannerPositions[index]['fullPosition']!,
            imageUrl: '',
            actionType: ActionType.page,
          ),
        );

        slideVisibilityActive[staticSlides.last.id] = true;
      }

      slides.assignAll(staticSlides);
      log('Loaded ${slides.length} banner slides');

      bannersResponse.value = ApiResponse.completed(response);
      log('Set banners response to COMPLETED status');
    } catch (e, stack) {
      log('Error fetching banners: $e $stack');
      bannersResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to fetch banners");

      List<BannerSlideItem> defaultSlides = [];
      for (int i = 0; i < 3; i++) {
        final slideId = 'new_${DateTime.now().millisecondsSinceEpoch}_$i';
        defaultSlides.add(
          BannerSlideItem(
            id: slideId,
            position: bannerPositions[i]['fullPosition']!,
            imageUrl: '',
            actionType: ActionType.page,
          ),
        );
        slideVisibilityActive[slideId] = true;
      }

      slides.assignAll(defaultSlides);
      log('Error occurred, added 3 default empty slides with custom positions');
    } finally {
      isLoading.value = false;
      log('Loading state set to false');
    }
  }

  String getPositionLabel(int index) {
    if (index >= 0 && index < bannerPositions.length) {
      return bannerPositions[index]['position']!;
    }
    return "Unknown Position";
  }

  String getPositionSubtext(int index) {
    if (index >= 0 && index < bannerPositions.length) {
      return bannerPositions[index]['subtext']!;
    }
    return "";
  }

  String getBannerSize(int index) {
    if (index >= 0 && index < bannerPositions.length) {
      return bannerPositions[index]['size']!;
    }
    return "Unknown Size";
  }

  double getAspectRatio(int index) {
    if (index >= 0 && index < bannerPositions.length) {
      return double.tryParse(bannerPositions[index]['aspectRatio'] ?? '1.0') ??
          1.0;
    }
    return 1.0;
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

        final index = slides.indexWhere((slide) => slide.id == slideId);
        if (index == -1) {
          showErrorToast(message: "Could not find slide");
          return;
        }

        final aspectRatio = getAspectRatio(index);

        final croppedPath = await Get.dialog(
          WebstoreImageCropDialog(
            imagePath: filePath,
            onCropped: (path) => Get.back(result: path),
            aspectRatio: aspectRatio,
            useCircleUi: false,
          ),
          barrierDismissible: false,
        );

        if (croppedPath == null) {
          log("Image cropping canceled");
          return;
        }

        File file = File(croppedPath);

        int fileSize = await file.length();
        double maxSizeInBytes = 5 * 1024 * 1024;

        if (fileSize > maxSizeInBytes) {
          showErrorToast(message: "File size exceeds 5MB limit");
          return;
        }

        selectedFiles[slideId] = file;
        clearedImages.remove(slideId);

        final updatedSlide = slides[index].copyWith(
          imageUrl: 'file://${file.path}',
        );
        slides[index] = updatedSlide;
        showSuccessToast(message: "Image selected and cropped successfully");
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

  void updateActionType(String slideId, ActionType type) {
    final index = slides.indexWhere((slide) => slide.id == slideId);
    if (index != -1) {
      final updatedSlide = slides[index].copyWith(actionType: type);
      slides[index] = updatedSlide;

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

    final currentSlideIds = slides.map((slide) => slide.id).toList();

    for (var slideId in currentSlideIds) {
      collectionController.disposeSlideResources(slideId);
      categoryController.disposeSlideResources(slideId);
      pageLinkController.disposeSlideResources(slideId);
    }

    List<BannerSlideItem> defaultSlides = [];
    for (int i = 0; i < 3; i++) {
      final slideId = 'new_${DateTime.now().millisecondsSinceEpoch}_$i';
      defaultSlides.add(
        BannerSlideItem(
          id: slideId,
          position: bannerPositions[i]['fullPosition']!,
          imageUrl: '',
          actionType: ActionType.page,
        ),
      );
      slideVisibilityActive[slideId] = true;
    }

    slides.assignAll(defaultSlides);
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

      for (var slideId in selectedFiles.keys) {
        final file = selectedFiles[slideId];
        if (file != null) {
          await _uploadSlideImage(slideId, file);
        }
      }

      await _updateBanners();

      selectedFiles.clear();
      uploadedImageInfo.clear();
      clearedImages.clear();

      await fetchBanners();

      showSuccessToast(message: "1x1 banners saved successfully");
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
        BannersOneXOneImagePresignedUrlImage(
          fileName: fileName,
          fileType: extension,
        ),
      ];

      final presignedRequest = BannersOneXOneImagePresignedUrlRequest(
        images: images,
      );

      final presignedResponse = await _webstoreRepository
          .bannersOneXOneImagePresignedUrl(presignedRequest);

      if (presignedResponse.images != null &&
          presignedResponse.images!.isNotEmpty) {
        final imageInfo = presignedResponse.images!.first;

        if (imageInfo.presignedUrl != null) {
          await _webstoreRepository.putBannerOneXOneImages(
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
      List<UpdateBannersOneXOneRequest> updateRequests = [];

      for (var slide in slides) {
        final slideId = slide.id;
        final position = slide.position;

        log('Banner position for slide $slideId: $position');

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

        String? typeId;
        String? typeLink;

        if (slide.actionType == ActionType.category) {
          typeId = categoryController.getSelectedCategoryId(slideId);
          typeLink = null;

          log('Using category ID for slide $slideId: $typeId');

          if (typeId == null || typeId.isEmpty) {
            log('No category ID selected for slide $slideId, skipping');
            continue;
          }
        } else if (slide.actionType == ActionType.collection) {
          typeId = collectionController.getSelectedCollectionId(slideId);
          typeLink = null;

          log('Using collection ID for slide $slideId: $typeId');

          if (typeId == null || typeId.isEmpty) {
            log('No collection ID selected for slide $slideId, skipping');
            continue;
          }
        } else {
          typeId = null;
          typeLink = slide.target ?? '';
        }

        if (originalBannerData.containsKey(slideId)) {
          final originalBanner = originalBannerData[slideId]!;

          List<UpdateBannersOneXOneRequestImage> images = [];

          if (clearedImages.contains(slideId)) {
          } else if (uploadedImageInfo.containsKey(slideId)) {
            final imageInfo = uploadedImageInfo[slideId]!;
            images.add(
              UpdateBannersOneXOneRequestImage(
                s3Key: imageInfo['s3Key'],
                fileName: imageInfo['fileName'],
                fileType: imageInfo['fileType'],
              ),
            );
          } else if (originalBanner.images != null &&
              originalBanner.images!.isNotEmpty &&
              slide.imageUrl.isNotEmpty) {
            for (var img in originalBanner.images!) {
              images.add(
                UpdateBannersOneXOneRequestImage(
                  id: img.id,
                  fileName: img.fileName,
                  fileType: img.fileType,
                  s3Key: img.s3Key,
                  presignedUrl: img.presignedUrl,
                ),
              );
            }
          }

          updateRequests.add(
            UpdateBannersOneXOneRequest(
              id: slideId,
              slidePosition: position,
              type: actionTypeStr,
              isWebstore: slideVisibilityActive[slideId],
              typeId: typeId,
              typeLink: typeLink,
              images: images,
            ),
          );
        } else {
          if (uploadedImageInfo.containsKey(slideId)) {
            final imageInfo = uploadedImageInfo[slideId]!;
            final bannerImage = UpdateBannersOneXOneRequestImage(
              s3Key: imageInfo['s3Key'],
              fileName: imageInfo['fileName'],
              fileType: imageInfo['fileType'],
            );

            updateRequests.add(
              UpdateBannersOneXOneRequest(
                slidePosition: position,
                type: actionTypeStr,
                isWebstore: slideVisibilityActive[slideId],
                typeId: typeId,
                typeLink: typeLink,
                images: [bannerImage],
              ),
            );
          }
        }
      }

      for (var req in updateRequests) {
        log(
          'Banner request: position=${req.slidePosition}, type=${req.type}, typeId=${req.typeId}, typeLink=${req.typeLink}',
        );
      }

      if (updateRequests.isNotEmpty) {
        log("Sending ${updateRequests.length} banner update requests");
        await _webstoreRepository.updateBannerOneXOne(updateRequests);
      } else {
        log("No banner changes detected to send to the server");
      }
    } catch (e) {
      log("Error updating/creating banners: $e");
      rethrow;
    }
  }
}
