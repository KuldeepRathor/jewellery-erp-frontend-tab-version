import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/model/create_vendor_poc_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/add_vendor_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class VendorServices {
  final HttpDioClient _apiService = Get.find();

  Future getVendorDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/vendors-dropdown?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/vendors-dropdown?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.vendorBaseUrl, path);
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
        AppUrl.vendorBaseUrl,
        '/gst-phone-number-availability',
        queryParameters: {'type_value': type_value, 'type': type},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getVendorTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.vendorBaseUrl,
        '/get-vendor-types',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getVendorById(String vendorId) async {
    try {
      final response = await _apiService.get(
        AppUrl.vendorBaseUrl,
        '/vendor/$vendorId',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getLedgerItems() async {
    try {
      final response = await _apiService.get(
        AppUrl.vendorBaseUrl,
        '/get-ledger-items',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validateCode(String code) async {
    try {
      final body = {'code': code};
      final response = await _apiService.post(
        AppUrl.vendorBaseUrl,
        '/check-code',
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getCityFromPincode(String pincode) async {
    try {
      final body = {"pincode": pincode};
      final response = await _apiService.post(
        AppUrl.vendorBaseUrl,
        '/pincode',
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addVendor(AddVendorRequestResponse vendorData) async {
    try {
      final body = vendorData.toJson();
      final response = await _apiService.post(
        AppUrl.vendorBaseUrl,
        '/vendor',
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future putVendor(String vendorId, AddVendorRequestResponse vendorData) async {
    try {
      final body = vendorData.toJson();
      final response = await _apiService.put(
        AppUrl.vendorBaseUrl,
        '/vendor',
        data: jsonEncode(body),
        queryParameters: {"id": vendorId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future getVendor(String vendorId) async {
  //   try {
  //     final response = await _apiService.get(
  //       AppUrl.localBaseUrl,
  //       '/vendors/$vendorId',
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future fetchGSTDetails(String gstNumber) async {
    try {
      final response = await _apiService.get(
        AppUrl.vendorBaseUrl,
        '/gst_verification',
        queryParameters: {'gst_number': gstNumber},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getVendorListingDetails({
    String? offsetId,
    int limit = 20,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/vendors?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/vendors?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.get(
        // AppUrl.localBaseUrl,
        // '/customer_details?_page=$page&_per_page=$limit&name=$search',
        AppUrl.vendorBaseUrl,
        path,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getVendorListingPoc({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path =
          '/paginated-vendor-poc?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/paginated-vendor-poc?query=$query&limit=$limit';
    }
    try {
      log("The query will be $query");
      final response = await _apiService.get(
        // AppUrl.localBaseUrl,
        // '/customer_details?_page=$page&_per_page=$limit&name=$search',
        AppUrl.estimationBaseUrl,
        path,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createVendorPoc(CreateVendorPocRequest vendorData) async {
    try {
      final body = vendorData.toJson();
      final response = await _apiService.post(
        AppUrl.estimationBaseUrl,
        '/create-vendor-poc',
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
