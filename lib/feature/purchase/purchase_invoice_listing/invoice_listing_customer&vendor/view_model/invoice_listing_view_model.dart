import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/model/purchase_invoice_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view_model/other_service_purchase_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view_model/vendor_purchase_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';

class InvoiceListingViewModel extends GetxController {
  final BaseFilterController filterController = Get.put(BaseFilterController());
  final OtherServicePurchaseListingViewmodel
  otherServicePurchaseListingController =
      Get.find<OtherServicePurchaseListingViewmodel>();
  final VendorPurchaseListingViewmodel vendorPurchaseListingController =
      Get.find<VendorPurchaseListingViewmodel>();

  @override
  void onInit() {
    super.onInit();

    filterController.resetAllFilters();

    filterController.fetchAllDropdownData(
      filterTypes: [
        'metalType',
        'dateRange',
        'transactionTypes',
        'paymentStatus',
        'invoiceStatus',
        'ornament',
      ],
    );
  }

  PurchaseInvoiceListingRequest createRequestFormFilters() {
    return PurchaseInvoiceListingRequest(
      metalType:
          filterController.selectedMetalTypes.isNotEmpty
              ? filterController.selectedMetalTypes
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      dateFrom: filterController.dateFrom.value,
      dateTo: filterController.dateTo.value,
      ornamentType:
          filterController.selectedOrnaments.isNotEmpty
              ? filterController.selectedOrnaments
                  .where((item) => item.id != null)
                  .map((item) => item.id!)
                  .toList()
              : null,
      paymentStatus: filterController.selectedPaymentStatus.value?.value,
      invoiceStatus: filterController.selectedInvoiceStatus.value?.value,
      transactionType: filterController.selectedTransactionTypes.value?.value,
    );
  }

  void applyFilters() {
    // Create request from filters
    final requestBody = createRequestFormFilters();

    // Call API with the filter request
    vendorPurchaseListingController.getPurchaseInvoice(
      isSearch: false,
      resetList: true,
      requestBody: requestBody,
    );

    otherServicePurchaseListingController.getCustomerPurchaseInvoice(
      isSearch: false,
      resetList: true,
      requestBody: requestBody,
    );
  }
}
