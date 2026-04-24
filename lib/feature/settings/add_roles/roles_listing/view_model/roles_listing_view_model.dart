// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/view/add_roles_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/roles_listing/models/get_roles_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/settings/settings_sidebar_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/repository/organization_repository.dart';

class RoleslistingViewmodel extends GetxController {
  final OrganizationRepository _organizationRepository =
      OrganizationRepository();
  final headers =
      [
        'Sn',
        'Role Name',
        'Role Type',
        'Branch',
        'Phone Number',
        'Two-Factor Auth',
        '',
      ].obs;
  final columnWidths =
      [
        0.09, // Reduced from 0.1
        1.15, // Reduced from 1.2
        0.48, // Reduced from 0.5
        0.48, // Reduced from 0.5
        0.48, // Reduced from 0.5
        0.68, // Reduced from 0.5
        0.15, // Reduced from 0.1
      ].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    print("Roles Listing viewmodel initiated");
  }

  @override
  void onClose() {
    print("Roles Listing viewmodel Deleted");
    super.onClose();
  }

  List<String> popUpValues = ["Edit", "Delete"];

  void navigateToCreateRole() {
    print("Navigate to create new role");
    final sidebarController = Get.find<SettingsSidebarController>(
      tag: 'globalSettings',
    );
    sidebarController.navigateToPage(const AddRolesPage());
  }

  void editRole(String roleId) {
    print("Edit role: $roleId");
    final sidebarController = Get.find<SettingsSidebarController>(
      tag: 'globalSettings',
    );
    sidebarController.navigateToPage(AddRolesPage(roleId: roleId));
  }

  final getRolesListingResponse = Rx<ApiResponse<GetRolesResponse>>(
    ApiResponse.initial("Initial"),
  );

  final searchQuery = ''.obs;

  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getRolesListing({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getRolesListingResponse.value = ApiResponse.loading("loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _organizationRepository.getRoles(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        getRolesListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getRolesListingResponse.value.data?.values ?? [];

        List<GetRolesResponseValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getRolesListingResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      if (resetList) {
        getRolesListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    print("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      print("Loading more called");
      await getRolesListing();
    }
  }

  void setSeachQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      getRolesListing(resetList: true, isSearch: true);
    });
  }
}
