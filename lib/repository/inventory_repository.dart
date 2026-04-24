import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/approval_issue_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue_listing/model/get_approval_issue_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/model/approval_receipt_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/model/get_approval_issue_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/model/get_approval_record_by_approval_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt_listing/model/get_approval_receipt_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/approval_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_approval_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/model/get_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/view_approval_issue/model/get_approval_issue_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/view_approval_receipt/model/get_approval_receipt_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/get_daily_rate_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/models/post_daily_rates_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_selected_purity_segregated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/post_design_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_images_upload_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_post_response_models.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/update_design_request_models/update_design_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/model/edit_stock_head_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/model/get_stock_head_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/models/post_stone_rate_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/get_all_stock_head_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/get_design_by_stock_head_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/create_lot_entry_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_entries_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_entries_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_transaction_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/material_in_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_create/models/post_material_in_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_listing/model/get_material_in_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_view/model/get_material_in_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/models/post_material_out_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_listing/model/get_material_out_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_view/model/get_material_out_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_outstanding/model/get_material_outstanding_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/add_stock_issue/model/stock_issue_record_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/issues_stock_listing/model/get_stock_issue_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/view_stock_issue/model/get_stock_issue_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/wanted_list/model/get_wanted_list_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/wanted_list/model/get_wanted_list_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/get_deisgn_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_admin_report/model/get_admin_daily_stock_count_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/model/get_ornament_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/model/get_status_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/model/get_weight_group_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/models/save_stock_verification_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/cancelled_incvoice/model/get_cancelled_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/cancelled_incvoice/model/get_cancelled_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sequences_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/master_settings/model/purity_types_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/model/get_estimate_preference_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/model/get_sales_preference_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/model/get_tag_preference_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/estimate_print/get_estimate_print_template_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/sales_print/get_sales_print_template_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/tag_print/get_tag_print_template_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/model/tag_print/update_tag_print_template_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer/model/create_counter_transfer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/model/get_tagging_line_item_editing_history_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/edit_tagged_items/model/update_tagging_line_item_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/update_collection_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/update_gender_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/update_metal_color_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_detailed_tagging_item_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_paginated_tagged_items_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_paginated_tagged_items_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_tagged_item_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/update_tagged_item_by_id_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_limited_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_report_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/models/tagged_items_report_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/get_all_designs_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/get_default_counter_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/get_lot_entries_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/get_tag_and_code_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/post_tagging_line_item_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/post_tagging_line_item_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/tagging_record_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/catalog_images_presigned_url_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/create_catalogue_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/add_new_catalogue/model/get_catalogue_metal_color_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/catalogue/catalogue_listing/model/get_catalog_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/create_collection_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/get_designs_by_category_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/get_tagging_and_catalog_itmes_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/add_collection/model/get_tagging_and_catalogue_items_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/collection/collection_listing/model/get_collections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/edit_webstore_stock_by_id_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/get_stock_head_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/get_webstore_stock_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/model/webstore_stock_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/online_only_design_listing/model/webstore_stock_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/counter/counter_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/counter/counter_transfer_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/get_ornament_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/metal_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/add_stock_head_request.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response_v2.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/services/inventory_services.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/barcode_template/model/barcode_model.dart';

class InventoryRepository {
  final InventoryServices inventoryServices = InventoryServices();

  Future<dynamic> createWebstoreStock(
    WebstoreStockRequest createWebstoreStockRequest,
  ) async {
    try {
      final response = await inventoryServices.createWebstoreStock(
        createWebstoreStockRequest,
      );

      return response;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  Future<GetWebstoreStockByIdResponse> getWebstoreStockById(
    String webstoreStockId,
  ) async {
    try {
      final response = await inventoryServices.getWebstoreStockById(
        webstoreStockId,
      );
      return GetWebstoreStockByIdResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> editWebstoreStockById(
    EditWebstoreStockByIdRequest editWebstoreStockByIdRequest,
    String webstoreStockId,
  ) async {
    try {
      final response = await inventoryServices.editWebstoreStockById(
        editWebstoreStockByIdRequest,
        webstoreStockId,
      );

      return response;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  Future<void> deleteWebstoreStock(String webstoreStockId) async {
    try {
      await inventoryServices.deleteWebstoreStock(webstoreStockId);
    } catch (e) {
      rethrow;
    }
  }

  Future<WebstoreStockResponse> getOnlineDesignListing({
    int? nextPage,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getOnlineDesignListing(
      nextPage: nextPage,
      limit: limit,
      query: query,
    );
    final data = WebstoreStockResponse.fromJson(response);
    return data;
  }

  Future<GetDesignDropdownResponse> getDesignDropdown({
    int? page,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getDesignDropdown(
      page: page,
      limit: limit,
      query: query,
    );
    final data = GetDesignDropdownResponse.fromJson(response);
    return data;
  }

  Future<List<StatusItem>> getStatusDropdown() async {
    try {
      final response = await inventoryServices.getStatusDropdown();
      // Since the API returns a list directly, parse it accordingly
      final List<dynamic> jsonList = response as List<dynamic>;
      return jsonList.map((item) => StatusItem.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<GetTaggingLineItemResponse> getTaggingLineItem(
    String taggingId,
  ) async {
    try {
      final response = await inventoryServices.getTaggingLineItem(taggingId);
      return GetTaggingLineItemResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetTaggingLineItemEditHistoryResponse> getTaggingLineItemEditHistory(
    String taggingId,
  ) async {
    try {
      final response = await inventoryServices.getTaggingLineItemEditHistory(
        taggingId,
      );
      return GetTaggingLineItemEditHistoryResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> editTaggingLineItem(
    UpdateTaggingLineItemEditHistoryRequest editTaggingLineItemRequest,
    String taggingId,
  ) async {
    try {
      final response = await inventoryServices.editTaggingLineItem(
        editTaggingLineItemRequest,
        taggingId,
      );

      return response;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  Future<void> updateTaggedItemWebstoreStatus(
    String id,
    bool isWebstore,
  ) async {
    try {
      await inventoryServices.updateTaggedItemWebstoreStatus(id, isWebstore);
    } catch (e) {
      log("Error updating Estimate Preference: $e");
      rethrow;
    }
  }

  Future<ImagesUploadResponse> getTaggedItemImagesPresignedUrl({
    required List<ImageRequestModel> images,
    required String groupId,
  }) async {
    try {
      final response = await inventoryServices.getTaggedItemImagesPresignedUrl(
        images: images,
      );
      return ImagesUploadResponse.fromJson(response);
    } catch (e) {
      log('Error getting tagged item presigned URLs: $e');
      rethrow;
    }
  }

  Future<dynamic> updateTaggedItemImages({
    required String taggingLineItemId,
    required List<Map<String, dynamic>> images,
  }) async {
    try {
      final response = await inventoryServices.updateTaggedItemImages(
        taggingLineItemId: taggingLineItemId,
        images: images,
      );
      return response;
    } catch (e) {
      log('Error updating tagged item images: $e');
      rethrow;
    }
  }

  Future<GetSequencesDropdownResponse> getSequencesDropdown({
    required String? voucherType,
    required String? voucherSection,
  }) async {
    try {
      final response = await inventoryServices.getSequencesDropdown(
        voucherType: voucherType,
        voucherSection: voucherSection,
      );

      return GetSequencesDropdownResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  //preference apis

  Future<GetEstimatePreferenceResponse> getEstimatePreference() async {
    final response = await inventoryServices.getEstimatePreference();
    final data = GetEstimatePreferenceResponse.fromJson(response);
    return data;
  }

  Future<GetEstimatePreferenceResponse> updateEstimatePreference(
    GetEstimatePreferenceResponse updateEstimatePreferenceRequest,
  ) async {
    try {
      final response = await inventoryServices.updateEstimatePreference(
        updateEstimatePreferenceRequest,
      );
      return GetEstimatePreferenceResponse.fromJson(response);
    } catch (e) {
      log("Error updating Estimate Preference: $e");
      rethrow;
    }
  }

  Future<GetSalesPreferenceResponse> getSalesPreference() async {
    final response = await inventoryServices.getSalesPreference();
    final data = GetSalesPreferenceResponse.fromJson(response);
    return data;
  }

  Future<GetSalesPreferenceResponse> updateSalesPreference(
    GetSalesPreferenceResponse updateSalesPreferenceRequest,
  ) async {
    try {
      final response = await inventoryServices.updateSalesPreference(
        updateSalesPreferenceRequest,
      );
      return GetSalesPreferenceResponse.fromJson(response);
    } catch (e) {
      log("Error updating Sales Preference: $e");
      rethrow;
    }
  }

  Future<GetTagPreferenceResponse> getTagPreference() async {
    final response = await inventoryServices.getTagPreference();
    final data = GetTagPreferenceResponse.fromJson(response);
    return data;
  }

  Future<GetTagPreferenceResponse> updateTagPreference(
    GetTagPreferenceResponse updateTagPreferenceRequest,
  ) async {
    try {
      final response = await inventoryServices.updateTagPreference(
        updateTagPreferenceRequest,
      );
      return GetTagPreferenceResponse.fromJson(response);
    } catch (e) {
      log("Error updating Tag Preference: $e");
      rethrow;
    }
  }
  //print settings apis

  Future<List<GetSalesPrintTemplateResponse>>
  getAllSalesPrintTemplates() async {
    try {
      final response = await inventoryServices.getSalesPrintTemplate();

      // Check if response is a List
      if (response is List) {
        // Convert each item to GetSalesPrintTemplateResponse
        return response
            .map((item) => GetSalesPrintTemplateResponse.fromJson(item))
            .toList();
      } else if (response is Map<String, dynamic>) {
        // If it's a single object, wrap it in a list
        return [GetSalesPrintTemplateResponse.fromJson(response)];
      } else {
        // If response is empty or not valid
        log("Invalid response format: $response");
        throw Exception("Invalid response format received from API");
      }
    } catch (e) {
      log("Error getting Sales Print Templates: $e");
      rethrow;
    }
  }

  // Get a single template (keeping for backward compatibility)
  Future<GetSalesPrintTemplateResponse> getSalesPrintTemplate() async {
    try {
      final templates = await getAllSalesPrintTemplates();
      if (templates.isNotEmpty) {
        return templates.first;
      } else {
        throw Exception("No templates found in the response");
      }
    } catch (e) {
      log("Error getting Sales Print Template: $e");
      rethrow;
    }
  }

  // Update template
  Future<GetSalesPrintTemplateResponse> updateSalesPrintTemplate(
    GetSalesPrintTemplateResponse updateSalesPrintTemplateRequest,
  ) async {
    try {
      final response = await inventoryServices.updateSalesPrintTemplate(
        updateSalesPrintTemplateRequest,
      );

      // Handle possible list response
      if (response is List && response.isNotEmpty) {
        return GetSalesPrintTemplateResponse.fromJson(response[0]);
      } else if (response is Map<String, dynamic>) {
        return GetSalesPrintTemplateResponse.fromJson(response);
      } else {
        throw Exception("Invalid response format received from API");
      }
    } catch (e) {
      log("Error updating Sales Print Template: $e");
      rethrow;
    }
  }

  Future<GetEstimatePrintTemplateResponse> getEstimatePrintTemplate() async {
    final response = await inventoryServices.getEstimatePrintTemplate();
    final data = GetEstimatePrintTemplateResponse.fromJson(response);
    return data;
  }

  Future<GetEstimatePrintTemplateResponse> updateEstimatePrintTemplate(
    GetEstimatePrintTemplateResponse updateEstimatePrintTemplateRequest,
  ) async {
    try {
      final response = await inventoryServices.updateEstimatePrintTemplate(
        updateEstimatePrintTemplateRequest,
      );
      return GetEstimatePrintTemplateResponse.fromJson(response);
    } catch (e) {
      log("Error updating Estimate Print Template: $e");
      rethrow;
    }
  }

  Future<GetTagPrintTemplateResponse> getTagPrintTemplate() async {
    final response = await inventoryServices.getTagPrintTemplate();

    final data = GetTagPrintTemplateResponse.fromJson(response);
    return data;
  }

  Future<UpdateTagPrintTemplateRequest> updateTagPrintTemplate(
    UpdateTagPrintTemplateRequest updateTagPrintTemplateRequest,
  ) async {
    try {
      final response = await inventoryServices.updateTagPrintTemplate(
        updateTagPrintTemplateRequest,
      );
      return UpdateTagPrintTemplateRequest.fromJson(response);
    } catch (e) {
      log("Error editing Tag Print Template");
      rethrow;
    }
  }

  Future<GetWeightGroupDropdownResponse> getWeightGroupDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getWeightGroupDropdown(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetWeightGroupDropdownResponse.fromJson(response);
    return data;
  }

  Future<GetOrnamentDropdownResponse> getOrnamentDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getOrnamentDropdown(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetOrnamentDropdownResponse.fromJson(response);
    return data;
  }

  Future<GetApprovalIssueNumberResponse> getApprovalIssueNumber({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getApprovalIssueNumber(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetApprovalIssueNumberResponse.fromJson(response);
    return data;
  }

  Future<GetApprovalIssueByIdResponse> getApprovalIssueById({
    required String id,
  }) async {
    final response = await inventoryServices.getApprovalIssueById(id: id);

    final data = GetApprovalIssueByIdResponse.fromJson(response);
    return data;
  }

  Future<GetApprovalReceiptByIdResponse> getApprovalReceiptById({
    required String id,
  }) async {
    final response = await inventoryServices.getApprovalReceiptById(id: id);

    final data = GetApprovalReceiptByIdResponse.fromJson(response);
    return data;
  }

  Future<List<CategoriesResponse>> getInventoryCategories({
    bool is_webstore = false,
  }) async {
    final response = await inventoryServices.getInventoryCategories(
      is_webstore: is_webstore,
    );
    return (response as List)
        .map((item) => CategoriesResponse.fromJson(item))
        .toList();
  }

  Future<String> nextSequence({required String invoiceType}) async {
    final response = await inventoryServices.nextSequence(
      invoiceType: invoiceType,
    );
    return response["values"][0]["value"];
  }

  //Stock verification

  Future<dynamic> saveStockVerification(
    SaveStockVerificationRequest saveStockVerificationRequest,
  ) async {
    try {
      final response = await inventoryServices.saveStockVerification(
        saveStockVerificationRequest,
      );

      return response;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  //tagged item report

  Future<List<int>> downloadTaggedItemsReport({
    required Map<String, dynamic> requestBody,
    int limit = 10000,
  }) async {
    try {
      final response = await inventoryServices.downloadTaggedItemsReport(
        requestBody: requestBody,
        limit: limit,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Collection

  Future<void> deleteCollection(String collectionId) async {
    try {
      await inventoryServices.deleteCollection(collectionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetAllCollectionsResponse> getCollection() async {
    final response = await inventoryServices.getCollection();

    return GetAllCollectionsResponse.fromJson(response);
  }

  Future<dynamic> createCollection(
    CreateCollectionRequest createCollectionRequest,
  ) async {
    try {
      final response = await inventoryServices.createCollection(
        createCollectionRequest,
      );

      return response;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  Future<GetTaggingAndCatalogItemsReponse> getTaggingAndCatalogItems({
    List<String>? designIds,
    List<String>? webOnlyStockIds,
    List<String>? categoryIds,
  }) async {
    try {
      final getTaggingAndCatalogItemRequest = GetTaggingAndCatalogItemsRequest(
        designIds: designIds,
        webOnlyStockIds: webOnlyStockIds,
        categoryIds: categoryIds,
      );

      final response = await inventoryServices.getTaggingAndCatalogItems(
        getTaggingAndCatalogItemRequest,
      );
      return GetTaggingAndCatalogItemsReponse.fromJson(response);
    } catch (e) {
      log('Error fetching tagging and catalog items: $e');
      rethrow;
    }
  }

  Future<GetDesignByCategoryResponse> getDesignsByCategories(
    List<String> categoryIds,
  ) async {
    try {
      // Pass the category IDs directly to the service method
      final response = await inventoryServices.getDesignsByCategories(
        categoryIds,
      );
      return GetDesignByCategoryResponse.fromJson(response);
    } catch (e) {
      log('Error fetching designs by categories: $e');
      rethrow;
    }
  }

  //Catalougue

  Future<GetMaterialInByIdResponse> getCatalogueById({
    required String? id,
  }) async {
    try {
      final response = await inventoryServices.getCatalogueById(id: id);
      return GetMaterialInByIdResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCatalogue(String catalogId) async {
    try {
      await deleteCatalogues([catalogId]);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteCatalogues(List<String> catalogIds) async {
    try {
      await inventoryServices.deleteCatalogue(catalogIds);
    } catch (e) {
      log('Error deleting catalogues: $e');
      rethrow;
    }
  }

  Future<CatalogImagesPresignedUrlRequest> catalogImagePresignedUrl(
    CatalogImagesPresignedUrlRequest request,
  ) async {
    try {
      final response = await inventoryServices.catalogImagePresignedUrl(
        request,
      );
      return CatalogImagesPresignedUrlRequest.fromJson(response);
    } catch (e) {
      log('Error getting catalog presigned URL: $e');
      rethrow;
    }
  }

  Future putCatalogImages({
    required String putUrl,
    required String imagePath,
  }) async {
    try {
      final response = await inventoryServices.putCatalogImages(
        putUrl: putUrl,
        imagePath: imagePath,
      );
      return response;
    } catch (e) {
      log('Error uploading image to S3: $e');
      rethrow;
    }
  }

  Future<dynamic> createCatalogue(
    CreateCatalogueRequest createCatalogueRequest,
  ) async {
    try {
      final response = await inventoryServices.createCatalogue(
        createCatalogueRequest,
      );

      return response;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  Future<dynamic> editCatalogue(
    CreateCatalogueRequest createCatalogueRequest,
    String catalogId,
  ) async {
    try {
      final response = await inventoryServices.editCatalogue(
        createCatalogueRequest,
        catalogId,
      );

      return response;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  Future<List<GetCatalogMetalColorResponse>> getCatlogMetaColor() async {
    final response = await inventoryServices.getCatlogMetaColor();

    if (response is List) {
      return response
          .map<GetCatalogMetalColorResponse>(
            (item) => GetCatalogMetalColorResponse.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } else {
      final singleItem = GetCatalogMetalColorResponse.fromJson(
        response as Map<String, dynamic>,
      );
      return [singleItem];
    }
  }

  Future<GetCatalogueListingResponse> getCatalogueListing({
    int? nextPage,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getCatalogueListing(
      nextPage: nextPage,
      limit: limit,
      query: query,
    );
    final data = GetCatalogueListingResponse.fromJson(response);
    return data;
  }

  Future<void> deleteDesign(String ornamentId) async {
    try {
      await inventoryServices.deleteDesign(ornamentId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteStockHead(String ornamentId) async {
    try {
      await inventoryServices.deleteStockHead(ornamentId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOrnament(String ornamentId) async {
    try {
      await inventoryServices.deleteOrnament(ornamentId);
    } catch (e) {
      rethrow;
    }
  }

  //Orders

  Future<GetTaggingLineItemCodeTagResponse> getByExistingTag(String tag) async {
    final response = await inventoryServices.getByExistingTag(tag);

    return GetTaggingLineItemCodeTagResponse.fromJson(response);
  }

  //Jewellery Plan

  Future<GetDesignByStockHeadIdResponse> getDesignByStockHeadId(
    String stock_id,
  ) async {
    final response = await inventoryServices.getDesignByStockHeadId(stock_id);
    return GetDesignByStockHeadIdResponse.fromJson(response);
  }

  // //Material In Out
  //   Future<MaterialInRequestModel> addMaterialIn(
  //       MaterialInRequestModel materialInRequest) async {
  //     final response = await inventoryServices.addMaterialIn(materialInRequest);

  //     return MaterialInRequestModel.fromJson(response);
  //   }

  //Material In Out

  Future<GetMaterialInByIdResponse> getMaterialInById({
    required String? id,
  }) async {
    try {
      final response = await inventoryServices.getMaterialInById(id: id);
      return GetMaterialInByIdResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetMaterialOutByIdResponse> getMaterialOutById({
    required String? id,
  }) async {
    try {
      final response = await inventoryServices.getMaterialOutById(id: id);
      return GetMaterialOutByIdResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<MaterialInRequestModel> addMaterialIn(
    MaterialInRequestModel materialInRequest,
  ) async {
    final response = await inventoryServices.addMaterialIn(materialInRequest);

    return MaterialInRequestModel.fromJson(response);
  }

  Future<MaterialOutRequestModel> addMaterialOut(
    MaterialOutRequestModel materialOutRequest,
  ) async {
    final response = await inventoryServices.addMaterialOut(materialOutRequest);

    return MaterialOutRequestModel.fromJson(response);
  }

  Future<void> cancelMaterialInRecord(String recordId) async {
    try {
      await inventoryServices.cancelMaterialInRecord(recordId);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetMaterialInListingResponse> getMaterialInListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getMaterialInListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetMaterialInListingResponse.fromJson(response);
    return data;
  }

  Future<void> cancelMaterialOutRecord(String recordId) async {
    try {
      await inventoryServices.cancelMaterialOutRecord(recordId);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetMaterialOutListingResponse> getMaterialOutListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getMaterialOutListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetMaterialOutListingResponse.fromJson(response);
    return data;
  }

  Future<GetMaterialOutstandingListingResponse> getMaterialOutstandingListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getMaterialOutstandingListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetMaterialOutstandingListingResponse.fromJson(response);
    return data;
  }

  //Stock Issue

  Future<GetStockIssueByIdResponse> getStockIssueById({
    required String id,
  }) async {
    final response = await inventoryServices.getStockIssueById(id: id);

    final data = GetStockIssueByIdResponse.fromJson(response);
    return data;
  }

  Future<Map<String, dynamic>> submitStockIssueRecord(
    StockIssueRecordRequest stockIssueRecordRequest,
  ) async {
    try {
      final response = await inventoryServices.submitStockIssueRecord(
        stockIssueRecordRequest,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> stockIssueNumber() async {
    final response = await inventoryServices.stockIssueNumber();
    return response["values"][0]["value"];
  }

  Future<void> cancelStockIssueRecord(String recordId) async {
    try {
      await inventoryServices.cancelStockIssueRecord(recordId);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetStockIssueListingResponse> getStockIssueListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getStockIssueListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetStockIssueListingResponse.fromJson(response);
    return data;
  }

  //Approval flow

  Future<GetApprovalRecordByApprovalNumberResponse>
  getApprovalRecordByApprovalNumber(String approval_number) async {
    final response = await inventoryServices.getApprovalRecordByApprovalNumber(
      approval_number,
    );
    return GetApprovalRecordByApprovalNumberResponse.fromJson(response);
  }

  Future<ApprovalIssueRecordRequest> submitApprovalIssueRecord(
    ApprovalIssueRecordRequest approvalIssueRecordRequest,
  ) async {
    final response = await inventoryServices.submitApprovalIssueRecord(
      approvalIssueRecordRequest,
    );
    return ApprovalIssueRecordRequest.fromJson(response);
  }

  Future<ApprovalReceiptRecordRequest> submitApprovalReceiptRecord(
    ApprovalReceiptRecordRequest approvalReceiptRecordRequest,
  ) async {
    try {
      final response = await inventoryServices.submitApprovalReceiptRecord(
        approvalReceiptRecordRequest,
      );

      // Handle the response directly without using fromJson
      return ApprovalReceiptRecordRequest(
        partyId: response["party_id"],
        partyType: response["party_type"],
        receiptDate: response["receipt_date"], // Keep as string
        remarks: response["remarks"],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> approvalReceiptNumber() async {
    final response = await inventoryServices.approvalReceiptNumber();
    return response["values"][0]["value"];
  }

  Future<GetApprovalIssueListingResponse> getApprovalIssueListing({
    String? page,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getApprovalIssueListing(
      offsetId: page,
      limit: limit,
      query: query,
    );
    final data = GetApprovalIssueListingResponse.fromJson(response);
    return data;
  }

  Future<GetApprovalReceiptListingResponse> getApprovalReceiptListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getApprovalReceiptListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetApprovalReceiptListingResponse.fromJson(response);
    return data;
  }

  // In inventory_repository.dart
  Future<GetApprovalListingResponse> getApprovalListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    ApprovalListingRequest? filterRequest,
  }) async {
    final response = await inventoryServices.getApprovalListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
      filterRequest: filterRequest,
    );
    final data = GetApprovalListingResponse.fromJson(response);
    return data;
  }

  Future<GetCancelReportResponse> getCancelledInvoiceListing({
    String? offsetId,
    int limit = 10,
    String query = '',
    GetCancelReportRequest? filterRequest,
  }) async {
    final response = await inventoryServices.getCancelledInvoiceListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
      filterRequest: filterRequest,
    );
    final data = GetCancelReportResponse.fromJson(response);
    return data;
  }

  Future<String> approvalIssueNumber() async {
    final response = await inventoryServices.approvalIssueNumber();
    return response["values"][0]["value"];
  }

  Future<GetTaggingLineItemCodeTagResponse> getTaggingLineItemByBarcode(
    String tagBarcode,
  ) async {
    final response = await inventoryServices.getTaggingLineItemByBarcode(
      tagBarcode,
    );
    return GetTaggingLineItemCodeTagResponse.fromJson(response);
  }

  Future<GetTaggingLineItemCodeTagResponse> getTaggingLineItemCodeTag(
    String code,
    int? tag_number, {
    int? metal_type_id,
  }) async {
    final response = await inventoryServices.getTaggingLineItemCodeTag(
      code,
      tag_number,
      metal_type_id: metal_type_id,
    );

    return GetTaggingLineItemCodeTagResponse.fromJson(response);
  }

  Future<void> postTaggingLineItemReTag(String taggingLineItemId) async {
    final response = await inventoryServices.postTaggingLineItemReTag(
      taggingLineItemId,
    );

    return response;
  }

  Future<GetTaggingLineItemCodeTagResponse> getTaggingLineItemCodeTagSales(
    String code,
    int? tag_number, {
    String? customer_id,
    int? metal_type_id,
  }) async {
    final response = await inventoryServices.getTaggingLineItemCodeTagSales(
      code,
      tag_number,
      customer_id: customer_id,
      metal_type_id: metal_type_id,
    );

    return GetTaggingLineItemCodeTagResponse.fromJson(response);
  }

  //tagging

  Future<GetDefaultCounterResponse> getDefaultCounter() async {
    final response = await inventoryServices.getDefaultCounter();

    return GetDefaultCounterResponse.fromJson(response);
  }

  Future<String> taggingRecordNumber() async {
    final response = await inventoryServices.taggingRecordNumber();
    return response["values"][0]["value"];
  }

  Future<GetTagAndCodeResponse> getTagAndCode(
    String designId,
    double grossWeight,
    double netWeight,
  ) async {
    final response = await inventoryServices.getTagAndCode(
      designId,
      grossWeight,
      netWeight,
    );
    return GetTagAndCodeResponse.fromJson(response);
  }

  Future<TaggingRecordRequest> taggingRecord(
    TaggingRecordRequest taggingRecordRequest,
  ) async {
    final response = await inventoryServices.taggingRecord(
      taggingRecordRequest,
    );
    return TaggingRecordRequest.fromJson(response);
  }

  Future<PostTaggingLineItemResponse> postTaggingLineItem(
    PostTaggingLineItemRequest taggingRecordRequest,
  ) async {
    final response = await inventoryServices.postTaggingLineItem(
      taggingRecordRequest,
    );
    return PostTaggingLineItemResponse.fromJson(response);
  }

  Future<GetAllDesignsResponse> getAllDesigns() async {
    final response = await inventoryServices.getAllDesigns();

    return GetAllDesignsResponse.fromJson(response);
  }

  Future<GetAllOrnamentsResponse> getAllOrnaments({
    bool? isStone,
    bool? isOldGold,
    bool? isService,
  }) async {
    final response = await inventoryServices.getAllOrnaments(
      isOldGold: isOldGold,
      isService: isService,
      isStone: isStone,
    );

    return GetAllOrnamentsResponse.fromJson(response);
  }

  //counter
  Future<CounterResponse> getCounterListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getCounterListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = CounterResponse.fromJson(response);
    return data;
  }

  Future<CounterValue> addCounter(CounterValue addCounter) async {
    final response = await inventoryServices.addCounter(addCounter);
    return CounterValue.fromJson(response);
  }

  //counter transfer lsiting

  Future<void> cancelCounterTransfer(String counter_transfer_id) async {
    try {
      await inventoryServices.cancelCounterTransfer(counter_transfer_id);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateCounterTransferRequest> createCounterTransfer(
    CreateCounterTransferRequest create_counter_transfer_request,
  ) async {
    final response = await inventoryServices.createCounterTransfer(
      create_counter_transfer_request,
    );
    return CreateCounterTransferRequest.fromJson(response);
  }

  Future<CounterTransferListingResponse> getCounterTransferListing({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getCounterTransferListing(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = CounterTransferListingResponse.fromJson(response);
    return data;
  }

  //Stone Rates repo

  Future<GetStoneRatesValue> getStoneRateeById(String stoneRateId) async {
    final response = await inventoryServices.getStoneRateeById(stoneRateId);
    return GetStoneRatesValue.fromJson(response);
  }

  Future<GetStoneRatesValue> editStoneRate(
    String stoneRateId,
    PostStoneRateRequest editStoneRatesRequest,
  ) async {
    try {
      final response = await inventoryServices.editStoneRate(
        stoneRateId,
        editStoneRatesRequest,
      );
      return GetStoneRatesValue.fromJson(response);
    } catch (e) {
      log("Error editing Stone Rate");
      rethrow;
    }
  }

  Future<GetStoneRatesResponse> getStoneRates({
    int? nextPage,
    int limit = 10,
    String query = '',
  }) async {
    final response = await inventoryServices.getStoneRates(
      nextPage: nextPage,
      limit: limit,
      query: query,
    );
    final data = GetStoneRatesResponse.fromJson(response);
    return data;
  }

  Future<GetStoneRatesValue> addStoneRates(
    PostStoneRateRequest addStoneRatesRequest,
  ) async {
    final response = await inventoryServices.addStoneRates(
      addStoneRatesRequest,
    );
    return GetStoneRatesValue.fromJson(response);
  }

  //Stock Head repos

  Future<EditStockHeadRequest> editStockHead(
    String stockHeadId,
    EditStockHeadRequest editStockHeadRequest,
  ) async {
    try {
      final response = await inventoryServices.editStockHead(
        stockHeadId,
        editStockHeadRequest,
      );
      return EditStockHeadRequest.fromJson(response);
    } catch (e) {
      log("Error editing Stock Head");
      rethrow;
    }
  }

  Future<StockHeadResponse> getStockHeads({
    int? page,
    int limit = 10,
    String query = '',
    int? metal_type,
  }) async {
    final response = await inventoryServices.getStockHeads(
      page: page,
      limit: limit,
      query: query,
      metal_type: metal_type,
    );
    final data = StockHeadResponse.fromJson(response);
    return data;
  }

  Future<GetStockHeadDropdownResponse> getStockHeadsDropdown({
    int? page,
    int limit = 10,
    String query = '',
    int? metal_type,
  }) async {
    final response = await inventoryServices.getStockHeadsDropdown(
      page: page,
      limit: limit,
      query: query,
      metal_type: metal_type,
    );
    final data = GetStockHeadDropdownResponse.fromJson(response);
    return data;
  }

  Future<GetStockHeadById> getStockHeadById(String stockHeadId) async {
    final response = await inventoryServices.getStockHeadById(stockHeadId);
    return GetStockHeadById.fromJson(response);
  }

  Future<GetAllStockHeadsResponse> getAllStockHeads({String query = ""}) async {
    final response = await inventoryServices.getAllStockHeads(query: query);
    return GetAllStockHeadsResponse.fromJson(response);
  }

  Future<AddStockHeadRequest> addStockHead(
    AddStockHeadRequest addStockRequest,
  ) async {
    final response = await inventoryServices.addStockHead(addStockRequest);
    return AddStockHeadRequest.fromJson(response);
  }

  Future<List<CategoriesResponse>> getCategories() async {
    final response = await inventoryServices.getCategories();
    return (response as List)
        .map((item) => CategoriesResponse.fromJson(item))
        .toList();
  }

  Future<List<StockHeadMetalTypesResponse>> getStockHeadMetalTypes() async {
    final response = await inventoryServices.getStockHeadMetalTypes();
    return (response as List)
        .map((item) => StockHeadMetalTypesResponse.fromJson(item))
        .toList();
  }

  //Ornament types

  Future<OrnamnetTypeValues> getOrnamentTypeById(String ornamentId) async {
    final response = await inventoryServices.getOrnamentTypeById(ornamentId);
    return OrnamnetTypeValues.fromJson(response);
  }

  Future<OrnamnetTypeValues> editOrnament(
    String ornamentId,
    OrnamnetTypeValues ornamentType,
  ) async {
    try {
      final response = await inventoryServices.editOrnamentType(
        ornamentId,
        ornamentType,
      );
      return OrnamnetTypeValues.fromJson(response);
    } catch (e) {
      log("Error editing Ornament Type");
      rethrow;
    }
  }

  Future<OrnamentTypeResponse> getOrnamentType({String? metal_type}) async {
    final response = await inventoryServices.getOrnamentTypes(
      metaltype: metal_type,
    );
    log("The type is : ${response.runtimeType}");
    return OrnamentTypeResponse.fromJson(response);
  }

  Future<OrnamnetTypeValues> addOrnamnetType(
    OrnamnetTypeValues ornamentType,
  ) async {
    final response = await inventoryServices.addOrnamentType(ornamentType);
    return OrnamnetTypeValues.fromJson(response);
  }

  Future<bool> validateCode(String code, String model) async {
    final response = await inventoryServices.codeAvailability(code, model);
    return response["is_unique"] ?? false;
  }

  Future<List<MetalTypeResponse>> getMetalTypes() async {
    final response = await inventoryServices.getMetalTypes();
    return (response as List)
        .map((item) => MetalTypeResponse.fromJson(item))
        .toList();
  }

  // Design repos
  Future<PostDesignResponseModel> addDesign({
    required PostDesignRequestModel postDesignRequestModel,
  }) async {
    final response = await inventoryServices.addDesign(
      postDesignRequestModel: postDesignRequestModel,
    );
    return PostDesignResponseModel.fromJson(response);
  }

  Future<PaginatedDesignListingResponse> getPaginatedDesign({
    int? nextPage,
    int limit = 20,
    String query = '',
    String? metalType,
  }) async {
    final response = await inventoryServices.getPaginatedDesign(
      nextPage: nextPage,
      limit: limit,
      query: query,
      metalType: metalType,
    );

    final data = PaginatedDesignListingResponse.fromJson(response);
    return data;
  }

  Future<GetDesignResponseModel> getDesignById({required String id}) async {
    final response = await inventoryServices.getDesignById(id: id);

    final data = GetDesignResponseModel.fromJson(response);
    return data;
  }

  Future<PostDesignResponseModel> updateDesign({
    required UpdateDesignRequestModel postDesignRequestModel,
    required String id,
  }) async {
    final response = await inventoryServices.updateDesign(
      postDesignRequestModel: postDesignRequestModel,
      id: id,
    );
    return PostDesignResponseModel.fromJson(response);
  }

  Future<ImagesUploadResponse> addDesignImages({
    required List<ImageRequestModel> images,
  }) async {
    final response = await inventoryServices.addDesignImages(images: images);
    return ImagesUploadResponse.fromJson(response);
  }

  Future putDesignImages({
    required String putUrl,
    required String imagePath,
  }) async {
    final response = await inventoryServices.putDesignImages(
      putUrl: putUrl,
      imagePath: imagePath,
    );
    return response;
  }

  Future<PaginatedDesignListingResponse> getAllDesign() async {
    final response = await inventoryServices.getAllDesign();

    final data = PaginatedDesignListingResponse.fromJson(response);
    return data;
  }

  // Purity repos
  Future<GetPurityResponse> getSelectedPurity() async {
    final response = await inventoryServices.getSelectedPurity();

    return GetPurityResponse.fromJson(response);
  }

  Future<GetPurityResponseV2> getSelectedPurityv2() async {
    final response = await inventoryServices.getSelectedPurityv2();

    return GetPurityResponseV2.fromJson(response);
  }

  Future<GetPurityResponse> getAllPurityTypes() async {
    final response = await inventoryServices.getAllPurityTypes();

    return GetPurityResponse.fromJson(response);
  }

  // Tagged items Repos
  Future<PaginatedGetTaggedItemsResponse> getPaginatedTaggedItems({
    String? offsetId,
    int limit = 1,
    String query = '',
    GetPaginatedTaggedItemsRequest? requestBody,
  }) async {
    log("The query will be r $query");
    final response = await inventoryServices.getPaginatedTaggedItems(
      offsetId: offsetId,
      limit: limit,
      query: query,
      requestBody: requestBody,
    );

    final data = PaginatedGetTaggedItemsResponse.fromJson(response);
    return data;
  }

  Future<GetTaggedItemsByIdResponse> getDetailedTaggedItems({
    required String id,
    GetDetailedTaggingItemRequest? requestBody,
  }) async {
    log("Getting detailed tagged items with filters");
    final response = await inventoryServices.getDetailedTaggedItems(
      id: id,
      requestBody: requestBody,
    );

    final data = GetTaggedItemsByIdResponse.fromJson(response);
    return data;
  }

  Future<ImagesUploadResponse> addTaggedItemsImages({
    required List<ImageRequestModel> images,
  }) async {
    final response = await inventoryServices.addTaggedItemsImages(
      images: images,
    );
    return ImagesUploadResponse.fromJson(response);
  }

  Future<GetTaggedItemsByIdResponse> updateTaggedItems({
    required UpdateTaggedItemsByIdRequest updateTaggedItemsByIdRequest,
    required String id,
  }) async {
    final response = await inventoryServices.updateTaggedItems(
      updateTaggedItemsByIdRequest: updateTaggedItemsByIdRequest,
      id: id,
    );
    return GetTaggedItemsByIdResponse.fromJson(response);
  }

  // Tagged items report repository
  Future<GetTaggedItemsReportResponse> getPaginatedTaggedItemsReport({
    String? offsetId,
    int limit = 1,
    String query = '',
    required GetTaggedItemsReportRequest requestBody,
  }) async {
    log("The query will be r $query");
    final response = await inventoryServices.getPaginatedTaggedItemsReport(
      offsetId: offsetId,
      limit: limit,
      query: query,
      requestBody: requestBody,
    );

    final data = GetTaggedItemsReportResponse.fromJson(response);
    return data;
  }

  Future<GetTaggedItemsReportLimitedResponse>
  getPaginatedTaggedItemsReportLimited({
    String? offsetId,
    int limit = 100,
    String query = '',
    required GetTaggedItemsReportRequest requestBody,
  }) async {
    log("The query will be r $query");
    final response = await inventoryServices
        .getPaginatedTaggedItemsReportLimited(
          offsetId: offsetId,
          limit: limit,
          query: query,
          requestBody: requestBody,
        );

    final data = GetTaggedItemsReportLimitedResponse.fromJson(response);
    return data;
  }

  Future<GetWantedListResponse> getPaginatedWantedList({
    String? offsetId,
    int limit = 1,
    String query = '',
    required GetWantedListRequest requestBody,
  }) async {
    log("The query will be r $query");
    final response = await inventoryServices.getPaginatedWantedList(
      offsetId: offsetId,
      limit: limit,
      query: query,
      requestBody: requestBody,
    );

    final data = GetWantedListResponse.fromJson(response);
    return data;
  }

  // Daily Rates repository
  Future<GetPaginatedDailyRatesResponse> getPaginatedDailyRates({
    String? offsetId,
    String? startDate,
    String? endDate,
    int limit = 100,
    String query = '',
  }) async {
    log("The query will be r $query");
    final response = await inventoryServices.getPaginatedDailyRates(
      offsetId: offsetId,
      endDate: endDate,
      startDate: startDate,
      limit: limit,
      query: query,
    );

    final data = GetPaginatedDailyRatesResponse.fromJson(response);
    return data;
  }

  Future<DailyRateResponse> addDailyRates(
    PostDailyRatesRequest dailyRatesRequest,
  ) async {
    final response = await inventoryServices.addDailyRates(dailyRatesRequest);
    return DailyRateResponse.fromJson(response);
  }

  Future<DailyRateResponse> getLatestDailyRate() async {
    final response = await inventoryServices.getLatestDailyRate();
    return DailyRateResponse.fromJson(response);
  }

  ///Todo Barcode Print
  Future<Uint8List> getBarCodePrint({required BarcodeModel detail}) async {
    return await inventoryServices.getBarCodePrint(detail: detail);
  }

  Future<GetAdminDailyStockCountResponse> getCounterWiseStockCount({
    required String dateFilter,
  }) async {
    final response = await inventoryServices.getCounterWiseStockCount(
      dateFilter: dateFilter,
    );

    final data = GetAdminDailyStockCountResponse.fromJson(response);
    return data;
  }

  Future<GetSelectedPuritySegregatedResponse>
  getSelectedPurityTypesSegregated() async {
    final response = await inventoryServices.getSelectedPurityTypesSegregated();
    final data = GetSelectedPuritySegregatedResponse.fromJson(response);
    return data;
  }

  Future<GetAllOrnamentsResponse> getAllOrnamentsByMetalTypeAndPurity({
    required String metalType,
    required String purity,
  }) async {
    final response = await inventoryServices
        .getAllOrnamentsByMetalTypeAndPurity(
          metalType: metalType,
          purity: purity,
        );
    final data = GetAllOrnamentsResponse.fromJson(response);
    return data;
  }

  Future<bool> deleteTaggingLineItems({required List<String> ids}) async {
    try {
      await inventoryServices.deleteTaggingLineItems(ids: ids);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteTaggingRecords({required List<String> recordIds}) async {
    try {
      await inventoryServices.deleteTaggingRecords(recordIds: recordIds);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> downloadAllDesignsCSV() async {
    final response = await inventoryServices.downloadAllDesignsCSV();
    return response;
  }

  Future<PurityData> getVendorTypes() async {
    final response = await inventoryServices.getPurityTypes();
    log("The response is : $response");
    return PurityData.fromJson(response);
  }

  Future<bool> updatePurityStatus(
    String? purityId,
    bool status,
    String purity_type,
  ) async {
    final response = await inventoryServices.updatePurityStatus(
      purityId,
      status,
      purity_type,
    );
    log("The response is : $response");
    // if (["successfully"].contains(response["message"])) {
    //   return ["successfully"].contains(response["message"]);
    // } else {
    //   return false;
    // }
    return true;
  }

  Future<bool> updatePurityAndDisplayName(
    String purityTypeName,
    String displayName,
  ) async {
    final response = await inventoryServices.addPurityDetails(
      purityTypeName,
      displayName,
    );
    log("The response is : $response");
    if (["successfully"].contains(response["message"])) {
      return ["successfully"].contains(response["message"]);
    } else {
      return false;
    }
  }

  // Updated repository method
  Future<GetLotEntriesResponse> getLotEntries({
    int? nextPage,
    int limit = 10,
    String query = '',
    GetLotEntriesRequest? filterRequest,
  }) async {
    final response = await inventoryServices.fetchLotEntries(
      nextPage: nextPage,
      limit: limit,
      query: query,
      filterRequest: filterRequest,
    );
    final data = GetLotEntriesResponse.fromJson(response);
    return data;
  }

  Future<GetLotEntriesValue> createLotEntry(
    CreateLotEntryRequest request,
  ) async {
    final response = await inventoryServices.createLotEntry(request: request);
    final data = GetLotEntriesValue.fromJson(response);
    return data;
  }

  Future<GetLotEntriesValue> updateLotEntry({
    required String id,
    required CreateLotEntryRequest request,
  }) async {
    final response = await inventoryServices.updateLotEntry(
      id: id,
      request: request,
    );
    final data = GetLotEntriesValue.fromJson(response);
    return data;
  }

  Future<GetLotEntriesByIdResponse> fetchLotEntryById({
    required String lotEntryId,
  }) async {
    final response = await inventoryServices.fetchLotEntryById(
      lotEntryId: lotEntryId,
    );
    final data = GetLotEntriesByIdResponse.fromJson(response);
    return data;
  }

  Future<GetLotEntriesDropdownResponse> fetchLotEntriesDropdown({
    String query = '',
    int limit = 10,
    int page = 1,
  }) async {
    final response = await inventoryServices.fetchLotEntriesDropdown(
      query: query,
      limit: limit,
      page: page,
    );
    final data = GetLotEntriesDropdownResponse.fromJson(response);
    return data;
  }

  Future<void> changeLotEntryStatus({
    required String lotEntryId,
    required String status,
  }) async {
    await inventoryServices.changeLotEntryStatus(
      lotEntryId: lotEntryId,
      status: status,
    );
    return;
  }

  Future<List<LotTransactionTypesResponse>> fetchLotTransactionTypes() async {
    final response = await inventoryServices.fetchLotTransactionTypes();
    return (response as List)
        .map((item) => LotTransactionTypesResponse.fromJson(item))
        .toList();
  }

  Future<InvoiceNumberResponse> fetchMaterialDropdown({
    String query = '',
    int limit = 10,
    int page = 1,
  }) async {
    final response = await inventoryServices.fetchMaterialDropdown(
      query: query,
      limit: limit,
      page: page,
    );
    final data = InvoiceNumberResponse.fromJson(response);
    return data;
  }

  Future<InvoiceNumberResponse> fetchPurchaseRecordDropdown({
    String query = '',
    int limit = 10,
    int page = 1,
  }) async {
    final response = await inventoryServices.fetchPurchaseRecordDropdown(
      query: query,
      limit: limit,
      page: page,
    );
    final data = InvoiceNumberResponse.fromJson(response);
    return data;
  }

  Future<GetApprovalReceiptByIdResponse> getChargeType({
    required String id,
  }) async {
    final response = await inventoryServices.getChargeType();

    final data = GetApprovalReceiptByIdResponse.fromJson(response);
    return data;
  }

  Future<void> updateMetalColor({
    required UpdateMetalColorRequest request,
  }) async {
    await inventoryServices.updateMetalColor(request: request);
  }

  Future<void> updateCollection({
    required UpdateCollectionRequest request,
  }) async {
    await inventoryServices.updateCollection(request: request);
  }

  Future<void> updateGender({required UpdateGenderRequest request}) async {
    await inventoryServices.updateGender(request: request);
  }
}
