import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/model/get_approval_issue_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/cards/party_details_card.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_new_party_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view_model/approval_receipt_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_calendar.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';

class ApprovalReceiptPartyDetailsWidget extends StatefulWidget {
  const ApprovalReceiptPartyDetailsWidget({
    super.key,
    required this.isPurchase,
    this.focusNode,
    this.nextFocusNode,
  });
  final bool isPurchase;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  @override
  State<ApprovalReceiptPartyDetailsWidget> createState() =>
      _ApprovalReceiptPartyDetailsWidgetState();
}

class _ApprovalReceiptPartyDetailsWidgetState
    extends State<ApprovalReceiptPartyDetailsWidget> {
  final ApprovalReceiptPartyDetailsController controller =
      Get.put<ApprovalReceiptPartyDetailsController>(
        ApprovalReceiptPartyDetailsController(),
      );

  final FocusNode approvalDateFocusNode = FocusNode();

  final FocusNode approvalIssueFocusNode = FocusNode();

  final FocusNode fetchButtonFocusNode = FocusNode();

  List<FocusNode> getIgnoreFocusList() {
    if (widget.focusNode != null) {
      return [
        widget.focusNode!,
        approvalDateFocusNode,
        approvalIssueFocusNode,
        fetchButtonFocusNode,
      ];
    } else {
      return [
        approvalDateFocusNode,
        approvalIssueFocusNode,
        fetchButtonFocusNode,
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    controller.setDefaultDate();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space &&
              approvalDateFocusNode.hasFocus) {
            // Open date picker when space is pressed on approval date field
            controller.selectDate(context, controller.approvalDateController);
            return KeyEventResult.handled;
          }
        }
        return onNormalKeyEvent(node, event, getIgnoreFocusList());
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      text: "Approval Receipt Number",
                                      color: primaryTextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    const SizedBox(height: 4),
                                    Obx(
                                      () => Container(
                                        height: 38,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: grey1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              CustomText(
                                                text:
                                                    controller
                                                        .approvalReceiptNumber
                                                        .value,
                                                fontSize: 16,
                                                fontFamily: 'Satoshi',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: SearchDropdownMenu(
                            controller: controller,
                            isPurchase: widget.isPurchase,
                            // focusNode: widget.focusNode,
                            nextFocusNode: approvalDateFocusNode,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CustomDateField(
                                                focusNode:
                                                    approvalDateFocusNode,
                                                controller:
                                                    controller
                                                        .approvalDateController,
                                                labelText: "Approval Date",
                                                onTap:
                                                    (
                                                      context,
                                                    ) => controller.selectDate(
                                                      context,
                                                      controller
                                                          .approvalDateController,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // In the ApprovalReceiptPartyDetailsWidget class
                        // Replace the existing approval issue number dropdown implementation with this
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: "Approval Issue Number",
                                color: primaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                              // Using generic autocomplete dropdown for approval issue numbers
                              Obx(() {
                                return SizedBox(
                                  width: Get.width * .2,
                                  child: GenericAutocompleteDropdown<
                                    GetApprovalIssueNumberValue
                                  >(
                                    controller:
                                        controller
                                            .approvalIssueSearchController
                                            .value,
                                    focusNode:
                                        controller.approvalIssueFocusNode,
                                    items: const [],
                                    getDisplayValue:
                                        (approvalIssue) =>
                                            approvalIssue.approvalIssueNumber ??
                                            '',
                                    onSelected: (value) async {
                                      controller.setSelectedApprovalIssue(
                                        value,
                                      );
                                    },
                                    customOptionsBuilder: (
                                      textEditingValue,
                                    ) async {
                                      await controller
                                          .searchApprovalIssueNumbers(
                                            textEditingValue.text,
                                          );
                                      return controller.approvalIssueOptions
                                          .toList();
                                    },
                                    borderColor: secondaryColor,
                                    isLastRow: true,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const CustomDashedLineWidget(width: double.infinity),
                    const SizedBox(height: 8),
                    _buildPartyDetailsCard(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
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
                    controller.selectedParty.value is CustomerSearchValue
                        ? (controller.selectedParty.value
                                    as CustomerSearchValue)
                                .name ??
                            'N/A'
                        : (controller.selectedParty.value as VendorSearchValue)
                                .name ??
                            'N/A',
                sgst:
                    controller.selectedParty.value is CustomerSearchValue
                        ? (controller.selectedParty.value
                                    as CustomerSearchValue)
                                .gstNumber ??
                            'N/A'
                        : (controller.selectedParty.value as VendorSearchValue)
                                .gstNumber ??
                            'N/A',
                address: _getFormattedAddress(),
                onEditPressed: () {
                  final selectedParty = controller.selectedParty.value!;

                  // Add debug information
                  log("Selected party type: ${selectedParty.runtimeType}");
                  log(
                    "Is CustomerSearchValue: ${selectedParty is CustomerSearchValue}",
                  );
                  log(
                    "Is VendorSearchValue: ${selectedParty is VendorSearchValue}",
                  );

                  if (selectedParty is CustomerSearchValue) {
                    log("Opening customer dialog with ID: ${selectedParty.id}");
                    Get.dialog(AddCustomerDialog(customerId: selectedParty.id));
                  } else if (selectedParty is VendorSearchValue) {
                    log("Opening vendor dialog with ID: ${selectedParty.id}");
                    Get.dialog(AddVendorDialog(vendorId: selectedParty.id));
                  } else {
                    log("Unknown party type: ${selectedParty.runtimeType}");
                  }
                },
              )
              : const Center(child: Text('No party selected')),
    );
  }

  String _getFormattedAddress() {
    if (controller.selectedParty.value == null) {
      return 'N/A';
    }

    List<Address>? addresses;
    if (controller.selectedParty.value is CustomerSearchValue) {
      addresses =
          (controller.selectedParty.value as CustomerSearchValue).address;
    } else if (controller.selectedParty.value is VendorSearchValue) {
      addresses = (controller.selectedParty.value as VendorSearchValue).address;
    }

    if (addresses == null || addresses.isEmpty) {
      return 'N/A';
    }

    // Find default address first
    Address? defaultAddress = addresses.firstWhere(
      (address) => address.isDefault == true,
      orElse: () => addresses!.first,
    );

    List<String> addressParts = [];
    if (defaultAddress.addressLine1 != null &&
        defaultAddress.addressLine1!.isNotEmpty) {
      addressParts.add(defaultAddress.addressLine1!);
    }
    if (defaultAddress.addressLine2 != null &&
        defaultAddress.addressLine2!.isNotEmpty) {
      addressParts.add(defaultAddress.addressLine2!);
    }
    if (defaultAddress.city != null && defaultAddress.city!.isNotEmpty) {
      addressParts.add(defaultAddress.city!);
    }
    if (defaultAddress.state != null && defaultAddress.state!.isNotEmpty) {
      addressParts.add(defaultAddress.state!);
    }
    if (defaultAddress.pincode != null && defaultAddress.pincode!.isNotEmpty) {
      addressParts.add(defaultAddress.pincode!);
    }

    return addressParts.isEmpty ? 'N/A' : addressParts.join(', ');
  }
}

class SearchDropdownMenu extends StatelessWidget {
  final ApprovalReceiptPartyDetailsController controller;
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
        return Column(
          children: [
            const SizedBox(height: 24),
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
                      focusNode: focusNode,

                      controller: controller.searchController.value,
                      // enableFilter: true,
                      requestFocusOnTap: true,
                      onSelected: (value) => _onItemSelected(value, isPurchase),
                      dropdownMenuEntries: _buildDropdownMenuEntries(),
                      width: constraints.maxWidth,
                      textStyle: const TextStyle(fontSize: 14),
                      menuStyle: MenuStyle(
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
            ),
          ],
        );
      },
    );
  }

  Future<void> _onItemSelected(dynamic item, bool isPurchase) async {
    if (item is CustomerSearchValue || item is VendorSearchValue) {
      controller.setSelectedContact(item);
      final VendorBillDetailsController vendorBillDetailsController =
          Get.find<VendorBillDetailsController>();

      if (nextFocusNode != null) {
        nextFocusNode!.requestFocus();
      }

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
