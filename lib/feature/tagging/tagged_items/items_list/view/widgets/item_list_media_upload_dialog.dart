// optimized_tagged_item_media_upload_dialog.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/enhance_media_upload_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view_model/item_list_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemListMediaUploadDialog extends StatefulWidget {
  final TaggedItemReportValueResponse item;
  final int itemIndex;
  final bool isViewMode;

  const ItemListMediaUploadDialog({
    super.key,
    required this.item,
    required this.itemIndex,
    this.isViewMode = false,
  });

  @override
  State<ItemListMediaUploadDialog> createState() =>
      _ItemListMediaUploadDialogState();
}

class _ItemListMediaUploadDialogState extends State<ItemListMediaUploadDialog> {
  final EnhancedTaggedItemMediaUploadController controller =
      Get.find<EnhancedTaggedItemMediaUploadController>();
  int selectedMediaIndex = 0;
  final PageController pageController = PageController();

  Player? currentVideoPlayer;
  VideoController? currentVideoController;
  bool isVideoInitialized = false;
  String? videoError;
  bool isLowEndDevice = false;

  // Tracks whether user is in "reorder mode"
  bool isReorderMode = false;

  @override
  void initState() {
    super.initState();
    controller.isInitialized.value = false;
    _detectDeviceCapabilities();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isViewMode) {
        controller.populateWithFetchedData(widget.item);
      } else {
        controller.clearControllers();
        controller.isInitialized.value = true;
      }
    });
  }

  void _detectDeviceCapabilities() {
    if (Platform.isWindows || Platform.isLinux) {
      isLowEndDevice = true;
    }
  }

  @override
  void dispose() {
    _disposeCurrentVideo();
    pageController.dispose();
    super.dispose();
  }

  void _disposeCurrentVideo() {
    currentVideoPlayer?.dispose();
    currentVideoController = null;
    currentVideoPlayer = null;
    isVideoInitialized = false;
    videoError = null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: Get.width * 0.6,
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (!controller.isInitialized.value && widget.isViewMode) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.mediaPaths.isEmpty) {
                  return _buildUploadArea();
                } else {
                  return _buildMediaGallery();
                }
              }),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
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
            text: 'Upload Media',
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          Row(
            children: [
              // Reorder mode toggle button
              Obx(
                () =>
                    controller.mediaPaths.length > 1
                        ? Tooltip(
                          message:
                              isReorderMode
                                  ? 'Exit Reorder Mode'
                                  : 'Reorder Media',
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              setState(() {
                                isReorderMode = !isReorderMode;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isReorderMode
                                        ? primaryColor
                                        : const Color(0xFFE6E8FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.swap_vert_rounded,
                                    size: 18,
                                    color:
                                        isReorderMode
                                            ? Colors.white
                                            : primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isReorderMode ? 'Done' : 'Reorder',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isReorderMode
                                              ? Colors.white
                                              : primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickMedia,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E8FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF28328B).withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.perm_media_outlined,
              size: 80,
              color: const Color(0xFF28328B).withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            const CustomText(
              text: 'Upload Images or Videos',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF28328B),
            ),
            const SizedBox(height: 8),
            const CustomText(
              text: 'Images: 100MB max | Videos: 150MB max',
              fontSize: 14,
              color: Colors.grey,
            ),
            const SizedBox(height: 4),
            const CustomText(
              text: 'You can upload up to 5 files',
              fontSize: 14,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGallery() {
    return Column(
      children: [
        // Reorder hint banner
        if (isReorderMode)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: primaryColor.withOpacity(0.08),
            child: const Row(
              children: [
                Icon(Icons.drag_indicator, color: primaryColor, size: 18),
                SizedBox(width: 8),
                Text(
                  'Drag thumbnails below to reorder upload sequence',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        // Main media preview (hidden in reorder mode)
        if (!isReorderMode)
          Expanded(
            child: Stack(
              children: [
                Obx(() {
                  if (controller.mediaPaths.isEmpty) {
                    return const Center(child: Text('No media'));
                  }
                  return PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _disposeCurrentVideo();
                        selectedMediaIndex = index;
                      });
                    },
                    itemCount: controller.mediaPaths.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildMainMediaWidget(
                            controller.mediaPaths[index],
                            index,
                          ),
                        ),
                      );
                    },
                  );
                }),

                if (controller.mediaPaths.length > 1) ...[
                  _buildNavigationArrow(
                    isLeft: true,
                    onPressed:
                        selectedMediaIndex > 0
                            ? () => pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                            : null,
                  ),
                  _buildNavigationArrow(
                    isLeft: false,
                    onPressed:
                        selectedMediaIndex < controller.mediaPaths.length - 1
                            ? () => pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                            : null,
                  ),
                ],

                // Index badge on main preview
                Positioned(
                  top: 32,
                  left: 32,
                  child: _buildIndexBadge(selectedMediaIndex + 1),
                ),

                // Delete button
                Positioned(
                  top: 32,
                  right: 32,
                  child: GestureDetector(
                    onTap: () => _removeMedia(selectedMediaIndex),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
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
            ),
          ),

        // Spacer when in reorder mode so drag list takes most of the space
        if (isReorderMode) const SizedBox(height: 8),

        // Thumbnail strip — normal or drag-and-drop
        isReorderMode
            ? _buildDraggableThumbnailStrip()
            : _buildNormalThumbnailStrip(),
      ],
    );
  }

  // ───────────────────────── Normal thumbnail strip ──────────────────────────

  Widget _buildNormalThumbnailStrip() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:
              controller.mediaPaths.length +
              (controller.mediaPaths.length < 5 ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.mediaPaths.length &&
                controller.mediaPaths.length < 5) {
              return _buildAddButton();
            }
            return _buildThumbnail(index, showDragHandle: false);
          },
        ),
      ),
    );
  }

  // ─────────────────── Drag-and-drop reorder thumbnail strip ─────────────────

  Widget _buildDraggableThumbnailStrip() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Drag to reorder (upload sequence)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(
                () => ReorderableListView.builder(
                  scrollDirection: Axis.vertical,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      // Keep selectedMediaIndex in sync
                      final adjustedNew =
                          newIndex > oldIndex ? newIndex - 1 : newIndex;
                      if (selectedMediaIndex == oldIndex) {
                        selectedMediaIndex = adjustedNew;
                      } else if (oldIndex < selectedMediaIndex &&
                          adjustedNew >= selectedMediaIndex) {
                        selectedMediaIndex--;
                      } else if (oldIndex > selectedMediaIndex &&
                          adjustedNew <= selectedMediaIndex) {
                        selectedMediaIndex++;
                      }
                    });
                    controller.reorderMedia(oldIndex, newIndex);
                  },
                  itemCount: controller.mediaPaths.length,
                  itemBuilder: (context, index) {
                    final mediaData = controller.mediaPaths[index];
                    return _buildDraggableRow(
                      mediaData,
                      index,
                      key: ValueKey('${mediaData.path}_${mediaData.sortOrder}'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableRow(
    MediaData mediaData,
    int index, {
    required Key key,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              selectedMediaIndex == index
                  ? primaryColor
                  : Colors.grey.withOpacity(0.25),
          width: selectedMediaIndex == index ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sequence badge
          Container(
            width: 40,
            height: 72,
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9),
                bottomLeft: Radius.circular(9),
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // Thumbnail preview
          Container(
            width: 72,
            height: 72,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _buildThumbnailWidget(mediaData),
            ),
          ),

          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mediaData.fileName ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      mediaData.isVideo
                          ? Icons.videocam_outlined
                          : Icons.image_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      mediaData.isVideo ? 'Video' : 'Image',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (mediaData.fileSize != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        _formatFileSize(mediaData.fileSize!),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Drag handle (visible to user)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.drag_handle, color: Colors.grey, size: 24),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────── Helpers ────────────────────────────────────

  Widget _buildIndexBadge(int number) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
        ],
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _buildNavigationArrow({
    required bool isLeft,
    VoidCallback? onPressed,
  }) {
    return Positioned(
      left: isLeft ? 8 : null,
      right: isLeft ? null : 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
              ],
            ),
            child: Icon(isLeft ? Icons.chevron_left : Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _pickMedia,
      child: Container(
        width: 88,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E8FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF28328B).withOpacity(0.3)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Color(0xFF28328B), size: 32),
            SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(
                color: Color(0xFF28328B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(int index, {bool showDragHandle = false}) {
    final mediaData = controller.mediaPaths[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          _disposeCurrentVideo();
          selectedMediaIndex = index;
          pageController.jumpToPage(index);
        });
      },
      child: Stack(
        children: [
          Container(
            width: 88,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    selectedMediaIndex == index
                        ? primaryColor
                        : Colors.grey.withOpacity(0.3),
                width: selectedMediaIndex == index ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildThumbnailWidget(mediaData),
            ),
          ),
          // Index badge on each thumbnail
          Positioned(top: 4, left: 4, child: _buildIndexBadge(index + 1)),
        ],
      ),
    );
  }

  Widget _buildMainMediaWidget(MediaData mediaData, int index) {
    if (mediaData.isVideo) {
      if (index == selectedMediaIndex) {
        return _buildVideoWidget(mediaData);
      } else {
        return Container(
          color: Colors.black,
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 64,
            ),
          ),
        );
      }
    } else {
      return _buildOptimizedImageWidget(mediaData, fit: BoxFit.contain);
    }
  }

  Widget _buildThumbnailWidget(MediaData mediaData) {
    if (mediaData.isVideo) {
      return Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.video_library, color: Colors.white54, size: 40),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Color(0xFF28328B),
                size: 20,
              ),
            ),
          ],
        ),
      );
    } else {
      return _buildOptimizedImageWidget(mediaData, fit: BoxFit.cover);
    }
  }

  Widget _buildVideoWidget(MediaData mediaData) {
    if (currentVideoPlayer == null && videoError == null) {
      _initializeVideo(mediaData);
    }

    if (videoError != null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Error loading video',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    videoError = null;
                    _initializeVideo(mediaData);
                  });
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!isVideoInitialized || currentVideoController == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Video(
      controller: currentVideoController!,
      controls: MaterialVideoControls,
    );
  }

  Widget _buildOptimizedImageWidget(
    ImageData imageData, {
    BoxFit fit = BoxFit.contain,
  }) {
    if (imageData.isFile) {
      return Image.file(
        File(imageData.path),
        fit: fit,
        cacheHeight: isLowEndDevice && fit == BoxFit.cover ? 200 : null,
        errorBuilder:
            (context, error, stackTrace) => const Center(
              child: Icon(Icons.error_outline, color: Colors.red),
            ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageData.path,
        fit: fit,
        memCacheHeight: isLowEndDevice && fit == BoxFit.cover ? 200 : null,
        placeholder:
            (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget:
            (context, url, error) => const Center(
              child: Icon(Icons.error_outline, color: Colors.red),
            ),
      );
    }
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
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if (controller.isUploading.value) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: controller.uploadProgress.value,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.currentUploadingFile.value.isNotEmpty
                        ? 'Uploading: ${controller.currentUploadingFile.value} (${(controller.uploadProgress.value * 100).toStringAsFixed(1)}%)'
                        : 'Preparing upload...',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed:
                    controller.isUploading.value ? null : () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: const Text(
                    'Discard',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => InkWell(
                  onTap: controller.isUploading.value ? null : _saveMedia,
                  child: Container(
                    width: 120,
                    height: 38,
                    decoration: BoxDecoration(
                      color:
                          controller.isUploading.value
                              ? Colors.grey
                              : primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Save",
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
        ],
      ),
    );
  }

  Future<void> _pickMedia() async {
    await controller.pickMedia();
  }

  void _removeMedia(int index) {
    if (index >= 0 && index < controller.mediaPaths.length) {
      controller.removeMedia(index);

      if (index == selectedMediaIndex) {
        _disposeCurrentVideo();
      }

      if (selectedMediaIndex >= controller.mediaPaths.length &&
          controller.mediaPaths.isNotEmpty) {
        setState(() {
          selectedMediaIndex = controller.mediaPaths.length - 1;
          pageController.jumpToPage(selectedMediaIndex);
        });
      }
    }
  }

  Future<void> _saveMedia() async {
    // Exit reorder mode before saving
    if (isReorderMode) setState(() => isReorderMode = false);

    final success = await controller.saveMedia(widget.item.id ?? '');

    if (success) {
      Get.back(result: true);
      final reportViewModel = Get.find<ItemListViewModel>();
      reportViewModel.getTaggedItemsReportDetails(resetList: true);
    }
  }

  void _initializeVideo(MediaData mediaData) async {
    try {
      currentVideoPlayer = Player();
      currentVideoController = VideoController(currentVideoPlayer!);

      currentVideoPlayer!.stream.error.listen((error) {
        if (mounted) {
          setState(() {
            videoError = error.toString();
            isVideoInitialized = false;
          });
        }
      });

      final media =
          mediaData.isFile
              ? Media('file://${mediaData.path}')
              : Media(mediaData.path);

      await currentVideoPlayer!.open(media);

      if (mounted) {
        setState(() {
          isVideoInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          videoError = e.toString();
          isVideoInitialized = false;
        });
      }
    }
  }
}
