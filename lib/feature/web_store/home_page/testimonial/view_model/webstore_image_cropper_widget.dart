import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';

// Custom Intents
class CropIntent extends Intent {
  const CropIntent();
}

class CancelIntent extends Intent {
  const CancelIntent();
}

class WebstoreImageCropDialog extends StatefulWidget {
  final String imagePath;
  final Function(String) onCropped;
  final double aspectRatio;
  final bool useCircleUi;

  const WebstoreImageCropDialog({
    super.key,
    required this.imagePath,
    required this.onCropped,
    this.aspectRatio = 1.0, // Default to 1:1 ratio for circular images
    this.useCircleUi = true, // Default to circular UI
  });

  @override
  State<WebstoreImageCropDialog> createState() =>
      _WebstoreImageCropDialogState();
}

class _WebstoreImageCropDialogState extends State<WebstoreImageCropDialog> {
  final _cropController = CropController();
  late Future<Uint8List> _imageBytes;
  bool _isCropping = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _imageBytes = File(widget.imagePath).readAsBytes();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleCropResult(CropResult result) async {
    switch (result) {
      case CropSuccess(:final croppedImage):
        // Save cropped image to temporary file
        final tempDir = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final tempFile = File('${tempDir.path}/cropped_$timestamp.jpg');

        // Decode and encode as JPG with quality
        final croppedDecoded = img.decodeImage(croppedImage);
        if (croppedDecoded != null) {
          final jpg = img.encodeJpg(croppedDecoded, quality: 100);
          await tempFile.writeAsBytes(jpg);
          widget.onCropped(tempFile.path);
        }

      case CropFailure(:final cause):
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text('Failed to crop image: $cause'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
    }

    if (mounted) {
      setState(() => _isCropping = false);
    }
  }

  void _handleCrop() {
    if (!_isCropping) {
      setState(() => _isCropping = true);
      _cropController.crop();
    }
  }

  void _handleCancel() {
    if (!_isCropping) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String titleText =
        widget.useCircleUi
            ? 'Crop Profile Photo'
            : 'Crop Image (${widget.aspectRatio.toStringAsFixed(2)}:1)';

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        // Enter or Space to crop
        LogicalKeySet(LogicalKeyboardKey.enter): const CropIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const CropIntent(),
        // Escape to cancel
        LogicalKeySet(LogicalKeyboardKey.escape): const CancelIntent(),
        // Ctrl/Cmd + Enter to crop
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
            const CropIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.enter):
            const CropIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          CropIntent: CallbackAction<CropIntent>(
            onInvoke: (intent) => _handleCrop(),
          ),
          CancelIntent: CallbackAction<CancelIntent>(
            onInvoke: (intent) => _handleCancel(),
          ),
        },
        child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          child: Dialog(
            child: Container(
              width: 1000, // Increased width for better banner crop experience
              height: 700,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        titleText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Keyboard shortcuts info
                      Row(
                        children: [
                          _buildShortcutHint('Esc', 'Cancel'),
                          const SizedBox(width: 8),
                          _buildShortcutHint('Enter', 'Crop'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<Uint8List>(
                      future: _imageBytes,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Stack(
                          children: [
                            Crop(
                              controller: _cropController,
                              image: snapshot.data!,
                              onCropped: _handleCropResult,
                              withCircleUi: widget.useCircleUi,
                              aspectRatio: widget.aspectRatio,
                              initialRectBuilder: InitialRectBuilder.withBuilder((
                                viewportRect,
                                imageRect,
                              ) {
                                // Create a centered rectangle with proper aspect ratio
                                final viewportCenter = Offset(
                                  viewportRect.left + viewportRect.width / 2,
                                  viewportRect.top + viewportRect.height / 2,
                                );

                                // Calculate optimal size for crop rect
                                double cropWidth, cropHeight;
                                if (viewportRect.width / viewportRect.height >
                                    widget.aspectRatio) {
                                  // If viewport is wider than target aspect ratio
                                  cropHeight = viewportRect.height * 0.8;
                                  cropWidth = cropHeight * widget.aspectRatio;
                                } else {
                                  // If viewport is taller than target aspect ratio
                                  cropWidth = viewportRect.width * 0.8;
                                  cropHeight = cropWidth / widget.aspectRatio;
                                }

                                return Rect.fromCenter(
                                  center: viewportCenter,
                                  width: cropWidth,
                                  height: cropHeight,
                                );
                              }),
                              maskColor: Colors.black.withOpacity(0.6),
                              baseColor: Colors.black,
                              radius: widget.useCircleUi ? 0 : 8,
                              interactive: true,
                              filterQuality: FilterQuality.high,
                            ),
                            if (_isCropping)
                              Container(
                                color: Colors.black45,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomInkButton(
                        onPressed: () => _handleCancel(),
                        text: "Cancel",
                      ),
                      CustomInkButton(
                        onPressed: () => _handleCrop(),
                        text: "Crop",
                        isLoading: _isCropping,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutHint(String key, String action) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              key,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            action,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
