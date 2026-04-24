// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/approval_issue_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/model/approval_receipt_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/approval_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/post_daily_rates_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/post_design_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/update_design_request_models/update_design_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/model/edit_stock_head_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/models/post_stone_rate_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/create_lot_entry_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_entries_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_create/models/post_material_in_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/models/post_material_out_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/model/stock_issue_record_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/wanted_list/model/get_wanted_list_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/models/save_stock_verification_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/cancelled_incvoice/model/get_cancelled_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/model/get_estimate_preference_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/model/get_sales_preference_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/model/get_tag_preference_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/estimate_print/get_estimate_print_template_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/sales_print/get_sales_print_template_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/tag_print/update_tag_print_template_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/model/create_counter_transfer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/model/update_tagging_line_item_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/update_collection_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/update_gender_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/update_metal_color_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_detailed_tagging_item_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_paginated_tagged_items_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/update_tagged_item_by_id_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/post_tagging_line_item_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/tagging_record_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/catalog_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/create_catalogue_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/create_collection_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/get_tagging_and_catalog_itmes_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/edit_webstore_stock_by_id_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/webstore_stock_request.dart';
import 'package:jewellery_erp_frontend_tab_version/model/counter/counter_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/get_ornament_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/add_stock_head_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/barcode_template/model/barcode_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/barcode_template/service/barcode_generator.dart';

class InventoryServices {
  final HttpDioClient _apiService = Get.find();

  Future createWebstoreStock(
    WebstoreStockRequest createWebstoreStockRequest,
  ) async {
    try {
      final body = jsonEncode(createWebstoreStockRequest.toJson());
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/webstore-only-stock',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getWebstoreStockById(String webstoreStockId) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/webstore-only-stock/$webstoreStockId",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future editWebstoreStockById(
    EditWebstoreStockByIdRequest editWebstoreStockByIdRequest,
    String webstoreStockId,
  ) async {
    try {
      final body = jsonEncode(editWebstoreStockByIdRequest.toJson());
      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        '/webstore-stock',
        queryParameters: {"id": webstoreStockId},
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWebstoreStock(String webstoreStockId) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-webstore-stock/$webstoreStockId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future getOnlineDesignListing({
    int? nextPage,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (nextPage != null) {
      path =
          '/paginated-webstore-only-stock?query=$query&limit=$limit&page=$nextPage';
    } else {
      path = '/paginated-webstore-only-stock?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        path,
        data: {},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDesignDropdown({
    int? page,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (page != null) {
      path = '/design-dropdown-paginated?query=$query&limit=$limit&page=$page';
    } else {
      path = '/design-dropdown-paginated?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getStatusDropdown() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/get-item-status-dropdown",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getTaggingLineItem(String taggingId) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        "/tagging-line-item/$taggingId",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getTaggingLineItemEditHistory(String taggingId) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/tagging-line-item-edit-history/$taggingId",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future editTaggingLineItem(
    UpdateTaggingLineItemEditHistoryRequest editTaggingLineItemRequest,
    String taggingId,
  ) async {
    try {
      final body = jsonEncode(editTaggingLineItemRequest.toJson());
      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item/$taggingId',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateTaggedItemWebstoreStatus(String id, bool isWebstore) async {
    try {
      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/update-tagged-item-webstore-status/$id",
        queryParameters: {"is_webstore": isWebstore},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getTaggedItemImagesPresignedUrl({
    required List<ImageRequestModel> images,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "images": images.map((img) => img.toJson()).toList(),
      };

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/tagged-item-presigned-url-save",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateTaggedItemImages({
    required String taggingLineItemId,
    required List<Map<String, dynamic>> images,
  }) async {
    try {
      final body = {
        "tagging_line_item_id": taggingLineItemId,
        "images": images,
      };

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/update-tagged-item-images",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSequencesDropdown({
    required String? voucherType,
    required String? voucherSection,
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/sequences-dropdown',
        queryParameters: {
          "voucher_type": voucherType,
          "voucher_section": voucherSection,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //preference apis

  Future getEstimatePreference() async {
    String path = '/get-estimate-preference';
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.estimationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSalesPreference() async {
    String path = '/get-sale-preference';
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.estimationBaseUrl, path);

      log("Response type: ${response.runtimeType}, Response: $response");

      return response;
    } catch (e) {
      log("Error in getSalesPrintTemplate service: $e");
      rethrow;
    }
  }

  Future getTagPreference() async {
    String path = '/get-tag-preference';
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateEstimatePreference(
    GetEstimatePreferenceResponse updateEstimatePrintTemplateRequest,
  ) async {
    try {
      final body = updateEstimatePrintTemplateRequest.toJson();

      final response = await _apiService.put(
        AppUrl.estimationBaseUrl,
        "/udpate-estimate-preference",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateSalesPreference(
    GetSalesPreferenceResponse updateSalesPreferenceRequest,
  ) async {
    try {
      final body = updateSalesPreferenceRequest.toJson();

      final response = await _apiService.put(
        AppUrl.estimationBaseUrl,
        "/udpate-sale-preference",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateTagPreference(
    GetTagPreferenceResponse updateTagPreferenceRequest,
  ) async {
    try {
      final body = updateTagPreferenceRequest.toJson();

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/udpate-tag-preference",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //print template apis
  Future getSalesPrintTemplate() async {
    String path = '/get-sale-print-template';
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.estimationBaseUrl, path);

      // Log the response type for debugging
      log("Response type: ${response.runtimeType}, Response: $response");

      // Return the raw response - processing happens in repository
      return response;
    } catch (e) {
      log("Error in getSalesPrintTemplate service: $e");
      rethrow;
    }
  }

  // Update template
  Future updateSalesPrintTemplate(
    GetSalesPrintTemplateResponse updateSalesPrintTemplateRequest,
  ) async {
    try {
      final body = updateSalesPrintTemplateRequest.toJson();
      log(
        "Updating template: ${updateSalesPrintTemplateRequest.templateNumber} with data: $body",
      );

      final response = await _apiService.put(
        AppUrl.estimationBaseUrl,
        "/udpate-sale-print-template",
        data: jsonEncode(body),
      );

      // Return raw response - processing happens in repository
      return response;
    } catch (e) {
      log("Error in updateSalesPrintTemplate service: $e");
      rethrow;
    }
  }

  Future getEstimatePrintTemplate() async {
    String path = '/get-estimate-print-template';
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.estimationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateEstimatePrintTemplate(
    GetEstimatePrintTemplateResponse updateEstimatePrintTemplateRequest,
  ) async {
    try {
      final body = updateEstimatePrintTemplateRequest.toJson();

      final response = await _apiService.put(
        AppUrl.estimationBaseUrl,
        "/udpate-estimate-print-template",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getTagPrintTemplate() async {
    String path = '/get-tag-print-template';
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateTagPrintTemplate(
    UpdateTagPrintTemplateRequest updateTagPrintTemplateRequest,
  ) async {
    try {
      final body = updateTagPrintTemplateRequest.toJson();

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/udpate-tag-print-template",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getWeightGroupDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/weight-groups-dropdown?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/weight-groups-dropdown?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getOrnamentDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-ornament-dropdown?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/paginated-ornament-dropdown?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getApprovalIssueNumber({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-approval-line-items-dropdown?query=$query&limit=$limit&page=$offsetId';
    } else {
      path =
          '/paginated-approval-line-items-dropdown?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getApprovalIssueById({required String id}) async {
    String path = '/approval-record-by-id';
    try {
      log("The query will be $path");
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        path,
        queryParameters: {"id": id},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getApprovalReceiptById({required String id}) async {
    String path = '/approval-receipt-record-by-id';
    try {
      log("The query will be $path");
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        path,
        queryParameters: {"id": id},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getInventoryCategories({bool is_webstore = false}) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/categories",
        queryParameters: {"is_webstore": is_webstore},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Stock verification

  Future<Map<String, dynamic>> nextSequence({
    required String invoiceType,
  }) async {
    try {
      final body = {
        "types": [invoiceType],
      };
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/next-sequences",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future saveStockVerification(
    SaveStockVerificationRequest saveStockVerificationRequest,
  ) async {
    try {
      final body = jsonEncode(saveStockVerificationRequest.toJson());
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/save-stock-verification',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Tagged item report

  Future<List<int>> downloadTaggedItemsReport({
    required Map<String, dynamic> requestBody,
    int limit = 10000,
  }) async {
    try {
      final response = await _apiService.post<List<int>>(
        AppUrl.aggregateBaseUrl,
        '/tagging-report/download-csv',
        queryParameters: {'limit': limit},
        data: jsonEncode(requestBody),
        responseType: ResponseType.bytes,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Webstore service

  //Collection Service

  Future<void> deleteCollection(String collectionId) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-collection/$collectionId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future getCollection() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/all-collections',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createCollection(
    CreateCollectionRequest createCollectionRequest,
  ) async {
    try {
      final body = jsonEncode(createCollectionRequest.toJson());
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/create-collection',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDesignsByCategories(List<String> categoryIds) async {
    try {
      // Send the categoryIds directly as a JSON array
      final body = jsonEncode(categoryIds);
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/get-designs',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTaggingAndCatalogItems(
    GetTaggingAndCatalogItemsRequest getTaggingAndCatalogItemRequest,
  ) async {
    try {
      final body = jsonEncode(getTaggingAndCatalogItemRequest.toJson());
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/get-tagging-and-catalog-items',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Catalog service

  Future getCatalogueById({required String? id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/catalog//$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCatalogue(List<String> catalogIds) async {
    try {
      final body = jsonEncode(catalogIds);

      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-catalog',
        data: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future catalogImagePresignedUrl(
    CatalogImagesPresignedUrlRequest request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/catalog-images-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putCatalogImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final mimeType = lookupMimeType(imagePath);
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': mimeType ?? 'application/octet-stream'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createCatalogue(CreateCatalogueRequest createCatalogueRequest) async {
    try {
      final body = jsonEncode(createCatalogueRequest.toJson());
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/create-catalog',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future editCatalogue(
    CreateCatalogueRequest createCatalogueRequest,
    String catalogId,
  ) async {
    try {
      final body = jsonEncode(createCatalogueRequest.toJson());
      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        '/edit-catalog/$catalogId',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getCatlogMetaColor() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/catalog-metal-colour',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getCatalogueListing({
    int? nextPage,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (nextPage != null) {
      path = '/catalog?query=$query&limit=$limit&page=$nextPage';
    } else {
      path = '/catalog?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteStockHead(String stockHeadId) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-stock-head/$stockHeadId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDesign(String designId) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-design/$designId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOrnament(String ornamentId) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-ornament/$ornamentId',
      );
    } catch (e) {
      rethrow;
    }
  }

  //Orders
  Future getByExistingTag(String tag) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item-by-barcode-number?tag_barcode=$tag',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Orders
  Future getAllPurityTypesSegregated() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/all-purity-types-segregated",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Jewellery Plan

  Future getDesignByStockHeadId(String stock_id) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/design-by-stock-id",
        queryParameters: {"stock_id": stock_id},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //
  //Material In Out

  Future getMaterialInById({required String? id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/material-in/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getMaterialOutById({required String? id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/material-out/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addMaterialIn(MaterialInRequestModel materialInRequest) async {
    try {
      final body = jsonEncode(materialInRequest.toJson());
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/material-in',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addMaterialOut(MaterialOutRequestModel materialOutRequest) async {
    try {
      final body = jsonEncode(materialOutRequest.toJson());
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/material-out',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelMaterialInRecord(String recordId) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-material-in-record/$recordId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future getMaterialInListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-material-in?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-material-in?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelMaterialOutRecord(String recordId) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-material-out-record/$recordId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future getMaterialOutListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-material-out?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-material-out?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getMaterialOutstandingListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/material-outstanding?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/material-outstanding?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Stock issue

  Future getStockIssueById({required String id}) async {
    String path = '/stock-issue/$id';
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> submitStockIssueRecord(
    StockIssueRecordRequest stockIssueRecordRequest,
  ) async {
    try {
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/stock-issue",
        data: stockIssueRecordRequest.toJson(),
      );

      if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelStockIssueRecord(String recordId) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-stock-issue-record/$recordId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future getStockIssueListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/all-approval-stock-issue?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/all-approval-stock-issue?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future stockIssueNumber() async {
    try {
      final body = {
        "types": ["issue_invoice_number"],
      };
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/next-sequences",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Approval flow

  Future getApprovalRecordByApprovalNumber(String approval_number) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        "/approval-record-by-approval-number",
        queryParameters: {"approval_number": approval_number},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future submitApprovalIssueRecord(
    ApprovalIssueRecordRequest approvalIssueRecordRequest,
  ) async {
    try {
      final body = approvalIssueRecordRequest.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/approval-record",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future submitApprovalReceiptRecord(
    ApprovalReceiptRecordRequest approvalReceiptRecordRequest,
  ) async {
    try {
      final body = approvalReceiptRecordRequest.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/approval-receipt-record",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future approvalReceiptNumber() async {
    try {
      final body = {
        "types": ["approval_receipt_number"],
      };
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/next-sequences",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getApprovalIssueListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-approval-records-aggregated?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/paginated-approval-records-aggregated?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getApprovalReceiptListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-approval-receipt-records-aggregated?query=$query&limit=$limit&page=$offsetId';
    } else {
      path =
          '/paginated-approval-receipt-records-aggregated?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getApprovalListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    ApprovalListingRequest? filterRequest,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-approval-line-items?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/paginated-approval-line-items?query=$query&limit=$limit';
    }

    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        path,
        data: filterRequest?.toJson() ?? {},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getCancelledInvoiceListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    GetCancelReportRequest? filterRequest,
  }) async {
    String path;
    if (offsetId != null) {
      path = '/get-cancel-report?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/get-cancel-report?query=$query&limit=$limit';
    }

    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        path,
        data: filterRequest?.toJson() ?? {},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future approvalIssueNumber() async {
    try {
      final body = {
        "types": ["approval_issue_number"],
      };
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/next-sequences",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getTaggingLineItemByBarcode(String tagBarcode) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item-by-barcode-number',
        queryParameters: {'tag_barcode': tagBarcode},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getTaggingLineItemCodeTag(
    String code,
    int? tag_number, {
    int? metal_type_id,
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item-code-tag-id',
        queryParameters: {'code': code, 'tag_number': tag_number},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future postTaggingLineItemReTag(String taggingLineItemId) async {
    try {
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item-retag/$taggingLineItemId',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getTaggingLineItemCodeTagSales(
    String code,
    int? tag_number, {
    String? customer_id,
    int? metal_type_id,
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/tagging-line-item-code-tag-id-sales',
        queryParameters: {
          'code': code,
          'tag_number': tag_number,
          'customer_id': customer_id,
          'metal_type_id': metal_type_id,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //tagging entry

  Future getDefaultCounter() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/get-default-counter',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future taggingRecordNumber() async {
    try {
      final body = {
        "types": ["tagging_record_number"],
      };
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/next-sequences",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getTagAndCode(
    String designId,
    double grossWeight,
    double netWeight,
  ) async {
    try {
      final body = {
        "design": designId,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
      };
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/get-tag-and-code",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future taggingRecord(TaggingRecordRequest taggingRecordRequest) async {
    try {
      final body = taggingRecordRequest.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/tagging-record",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future postTaggingLineItem(
    PostTaggingLineItemRequest taggingRecordRequest,
  ) async {
    try {
      final body = taggingRecordRequest.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/tagging-line-item",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllDesigns() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/all-designs',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllOrnaments({
    bool? isStone,
    bool? isOldGold,
    bool? isService,
  }) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/all-ornaments',
        queryParameters: {
          "is_stone": isStone,
          "is_service": isService,
          "is_old_gold": isOldGold,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Counter
  Future getCounterListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/counters?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/counters?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addCounter(CounterValue addcounter) async {
    try {
      final body = addcounter.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/counter",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Counter tranfer Listing

  Future<void> cancelCounterTransfer(String counter_transfer_id) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-counter-transfer/$counter_transfer_id',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future createCounterTransfer(
    CreateCounterTransferRequest create_counter_transfer_request,
  ) async {
    try {
      final body = create_counter_transfer_request.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/counter-transfer",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getCounterTransferListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-counter-transfer?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-counter-transfer?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Stone Rates Services

  Future getStoneRateeById(String stoneRateId) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/stone-rate/$stoneRateId",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future editStoneRate(
    String stoneRateId,
    PostStoneRateRequest editStoneRatesRequest,
  ) async {
    try {
      // ignore: unused_local_variable
      final body = editStoneRatesRequest.toJson();

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/edit_stone_rate",
        queryParameters: {"id": stoneRateId},
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future updatePurityStatus(
  //   String? purityId,
  //   bool status,
  //   String purity_type,
  // ) async {
  //   try {
  //     final response = await _apiService.put(
  //       AppUrl.inventoryBaseUrl,
  //       "/update-purity-types-status",
  //       queryParameters: {
  //         "id": purityId,
  //         "status": status,
  //         "purity_type": purity_type,
  //       },
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future updatePurityStatus(
    String? purityId,
    bool status,
    String purity_type,
  ) async {
    try {
      // Build query parameters, only include id if it's not null
      final Map<String, dynamic> queryParams = {
        "status": status,
        "purity_type": purity_type,
      };

      // Only add id if it's provided
      if (purityId != null && purityId.isNotEmpty) {
        queryParams["id"] = purityId;
      }

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/update-purity-types-status",
        queryParameters: queryParams,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addPurityDetails(String purityTypeName, String displayName) async {
    try {
      // ignore: unused_local_variable
      // Map<String, dynamic> data = {
      //   "id": purityId,
      // };

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/update-purity-types-list",
        // queryParameters: data,
        data: jsonEncode({
          "settings": [
            {"purity_type_name": purityTypeName, "secondary_name": displayName},
          ],
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getStoneRates({
    int? nextPage,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (nextPage != null) {
      path = '/stone-rates?query=$query&limit=$limit&page=$nextPage';
    } else {
      path = '/stone-rates?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        path,
        // "/stone-rates",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addStoneRates(PostStoneRateRequest addStoneRatesRequest) async {
    try {
      final body = addStoneRatesRequest.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/stone-rate",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //  Future getStoneRates({
  //   String? offsetId,
  //   int limit = 10,
  //   String query = '',
  // }) async {
  //   String path;
  //   if (offsetId != null) {
  //     path = '/stone-rates?query=$query&limit=$limit&offset_id=$offsetId';
  //   } else {
  //     path = '/stone-rates?query=$query&limit=$limit';
  //   }
  //   try {
  //     final response = await _apiService.get(
  //       AppUrl.inventoryBaseUrl,
  //       path,
  //       // "/stone-rates",
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  //Stock head services

  Future getStockHeadById(String stockHeadId) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/stock-head/$stockHeadId",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future editStockHead(
    String stockHeadId,
    EditStockHeadRequest editStockHeadRequest,
  ) async {
    try {
      final body = editStockHeadRequest.toJson();

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/edit-stock-head/$stockHeadId",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getStockHeads({
    int? page,
    int? limit = 10,
    String? query = '',
    int? metal_type,
  }) async {
    String path;

    if (page != null) {
      path =
          '/stock-heads?query=$query&limit=$limit&page=$page&metal_type=${metal_type ?? ''}';
    } else {
      path =
          '/stock-heads?query=$query&limit=$limit&metal_type=${metal_type ?? ''}';
    }

    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getStockHeadsDropdown({
    int? page,
    int? limit = 10,
    String? query = '',
    int? metal_type,
  }) async {
    String path;

    if (page != null) {
      path =
          '/stock-heads-dropdown?query=$query&limit=$limit&page=$page&metal_type=${metal_type ?? ''}';
    } else {
      path =
          '/stock-heads-dropdown?query=$query&limit=$limit&metal_type=${metal_type ?? ''}';
    }

    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllStockHeads({String query = ""}) async {
    try {
      String url;
      if (query.isNotEmpty) {
        url = '/all-stock-heads?metal_type=$query';
      } else {
        url = "/all-stock-heads";
      }
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        url,
        queryParameters: {
          // 'query': query,
          // 'offset_id': uuid,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addStockHead(AddStockHeadRequest addStockRequest) async {
    try {
      final body = addStockRequest.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/stock-head",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getCategories() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/categories",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  // Future getCategories() async {
  //   try {
  //     final response = await _apiService.get(
  //       AppUrl.inventoryBaseUrl,
  //       "/categories",
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future getStockHeadMetalTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/stock-head-metal-types",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ornamnet services
  Future getOrnamentTypeById(String ornamentId) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/ornament/$ornamentId",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future editOrnamentType(
    String ornamentId,
    OrnamnetTypeValues ornamentType,
  ) async {
    try {
      final body = ornamentType.toJson();

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/editOrnament",
        queryParameters: {"id": ornamentId},
        data: jsonEncode(body), // Add the request body here
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getOrnamentTypes({String? metaltype}) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/all-ornaments",
        queryParameters: {"metal_type": metaltype},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addOrnamentType(OrnamnetTypeValues ornamentType) async {
    try {
      final body = ornamentType.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/ornament",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future codeAvailability(String code, String model) async {
    try {
      final body = {"code": code};
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/code-availability",
        data: jsonEncode(body),
        queryParameters: {"model": model},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getMetalTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/ornament-metal-types",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Design Services

  Future addDesignImages({required List<ImageRequestModel> images}) async {
    try {
      final Map<String, List<Map<String, dynamic>>> body;
      List<Map<String, dynamic>> imageData = [];
      for (var element in images) {
        imageData.add(element.toJson());
      }
      body = {"images": imageData};

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/design-presigned-url-save",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putDesignImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await _apiService.putUrlLink(
        putUrl,
        data: File(imagePath).readAsBytesSync(),
        options: Options(
          headers: {'Content-Type': lookupMimeType(imagePath).toString()},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addDesign({
    required PostDesignRequestModel postDesignRequestModel,
  }) async {
    try {
      final body = postDesignRequestModel.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/design",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPaginatedDesign({
    int? nextPage,
    int limit = 20,
    String query = '',
    String? metalType,
  }) async {
    String path;
    if (nextPage != null) {
      path =
          '/designs?query=$query&limit=$limit&page=$nextPage&metal_type=${metalType ?? ''}';
    } else {
      path = '/designs?query=$query&limit=$limit&metal_type=${metalType ?? ''}';
    }
    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDesignById({required String id}) async {
    String path = "/design/$id";

    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateDesign({
    required UpdateDesignRequestModel postDesignRequestModel,
    required String id,
  }) async {
    try {
      final body = postDesignRequestModel.toJson();

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        "/design?id=$id",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllDesign() async {
    String path = "/all-designs";

    try {
      log("The query will be $path");
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Purity Services
  Future getSelectedPurity() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/selected-purity-types",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSelectedPurityv2() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/v2/selected-purity-types",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllPurityTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/all-purity-types",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Tagged items Services
  Future getPaginatedTaggedItems({
    String? offsetId,
    int limit = 1,
    String query = '',
    GetPaginatedTaggedItemsRequest? requestBody,
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-tagging-records?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-tagging-records?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        path,
        data: jsonEncode(requestBody?.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDetailedTaggedItems({
    required String id,
    GetDetailedTaggingItemRequest? requestBody,
  }) async {
    String path = '/detailed-tagging-record/$id';

    try {
      log("Getting detailed tagged items with path: $path");
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        path,
        data:
            requestBody != null
                ? jsonEncode(requestBody.toJson())
                : jsonEncode({}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addTaggedItemsImages({required List<ImageRequestModel> images}) async {
    try {
      final Map<String, List<Map<String, dynamic>>> body;
      List<Map<String, dynamic>> imageData = [];
      for (var element in images) {
        imageData.add(element.toJson());
      }
      body = {"images": imageData};

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/tagged-item-presigned-url-save",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateTaggedItems({
    required UpdateTaggedItemsByIdRequest updateTaggedItemsByIdRequest,
    required String id,
  }) async {
    try {
      final body = updateTaggedItemsByIdRequest.toJson();

      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        // "/design?id=$id",
        "/tagging-record/$id",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Tagged Items report Services
  Future getPaginatedTaggedItemsReport({
    String? offsetId,
    int limit = 1,
    String query = '',
    required GetTaggedItemsReportRequest requestBody,
  }) async {
    String path;
    if (offsetId != null) {
      path = '/tagging-report?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/tagging-report?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        path,
        data: jsonEncode(requestBody.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPaginatedTaggedItemsReportLimited({
    String? offsetId,
    int limit = 100,
    String query = '',
    required GetTaggedItemsReportRequest requestBody,
  }) async {
    String path;
    if (offsetId != null && offsetId.isNotEmpty) {
      path =
          '/tagging-report-limited?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/tagging-report-limited?query=$query&limit=$limit';
    }
    try {
      log("API call - query: $query, offsetId: $offsetId, limit: $limit");
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        path,
        data: jsonEncode(requestBody.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPaginatedWantedList({
    String? offsetId,
    int limit = 10,
    String query = '',
    required GetWantedListRequest requestBody,
  }) async {
    String path;
    if (offsetId != null) {
      path = '/wanted-list?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/wanted-list?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.post(
        // AppUrl.localBaseUrl,
        // '/customer_details?_page=$page&_per_page=$limit&name=$search',
        AppUrl.inventoryBaseUrl,
        path,
        data: jsonEncode(requestBody.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Daily Rates Services
  Future getPaginatedDailyRates({
    String? startDate,
    String? endDate,
    String? offsetId,
    int limit = 100,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/daily-purity-rate?query=$query&limit=$limit&date_from=$startDate&date_to=$endDate&offset_id=$offsetId';
    } else {
      path =
          '/daily-purity-rate?query=$query&limit=$limit&date_from=$startDate&date_to=$endDate';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addDailyRates(PostDailyRatesRequest dailyRatesRequest) async {
    try {
      final body = dailyRatesRequest.toJson();

      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        "/daily-purity-rate",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getLatestDailyRate() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        "/get-latest-purity-rate",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  ///Todo Barcode Print
  Future<Uint8List> getBarCodePrint({required BarcodeModel detail}) async {
    Uint8List pdf = await BarcodeGenerator.instance.generateEBarcode(detail);

    return pdf;
  }

  Future getCounterWiseStockCount({required String dateFilter}) async {
    String path = "/counter-wise-stock-count";

    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        path,
        queryParameters: {"date_filter": dateFilter},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSelectedPurityTypesSegregated() async {
    String path = '/selected-purity-types-segregated';

    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllOrnamentsByMetalTypeAndPurity({
    required String metalType,
    required String purity,
  }) async {
    String path = '/all-ornaments?metal_type=$metalType&purity=$purity';

    try {
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteTaggingLineItems({required List<String> ids}) async {
    try {
      final response = await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/delete-tagging-line-item',
        data: jsonEncode(ids), // Send list of IDs directly as request body
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteTaggingRecords({
    required List<String> recordIds,
  }) async {
    try {
      final response = await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/delete-tagging-record',
        data: jsonEncode(recordIds),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> downloadAllDesignsCSV() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/all-designs/download-csv',
        options: Options(responseType: ResponseType.bytes),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPurityTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/all-purity-types-list',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Updated fetchLotEntries method in your API service
  Future fetchLotEntries({
    int? nextPage,
    int limit = 10,
    String query = '',
    GetLotEntriesRequest? filterRequest,
  }) async {
    // Create the request body
    final Map<String, dynamic> requestBody = {'limit': limit};

    // Add pagination
    if (nextPage != null) {
      requestBody['page'] = nextPage;
    }

    // Add search query
    if (query.isNotEmpty) {
      requestBody['query'] = query;
    }

    // Merge filter parameters if provided
    if (filterRequest != null) {
      final filterJson = filterRequest.toJson();
      // Remove null values to keep the request clean
      filterJson.removeWhere(
        (key, value) => value == null || (value is List && value.isEmpty),
      );
      requestBody.addAll(filterJson);
    }

    try {
      final response = await _apiService.post(
        AppUrl.aggregateBaseUrl,
        '/get-lot-entries-aggregated',
        data: requestBody,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createLotEntry({required CreateLotEntryRequest request}) async {
    try {
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        '/create-lot-entry',
        data: jsonEncode(request.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateLotEntry({
    required String id,
    required CreateLotEntryRequest request,
  }) async {
    try {
      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        '/update-lot-entry',
        data: jsonEncode(request.toJson()),
        queryParameters: {'id': id},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchLotEntryById({required String lotEntryId}) async {
    try {
      final response = await _apiService.get(
        AppUrl.aggregateBaseUrl,
        '/get-lot-entry-aggregated/$lotEntryId',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchLotEntriesDropdown({
    String query = '',
    int limit = 10,
    int page = 1,
  }) async {
    try {
      final path =
          '/get-lot-entries-dropdown-aggregated?query=$query&limit=$limit&page=$page';
      final response = await _apiService.get(AppUrl.aggregateBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future changeLotEntryStatus({
    required String lotEntryId,
    required String status,
  }) async {
    try {
      final response = await _apiService.put(
        AppUrl.inventoryBaseUrl,
        '/change-status-lot-entry/$lotEntryId?status=$status',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchLotTransactionTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/lot-transaction-type',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchMaterialDropdown({
    String query = '',
    int limit = 10,
    int page = 1,
  }) async {
    try {
      final path =
          '/get-material-in-dropdown?query=$query&limit=$limit&page=$page';
      final response = await _apiService.get(AppUrl.inventoryBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchPurchaseRecordDropdown({
    String query = '',
    int limit = 10,
    int page = 1,
  }) async {
    try {
      final path =
          '/all-purchase-record-dropdown-paginated?query=$query&limit=$limit&page=$page';
      final response = await _apiService.get(AppUrl.purchaseBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getChargeType() async {
    try {
      const path = '/making-charge-type';
      final response = await _apiService.get(AppUrl.purchaseBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMetalColor({
    required UpdateMetalColorRequest request,
  }) async {
    try {
      await _apiService.put(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item/metal-color',
        data: jsonEncode(request.toJson()),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCollection({
    required UpdateCollectionRequest request,
  }) async {
    try {
      await _apiService.put(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item/collection',
        data: jsonEncode(request.toJson()),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGender({required UpdateGenderRequest request}) async {
    try {
      await _apiService.put(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item/gender',
        data: jsonEncode(request.toJson()),
      );
    } catch (e) {
      rethrow;
    }
  }
}
