// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/get_account_mapping_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_types_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view_model/add_vendor_tabbar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/error_message.dart';

class NextTabIntent extends Intent {
  const NextTabIntent();
}

class NextFocusAction extends Intent {
  const NextFocusAction();
}

class PreviousFocusAction extends Intent {
  const PreviousFocusAction();
}

class GSTDetailsWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormState> gstKey;
  final TextEditingController gstController;
  final TextEditingController codeController;
  final TextEditingController storeNameController;
  final TextEditingController address1Controller;
  final TextEditingController address2Controller;
  final TextEditingController cityController;
  final TextEditingController pinCodeController;
  final TextEditingController panController;
  final TextEditingController percentageController;
  final TextEditingController ledgerController;

  final List<VendorType> selectedVendorTypes;

  final String selectedDeduction;

  final List<String> deductionItems;
  final Function(List<VendorType>) onVendorTypeChanged;
  final Function(AccountMapping) onLedgerChanged;
  final Function(String?) onDeductionChanged;

  final bool isLoading;
  final bool detailsFetched;
  final VoidCallback fetchGSTDetails;
  final String? vendorId;

  const GSTDetailsWidget({
    super.key,
    required this.formKey,
    required this.gstKey,
    required this.gstController,
    required this.codeController,
    required this.storeNameController,
    required this.address1Controller,
    required this.address2Controller,
    required this.cityController,
    required this.pinCodeController,
    required this.panController,
    required this.percentageController,
    required this.selectedVendorTypes,
    required this.selectedDeduction,
    required this.deductionItems,
    required this.onVendorTypeChanged,
    required this.onLedgerChanged,
    required this.onDeductionChanged,
    required this.isLoading,
    required this.detailsFetched,
    required this.fetchGSTDetails,
    this.vendorId,
    required this.ledgerController,
  });

  @override
  State<GSTDetailsWidget> createState() => _GSTDetailsWidgetState();
}

class _GSTDetailsWidgetState extends State<GSTDetailsWidget> {
  late List<FocusNode> focusNodes;
  int currentFocusIndex = 0;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final FocusNode ledgerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(13, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    _focusScopeNode.dispose();
    super.dispose();
  }

  // KeyEventResult _handleKeyPress(FocusNode node, KeyEvent event) {
  //   if (event is KeyDownEvent) {
  //     if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
  //       _moveFocus(1);
  //       return KeyEventResult.handled;
  //     } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
  //       _moveFocus(-1);
  //       return KeyEventResult.handled;
  //     } else if (event.logicalKey == LogicalKeyboardKey.tab) {
  //       _moveFocus(HardwareKeyboard.instance.isShiftPressed ? -1 : 1);
  //       return KeyEventResult.handled;
  //     }
  //   }
  //   return KeyEventResult.ignored;
  // }

  // void _moveFocus(int step) {
  //   setState(() {
  //     currentFocusIndex = (currentFocusIndex + step) % focusNodes.length;
  //     if (currentFocusIndex < 0) currentFocusIndex += focusNodes.length;
  //     FocusScope.of(context).requestFocus(focusNodes[currentFocusIndex]);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final addVendorTabController = Get.find<AddVendorTabController>();
    return FocusScope(
      node: _focusScopeNode,
      autofocus: true,
      onKeyEvent: onNormalKeyEvent,
      child: Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const NextTabIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            NextTabIntent: CallbackAction<NextTabIntent>(
              onInvoke:
                  (NextTabIntent intent) =>
                      addVendorTabController.nextTab(null),
            ),
          },
          child: SingleChildScrollView(
            child: Form(
              key: widget.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * .02),
                  // const CustomText(
                  //   text: "GST",
                  //   color: primaryTextColor,
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 16,
                  // ),
                  // SizedBox(height: Get.height * .02),
                  // _buildGSTInput(addVendorTabController),
                  SizedBox(height: Get.height * .02),
                  _buildVendorDetails(addVendorTabController),
                  SizedBox(height: Get.height * .02),
                  _buildAddressDetails(addVendorTabController),
                  SizedBox(height: Get.height * .02),
                  _buildCityInput(addVendorTabController),
                  SizedBox(height: Get.height * .02),
                  _buildLegalDetails(addVendorTabController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGSTInput(AddVendorTabController addVendorTabController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: widget.gstKey,
          child: Column(
            children: [
              SizedBox(
                width: Get.width * .2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "GST Details",
                      color: blackColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    Obx(
                      () => CustomText(
                        text:
                            addVendorTabController
                                .gstDetailsResponse
                                .value
                                .data
                                ?.gst_type ??
                            '-',
                        color: secondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              CustomTextField(
                controller: widget.gstController,
                // autofocus: true,
                width: Get.width * .2,
                onChanged: (value) {
                  // Capitalize the input and update the controller
                  final capitalizedValue = value.toUpperCase();
                  final currentCursorPosition =
                      widget.gstController.selection.baseOffset;
                  widget.gstController.value = TextEditingValue(
                    text: capitalizedValue,
                    selection: TextSelection.collapsed(
                      offset: currentCursorPosition,
                    ),
                  );
                  addVendorTabController
                      .gstDetailsResponse
                      .value = ApiResponse.initial("Initial");
                  addVendorTabController.checkGSTAvailability(capitalizedValue);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter GST number';
                  }
                  if (!RegExp(
                    r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}$',
                  ).hasMatch(value)) {
                    return 'Invalid GST number format';
                  }
                  if (!addVendorTabController.isGSTAvailable.value) {
                    return 'This GST number is already registered';
                  }
                  return null;
                },
                suffixIcon: Obx(() {
                  if (addVendorTabController.isCheckingGST.value) {
                    return const SizedBox(
                      width: 10,
                      height: 10,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 4),
                      ),
                    );
                  }
                  if (widget.gstController.text.isNotEmpty &&
                      addVendorTabController.isGSTAvailable.value) {
                    return const Icon(Icons.check_circle, color: Colors.green);
                  }
                  if (!addVendorTabController.isGSTAvailable.value) {
                    return const Icon(Icons.error, color: Colors.red);
                  }
                  return const SizedBox.shrink();
                }),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            const CustomText(text: ""),
            const SizedBox(height: 4),
            Obx(
              () => Row(
                children: [
                  CustomButton1(
                    buttonName: 'Fetch Details',
                    isLoading:
                        addVendorTabController
                            .gstDetailsResponse
                            .value
                            .status ==
                        Status.LOADING,
                    onTap: () {
                      addVendorTabController.gstDetailsResponse.value.status ==
                              Status.LOADING
                          ? null
                          : widget.fetchGSTDetails();
                    },
                  ),
                  const SizedBox(width: 4),
                  Visibility(
                    visible:
                        addVendorTabController
                            .gstDetailsResponse
                            .value
                            .status ==
                        Status.ERROR,
                    child: ErrorMessageWidget(
                      message:
                          addVendorTabController
                              .gstDetailsResponse
                              .value
                              .message ??
                          "Something went wrong",
                    ),
                  ),
                  // Visibility(
                  //   visible: addVendorTabController
                  //           .gstDetailsResponse.value.status ==
                  //       Status.ERROR,
                  //   child: CustomText(
                  //     text: addVendorTabController
                  //             .gstDetailsResponse.value.message ??
                  //         "Something went wrong",
                  //     color: Colors.red,
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVendorDetails(AddVendorTabController addVendorTabController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => CustomTextField(
            controller: addVendorTabController.codeController,
            // focusNode: focusNodes[2],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofocus: true,
            name: 'Enter Code',
            readOnly: widget.vendorId == null ? false : true,
            width: Get.width * .2,
            onChanged: (value) {
              log("Because Onchaged");
              final capitalizedValue = value.toUpperCase();
              final currentCursorPosition =
                  addVendorTabController.codeController.selection.baseOffset;
              addVendorTabController.codeController.value = TextEditingValue(
                text: capitalizedValue,
                selection: TextSelection.collapsed(
                  offset: currentCursorPosition,
                ),
              );
              addVendorTabController.checkCodeAvailability(capitalizedValue);
            },
            validator:
                addVendorTabController.isCodeAvailable.value == false
                    ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Code is required';
                      }
                      if (!addVendorTabController.isCodeAvailable.value) {
                        return 'This code is already taken';
                      }
                      return null;
                    }
                    : (value) {
                      if (value == null || value.isEmpty) {
                        return 'Code is required';
                      }
                      return null;
                    },
            suffixIcon: Obx(() {
              if (addVendorTabController.isCheckingCode.value) {
                return const SizedBox(
                  width: 10,
                  height: 10,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 4),
                  ),
                );
              }
              if ((addVendorTabController.codeController.text.isNotEmpty &&
                      addVendorTabController.isCodeAvailable.value) ||
                  widget.vendorId != null) {
                return const Icon(Icons.check_circle, color: Colors.green);
              }
              if (!addVendorTabController.isCodeAvailable.value) {
                return const Icon(Icons.error, color: Colors.red);
              }

              return const SizedBox.shrink();
            }),
          ),
        ),
        const SizedBox(width: 16),
        CustomTextField(
          controller: widget.storeNameController,
          // focusNode: focusNodes[3],
          name: 'Store Name',
          width: Get.width * .2,
          validator: (value) {
            if (((value == null || value.isEmpty))) {
              return 'Store name is required';
            }
            return null;
          },
        ),
        const SizedBox(width: 16),
        // Obx(
        //   () {
        //     final vendorTypes = addVendorTabController
        //             .vendorTypesResponse.value.data?.vendorTypes ??
        //         [];
        //     return CustomMultiSelectDropdown(
        //       name: 'Vendor Type',
        //       width: Get.width * .2,
        //       items: vendorTypes.map((vt) => vt.vendorType ?? '').toList(),
        //       selectedItems: widget.selectedVendorTypes
        //           .map((vt) => vt.vendorType ?? '')
        //           .toList(),
        //       onChanged: (List<String> newSelection) {
        //         final newSelectedVendorTypes = newSelection
        //             .map((s) =>
        //                 vendorTypes.firstWhere((vt) => vt.vendorType == s))
        //             .toList();
        //         widget.onVendorTypeChanged(newSelectedVendorTypes);
        //       },
        //       validator: (List<String>? values) {
        //         if (values == null || values.isEmpty) {
        //           return "Select Vendor Type";
        //         }
        //         return null;
        //       },
        //       displayStringForOption: (value) => value,
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildAddressDetails(AddVendorTabController addVendorTabController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: addVendorTabController.address1Controller,
          // focusNode: focusNodes[5],
          name: 'Address Line 1',
          width: Get.width * .2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Address is required';
            }
            return null;
          },
        ),
        const SizedBox(width: 16),
        CustomTextField(
          controller: addVendorTabController.address2Controller,
          // focusNode: focusNodes[6],
          name: 'Address Line 2',
          width: Get.width * .2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Address is required';
            }
            return null;
          },
        ),
        const SizedBox(width: 16),
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          ],
          controller: addVendorTabController.pinCodeController,
          // focusNode: focusNodes[7],
          name: 'PIN Code',
          width: Get.width * .2,
          onChanged: (value) {
            addVendorTabController.checkPinCodeAndSetCity(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'PIN Code is required';
            }
            if (value.length != 6) {
              return "Invalid PIN code length";
            }
            // if (!addVendorTabController.isPinCodeValid.value) {
            //   return "Invalid PIN code";
            // }
            return null;
          },
          suffixIcon: Obx(() {
            if (addVendorTabController.isCheckingPinCode.value) {
              return const SizedBox(
                width: 10,
                height: 10,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 4),
                ),
              );
            }
            if (!addVendorTabController.isPinCodeValid.value &&
                addVendorTabController.pinCodeController.text.length == 6) {
              return const Icon(Icons.error, color: Colors.red);
            }
            if (addVendorTabController.isPinCodeValid.value &&
                addVendorTabController.pinCodeController.text.length == 6) {
              return const Icon(Icons.check_circle, color: Colors.green);
            }
            return const SizedBox.shrink();
          }),
        ),
      ],
    );
  }

  Widget _buildCityInput(AddVendorTabController addVendorTabController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: addVendorTabController.stateController,
          // focusNode: focusNodes[8],
          name: 'State',
          width: Get.width * .2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'State is required';
            }
            if (addVendorTabController.gstDetailsResponse.value.data?.state !=
                null) {
              final gstState =
                  addVendorTabController.gstDetailsResponse.value.data!.state;
              if (value.toLowerCase().trim() !=
                  gstState!.toLowerCase().trim()) {
                return 'State doesn\'t match GST details ($gstState)';
              }
            }
            return null;
          },
          onChanged: (value) {
            // Trigger form validation to update state mismatch error if needed
            addVendorTabController.formKey.currentState?.validate();
          },
        ),
        const SizedBox(width: 16),
        CustomTextField(
          controller: addVendorTabController.cityController,
          // focusNode: focusNodes[8],
          name: 'City',
          width: Get.width * .2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'City is required';
            }
            return null;
          },
        ),
        const SizedBox(width: 16),
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          ],
          // focusNode: _phoneNumberFocus,
          controller: addVendorTabController.phoneNumberController,
          name: 'Phone Number',
          width: Get.width * .2,
          focusNode: addVendorTabController.phoneNoFocusNode,
          onChanged: (value) {
            // Remove any non-digit characters
            String cleanedValue = value.replaceAll(RegExp(r'\D'), '');
            if (cleanedValue.length == 10) {
              addVendorTabController.checkPhoneAvailability(cleanedValue);
            }
          },

          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required';
            }
            String cleanedNumber = value.replaceAll(RegExp(r'\D'), '');
            if (cleanedNumber.length != 10) {
              return 'Enter a valid 10-digit phone number';
            }
            if (!addVendorTabController.isPhoneAvailable.value) {
              return 'This phone number is already registered';
            }
            return null;
          },
          suffixIcon: Obx(() {
            if (addVendorTabController.isCheckingPhone.value) {
              return const SizedBox(
                width: 10,
                height: 10,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 4),
                ),
              );
            }
            if (addVendorTabController.phoneNumberController.text.length ==
                    10 &&
                addVendorTabController.isPhoneAvailable.value) {
              return const Icon(Icons.check_circle, color: Colors.green);
            }
            if (!addVendorTabController.isPhoneAvailable.value) {
              return const Icon(Icons.error, color: Colors.red);
            }
            return const SizedBox.shrink();
          }),
        ),
      ],
    );
  }

  Widget _buildLegalDetails(AddVendorTabController addVendorTabController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Legal",
          color: primaryTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        SizedBox(height: Get.height * .02),
        _buildGSTInput(addVendorTabController),
        SizedBox(height: Get.height * .02),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: widget.panController, // focusNode: focusNodes[9],
              name: 'PAN No.',
              width: Get.width * .2,
              // hintText: "ILWPK0000F",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'PAN number is required';
                }
                if (!isValidPAN(value)) {
                  return 'Invalid PAN number format';
                }
                return null;
              },
            ),
            const SizedBox(width: 16),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     const CustomText(
            //       text: "Ledger",
            //       color: blackColor,
            //       fontWeight: FontWeight.w700,
            //       fontSize: 12,
            //     ),
            //     Obx(
            //       () {
            //         final ledgerList = addVendorTabController
            //                 .ledgerListResponse.value.data?.values ??
            //             [];
            //         return SizedBox(
            //           width: 200,
            //           child: GenericAutocompleteDropdown<AccountMapping>(
            //             items: ledgerList,
            //             isLastRow: true,
            //             onSelected: (AccountMapping? newSelection) {
            //               if (newSelection != null) {
            //                 widget.onLedgerChanged(
            //                     newSelection); // Update to handle single selection
            //                 ledgerFocusNode.requestFocus();
            //               }
            //             },
            //             validator: (String? value) {
            //               if (value == null || value.isEmpty) {
            //                 return "Select Ledger";
            //               }
            //               return null;
            //             },
            //             controller: widget.ledgerController,
            //             focusNode: FocusNode(),
            //             getDisplayValue: (AccountMapping value) {
            //               return value.groupName ?? "-";
            //             },
            //           ),
            //         );
            //       },
            //     ),
            //   ],
            // ),
            // const SizedBox(width: 16),
            CustomDropdownField(
              focusNode: ledgerFocusNode,
              name: 'Deduction',
              // focusNode: focusNodes[11],
              width: Get.width * .1,
              items: widget.deductionItems,
              selectedItem: widget.selectedDeduction,
              onChanged: widget.onDeductionChanged,
            ),
            const SizedBox(width: 16),
            CustomTextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              controller: widget.percentageController,
              // focusNode: focusNodes[12],
              name: '',
              width: Get.width * .1,
              hintText: "Percentage",
              validator: (value) {
                if (widget.selectedDeduction != 'None') {
                  if (value == null || value.isEmpty) {
                    return 'Percentage is required for TCS/TDS';
                  }
                  final percentage = double.tryParse(value);
                  if (percentage == null) {
                    return 'Enter a valid percentage';
                  }
                  if (percentage < 0 || percentage > 100) {
                    return 'Percentage must be between 0 and 100';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
