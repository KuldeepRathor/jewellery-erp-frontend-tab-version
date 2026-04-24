import 'dart:developer';

import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/get_order_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/get_webstore_order_detail_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/pagination_get_order_list_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/webstore_order_dropdown_status_item.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/delivery_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/return_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/shipped_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/webstore_order_cancel_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/webstore_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:printing/printing.dart';

class WebStoreOrdersViewModel extends GetxController {
  final WebstoreRepository _webstoreRepository = WebstoreRepository();
  final AggregateRepository _aggregateRepository = AggregateRepository();

  final headers =
      [
        'Sn',
        'Order Date',
        'Order-ID',
        "Customer Name",
        'Address',
        'Total Weight',
        'Total Amount',
        'Status',
        'Invoice No',
        '',
        '',
      ].obs;
  final columnWidths =
      [0.1, 0.42, 0.38, 0.38, 0.7, 0.42, 0.42, 0.42, 0.42, 0.1, 0.1].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final RxBool isDrawerVisible = false.obs;

  GetWebStoreOrdersListResponse? selectedOrder;

  Future<void> showItemDetails({required String index}) async {
    // selectedItemIndex.value = index;
    // final item =
    //     getVendorListingDetailsResponse.value.data?.values?.elementAt(index);
    await getWebStoreOrderDetail(index);
    // TaggedItemDetailsImageUploadController
    //     taggedItemDetailsImageUploadController =
    //     Get.find<TaggedItemDetailsImageUploadController>();

    // final data =
    //     getOrnamentTypeListingResponse.value.data?.lineItems?.elementAt(index);
    // if (data != null && data.id != null) {
    //   // Set current line item ID and populate with its images
    //   taggedItemDetailsImageUploadController.populateWithFetchedData(data);
    // }
    isDrawerVisible.value = true;
  }

  void hideItemDetails() {
    isDrawerVisible.value = false;
  }

  void onReturnTapped(GetWebStoreOrdersListResponse orderDetails) {
    selectedOrder = orderDetails;
    // Show the return dialog
    Get.dialog(ReturnDialog(selectedOrderId: selectedOrder?.id)).then((_) {
      // Refresh the order list after dialog is closed
      getWebStoreOrderListing(resetList: true);
    });
  }

  void onDeliveryTapped(GetWebStoreOrdersListResponse orderDetails) {
    selectedOrder = orderDetails;
    // Show the return dialog
    Get.dialog(DeliveryDialog(selectedOrderId: selectedOrder?.id)).then((_) {
      // Refresh the order list after dialog is closed
      getWebStoreOrderListing(resetList: true);
    });
  }

  void onCancelTapped(GetWebStoreOrdersListResponse orderDetails) {
    selectedOrder = orderDetails;
    // Show the return dialog
    Get.dialog(
      WebstoreOrdersCancelledDialog(selectedOrderId: selectedOrder?.id),
    ).then((_) {
      // Refresh the order list after dialog is closed
      getWebStoreOrderListing(resetList: true);
    });
  }

  void markAsShipped(GetWebStoreOrdersListResponse orderDetails) {
    selectedOrder = orderDetails;
    log("Marking as shipped for order ID: ${selectedOrder?.id}");
    Get.dialog(OrdersShippedDialog(selectedOrderId: selectedOrder?.id)).then((
      _,
    ) {
      // Refresh the order list after dialog is closed
      getWebStoreOrderListing(resetList: true);
    });
  }

  final getWebStoreListingResponse =
      Rx<ApiResponse<PaginatedGetOrderListingResponse>>(
        ApiResponse.initial("Initial"),
      );
  final getStatusListingForWebStoreItemResponse =
      Rx<ApiResponse<List<WebStoreDropDownStatusItem>>>(
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

  Future<void> getWebStoreOrderListing({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);

      getWebStoreListingResponse.value = ApiResponse.loading("loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      // await Future.delayed(
      //   Durations.extralong4,
      // );
      final response = await _webstoreRepository.getOrderListing(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        getWebStoreListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getWebStoreListingResponse.value.data?.values ?? [];

        List<GetWebStoreOrdersListResponse> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;

        getWebStoreListingResponse.value = ApiResponse.completed(response);
      }
      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        if (response.pagination?.next != null) {
          lastOffsetId = response.pagination?.next!;
          // TODO: if next == null then dont send the lastoffsetid coz it will go in loop
        }
      }
    } catch (e) {
      if (resetList) {
        getWebStoreListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getWebStoreOrderListing();
    }
  }

  void setSeachQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      // Simulating API call

      getWebStoreOrderListing(resetList: true, isSearch: true);
    });
  }

  final getWebStoreOrderResponseById =
      Rx<ApiResponse<WebStoreOrderDetailByIdResponse>>(
        ApiResponse.initial("Initial"),
      );
  final onWebStoreStatusChangeResponse = Rx<ApiResponse<bool>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getWebStoreOrderDetail(String orderId) async {
    try {
      getWebStoreOrderResponseById.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));
      final response = await _webstoreRepository.getWebStoreOrderDetail(
        orderId,
      );

      // setCustomerData(response);
      getWebStoreOrderResponseById.value = ApiResponse.completed(response);
      update();
    } catch (e, stack) {
      log('Error getting webstore detail: $e $stack');
      getWebStoreOrderResponseById.value = ApiResponse.error(e.toString());
      // Get.snackbar("Error", "Failed to load customer");
      showErrorToast(message: "Failed to load webstore detail");
    }
  }

  Future<void> getWebStoreInvoicePdf(String invoiceId) async {
    try {
      // showLoadingToast(message: "Loading invoice...");

      final pdfBytes = await _aggregateRepository.getWebStoreInvoicePdf(
        invoiceId: invoiceId,
      );

      // Use printing package to display PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );

      showSuccessToast(message: "Invoice loaded successfully");
    } catch (e, stack) {
      log('Error getting webstore invoice PDF: $e $stack');
      showErrorToast(message: "Failed to load invoice");
    }
  }

  Future<bool?> onWebStoreStatusChange({
    required String? selectedOrderId,
    required String status,
    Map? shippedData,
    Map? returnData,
    Map? deliveredData,
    Map? cancelData,
  }) async {
    try {
      onWebStoreStatusChangeResponse.value = ApiResponse.loading("Loading");
      await Future.delayed(const Duration(seconds: 1));

      // Simply use the status ID directly
      final Map<String, dynamic> map = {"status": status};

      log("Status: $status");
      log("Selected Order ID: $selectedOrderId");

      if (status == "2") {
        map.addAll({"shipped_data": shippedData!});
      } else if (status == "3") {
        map.addAll({"delivered_data": deliveredData!});
      } else if (status == "4") {
        map.addAll({"return_data": returnData!});
      } else if (status == "5") {
        map.addAll({"cancel_data": cancelData!});
      }

      final response = await _webstoreRepository.onWebStoreStatusChange(
        selectedOrderId ?? "",
        map,
      );

      onWebStoreStatusChangeResponse.value = ApiResponse.completed(response);
      if (ApiResponse.completed(response).status == Status.COMPLETED) {
        return true;
      }
    } catch (e, stack) {
      log('Error getting webstore: $e $stack');
      onWebStoreStatusChangeResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to update order status");
    }
    return null;
  }
}
