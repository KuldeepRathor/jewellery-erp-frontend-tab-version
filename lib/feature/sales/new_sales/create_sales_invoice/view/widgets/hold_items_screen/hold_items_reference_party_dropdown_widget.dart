import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_new_party_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/hold_items_reference_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class HoldItemsReferencePartyDropdown extends StatelessWidget {
  final HoldItemsReferencePartyController controller;

  const HoldItemsReferencePartyDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Search Mobile Number",
              color: blackColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: constraints.maxWidth,
              height: 38,
              child: Obx(() {
                return Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: secondaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: secondaryColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: secondaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Focus(
                    autofocus: true,
                    canRequestFocus: false,
                    child: DropdownMenu<dynamic>(
                      controller: controller.searchController.value,

                      // enableFilter: true,
                      requestFocusOnTap: true,
                      onSelected: (value) => _onItemSelected(value),
                      dropdownMenuEntries: _buildDropdownMenuEntries(),
                      width: constraints.maxWidth,
                      textStyle: const TextStyle(fontSize: 14),
                      menuStyle: MenuStyle(
                        backgroundColor: const WidgetStatePropertyAll(
                          Colors.white,
                        ),
                        maximumSize: WidgetStateProperty.all(
                          Size(constraints.maxWidth, 300),
                        ),
                        alignment: const Alignment(-0.96, 1.0),
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        constraints: BoxConstraints.tightFor(height: 38),
                        fillColor: Colors.white,
                      ),
                      hintText: "Search by name, phone, or code",
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onItemSelected(dynamic item) async {
    if (item is CustomerSearchValue || item is VendorSearchValue) {
      controller.setSelectedContact(item);
      // final VendorBillDetailsController vendorBillDetailsController =
      //     Get.find<VendorBillDetailsController>();
      // if (item is CustomerSearchValue) {
      //   if (isPurchase) {
      //     vendorBillDetailsController.fetchNextInvoiceNumber(
      //         invoiceType: "invoice_number_customer");
      //   } else {
      //     vendorBillDetailsController.fetchNextInvoiceNumber(
      //         invoiceType: "return_invoice_number_customer");
      //   }
      // } else {
      //   if (isPurchase) {
      //     vendorBillDetailsController.fetchNextInvoiceNumber(
      //         invoiceType: "invoice_number_vendor");
      //   } else {
      //     vendorBillDetailsController.fetchNextInvoiceNumber(
      //         invoiceType: "return_invoice_number_vendor");
      //   }
      // }
    } else if (item == 'add_new') {
      controller.searchController.value.text = "";
      await Get.dialog(const AddNewPartyDialog());
    }
  }

  List<DropdownMenuEntry<dynamic>> _buildDropdownMenuEntries() {
    List<DropdownMenuEntry<dynamic>> entries =
        controller.partyDetails.map<DropdownMenuEntry<dynamic>>((
          dynamic partyDetails,
        ) {
          String label;
          String subtitle;
          if (partyDetails is CustomerSearchValue) {
            label =
                "${partyDetails.name ?? 'No Name'} - ${partyDetails.phoneNumber ?? 'No Phone'}";
            subtitle = "Customer";
          } else if (partyDetails is VendorSearchValue) {
            label =
                "${partyDetails.name ?? 'No Name'} - ${partyDetails.code ?? 'No Code'}";
            subtitle = "Vendor";
          } else {
            return const DropdownMenuEntry<dynamic>(
              value: null,
              label: 'Invalid Entry',
            );
          }
          return DropdownMenuEntry<dynamic>(
            value: partyDetails,
            label: label,
            leadingIcon: _buildLeadingIcon(partyDetails),
            trailingIcon: Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          );
        }).toList();

    entries.add(
      DropdownMenuEntry<String>(
        value: 'add_new',
        label: 'Add New',
        leadingIcon: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.add, color: primaryColor, size: 15),
        ),
      ),
    );

    return entries;
  }

  Widget _buildLeadingIcon(dynamic contact) {
    return CircleAvatar(
      radius: 14,
      backgroundColor:
          contact is CustomerSearchValue ? tertiaryColor : primaryColor,
      child: Text(
        contact is CustomerSearchValue ? "C" : "V",
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}
