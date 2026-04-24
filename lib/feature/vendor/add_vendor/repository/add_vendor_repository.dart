// // ignore_for_file: avoid_print

// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/add_vendor_request.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_ledger_list_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_types_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/gst_details_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/services/add_vendor_services.dart';
// import 'package:jewellery_erp_frontend_tab_version/services/vendor_services.dart';

// class VendorRepository {
//   final VendorServices addVendorServices = Get.find();
//   Future<VendorTypesResponse> getVendorTypes() async {
//     final response = await addVendorServices.getVendorTypes();
//     print("The response is : $response");
//     return VendorTypesResponse.fromJson(response);
//   }

//   Future<LedgerItemsResponse> getLedgerItems() async {
//     final response = await addVendorServices.getLedgerItems();
//     print("The response is : $response");
//     return LedgerItemsResponse.fromJson(response);
//   }

//   Future<bool> validateCode(String code) async {
//     final response = await addVendorServices.validateCode(code);
//     return response["is_available"] ?? false;
//   }

//   Future<String?> getCityFromPincode(String pincode) async {
//     try {
//       final response = await addVendorServices.getCityFromPincode(pincode);
//       if (response is Map<String, dynamic> && response.containsKey('city')) {
//         return response['city'] as String?;
//       }
//       return null;
//     } catch (e) {
//       print("Error fetching city from pincode: $e");
//       return null;
//     }
//   }

//   Future<AddVendorRequestResponse> addVendor(
//       AddVendorRequestResponse vendorData) async {
//     final response = await addVendorServices.addVendor(vendorData);
//     print("The type is : ${response["id"].runtimeType}");
//     return AddVendorRequestResponse.fromJson(response);
//   }

//   // Future<AddVendorRequestResponse> getVendor(String query) async {
//   //   final response = await addVendorServices.getVendor(query);
//   //   print("The type is : ${response["id"].runtimeType}");
//   //   return AddVendorRequestResponse.fromJson(response);
//   // }

//   Future<GetVendorByIdResponse> getVendorById(String vendorId) async {
//     final response = await addVendorServices.getVendorById(vendorId);
//     print("The type is : ${response["id"].runtimeType}");
//     return GetVendorByIdResponse.fromJson(response);
//   }

//   Future<AddVendorRequestResponse> putVendor(
//       String vendorId, AddVendorRequestResponse vendorData) async {
//     final response = await addVendorServices.putVendor(vendorId, vendorData);
//     print("The type is : ${response["id"].runtimeType}");
//     return AddVendorRequestResponse.fromJson(response);
//   }

//   Future<GstDetailsResponse> fetchGSTDetails(String gstNumber) async {
//     final response = await addVendorServices.fetchGSTDetails(gstNumber);
//     print("The GST details response is: $response");
//     return GstDetailsResponse.fromJson(response);
//   }
// }
