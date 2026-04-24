import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/get_setup_plan_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/create_jewellery_plan/create_jewellery_plan_page.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';

class SetupPlanController extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();

  // Reactive variables for API response handling
  final getJewelleryPlanResponse = Rx<ApiResponse<GetSetupPlanListingResponse>>(
    ApiResponse.initial("Initial"),
  );

  final RxList<GetSetupPlanListingValue> plans =
      <GetSetupPlanListingValue>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<GetSetupPlanListingValue?> selectedPlan =
      Rx<GetSetupPlanListingValue?>(null);

  // Pagination and search variables
  final RxString searchQuery = ''.obs;
  final RxString lastOffsetId = RxString('');
  final RxBool hasMoreData = true.obs;

  // Constants
  static const int ITEMS_PER_PAGE = 10;

  @override
  void onInit() {
    super.onInit();
    loadPlans();
  }

  Future<void> loadPlans({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        plans.clear();
        lastOffsetId.value = '';
        hasMoreData.value = true;
      }

      if (!hasMoreData.value && !isRefresh) return;

      isLoading.value = true;
      getJewelleryPlanResponse.value = ApiResponse.loading("Loading plans...");

      final response = await estimationRepository.getJeweleryPlanListing(
        offsetId:
            isRefresh
                ? null
                : lastOffsetId.value.isEmpty
                ? null
                : lastOffsetId.value,
        limit: ITEMS_PER_PAGE,
        query: searchQuery.value,
      );

      // Update pagination info
      hasMoreData.value = response.pagination?.next != null;
      if (response.values?.isNotEmpty == true) {
        lastOffsetId.value = response.values!.last.id ?? '';
      }

      // Update plans list
      if (response.values != null) {
        if (isRefresh) {
          plans.value = response.values!;
        } else {
          plans.addAll(response.values!);
        }
      }

      getJewelleryPlanResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error loading plans: $e');
      getJewelleryPlanResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectPlan(GetSetupPlanListingValue plan) {
    selectedPlan.value = plan;
    log('Selected plan: ${plan.planName}');
  }

  void setSearchQuery(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    loadPlans(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (!isLoading.value && hasMoreData.value) {
      await loadPlans();
    }
  }

  Future<void> refreshPlans() async {
    await loadPlans(isRefresh: true);
  }

  void addNewPlan() {
    SidebarController sidebarController = Get.find();
    sidebarController.navigateToWidget(
      newChild: const CreateJewelleryPlanPage(),
    );
  }

  void handleDiscard() {
    selectedPlan.value = null;
    Get.back();
  }

  void showRemarks() {
    Get.dialog(const AddRemarkDialog());
  }

  // Helper methods
  bool get isInitialLoading =>
      getJewelleryPlanResponse.value.status == Status.LOADING && plans.isEmpty;

  bool get hasError => getJewelleryPlanResponse.value.status == Status.ERROR;

  String get errorMessage =>
      getJewelleryPlanResponse.value.message ?? 'Unknown error occurred';
}
