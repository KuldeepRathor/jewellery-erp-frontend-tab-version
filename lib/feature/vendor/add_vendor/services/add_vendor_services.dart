// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/base/api_dio_client.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/add_vendor_request.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

// class AddVendorServices {
//   final HttpDioClient _apiService = Get.find();
//   Future getVendorTypes() async {
//     try {
//       final response = await _apiService.get(
//         AppUrl.vendorBaseUrl,
//         '/get-vendor-types',
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future getVendorById(String vendorId) async {
//     try {
//       final response = await _apiService.get(
//         AppUrl.vendorBaseUrl,
//         '/vendor/$vendorId',
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future getLedgerItems() async {
//     try {
//       final response = await _apiService.get(
//         AppUrl.vendorBaseUrl,
//         '/get-ledger-items',
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>> validateCode(String code) async {
//     try {
//       final body = {
//         'code': code,
//       };
//       final response = await _apiService.post(
//         AppUrl.vendorBaseUrl,
//         '/check-code',
//         data: jsonEncode(body),
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future getCityFromPincode(String pincode) async {
//     try {
//       final body = {
//         "pincode": pincode,
//       };
//       final response = await _apiService.get(
//         AppUrl.vendorBaseUrl,
//         '/pincode',
//         data: jsonEncode(body),
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future addVendor(AddVendorRequestResponse vendorData) async {
//     try {
//       final body = vendorData.toJson();
//       final response = await _apiService.post(
//         AppUrl.vendorBaseUrl,
//         '/vendor',
//         data: jsonEncode(body),
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future putVendor(String vendorId, AddVendorRequestResponse vendorData) async {
//     try {
//       final body = vendorData.toJson();
//       final response = await _apiService.put(
//         AppUrl.vendorBaseUrl,
//         '/vendor',
//         data: jsonEncode(body),
//         queryParameters: {
//           "id": vendorId,
//         },
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Future getVendor(String vendorId) async {
//   //   try {
//   //     final response = await _apiService.get(
//   //       AppUrl.localBaseUrl,
//   //       '/vendors/$vendorId',
//   //     );
//   //     return response;
//   //   } catch (e) {
//   //     rethrow;
//   //   }
//   // }

//   Future fetchGSTDetails(String gstNumber) async {
//     try {
//       final response = await _apiService.get(
//         AppUrl.vendorBaseUrl,
//         '/gst_verification',
//         queryParameters: {
//           'gst_number': gstNumber,
//         },
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
