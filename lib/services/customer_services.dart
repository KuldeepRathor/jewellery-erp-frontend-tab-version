import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/create_customer_aadhar_presigned_url_save_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/create_customer_pan_presigned_url_save_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class CustomerServices {
  final HttpDioClient _apiService = Get.find();

  Future customerPanPresignedUrl(CustomerPanPresignedUrlSave request) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.customerBaseUrl,
        '/customer-pan-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future customerAadharPresignedUrl(
    CustomerAadharPresignedUrlSave request,
  ) async {
    try {
      final body = jsonEncode(request.toJson());
      final response = await _apiService.post(
        AppUrl.customerBaseUrl,
        '/customer-aadhaar-presigned-url-save',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putCustomerImage({
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

  Future getCountryCode({String query = ''}) async {
    try {
      final response = await _apiService.get(
        AppUrl.customerBaseUrl,
        '/phone-country-code?query=$query',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> gst_phone_number_availability(
    String type_value,
    String type,
  ) async {
    try {
      final response = await _apiService.post(
        AppUrl.customerBaseUrl,
        '/gst-phone-number-availability',
        queryParameters: {'type_value': type_value, 'type': type},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addCustomer(CustomerDetails customerData) async {
    try {
      final body = customerData.toJson();

      final response = await _apiService.post(
        AppUrl.customerBaseUrl,
        "/customer",
        data: jsonEncode(body),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Map<String, dynamic>> getCustomer(String query) async {
  //   try {
  //     final response = await _apiService.get(
  //       AppUrl.customerBaseUrl,
  //       "/customers",
  //       queryParameters: {
  //         "query": query,
  //       },
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<Map<String, dynamic>> getCustomeById(String customerId) async {
    try {
      final response = await _apiService.get(
        AppUrl.customerBaseUrl,
        "/customer/$customerId",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> putCustomer(
    String customerId,
    CustomerDetails customerData,
  ) async {
    try {
      final body = customerData.toJson();

      final response = await _apiService.put(
        AppUrl.customerBaseUrl,
        "/editCustomer",
        queryParameters: {"id": customerId},
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getCustomerListingDetails({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/customers?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/customers?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.get(
        // AppUrl.localBaseUrl,
        // '/customer_details?_page=$page&_per_page=$limit&name=$search',
        AppUrl.customerBaseUrl,
        path,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateForcedKycPan({
    required String customerId,
    required bool isForcedKycPan,
  }) async {
    try {
      await _apiService.put(
        AppUrl.customerBaseUrl,
        "/edit-customer/force-kyc-pan-toggle/$customerId/$isForcedKycPan",
      );
      // No return needed since the API returns null
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateForcedKycAadhaar({
    required String customerId,
    required bool isForcedKycAadhaar,
  }) async {
    try {
      await _apiService.put(
        AppUrl.customerBaseUrl,
        "/edit-customer/force-kyc-aadhaar-toggle/$customerId/$isForcedKycAadhaar",
      );
      // No return needed since the API returns null
    } catch (e) {
      rethrow;
    }
  }
}
