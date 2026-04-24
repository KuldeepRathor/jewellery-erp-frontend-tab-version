import 'dart:developer';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_listing/model/customer_pagination_response.dart';
import 'package:jewellery_erp_frontend_tab_version/services/customer_services.dart';

class CustomerListingRepository {
  final CustomerServices _customerServices = CustomerServices();
  Future<PaginatedGetCustomerListingDetailsResponse> getCustomerListingDetails({
    String? offsetId,
    int limit = 1,
    String query = '',
  }) async {
    log("The query will be r $query");
    final response = await _customerServices.getCustomerListingDetails(
      offsetId: offsetId,
      limit: limit,
      query: query,
    );
    // List<GetCustomerListingDetailsResponse> data = [];
    // for (var i = 0; i < response.length; i++) {
    //   GetCustomerListingDetailsResponse getCustomerListingDetailsResponse =
    //       GetCustomerListingDetailsResponse.fromJson(response[i]);
    //   data.add(getCustomerListingDetailsResponse);
    // }
    final data = PaginatedGetCustomerListingDetailsResponse.fromJson(response);
    return data;
  }
}
