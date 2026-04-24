import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/model/purchase_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class Attachment {
  final String path;
  final String fileName;
  final String fileType;
  final int fileSize;
  final bool isFile;
  final String? id;
  final String? s3Key;

  Attachment({
    required this.path,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    this.isFile = true,
    this.id,
    this.s3Key,
  });

  String get formattedSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}

class InvoiceDeatilsController extends GetxController {
  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();

  final getInvoiceDetailsResponse = Rx<ApiResponse<PurchaseInvoiceModel>>(
    ApiResponse.initial("Initial"),
  );

  // Attachments handling
  final RxList<Attachment> attachments = <Attachment>[].obs;
  final RxList<Attachment> temporaryAttachments = <Attachment>[].obs;
  final RxBool isUploading = false.obs;
  final RxBool isDownloading = false.obs;

  Future<void> getInvoiceDetailsById({required String id}) async {
    try {
      getInvoiceDetailsResponse.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await _purchaseInvoiceRepository.getPurchaseInvoiceById(
        id: id,
      );
      getInvoiceDetailsResponse.value = ApiResponse.completed(response);

      // Load attachments from the invoice model
      loadAttachmentsFromInvoice(response);
    } catch (e) {
      getInvoiceDetailsResponse.value = ApiResponse.error(e.toString());
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }

  // Method to load attachments from the invoice model
  void loadAttachmentsFromInvoice(PurchaseInvoiceModel invoice) {
    attachments.clear();

    if (invoice.purchaseAttachments != null &&
        invoice.purchaseAttachments!.isNotEmpty) {
      for (var attachment in invoice.purchaseAttachments!) {
        // Default estimated size - this will be shown until real files are loaded
        int estimatedSize = 100 * 1024; // 100KB as default estimate

        attachments.add(
          Attachment(
            path: attachment.presignedUrl ?? '',
            fileName: attachment.fileName ?? 'Unknown',
            fileType: attachment.fileType ?? 'unknown',
            fileSize: estimatedSize,
            isFile: false, // These are from server
            id: attachment.id,
            s3Key: attachment.s3Key,
          ),
        );
      }
    }
  }

  Future<void> downloadFile(String url) async {
    if (url.isEmpty) {
      showErrorToast(message: "Invalid download URL");
      return;
    }

    try {
      isDownloading.value = true;

      if (kIsWeb) {
        // For web platform, use window navigation
        try {
          // Launch URL in a new tab
          final Uri uri = Uri.parse(url);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          showSuccessToast(message: "Download started in browser");
        } catch (e) {
          log("Web download error: $e");
          showErrorToast(message: "Failed to open URL");
        }
      } else if (Platform.isMacOS) {
        // For macOS, try the system open command
        try {
          await Process.run('open', [url]);
          showSuccessToast(message: "Download started in browser");
        } catch (e) {
          log("MacOS process error: $e");
          showErrorToast(message: "Failed to open URL");
        }
      } else {
        // For other platforms, use url_launcher
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
        showSuccessToast(message: "Download started");
      }
    } catch (e) {
      log("Error downloading file: $e");
      showErrorToast(message: "Failed to download file");
    } finally {
      isDownloading.value = false;
    }
  } // Used when uploading files directly (without preview dialog)

  Future<void> pickAttachments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'svg',
          'pdf',
          'doc',
          'docx',
          'csv',
        ],
        allowMultiple: true,
      );

      if (result != null) {
        List<String> paths = result.paths.whereType<String>().toList();
        _addAttachmentsFromPaths(paths, attachments);
      }
    } catch (e) {
      log("Error picking attachments: $e");
      showErrorToast(message: "Error selecting files");
    }
  }

  // Used when selecting files in the dialog preview
  Future<void> pickAttachmentsTemporary() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'svg',
          'pdf',
          'doc',
          'docx',
          'csv',
        ],
        allowMultiple: true,
      );

      if (result != null) {
        List<String> paths = result.paths.whereType<String>().toList();
        _addAttachmentsFromPaths(paths, temporaryAttachments);
      }
    } catch (e) {
      log("Error picking temporary attachments: $e");
      showErrorToast(message: "Error selecting files");
    }
  }

  void _addAttachmentsFromPaths(
    List<String> paths,
    RxList<Attachment> targetList,
  ) async {
    for (String filePath in paths) {
      File file = File(filePath);
      int fileSize = await file.length();
      String extension = path.extension(filePath).toLowerCase();
      String fileName = path.basename(filePath);

      // Check if file size is within limit (5MB for images, 50MB for other files)
      double maxSizeInBytes =
          extension == '.mp4'
              ? 50 *
                  1024 *
                  1024 // 50MB for videos
              : 5 * 1024 * 1024; // 5MB for other files

      if (fileSize <= maxSizeInBytes) {
        targetList.add(
          Attachment(
            path: filePath,
            fileName: fileName,
            fileType: extension.replaceAll('.', ''),
            fileSize: fileSize,
          ),
        );
      } else {
        // Show error for files that are too large
        showErrorToast(message: "File $fileName exceeds size limit");
      }
    }
  }

  void removeAttachment(Attachment attachment) {
    attachments.remove(attachment);
  }

  void removeTemporaryAttachment(int index) {
    if (index >= 0 && index < temporaryAttachments.length) {
      temporaryAttachments.removeAt(index);
    }
  }

  void clearAttachments() {
    attachments.clear();
  }

  void clearTemporaryAttachments() {
    temporaryAttachments.clear();
  }

  void confirmTemporaryAttachments() {
    // Add all temporary attachments to the main list
    attachments.addAll(temporaryAttachments);
    clearTemporaryAttachments();
  }

  Future<void> uploadAttachments(String invoiceId) async {
    try {
      if (attachments.isEmpty) return;

      isUploading.value = true;

      // 1. Separate local and remote attachments
      final localAttachments =
          attachments.where((attachment) => attachment.isFile).toList();
      final remoteAttachments =
          attachments.where((attachment) => !attachment.isFile).toList();

      // Clear the main attachments list temporarily during upload
      attachments.clear();

      // 2. Create presigned URL request objects for ALL attachments (both local and remote)
      final allAttachmentsForPresignedUrls = [
        // For local files, we need new presigned URLs for upload
        ...localAttachments.map((attachment) {
          final filePath = attachment.path;
          final extension = path.extension(filePath).replaceAll(".", "");
          final fileName = path
              .basenameWithoutExtension(filePath)
              .replaceAll(" ", "_");

          return PurchasePresignedUrlImage(
            fileName: fileName,
            fileType: extension,
          );
        }),

        // For remote files, we also request new presigned URLs for re-upload
        // If we're fully re-uploading, we'd need this - but it depends on the API design
        ...remoteAttachments.map((attachment) {
          return PurchasePresignedUrlImage(
            fileName: path
                .basenameWithoutExtension(attachment.fileName)
                .replaceAll(" ", "_"),
            fileType: attachment.fileType,
            id: attachment.id, // Keep the original ID for reference
            s3Key: attachment.s3Key, // Keep the original S3Key for reference
          );
        }),
      ];

      if (allAttachmentsForPresignedUrls.isEmpty) {
        return;
      }

      final presignedRequest = PurchasePresignedUrlRequest(
        groupId: invoiceId,
        images: allAttachmentsForPresignedUrls,
      );

      final presignedResponse = await _purchaseInvoiceRepository
          .catalogImagePresignedUrl(presignedRequest);

      if (presignedResponse.images != null &&
          presignedResponse.images!.isNotEmpty) {
        if (presignedResponse.images!.length ==
            allAttachmentsForPresignedUrls.length) {
          for (int i = 0; i < localAttachments.length; i++) {
            try {
              final attachment = localAttachments[i];
              final element = presignedResponse.images![i];

              await _purchaseInvoiceRepository.putPurchaseAttachments(
                putUrl: element.presignedUrl ?? "",
                imagePath: attachment.path,
              );
            } catch (e) {
              log("Error uploading local attachment to S3: $e");
              rethrow;
            }
          }

          for (int i = 0; i < remoteAttachments.length; i++) {
            try {
              final attachment = remoteAttachments[i];
              final element =
                  presignedResponse.images![localAttachments.length + i];

              if (attachment.path.isNotEmpty &&
                  attachment.path != 'Unknown' &&
                  element.presignedUrl != null &&
                  element.presignedUrl!.isNotEmpty) {
                await _purchaseInvoiceRepository.putPurchaseAttachments(
                  putUrl: element.presignedUrl ?? "",
                  imagePath: attachment.path,
                );
              }
            } catch (e) {
              log("Error re-uploading remote attachment to S3: $e");
            }
          }
        } else {
          log("Mismatch between presigned URLs and attachments count");
          throw Exception(
            "Mismatch between presigned URLs and attachments count",
          );
        }
      }

      await _purchaseInvoiceRepository.editPurchaseAttachments(
        invoiceId: invoiceId,
        attachments: presignedResponse.images ?? [],
      );

      showSuccessToast(message: "Attachments uploaded successfully");

      await getInvoiceDetailsById(id: invoiceId);
    } catch (e) {
      log("Error uploading attachments: $e");
      showErrorToast(message: "Error uploading files: $e");
    } finally {
      isUploading.value = false;
    }
  }
}
