import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/party_details_adapter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';

class EstimationSearchPartyDropdown extends StatelessWidget {
  final EstimationSearchPartyController controller;
  final FocusNode? focusNode;

  const EstimationSearchPartyDropdown({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Obx(() {
          return PartyDropdownAdapter(
            label: 'Search Mobile Number',
            controller: controller.searchController.value,
            focusNode: focusNode ?? FocusNode(),
            items: const [],
            onSelected: (value) => _onItemSelected(value),
            validator: (value) {
              // if (controller.isRequired.value &&
              //     (value == null || value.isEmpty)) {
              //   return "Select Party";
              // }
              return null;
            },
            customOptionsBuilder: (textValue) async {
              if (textValue.text != ADD_NEW) {
                final searchText = textValue.text;

                controller.lastSearchQuery.value =
                    searchText; // Store the raw input separately
                await controller.searchParties(textValue.text);
              }
              // Map the search results to PartyDetails objects
              return controller.partyDetails
                  .map((party) => PartyDetails(party))
                  .toList()
                // Then add ADD_NEW as the last item in the list
                ..add(PartyDetails(ADD_NEW));
            },
          );
        });
      },
    );
  }

  Future<void> _onItemSelected(dynamic item) async {
    if (item is CustomerSearchValue || item is VendorSearchValue) {
      controller.setSelectedContact(item);
    } else if (item == ADD_NEW) {
      await Get.dialog(
        AddCustomerDialog(userData: controller.lastSearchQuery.value),
      );
      controller.searchController.value.text = "";
    }

    final EstimationItemDetailsController estimationItemDetailsController =
        Get.find<EstimationItemDetailsController>();
    estimationItemDetailsController.getLatestRowInFocus();
  }
}
