import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view_model/invoice_deatils_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:svg_flutter/svg.dart';
import 'package:intl/intl.dart';

class ViewEstimateWidget extends StatelessWidget {
  final InvoiceDeatilsController invoiceDetailsController =
      Get.find<InvoiceDeatilsController>();

  ViewEstimateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton2(
                  onTap: () {
                    _showUploadDialog(context);
                  },
                  image: 'assets/svgs/add.svg',
                  buttonName: 'Upload New',
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.02),
            const Divider(),
            SizedBox(height: Get.height * 0.02),
            Obx(
              () => CustomText(
                text:
                    "${invoiceDetailsController.attachments.length} Attachments",
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Obx(() => _buildAttachmentsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsList() {
    if (invoiceDetailsController.attachments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No attachments yet. Click 'Upload New' to add files.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          invoiceDetailsController.attachments.map((attachment) {
            final extension = path.extension(attachment.fileName).toLowerCase();

            // Create the attachment card with hover effect and download on click
            return GestureDetector(
              onTap: () => _downloadAttachment(attachment),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _buildAttachmentCard(attachment, extension),
              ),
            );
          }).toList(),
    );
  }

  Future<void> _downloadAttachment(Attachment attachment) async {
    try {
      if (attachment.isFile) {
        // For local files, we can't do much in the web context
        // showErrorToast(message: "This is a local file");
      } else if (attachment.path.isNotEmpty) {
        invoiceDetailsController.downloadFile(attachment.path);
      }
    } catch (e) {
      showErrorToast(message: "Error downloading file: $e");
    }
  }

  Widget _buildAttachmentCard(Attachment attachment, String extension) {
    // Format date - use today's date for simplicity since we don't have actual date
    final String dateStr = DateFormat('MMMM/d/yyyy').format(DateTime.now());

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top info section
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.fileType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  attachment.formattedSize,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // File preview/icon
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Center(child: _getFilePreview(attachment, extension)),
          ),

          // Date and filename section
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                _buildFileNameLabel(attachment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFilePreview(Attachment attachment, String extension) {
    // For local image files
    if (attachment.isFile && ['.jpg', '.jpeg', '.png'].contains(extension)) {
      return Image.file(
        File(attachment.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    // For remote image files
    else if (!attachment.isFile &&
        ['.jpg', '.jpeg', '.png'].contains(extension)) {
      if (attachment.path.isNotEmpty && attachment.path != 'Unknown') {
        return CachedNetworkImage(
          imageUrl: attachment.path,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder:
              (context, url) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          errorWidget: (context, url, error) => _buildFileTypeLabel(attachment),
        );
      }
    }

    // For non-image files, show label based on type
    return _buildColoredTypeLabel(attachment, extension);
  }

  Widget _buildColoredTypeLabel(Attachment attachment, String extension) {
    final baseName = path.basenameWithoutExtension(attachment.fileName);
    final shortName =
        baseName.length > 10 ? baseName.substring(0, 10) : baseName;
    final fileType = extension.replaceAll('.', '').toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$shortName...$fileType',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildFileTypeLabel(Attachment attachment) {
    final extension = path.extension(attachment.fileName).toLowerCase();

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getDisplayName(attachment, extension),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getDisplayName(Attachment attachment, String extension) {
    final baseName = path.basenameWithoutExtension(attachment.fileName);
    final shortName =
        baseName.length > 10 ? baseName.substring(0, 10) : baseName;

    if (extension == '.pdf') {
      return '$shortName...PDF';
    } else if (['.png', '.jpg', '.jpeg'].contains(extension)) {
      return '$shortName...${extension.replaceAll('.', '').toUpperCase()}';
    } else {
      return '$shortName...${extension.replaceAll('.', '').toUpperCase()}';
    }
  }

  Widget _buildFileNameLabel(Attachment attachment) {
    final fileName = path.basenameWithoutExtension(attachment.fileName);
    return Text(
      fileName,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _showUploadDialog(BuildContext context) {
    // Clear any previous temporary uploads
    invoiceDetailsController.clearTemporaryAttachments();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: Get.width * 0.6,
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.7, // Increased max height
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Upload area with scrollable content
                Expanded(child: _buildDialogContent(context)),

                // Bottom action buttons - fixed at bottom
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        child: const Text('Discard'),
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        return SizedBox(
                          // Fixed width for button to avoid layout issues
                          width: 100,
                          child: ElevatedButton(
                            onPressed:
                                invoiceDetailsController
                                        .temporaryAttachments
                                        .isEmpty
                                    ? null
                                    : () {
                                      // Save the attachments
                                      invoiceDetailsController
                                          .confirmTemporaryAttachments();
                                      Navigator.of(context).pop();

                                      // Get the current invoice ID from the controller
                                      final invoiceId =
                                          invoiceDetailsController
                                              .getInvoiceDetailsResponse
                                              .value
                                              .data
                                              ?.id ??
                                          '';
                                      if (invoiceId.isNotEmpty) {
                                        invoiceDetailsController
                                            .uploadAttachments(invoiceId);
                                      } else {
                                        showErrorToast(
                                          message: "Invalid invoice ID",
                                        );
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child:
                                invoiceDetailsController.isUploading.value
                                    ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Save'),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Always show the upload container
            const SizedBox(height: 16),
            Container(
              height: Get.height * 0.3,
              width: Get.width * 0.58,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Upload icon
                  InkWell(
                    onTap: () {
                      invoiceDetailsController.pickAttachmentsTemporary();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: Get.height * 0.05),
                        SvgPicture.asset(
                          'assets/svgs/upload.svg',
                          color: primaryColor,
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(height: Get.height * 0.0125),
                        const Text(
                          'Upload or Drag PDF, DOC.',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Supported formats are JPEG, PNG, PDF, SVG \nRecommended Size Upto 5mb per image and 50mb per video',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // If files are selected, show the file list in two columns
            if (invoiceDetailsController.temporaryAttachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  width: Get.width * 0.58,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two columns
                          childAspectRatio:
                              4.5, // Adjust based on item dimensions
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 8,
                        ),
                    itemCount:
                        invoiceDetailsController.temporaryAttachments.length,
                    itemBuilder: (context, index) {
                      final attachment =
                          invoiceDetailsController.temporaryAttachments[index];
                      return _buildGridFileItem(attachment, index);
                    },
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildGridFileItem(Attachment attachment, int index) {
    final fileIcon = _getFileIcon(attachment.fileType);
    final fileName = path.basename(attachment.fileName);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // File icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(child: Icon(fileIcon, color: primaryColor, size: 20)),
          ),
          const SizedBox(width: 8),

          // File details
          Expanded(
            child: Row(
              children: [
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fileName.length > 25
                            ? "${fileName.substring(0, 22)}..."
                            : fileName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "(${attachment.formattedSize})",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Close button
                InkWell(
                  onTap: () {
                    invoiceDetailsController.removeTemporaryAttachment(index);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'svg':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
