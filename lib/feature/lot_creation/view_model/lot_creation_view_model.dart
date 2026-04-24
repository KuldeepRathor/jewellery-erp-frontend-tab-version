import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_entries_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_entries_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/view/lot_creation_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/delivery_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/return_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/webstore_order_cancel_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class LotCreationViewModel extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  // Add filter controller
  final BaseFilterController filterController = Get.put(BaseFilterController());

  final topHeaders = ["", "Tagged", "Difference", ""];
  final headers =
      [
        'Sn',
        'Date',
        'Lot No.',
        "Rec No.",
        'Txn Type',
        'Supplier',
        'Gwt (gm)',
        'Nwt (gm)',
        'Pcs',
        'Purity',
        'Pcs',
        'Gwt',
        'Nwt',
        'Pcs',
        'Gwt',
        'Nwt',
        'Status',
        '',
      ].obs;

  final topColumnWidths = [2.9, 0.9, 0.9, 0.4];
  final columnWidths =
      [
        0.1, // Sn
        0.3, // Date
        0.3, // Lot No.
        0.3, // Rec No.
        0.4, // Txn Type
        0.3, // Supplier
        0.3, // Gwt (gm)
        0.3, // Nwt (gm)
        0.3, // Pcs
        0.3, // Purity
        0.3, // Pcs (duplicate)
        0.3, // Gwt
        0.3, // Nwt
        0.3, // Pcs (duplicate)
        0.3, // Gwt
        0.3, // Nwt
        0.3, // Status
        0.1, // Empty column
      ].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final currentFilterRequest = Rx<GetLotEntriesRequest?>(null);

  List<String> popUpValues = ["Edit", "Complete", "Cancel"];

  @override
  void onInit() {
    super.onInit();
    filterController.resetAllFilters();

    // Initialize filter controller with relevant filter types for lot entries
    filterController.fetchAllDropdownData(
      filterTypes: ['purity', 'vendor', 'status', 'branch'],
    );
  }

  void onReturnTapped() {
    // Show the return dialog
    Get.dialog(const ReturnDialog()).then((_) {
      // Refresh the order list after dialog is closed
      getVendorListingDetails(resetList: true);
    });
  }

  void onDeliveryTapped() {
    // Show the return dialog
    Get.dialog(const DeliveryDialog()).then((_) {
      // Refresh the order list after dialog is closed
      getVendorListingDetails(resetList: true);
    });
  }

  void onCancelTapped() {
    // Show the return dialog
    Get.dialog(const WebstoreOrdersCancelledDialog()).then((_) {
      // Refresh the order list after dialog is closed
      getVendorListingDetails(resetList: true);
    });
  }

  // Show confirmation dialog for completing a lot entry
  void showCompleteConfirmationDialog(String lotEntryId) {
    Get.dialog(
      CancelPaymentDialog(
        subtitle: 'Are you sure you want to mark this lot entry as completed?',
        onYesPressed: () async {
          await changeLotEntryStatus(
            lotEntryId: lotEntryId,
            status: 'Completed',
          );
          getVendorListingDetails(resetList: true);
        },
      ),
    );
  }

  // Show confirmation dialog for canceling a lot entry
  void showCancelConfirmationDialog(String lotEntryId) {
    Get.dialog(
      CancelPaymentDialog(
        subtitle: 'Are you sure you want to cancel this lot entry?',
        onYesPressed: () async {
          await changeLotEntryStatus(lotEntryId: lotEntryId, status: 'Cancel');
          getVendorListingDetails(resetList: true);
        },
      ),
    );
  }

  // Show the dialog
  Future<void> showLotEntryDialog({GetLotEntriesValue? lotData}) async {
    bool? refreshList = await Get.dialog(LotEntryDialog(lotData: lotData));

    if (refreshList == true) {
      getVendorListingDetails(resetList: true);
    }
  }

  final getVendorListingDetailsResponse =
      Rx<ApiResponse<GetLotEntriesResponse>>(ApiResponse.initial("Initial"));

  final searchQuery = ''.obs;

  int? nextPageNo;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  void setInitialConditions({required bool isSearch}) {
    nextPageNo = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getVendorListingDetails({
    bool resetList = false,
    bool isSearch = false,
    GetLotEntriesRequest? filterRequest,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      // Update the current filter request
      currentFilterRequest.value = filterRequest;
      getVendorListingDetailsResponse.value = ApiResponse.loading("loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _inventoryRepository.getLotEntries(
        nextPage: nextPageNo,
        limit: itemsPerPage,
        query: searchQuery.value,
        filterRequest:
            currentFilterRequest
                .value, // Use stored filter request for pagination
      );

      if (resetList) {
        getVendorListingDetailsResponse.value = ApiResponse.completed(response);
      } else {
        final currentData =
            getVendorListingDetailsResponse.value.data?.values ?? [];

        List<GetLotEntriesValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;

        getVendorListingDetailsResponse.value = ApiResponse.completed(response);
      }
      hasMorePages.value = response.pagination?.nextPage != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        nextPageNo = response.pagination?.nextPage;
      }
    } catch (e) {
      if (resetList) {
        getVendorListingDetailsResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getVendorListingDetails();
    }
  }

  void setSeachQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      // Simulating API call
      getVendorListingDetails(resetList: true, isSearch: true);
    });
  }

  void applyFilters(GetLotEntriesRequest filterRequest) {
    getVendorListingDetails(
      resetList: true,
      isSearch: false,
      filterRequest: filterRequest,
    );
  }

  // New method to apply filters from the filter controller
  void applyFiltersFromController() {
    final request = createRequestFromFilters();
    applyFilters(request);
  }

  void clearFilters() {
    currentFilterRequest.value = null;
    filterController.resetAllFilters();
    getVendorListingDetails(resetList: true, isSearch: false);
  }

  // Create request from filter controller values
  GetLotEntriesRequest createRequestFromFilters() {
    return GetLotEntriesRequest(
      dateFrom: filterController.dateFrom.value,
      dateTo: filterController.dateTo.value,
      minNetWeight: filterController.minNetWeight.value,
      maxNetWeight: filterController.maxNetWeight.value,
      minGrossWeight: filterController.minGrossWeight.value,
      maxGrossWeight: filterController.maxGrossWeight.value,
      minLotNumber: filterController.minLotNumber.value,
      maxLotNumber: filterController.maxLotNumber.value,
      purity:
          filterController.selectedPurity.value?.id != null
              ? [filterController.selectedPurity.value!.id!]
              : null,
      status: filterController.selectedStatus.value?.id,
      branchIds:
          filterController.selectedBranches
              .map((branch) => branch.id!)
              .toList(),
    );
  }

  final changeStatusResponse = Rx<ApiResponse<void>>(
    ApiResponse.initial("Initial"),
  );

  // Method to change lot entry status
  Future<void> changeLotEntryStatus({
    required String lotEntryId,
    required String status,
  }) async {
    try {
      changeStatusResponse.value = ApiResponse.loading("Changing status");

      final response = await _inventoryRepository.changeLotEntryStatus(
        lotEntryId: lotEntryId,
        status: status,
      );

      changeStatusResponse.value = ApiResponse.completed(response);
    } catch (e) {
      changeStatusResponse.value = ApiResponse.error(e.toString());
      // Show error message
      showErrorToast(message: 'Failed to update status: ${e.toString()}');
    }
  }
}
