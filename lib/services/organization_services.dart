import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/employee/add_employee/model/add_employees_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/add_role_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/kyc_settings/model/update_org_kyc_settings_request.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class OrganizationServices {
  final HttpDioClient _apiService = Get.find();

  Future getOrgKycSettings() async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/get-org-kyc-settings',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateOrgKycSettings(UpdateOrgKycSettingsRequest data) async {
    try {
      final response = await _apiService.put(
        AppUrl.organizationBaseUrl,
        '/update-org-kyc-settings',
        data: jsonEncode(data.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getBranchesDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/branches?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/branches?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.organizationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getSettlementDetails() async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/get-settlement-details',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateStatusAccountSettings({
    required String id,
    required bool is_active,
  }) async {
    try {
      final response = await _apiService.put(
        AppUrl.organizationBaseUrl,
        '/update-status-account-settings',
        data: [
          {"id": id, "is_active": is_active},
        ],
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createAccountSettings(
    Map<String, dynamic> createAccountSettingsRequest,
  ) async {
    try {
      final body = jsonEncode(createAccountSettingsRequest);
      final response = await _apiService.post(
        AppUrl.organizationBaseUrl,
        '/create-account-setting',
        data: body,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateAccountSettingsbyId(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(
        AppUrl.organizationBaseUrl,
        '/update-account-setting/$id',
        data: jsonEncode(data),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteAccountSettingsbyId({required String id}) async {
    try {
      final response = await _apiService.delete(
        AppUrl.organizationBaseUrl,
        '/delete-account-setting/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAccountSettings({required String accountType}) async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/get-account-settings-by-org-id',
        queryParameters: {"account_type": accountType},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAccountSettingsById({required String id}) async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/get-account-setting/$id',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAccountSettingsList({String? accountType}) async {
    try {
      Map<String, dynamic> queryParameters = {};

      if (accountType != null) queryParameters["account_type"] = accountType;

      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/get-account-settings-by-org-id',
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getEmployeeDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/employees-dropdown?query=$query&limit=$limit&page=$offsetId';
    } else {
      path = '/employees-dropdown?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.organizationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //pan

  Future verifyPanNo({
    required String pan,
    required String name,
    String? customerId,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.customerBaseUrl,
        '/verify-pan',
        data: {"pan": pan, "name": name, "customer_id": customerId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //aadhar
  Future getAadharOtp({required String adhar_number}) async {
    try {
      final response = await _apiService.get(
        AppUrl.customerBaseUrl,
        '/request-adhar-otp',
        queryParameters: {"adhar_number": adhar_number},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future verifyAadharOtp({
    required String ref_id,
    required String otp,
    String? customerId,
    required String aadhaarNumber,
  }) async {
    try {
      final response = await _apiService.post(
        AppUrl.customerBaseUrl,
        '/verify-adhar-otp',
        data: {
          'ref_id': ref_id,
          'otp': otp,
          'customer_id': customerId,
          'aadhaar_number': aadhaarNumber,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Login
  Future refresh_token(String refresh_token) async {
    try {
      final response = await _apiService.post(
        AppUrl.organizationBaseUrl,
        '/refresh_token',
        options: Options(headers: {'refresh-token': refresh_token}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future verifyOtp(String role_id, String otp) async {
    try {
      final response = await _apiService.post(
        AppUrl.organizationBaseUrl,
        '/verify_otp',
        data: {'role_id': role_id, 'otp': otp},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future login(
    String role_readable_id,
    String branch_readable_id,
    String pin,
  ) async {
    try {
      final response = await _apiService.post(
        AppUrl.organizationBaseUrl,
        '/login',
        data: {
          'role_readable_id': role_readable_id,
          'branch_readable_id': branch_readable_id,
          'pin': pin,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getToken() async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/token',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Employee

  Future addEmployee(AddEmployeesRequest vendorData) async {
    try {
      final body = vendorData.toJson();
      final response = await _apiService.post(
        AppUrl.organizationBaseUrl,
        '/employee',
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getEmployees({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    String path;
    if (offsetId != null) {
      path = '/employees?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/employees?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.organizationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getEmployeeById(String employeeId) async {
    String path = '/employee/$employeeId';
    try {
      final response = await _apiService.get(AppUrl.organizationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getGstType({required String gstNumber}) async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/get-gst-type',
        queryParameters: {"gstNumber": gstNumber},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getGstTypev2({required String state_name, bool? in_store_sale}) async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/v2/get-gst-type',
        queryParameters: {
          "state_name": state_name,
          "in_store_sale": in_store_sale,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllBranches() async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/branches',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future addRole(AddRoleRequestModel addRoleData) async {
    try {
      final body = addRoleData.toJson();
      final response = await _apiService.post(
        AppUrl.organizationBaseUrl,
        '/create-role',
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getRoleTypes() async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/role-types',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getRoles({String? offsetId, int limit = 10, String query = ''}) async {
    String path;
    if (offsetId != null) {
      path = '/roles?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '/roles?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(AppUrl.organizationBaseUrl, path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchRoleById(String roleId) async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/role/$roleId',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateRoleById(String roleId, AddRoleRequestModel data) async {
    try {
      final response = await _apiService.put(
        AppUrl.organizationBaseUrl,
        '/role/$roleId',
        data: jsonEncode(data.toJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
