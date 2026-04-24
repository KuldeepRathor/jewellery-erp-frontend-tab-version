import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/get_order_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_settlements/model/get_settlements_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';

class WebStoreSettlementsViewModel extends GetxController {
  final WebstoreRepository _webstoreRepository = WebstoreRepository();
  final headers =
      [
        'Date',
        'Count',
        "Total Online Amount",
        'Txn Charges',
        'Gst',
        'Settlement Amount',
        'Settlement Id',
        'Settlement Date',
        'Action',
      ].obs;
  final columnWidths =
      [0.45, 0.25, 0.45, 0.45, 0.45, 0.45, 0.75, 0.45, 0.35].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final RxBool isDrawerVisible = false.obs;

  GetWebStoreOrdersListResponse? selectedOrder;
  Future<void> showItemDetails({required String index}) async {
    isDrawerVisible.value = true;
  }

  void hideItemDetails() {
    isDrawerVisible.value = false;
  }

  final getPaginatedGetOrderSettlementListingResponse =
      Rx<ApiResponse<GetSettlementsListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;

  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  final Rx<DateTime?> dateFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> dateTo = Rx<DateTime?>(null);
  final RxList<int> selectedGatewayTypes = <int>[].obs;

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getSettlementsListing({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getPaginatedGetOrderSettlementListingResponse.value = ApiResponse.loading(
        "loading",
      );
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _webstoreRepository.getWebStoreSettlements(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
        dateFrom: dateFrom.value?.toIso8601String(),
        dateTo: dateTo.value?.toIso8601String(),
        gatewayType: selectedGatewayTypes.isEmpty ? null : selectedGatewayTypes,
      );

      if (resetList) {
        getPaginatedGetOrderSettlementListingResponse
            .value = ApiResponse.completed(response);
      } else {
        final currentData =
            getPaginatedGetOrderSettlementListingResponse.value.data?.values ??
            [];

        List<GetSettlementsListingValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;

        getPaginatedGetOrderSettlementListingResponse
            .value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.nextPage != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      if (resetList) {
        getPaginatedGetOrderSettlementListingResponse.value = ApiResponse.error(
          e.toString(),
        );
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getSettlementsListing();
    }
  }

  //
  void setSeachQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      // Simulating API call

      getSettlementsListing(resetList: true, isSearch: true);
    });
  }
}
