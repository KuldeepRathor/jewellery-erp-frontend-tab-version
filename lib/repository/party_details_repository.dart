import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/services/party_details_services.dart';

class PartyDetailsRepository {
  final PartyDetailsServices partyDetailsServices = PartyDetailsServices();
  Future<CustomerSearchModel> searchCustomer(String query) async {
    final response = await partyDetailsServices.searchCustomers(query);
    return CustomerSearchModel.fromJson(response);
  }

  Future<VendorSearchModel> searchVendor(String query) async {
    final response = await partyDetailsServices.searchVendors(query);
    return VendorSearchModel.fromJson(response);
  }
}
