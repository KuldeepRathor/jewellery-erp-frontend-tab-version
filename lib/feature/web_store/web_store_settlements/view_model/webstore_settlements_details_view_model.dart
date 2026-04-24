// Create new file: webstore_settlement_details_view_model.dart
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_settlements/model/get_settlements_details_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';

class WebStoreSettlementDetailsViewModel extends GetxController {
  final WebstoreRepository _webstoreRepository = WebstoreRepository();
  final String settlementId;

  WebStoreSettlementDetailsViewModel({required this.settlementId});

  final headers =
      [
        'Date',
        'Phone Number',
        'Customer Name',
        'Txn ID',
        'Txn Type',
        'Txn Amount',
        'Payment Mode',
        'Payment ID',
        'Txn Charges',
        'GST',
        'Settlement Amount',
        'Settlement ID',
        'Settlement Date',
      ].obs;

  final columnWidths =
      [0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4].obs;

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getSettlementDetailsResponse =
      Rx<ApiResponse<GetSettlementsDetailsListingResponse>>(
        ApiResponse.initial("Initial"),
      );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  @override
  void onInit() {
    super.onInit();
    getSettlementDetails(resetList: true);
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getSettlementDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getSettlementDetailsResponse.value = ApiResponse.loading("loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _webstoreRepository.getSettlementDetails(
        settlementId: settlementId,
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        getSettlementDetailsResponse.value = ApiResponse.completed(response);
      } else {
        final currentData =
            getSettlementDetailsResponse.value.data?.values ?? [];

        List<GetSettlementsDetailsListingValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;

        getSettlementDetailsResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.nextPage != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      if (resetList) {
        getSettlementDetailsResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getSettlementDetails();
    }
  }

  void setSeachQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      getSettlementDetails(resetList: true, isSearch: true);
    });
  }
}
