import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/ledger_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/view/widgets/party_details_adapter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/view_model/account_receipt_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_date_field_picker_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class AccountReceiptDetailsWidget extends StatefulWidget {
  const AccountReceiptDetailsWidget({super.key});

  @override
  State<AccountReceiptDetailsWidget> createState() =>
      _AccountReceiptDetailsWidgetState();
}

class _AccountReceiptDetailsWidgetState
    extends State<AccountReceiptDetailsWidget> {
  final FocusNode partyFocusNode = FocusNode();
  final FocusNode selfFocusNode = FocusNode();
  final FocusNode dateFocusNode = FocusNode();

  final AccountReceiptViewmodel accountReceiptViewmodel = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      partyFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                return PartyDropdownAdapter(
                                  label: 'Search Party Name/Phone/Code',
                                  controller: TextEditingController(
                                    text:
                                        accountReceiptViewmodel
                                                    .selectedVendorParty
                                                    .value !=
                                                null
                                            ? PartyDetails(
                                              accountReceiptViewmodel
                                                  .selectedVendorParty
                                                  .value,
                                            ).searchText
                                            : '',
                                  ),
                                  focusNode: partyFocusNode,
                                  items: const [],
                                  onSelected: (newSelection) {
                                    accountReceiptViewmodel
                                        .onVendorPartyChanged(newSelection);
                                    selfFocusNode.requestFocus();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Select Party";
                                    }
                                    return null;
                                  },
                                  customOptionsBuilder: (textValue) async {
                                    await accountReceiptViewmodel
                                        .fetchPartyItems(query: textValue.text);
                                    var list =
                                        accountReceiptViewmodel
                                            .partyListResponse
                                            .value
                                            .data ??
                                        [];

                                    return list.toList().map(
                                      (e) => PartyDetails(e),
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              color: grey2,
                              height: 60,
                              width: 2,
                            ),
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Obx(() {
                          //       return Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const CustomText(
                          //             text: 'Choose From Account',
                          //             color: blackColor,
                          //             fontWeight: FontWeight.w700,
                          //             fontSize: 12,
                          //           ),
                          //           SizedBox(
                          //             width: 300,
                          //             child: GenericAutocompleteDropdown<
                          //                 PosAccount>(
                          //               items:
                          //                   accountReceiptViewmodel.posAccounts,
                          //               isLastRow: true,
                          //               controller: TextEditingController(
                          //                 text: accountReceiptViewmodel
                          //                         .selectedSelfParty
                          //                         .value
                          //                         ?.name ??
                          //                     '',
                          //               ),
                          //               focusNode: selfFocusNode,
                          //               getDisplayValue: (PosAccount item) =>
                          //                   item.name,
                          //               onSelected: (PosAccount newSelection) {
                          //                 accountReceiptViewmodel
                          //                     .onSelfPartyChanged(newSelection);
                          //                 dateFocusNode.requestFocus();
                          //               },
                          //               validator: (value) {
                          //                 if (value == null || value.isEmpty) {
                          //                   return "Select POS Account";
                          //                 }
                          //                 return null;
                          //               },
                          //               itemBuilder: (PosAccount item) => Row(
                          //                 children: [
                          //                   const CircleAvatar(
                          //                     radius: 12,
                          //                     backgroundColor: primaryColor,
                          //                     child: Text(
                          //                       "P",
                          //                       style: TextStyle(
                          //                         fontSize: 10,
                          //                         color: Colors.white,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   const SizedBox(width: 8),
                          //                   Text(item.name),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       );
                          //     }),
                          //   ],
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 16),
                          //   child: Container(
                          //     color: grey2,
                          //     height: 60,
                          //     width: 2,
                          //   ),
                          // ),
                          GenericDateField(
                            label: "Entry Date",
                            width: 300,
                            focusNode: dateFocusNode,
                            controller:
                                accountReceiptViewmodel.paymentDateController,
                            onDateSelect: (context, controller) async {
                              await accountReceiptViewmodel.selectDate(
                                context,
                                controller,
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Entry Date missing";
                              }
                              return null;
                            },
                            labelColor: primaryTextColor,
                            focusedIconColor: secondaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        final detail =
                            accountReceiptViewmodel
                                .getPartyDetailsResponse
                                .value
                                .data
                                ?.vendor;
                        return LedgerDetailsWidget(
                          bankDetails:
                              detail?.bankDetails?.firstOrNull?.ifsc_code ??
                              "-",
                          ledgerName: detail?.name ?? "-",
                          gst: detail?.gstNumber ?? "-",
                          address:
                              "${detail?.address?.firstOrNull?.addressLine1 ?? '-'} ${detail?.address?.firstOrNull?.addressLine2 ?? '-'}",
                          outstandingCR: '₹80,000',
                          outstandingDR: '₹4,000',
                        );
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(color: grey2, height: 150, width: 2),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CustomText(
                            text: "Receipt Number",
                            fontSize: 12,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => CustomText(
                              text: accountReceiptViewmodel.paymentNumber.value,
                              fontSize: 16,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
