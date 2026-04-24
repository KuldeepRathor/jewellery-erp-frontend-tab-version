// feature Repository

import 'dart:developer';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/verify_aadhar_otp_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/verify_pan_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/employee/add_employee/model/add_employees_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_to_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/model/get_branches_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/model/get_employee_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/add_role_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/get_role_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/get_role_types_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/roles_listing/models/get_roles_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/kyc_settings/model/get_org_kyc_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/kyc_settings/model/update_org_kyc_settings_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/model/get_account_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/model/get_settlement_details_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/services/organization_services.dart';

class OrganizationRepository {
  final OrganizationServices organizationServices = OrganizationServices();

  Future<GetOrgKycSettingsResponse> getOrgKycSettings() async {
    try {
      final response = await organizationServices.getOrgKycSettings();
      return GetOrgKycSettingsResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrgKycSettings(UpdateOrgKycSettingsRequest request) async {
    try {
      await organizationServices.updateOrgKycSettings(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetBranchesDropdownResponse> getBranchesDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await organizationServices.getBranchesDropdown(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetBranchesDropdownResponse.fromJson(response);
    return data;
  }

  Future<GetSettlementDetailsResponse> getSettlementDetails() async {
    try {
      final response = await organizationServices.getSettlementDetails();
      return GetSettlementDetailsResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatusAccountSettings(String id, bool is_active) async {
    try {
      await organizationServices.updateStatusAccountSettings(
        id: id,
        is_active: is_active,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccountSettingsbyId(String id) async {
    try {
      await organizationServices.deleteAccountSettingsbyId(id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetAccountSettingsResponse> updateAccountSettingsbyId(
    String id,
    GetAccountSettingsResponse data,
  ) async {
    try {
      final response = await organizationServices.updateAccountSettingsbyId(
        id,
        data.toJson(),
      );
      return GetAccountSettingsResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetAccountSettingsResponse> createAccountSettings(
    GetAccountSettingsResponse createAccountSettingsRequest,
  ) async {
    try {
      final response = await organizationServices.createAccountSettings(
        createAccountSettingsRequest.toJson(),
      );

      return GetAccountSettingsResponse.fromJson(response);
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  Future<GetAccountSettingsResponse> getAccountSettings(
    String accountType,
  ) async {
    try {
      final response = await organizationServices.getAccountSettings(
        accountType: accountType,
      );
      return GetAccountSettingsResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetAccountSettingsResponse> getAccountSettingsById(String id) async {
    try {
      final response = await organizationServices.getAccountSettingsById(
        id: id,
      );
      return GetAccountSettingsResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetAccountSettingsResponse>> getAccountSettingsList({
    String? accountType,
  }) async {
    try {
      final response = await organizationServices.getAccountSettingsList(
        accountType: accountType,
      );

      // Since response is an array, we convert it directly
      if (response is List) {
        return response
            .map((item) => GetAccountSettingsResponse.fromJson(item))
            .toList();
      } else {
        throw Exception(
          "Expected array response but got: ${response.runtimeType}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GetEmployeeDropdownResponse> getEmployeeDropdown({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await organizationServices.getEmployeeDropdown(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetEmployeeDropdownResponse.fromJson(response);
    return data;
  }

  //pan
  Future<VerifyPanResponse> verifyPanNo(
    String pan,
    String name, {
    String? customerId,
  }) async {
    try {
      final response = await organizationServices.verifyPanNo(
        pan: pan,
        name: name,
        customerId: customerId,
      );
      return VerifyPanResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  //aadhar
  Future<String> getAadharOtp({required String adhar_number}) async {
    final response = await organizationServices.getAadharOtp(
      adhar_number: adhar_number,
    );
    return response["ref_id"];
  }

  Future<VerifyAadharOtpResponse> verifyAadharOtp({
    required String ref_id,
    required String otp,
    required String aadhaarNumber,
    String? customerId,
  }) async {
    try {
      final response = await organizationServices.verifyAadharOtp(
        ref_id: ref_id,
        otp: otp,
        aadhaarNumber: aadhaarNumber,
        customerId: customerId,
      );
      return VerifyAadharOtpResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future refresh_token(String refresh_token) async {
    try {
      final response = await organizationServices.refresh_token(refresh_token);
      return (response);
    } catch (e) {
      rethrow;
    }
  }

  Future verifyOtp(String role_id, String otp) async {
    try {
      final response = await organizationServices.verifyOtp(role_id, otp);
      return (response);
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
      final response = await organizationServices.login(
        role_readable_id,
        branch_readable_id,
        pin,
      );
      return (response);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getToken() async {
    final response = await organizationServices.getToken();
    return response["access"];
  }

  Future<AddEmployeesRequest> addEmployee(
    AddEmployeesRequest employeeData,
  ) async {
    final response = await organizationServices.addEmployee(employeeData);
    log("The type is : ${response["id"].runtimeType}");
    return AddEmployeesRequest.fromJson(response);
  }

  Future<GetEmployeesResponse> getEmployees({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await organizationServices.getEmployees(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetEmployeesResponse.fromJson(response);
    return data;
  }

  Future<GetEmployeesValue> getEmployeeById(String employeeId) async {
    final response = await organizationServices.getEmployeeById(employeeId);
    final data = GetEmployeesValue.fromJson(response);
    return data;
  }

  Future<String> getGstType({required String gstNumber}) async {
    final response = await organizationServices.getGstType(
      gstNumber: gstNumber,
    );
    return response["gst_type"];
  }

  Future<String> getGstTypev2({
    required String state_name,
    bool? in_store_sale,
  }) async {
    final response = await organizationServices.getGstTypev2(
      state_name: state_name,
      in_store_sale: in_store_sale,
    );
    return response["gst_type"];
  }

  Future<TransferToDropDownModel> getAllBranches() async {
    final response = await organizationServices.getAllBranches();

    return TransferToDropDownModel.fromJson(response);
  }

  Future<AddRoleRequestModel> addRole(AddRoleRequestModel addRoleData) async {
    await organizationServices.addRole(addRoleData);

    return AddRoleRequestModel(
      roleType: null,
      pin: "pin",
      roleName: "roleName",
      readableId: "readableId",
      shopId: "shopId",
      isTwoFactorAuthEnabled: false,
      phoneNumber: "phoneNumber",
      modules: [],
    );
  }

  Future<List<GetRoleTypesResponse>> getRoleTypes() async {
    final response = await organizationServices.getRoleTypes();

    return (response as List)
        .map(
          (item) => GetRoleTypesResponse.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<GetRolesResponse> getRoles({
    String? offsetId,
    int limit = 10,
    String query = '',
  }) async {
    final response = await organizationServices.getRoles(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    final data = GetRolesResponse.fromJson(response);
    return data;
  }

  Future<GetRoleByIdResponse> getRoleById(String roleId) async {
    final response = await organizationServices.fetchRoleById(roleId);
    final data = GetRoleByIdResponse.fromJson(response);
    return data;
  }

  Future<AddRoleRequestModel> updateRoleById(
    String roleId,
    AddRoleRequestModel request,
  ) async {
    await organizationServices.updateRoleById(roleId, request);

    return AddRoleRequestModel(
      roleType: null,
      pin: "pin",
      roleName: "roleName",
      readableId: "readableId",
      shopId: "shopId",
      isTwoFactorAuthEnabled: false,
      phoneNumber: "phoneNumber",
      modules: [],
    );
  }
}
