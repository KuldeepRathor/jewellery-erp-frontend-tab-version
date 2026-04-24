import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/create_vendor_poc_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/get_paginated_vedor_poc_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/model/get_vendor_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/add_vendor_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_ledger_list_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_types_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/gst_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/pincode_response.dart';
import 'package:jewellery_erp_frontend_tab_version/services/vendor_services.dart';

import '../feature/vendor/vendor_listing/models/pagination_response.dart';

class VendorRepository {
  final VendorServices vendorServices = Get.find();

  Future<GetVendorDropdownResponse> getVendorDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await vendorServices.getVendorDropdown(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetVendorDropdownResponse.fromJson(response);
    return data;
  }

  Future<bool> gst_phone_number_availability(
    String type_value,
    String type,
  ) async {
    final response = await vendorServices.gst_phone_number_availability(
      type_value,
      type,
    );
    return response["is_available"] ?? false;
  }

  Future<VendorTypesResponse> getVendorTypes() async {
    final response = await vendorServices.getVendorTypes();
    log("The response is : $response");
    return VendorTypesResponse.fromJson(response);
  }

  Future<LedgerItemsResponse> getLedgerItems() async {
    final response = await vendorServices.getLedgerItems();
    log("The response is : $response");
    return LedgerItemsResponse.fromJson(response);
  }

  Future<bool> validateCode(String code) async {
    final response = await vendorServices.validateCode(code);
    return response["is_available"] ?? false;
  }

  Future<PincodeResponse?> getCityFromPincode(String pincode) async {
    try {
      final response = await vendorServices.getCityFromPincode(pincode);
      if (response is Map<String, dynamic>) {
        return PincodeResponse.fromJson(response);
      }
      return null;
    } catch (e) {
      log("Error fetching details from pincode: $e");
      return null;
    }
  }

  Future<AddVendorRequestResponse> addVendor(
    AddVendorRequestResponse vendorData,
  ) async {
    final response = await vendorServices.addVendor(vendorData);
    log("The type is : ${response["id"].runtimeType}");
    return AddVendorRequestResponse.fromJson(response);
  }

  // Future<AddVendorRequestResponse> getVendor(String query) async {
  //   final response = await addVendorServices.getVendor(query);
  //   log("The type is : ${response["id"].runtimeType}");
  //   return AddVendorRequestResponse.fromJson(response);
  // }

  Future<GetVendorByIdResponse> getVendorById(String vendorId) async {
    final response = await vendorServices.getVendorById(vendorId);
    log("The type is : ${response["id"].runtimeType}");
    return GetVendorByIdResponse.fromJson(response);
  }

  Future<AddVendorRequestResponse> putVendor(
    String vendorId,
    AddVendorRequestResponse vendorData,
  ) async {
    final response = await vendorServices.putVendor(vendorId, vendorData);
    log("The type is : ${response["id"].runtimeType}");
    return AddVendorRequestResponse.fromJson(response);
  }

  Future<GstDetailsResponse> fetchGSTDetails(String gstNumber) async {
    final response = await vendorServices.fetchGSTDetails(gstNumber);
    log("The GST details response is: $response");
    return GstDetailsResponse.fromJson(response);
  }

  Future<PaginatedGetVendorListingDetailsResponse> getVendorListingDetails({
    String? offsetId,
    int limit = 20,
    String query = '',
  }) async {
    log("The query will be r $query");
    final response = await vendorServices.getVendorListingDetails(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    // List<GetCustomerListingDetailsResponse> data = [];
    // for (var i = 0; i < response.length; i++) {
    //   GetCustomerListingDetailsResponse getCustomerListingDetailsResponse =
    //       GetCustomerListingDetailsResponse.fromJson(response[i]);
    //   data.add(getCustomerListingDetailsResponse);
    // }
    final data = PaginatedGetVendorListingDetailsResponse.fromJson(response);
    return data;
  }

  Future<GetPaginatedVendorPocResponse> getVendorListingPoc({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    log("The query will be r $query");
    final response = await vendorServices.getVendorListingPoc(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );

    final data = GetPaginatedVendorPocResponse.fromJson(response);
    return data;
  }

  Future<CreateVendorPocRequest> createVendorPoc(
    CreateVendorPocRequest vendorData,
  ) async {
    final response = await vendorServices.createVendorPoc(vendorData);
    log("The type is : ${response["id"].runtimeType}");
    return CreateVendorPocRequest.fromJson(response);
  }
}
