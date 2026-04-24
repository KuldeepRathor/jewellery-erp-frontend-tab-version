// party_dropdown_adapter.dart

import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/res/constants/common_enums.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class PartyDetails {
  final dynamic party;

  PartyDetails(this.party);

  String get displayName {
    if (party is CustomerSearchValue) {
      final customer = party as CustomerSearchValue;
      return '${customer.name ?? '-'} (${customer.phoneNumber ?? '-'})';
    } else if (party is VendorSearchValue) {
      final vendor = party as VendorSearchValue;
      return '${vendor.name ?? '-'} (${vendor.code ?? '-'})';
    } else if (party == ADD_NEW) {
      return ADD_NEW;
    }
    return '-';
  }

  String get searchText {
    if (party is CustomerSearchValue) {
      return (party as CustomerSearchValue).name ?? '';
    } else if (party is VendorSearchValue) {
      return (party as VendorSearchValue).name ?? '';
    }
    return '';
  }

  Widget buildIcon() {
    String value;
    if (party is CustomerSearchValue) {
      value = "C";
    } else if (party is VendorSearchValue) {
      value = "V";
    } else {
      value = "+";
    }
    return CircleAvatar(
      radius: 12,
      backgroundColor:
          party is CustomerSearchValue ? tertiaryColor : primaryColor,
      child: Text(
        value,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }

  bool matchesSearch(String query) {
    if (party is CustomerSearchValue) {
      final customer = party as CustomerSearchValue;
      return (customer.name ?? '').toLowerCase().contains(query) ||
          (customer.phoneNumber ?? '').toLowerCase().contains(query);
    } else if (party is VendorSearchValue) {
      final vendor = party as VendorSearchValue;
      return (vendor.name ?? '').toLowerCase().contains(query) ||
          (vendor.code ?? '').toLowerCase().contains(query);
    }
    return false;
  }
}

class PartyDropdownAdapter extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<dynamic> items;
  final Function(dynamic) onSelected;
  final String? Function(String?)? validator;
  final String label;
  final Future<Iterable<PartyDetails>> Function(TextEditingValue)?
  customOptionsBuilder;

  final double width;

  const PartyDropdownAdapter({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.items,
    required this.onSelected,
    this.validator,
    required this.label,
    this.customOptionsBuilder,
    this.width = 450,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: blackColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        SizedBox(
          width: width,
          child: GenericAutocompleteDropdown<PartyDetails>(
            items: const [],
            isLastRow: true,
            controller: controller,
            onEditingComplete: () {},
            focusNode: focusNode,
            getDisplayValue: (item) => item.displayName,
            onSelected: (item) => onSelected(item.party),
            validator: validator,
            customOptionsBuilder: customOptionsBuilder,
            padding: const EdgeInsets.only(top: 8),
            itemBuilder:
                (item) => Row(
                  children: [
                    item.buildIcon(),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item.displayName, maxLines: 1)),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}
