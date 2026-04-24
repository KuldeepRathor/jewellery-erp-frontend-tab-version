import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_to_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/add_role_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/get_role_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/get_role_types_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/roles_listing/view_model/roles_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/settings/settings_sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

import 'permissions_view_model.dart';

class AddRolesViewModel extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  TextEditingController roleId = TextEditingController();
  TextEditingController digitPin = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  final roleIdFocusNode = FocusNode();

  // Branch selection
  final branchId = TextEditingController().obs;
  final branchIdFocusNode = FocusNode();
  final RxList<BranchValue> branchOptions = <BranchValue>[].obs;
  final Rx<BranchValue?> selectedBranch = Rx<BranchValue?>(null);
  final Rx<ApiResponse<TransferToDropDownModel>> getBranchesResponse =
      Rx<ApiResponse<TransferToDropDownModel>>(ApiResponse.initial("Initial"));
  final CustomDebouncer branchDebouncer = CustomDebouncer(milliseconds: 500);

  // Role type selection
  final roleType = TextEditingController().obs;
  final roleTypeFocusNode = FocusNode();
  final RxList<GetRoleTypesResponse> roleTypeOptions =
      <GetRoleTypesResponse>[].obs;
  final Rx<GetRoleTypesResponse?> selectedRoleType = Rx<GetRoleTypesResponse?>(
    null,
  );

  // Role types data from API
  final RxList<GetRoleTypesResponse> roleTypesData =
      <GetRoleTypesResponse>[].obs;

  final twoFactorAuthentication = false.obs;
  final twoFactorAuthenticationFocusNode = FocusNode();
  final isLoading = false.obs;

  // Edit mode variables
  final isEditMode = false.obs;
  final currentRoleId = "".obs; // Store the ID of the role being edited
  final roleByIdResponse = Rx<ApiResponse<GetRoleByIdResponse>>(
    ApiResponse.initial("Initial"),
  );

  final OrganizationRepository organizationRepository =
      OrganizationRepository();

  @override
  void onInit() {
    super.onInit();
    fetchBranches();
    fetchRoleTypes();
  }

  @override
  void onClose() {
    // roleId.dispose();
    // digitPin.dispose();
    // mobileNumber.dispose();
    // branchId.value.dispose();
    // roleType.value.dispose();
    // branchIdFocusNode.dispose();
    // roleTypeFocusNode.dispose();
    super.onClose();
  }

  // Validators
  String? validateRoleId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Role ID is required';
    }
    if (value.length < 3) {
      return 'Role ID must be at least 3 characters';
    }
    return null;
  }

  String? validatePin(String? value) {
    // If in edit mode and the PIN field is empty, it's okay (we'll keep the existing PIN)
    if (isEditMode.value && (value == null || value.isEmpty)) {
      return null;
    }

    // For new roles or when PIN is provided for updates, validate it
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }
    if (value.length != 4 || !RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'PIN must be exactly 4 digits';
    }
    return null;
  }

  String? validateMobileNumber(String? value) {
    if (!twoFactorAuthentication.value) {
      return null;
    }

    if (value == null || value.isEmpty) {
      return 'Mobile number is required for two-factor authentication';
    }

    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }

    return null;
  }

  String? validateBranchId(String? value) {
    if (selectedBranch.value == null) {
      return 'Branch selection is required';
    }
    return null;
  }

  String? validateRoleType(String? value) {
    if (selectedRoleType.value == null || value == null || value.isEmpty) {
      return 'Role Type selection is required';
    }
    return null;
  }

  // Load a role by its ID for editing
  Future<void> loadRoleById(String roleId) async {
    try {
      isEditMode.value = true;
      currentRoleId.value = roleId;
      roleByIdResponse.value = ApiResponse.loading("Loading role details");

      final response = await organizationRepository.getRoleById(roleId);
      roleByIdResponse.value = ApiResponse.completed(response);

      // Populate form fields with the loaded data
      populateFormWithRoleData(response);
    } catch (e) {
      roleByIdResponse.value = ApiResponse.error(e.toString());
      Get.snackbar(
        'Error',
        'Failed to load role details: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Populate form fields with data from the loaded role
  void populateFormWithRoleData(GetRoleByIdResponse data) {
    // Basic role information
    roleId.text = data.roleName ?? '';
    digitPin.text = ''; // PIN is usually not returned for security reasons

    // Two-factor authentication
    twoFactorAuthentication.value = data.isTwoFactorAuthEnabled ?? false;
    mobileNumber.text = data.phoneNumber ?? '';

    // Branch selection
    if (data.shop != null) {
      selectedBranch.value = data.shop;
      branchId.value.text = data.shop?.readableId ?? '';
    }

    // Role type
    if (data.roleType != null) {
      // Find matching role type in our options
      final matchingRoleType = roleTypesData.firstWhereOrNull(
        (type) => type.id == data.roleType?.id,
      );

      if (matchingRoleType != null) {
        selectedRoleType.value = matchingRoleType;
        roleType.value.text = matchingRoleType.roleType ?? '';
      }
    }

    // Set permissions
    if (data.modules != null && data.modules!.isNotEmpty) {
      final PermissionsViewModel permissionsViewModel =
          Get.find<PermissionsViewModel>();
      permissionsViewModel.loadExistingPermissions(data.modules!);
    }
  }

  // Update an existing role
  Future<void> updateRole() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        final PermissionsViewModel permissionsViewModel =
            Get.find<PermissionsViewModel>();

        // Create the update request model
        final updateRequest = AddRoleRequestModel(
          id: roleByIdResponse.value.data?.id,
          roleType: RoleType(
            id: selectedRoleType.value?.id ?? "",
            name: selectedRoleType.value?.roleType ?? "",
          ),
          isTwoFactorAuthEnabled: twoFactorAuthentication.value,
          pin: digitPin.text.isNotEmpty ? digitPin.text : null,
          roleName: roleId.text,
          readableId: roleId.text,
          shopId: selectedBranch.value?.id ?? '',
          phoneNumber: twoFactorAuthentication.value ? mobileNumber.text : '',
          modules: permissionsViewModel.modules.toList(),
        );

        // Call the update API
        await organizationRepository.updateRoleById(
          currentRoleId.value,
          updateRequest,
        );

        isLoading.value = false;
        showSuccessToast(message: 'Role updated successfully');

        // Return to the roles listing page
        _goBack();
      } catch (e, s) {
        isLoading.value = false;
        log("Error update $e, $s");
        showErrorToast(message: 'Failed to update role: ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Fetch all branches from API
  Future<void> fetchBranches() async {
    try {
      getBranchesResponse.value = ApiResponse.loading("Loading branches");
      final response = await organizationRepository.getAllBranches();
      branchOptions.value = response.values ?? [];
      branchOptions.refresh();
      getBranchesResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getBranchesResponse.value = ApiResponse.error(e.toString());
    }
  }

  // Search branches based on query
  Future<void> searchBranches(String query) async {
    if (getBranchesResponse.value.status != Status.COMPLETED &&
        getBranchesResponse.value.status != Status.ERROR) {
      await fetchBranches();
    }

    branchDebouncer.run(() {
      if (query.isEmpty) {
        // If query is empty, show all branches
        if (getBranchesResponse.value.data?.values != null) {
          branchOptions.value = getBranchesResponse.value.data!.values!;
        }
      } else {
        // Filter branches based on query
        branchOptions.value =
            getBranchesResponse.value.data?.values
                ?.where(
                  (branch) =>
                      branch.branchName?.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ==
                          true ||
                      branch.readableId?.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ==
                          true,
                )
                .toList() ??
            [];
      }
      branchOptions.refresh();
    });
  }

  // Handle branch selection
  void setSelectedBranch(BranchValue branch) {
    selectedBranch.value = branch;
    branchId.value.text = branch.readableId ?? '';
    branchIdFocusNode.unfocus();
    update();
  }

  // Method to search role types (for local filtering)
  void searchRoleTypes(String query) {
    if (query.isEmpty) {
      // Show all role types
      roleTypeOptions.assignAll(roleTypesData);
    } else {
      // Filter role types based on query
      roleTypeOptions.assignAll(
        roleTypesData
            .where(
              (type) => (type.roleType ?? "").toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList(),
      );
    }
  }

  // Method to handle role type selection
  void setSelectedRoleType(GetRoleTypesResponse roleTypeData) {
    selectedRoleType.value = roleTypeData;
    roleType.value.text = roleTypeData.roleType ?? "";
    roleTypeFocusNode.unfocus();

    // Apply permissions from the selected role type
    final PermissionsViewModel permissionsViewModel =
        Get.find<PermissionsViewModel>();
    permissionsViewModel.setPermissionsFromRoleType(roleTypeData);

    update();
  }

  void updateConcent(bool value) {
    twoFactorAuthentication.value = value;
    formKey.currentState?.validate(); // Revalidate form when 2FA toggle changes
    update();
  }

  void onDiscardTapped() {
    // If in edit mode, reload the original role data
    if (isEditMode.value && currentRoleId.value.isNotEmpty) {
      loadRoleById(currentRoleId.value);
      return;
    }

    // Otherwise clear all fields
    roleId.clear();
    digitPin.clear();
    mobileNumber.clear();
    branchId.value.clear();
    roleType.value.clear();
    selectedBranch.value = null;
    selectedRoleType.value = null;
    twoFactorAuthentication.value = false;
    final PermissionsViewModel permissionsViewModel =
        Get.find<PermissionsViewModel>();
    permissionsViewModel.clearController();
    roleIdFocusNode.requestFocus();
  }

  void onConfirmTapped() async {
    // Use form validation
    if (isLoading.value) {
      return;
    }

    if (isEditMode.value) {
      // Update existing role
      await updateRole();
    } else {
      // Create new role
      await createNewRole();
    }
  }

  Future<void> createNewRole() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        final PermissionsViewModel permissionsViewModel =
            Get.find<PermissionsViewModel>();
        await organizationRepository.addRole(
          AddRoleRequestModel(
            roleType: RoleType(
              id: selectedRoleType.value?.id ?? "",
              name: selectedRoleType.value?.roleType ?? "",
            ),
            isTwoFactorAuthEnabled: twoFactorAuthentication.value,
            pin: digitPin.text,
            roleName: roleId.text,
            readableId: roleId.text,
            shopId: selectedBranch.value?.id ?? '',
            phoneNumber: twoFactorAuthentication.value ? mobileNumber.text : '',
            modules: permissionsViewModel.modules.toList(),
          ),
        );

        isLoading.value = false;
        showSuccessToast(message: 'Role added successfully');

        _goBack();
      } catch (e) {
        isLoading.value = false;
        showErrorToast(message: 'Failed to add role: ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }
  }

  final getRoleTypesResponse = Rx<ApiResponse<GetRoleTypesResponse>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> fetchRoleTypes() async {
    try {
      getRoleTypesResponse.value = ApiResponse.loading("Loading role types");
      final response = await organizationRepository.getRoleTypes();

      // Store the role types data
      roleTypesData.assignAll(response);

      // Update the role type options
      roleTypeOptions.assignAll(roleTypesData);

      getRoleTypesResponse.value = ApiResponse.completed(
        response.isNotEmpty ? response.first : null,
      );
    } catch (e) {
      getRoleTypesResponse.value = ApiResponse.error(e.toString());
      Get.snackbar(
        'Error',
        'Failed to fetch role types: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _goBack() {
    final sidebarController = Get.find<SettingsSidebarController>(
      tag: 'globalSettings',
    );
    sidebarController.popBack();

    // Refresh the roles list if the controller exists
    if (Get.isRegistered<RoleslistingViewmodel>()) {
      final rolesController = Get.find<RoleslistingViewmodel>();
      rolesController.getRolesListing(resetList: true);
    }
  }

  void goBack() {
    onDiscardTapped();
    _goBack();
  }
}
