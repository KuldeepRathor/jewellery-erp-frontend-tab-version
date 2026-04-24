import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/cards/party_details_card.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_new_party_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/vendor_purchase/view_model/vendor_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';

class VendorDetailsWidget extends StatelessWidget {
  VendorDetailsWidget({
    super.key,
    required this.isPurchase,
    this.focusNode,
    this.nextFocusNode,
  });
  final bool isPurchase;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  final VendorDetailsController controller =
      Get.find<VendorDetailsController>();
  List<FocusNode> getIgnoreFocusList() {
    if (focusNode != null) {
      return [focusNode!];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent:
          (node, event) => onNormalKeyEvent(node, event, getIgnoreFocusList()),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 8),
              SearchDropdownMenu(
                controller: controller,
                isPurchase: isPurchase,
                focusNode: focusNode,
                nextFocusNode: nextFocusNode,
              ),
              const SizedBox(height: 28),
              CustomDashedLineWidget(width: Get.width),
              const SizedBox(height: 8),
              _buildPartyDetailsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const CustomText(
      text: 'Party Details',
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
  }

  Widget _buildPartyDetailsCard() {
    return Obx(
      () =>
          controller.selectedParty.value != null
              ? PartyDetailsCard(
                sundryDebtor:
                    // controller.selectedParty.value is CustomerSearchValue
                    //     ? (controller.selectedParty.value as CustomerSearchValue)
                    //             .name ??
                    //         'N/A'
                    //     :
                    (controller.selectedParty.value as VendorSearchValue)
                        .name ??
                    'N/A',
                sgst:
                    // controller.selectedParty.value is CustomerSearchValue
                    //     ? (controller.selectedParty.value as CustomerSearchValue)
                    //             .gstNumber ??
                    //         'N/A'
                    //     :
                    (controller.selectedParty.value as VendorSearchValue)
                        .gstNumber ??
                    'N/A',
                address:
                    // controller.selectedParty.value is CustomerSearchValue
                    //     ? (controller.selectedParty.value as CustomerSearchValue)
                    //             .address
                    //             ?.firstOrNull
                    //             ?.addressLine1 ??
                    //         'N/A'
                    //     :
                    (controller.selectedParty.value as VendorSearchValue)
                        .address
                        ?.firstOrNull
                        ?.addressLine1 ??
                    'N/A',
                onEditPressed: () {
                  final selectedParty = controller.selectedParty.value!;

                  // if (selectedParty is CustomerSearchValue) {
                  //   Get.dialog(AddCustomerDialog(customerId: selectedParty.id));
                  // } else
                  if (selectedParty is VendorSearchValue) {
                    Get.dialog(AddVendorDialog(vendorId: selectedParty.id));
                  }
                },
              )
              : const Center(child: Text('No party selected')),
    );
  }
}

class SearchDropdownMenu extends StatelessWidget {
  final VendorDetailsController controller;
  final bool isPurchase;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  const SearchDropdownMenu({
    super.key,
    required this.controller,
    required this.isPurchase,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
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
                  focusNode: focusNode,
                  requestFocusOnTap: true,
                  onSelected: (value) => _onItemSelected(value, isPurchase),
                  dropdownMenuEntries: _buildDropdownMenuEntries(),
                  width: constraints.maxWidth,
                  textStyle: const TextStyle(fontSize: 14),
                  menuStyle: MenuStyle(
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    maximumSize: WidgetStateProperty.all(
                      Size(constraints.maxWidth, 300),
                    ),
                  ),
                  inputDecorationTheme: const InputDecorationTheme(
                    constraints: BoxConstraints.tightFor(height: 38),
                  ),
                  hintText: "Search by name, phone, or code",
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> _onItemSelected(dynamic item, bool isPurchase) async {
    if (item is CustomerSearchValue || item is VendorSearchValue) {
      controller.setSelectedContact(item);

      final VendorBillDetailsController vendorBillDetailsController =
          Get.find<VendorBillDetailsController>();
      if (item is CustomerSearchValue) {
        if (isPurchase) {
          vendorBillDetailsController.fetchNextInvoiceNumber(
            invoiceType: "invoice_number_customer",
          );
        } else {
          vendorBillDetailsController.fetchNextInvoiceNumber(
            invoiceType: "return_invoice_number_customer",
          );
        }
      } else {
        if (isPurchase) {
          vendorBillDetailsController.fetchNextInvoiceNumber(
            invoiceType: "invoice_number_vendor",
          );
        } else {
          vendorBillDetailsController.fetchNextInvoiceNumber(
            invoiceType: "return_invoice_number_vendor",
          );
        }
      }
    } else if (item == 'add_new') {
      controller.searchController.value.text = "";
      await Get.dialog(const AddNewPartyDialog());
    }
    FocusManager.instance.primaryFocus?.nextFocus();
    if (nextFocusNode != null) {
      nextFocusNode?.requestFocus();
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
