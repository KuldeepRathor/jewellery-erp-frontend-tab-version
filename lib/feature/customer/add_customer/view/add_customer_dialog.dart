import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_country_code_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view_model/customer_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_calendar.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dropdown_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/error_message.dart';

class AddSaveIntent extends Intent {
  const AddSaveIntent();
}

class AddCustomerDialog extends StatefulWidget {
  final String? customerId;
  final String? userData;

  const AddCustomerDialog({super.key, this.customerId, this.userData});

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final CustomerController customerController = Get.put(CustomerController());
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _deductionFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    // Set the customer ID in controller if editing
    customerController.currentCustomerId = widget.customerId;

    if (widget.customerId != null) {
      customerController.getCustomerById(widget.customerId ?? "");
    }

    if (widget.userData != null) {
      if (isPhoneNumber(widget.userData!)) {
        customerController.phoneNumberController.text = widget.userData!;
        customerController.checkPhoneAvailability(widget.userData!);
      } else {
        customerController.nameController.text = widget.userData!;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_nameFocus);
    });
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const AddSaveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            AddSaveIntent: CallbackAction<AddSaveIntent>(
              onInvoke:
                  (AddSaveIntent intent) => customerController
                      .submitCustomerDetails(widget.customerId),
            ),
          },
          child: Focus(
            autofocus: true,
            onKeyEvent: onNormalKeyEvent,
            child: Container(
              height: Get.height * .95,
              width: Get.width * .7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                key: customerController.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Expanded(
                      child:
                          widget.customerId == null
                              ? _buildCustomerForm()
                              : Obx(() => _buildCustomerForm()),
                    ),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerForm() {
    if (widget.customerId != null &&
        customerController.getCustomerResponseById.value.status ==
            Status.LOADING) {
      return const Center(child: CircularProgressIndicator());
    } else if (widget.customerId != null &&
        customerController.getCustomerResponseById.value.status ==
            Status.ERROR) {
      return Center(
        child: Text(
          customerController.getCustomerResponseById.value.message ??
              "Something went wrong",
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () =>
                          customerController.isLoadingCountryCodes.value
                              ? Container(
                                width: Get.width * .12,
                                margin: const EdgeInsets.only(top: 24),
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                              : CustomDropdownField(
                                name: 'Country Code',
                                width: Get.width * .12,
                                items:
                                    customerController.countryCodes
                                        .map(
                                          (code) =>
                                              "${code.name} (${code.code})",
                                        )
                                        .toList(),
                                selectedItem:
                                    customerController
                                                .selectedCountryCode
                                                .value !=
                                            null
                                        ? "${customerController.selectedCountryCode.value?.name} (${customerController.selectedCountryCode.value?.code})"
                                        : "IN (+91)",
                                onChanged: (String? value) {
                                  if (value != null) {
                                    final code = customerController.countryCodes
                                        .firstWhere(
                                          (code) =>
                                              "${code.name} (${code.code})" ==
                                              value,
                                          orElse:
                                              () => GetCountryCodeResponse(
                                                name: "IN",
                                                code: "+91",
                                              ),
                                        );
                                    customerController.setSelectedCountryCode(
                                      code,
                                    );
                                  }
                                },
                              ),
                    ),
                    SizedBox(width: Get.width * .02),
                    CustomTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      focusNode: _nameFocus,
                      controller: customerController.phoneNumberController,
                      name: 'Phone Number',
                      width: Get.width * .16,
                      onChanged: (value) {
                        String cleanedValue = value.replaceAll(
                          RegExp(r'\D'),
                          '',
                        );
                        if (cleanedValue.length == 10) {
                          customerController.checkPhoneAvailability(
                            cleanedValue,
                          );
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        String cleanedNumber = value.replaceAll(
                          RegExp(r'\D'),
                          '',
                        );
                        if (cleanedNumber.length != 10) {
                          return 'Enter a valid 10-digit phone number';
                        }
                        if (!customerController.isPhoneAvailable.value) {
                          return 'This phone number is already registered';
                        }
                        return null;
                      },
                      suffixIcon: Obx(() {
                        if (customerController.isCheckingPhone.value) {
                          return const SizedBox(
                            width: 10,
                            height: 10,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 4),
                            ),
                          );
                        }
                        if (customerController
                                    .phoneNumberController
                                    .text
                                    .length ==
                                10 &&
                            customerController.isPhoneAvailable.value) {
                          return const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          );
                        }
                        if (!customerController.isPhoneAvailable.value) {
                          return const Icon(Icons.error, color: Colors.red);
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                    SizedBox(width: Get.width * .02),
                    CustomTextField(
                      controller: customerController.nameController,
                      name: 'Name',
                      width: Get.width * .16,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: customerController.address1Controller,
                      name: 'Address Line 1',
                      width: Get.width * .2,
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'Address Line 1 is required';
                        // }
                        return null;
                      },
                    ),
                    SizedBox(width: Get.width * .02),
                    CustomTextField(
                      controller: customerController.address2Controller,
                      name: 'Address Line 2',
                      width: Get.width * .2,
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'Address Line 1 is required';
                        // }
                        return null;
                      },
                    ),
                    SizedBox(width: Get.width * .02),
                    Obx(
                      () => CustomTextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$'),
                          ),
                        ],
                        controller: customerController.pinCodeController,
                        name: 'PIN Code',
                        width: Get.width * .2,
                        onChanged: (value) {
                          customerController.checkPinCodeAndSetCity(value);
                        },
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'PIN Code is required';
                          // }
                          // if (value.length != 6) {
                          //   return "Invalid PIN code length";
                          // }
                          // if (!customerController.isPinCodeValid.value) {
                          //   return "Invalid PIN code";
                          // }
                          return null;
                        },
                        suffixIcon:
                            customerController.isCheckingPinCode.value
                                ? const SizedBox(
                                  width: 2,
                                  height: 2,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                                : customerController.isPinCodeValid.value &&
                                    customerController
                                            .pinCodeController
                                            .text
                                            .length ==
                                        6
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: customerController.stateController,
                      name: 'State',
                      width: Get.width * .2,
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'State is required';
                        // }
                        return null;
                      },
                    ),
                    SizedBox(width: Get.width * .02),
                    CustomTextField(
                      controller: customerController.cityController,
                      name: 'City',
                      width: Get.width * .2,
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'City is required';
                        // }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDropdownField(
                      name: 'Gender',
                      // focusNode: focusNodes[11],
                      width: Get.width * .12,
                      items: const ['Male', "Female", "None"],
                      selectedItem:
                          customerController.genderController.text.isEmpty
                              ? "None"
                              : customerController.genderController.text,
                      onChanged: (String? value) {
                        if (value != null) {
                          customerController.genderController.text = value;
                        }
                      },
                    ),
                    SizedBox(width: Get.width * .02),
                    SizedBox(
                      width: Get.width * 0.2,
                      child: CustomDateField(
                        controller: customerController.dobController,
                        labelText: "Birthday",
                        borderColor: secondaryColor,
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Birthday is required';
                          // }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Get.height * .02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "Legal",
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                SizedBox(height: Get.height * .02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: customerController.panController,
                      name: 'PAN No.',
                      width: Get.width * .2,
                      validator: customerController.validatePAN,
                      capitalizeText: true,
                      focusNode: customerController.panFocusNode,
                      onChanged: (value) {
                        final capitalizedValue = value.toUpperCase();
                        final currentCursorPosition =
                            customerController
                                .panController
                                .selection
                                .baseOffset;

                        customerController
                            .panController
                            .value = TextEditingValue(
                          text: capitalizedValue,
                          selection: TextSelection.collapsed(
                            offset: currentCursorPosition,
                          ),
                        );

                        customerController
                            .panVerificationResponse
                            .value = ApiResponse.initial("Initial");
                      },
                      suffixIcon: Obx(
                        () => customerController.getVerificationIcon(
                          customerController.isPanVerifiedOnline.value,
                          customerController.isPanVerifiedOffline.value,
                        ),
                      ),
                    ),
                    SizedBox(width: Get.width * .02),
                    Column(
                      children: [
                        const CustomText(text: ""),
                        const SizedBox(height: 6),
                        Obx(
                          () => CustomButton1(
                            buttonName: 'Verify',
                            isLoading:
                                customerController
                                    .panVerificationResponse
                                    .value
                                    .status ==
                                Status.LOADING,
                            onTap: customerController.verifyPAN,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    Obx(
                      () => Column(
                        children: [
                          const CustomText(text: ""),
                          Visibility(
                            visible:
                                customerController
                                    .panVerificationResponse
                                    .value
                                    .status ==
                                Status.COMPLETED,
                            child:
                                customerController.isPANValid.value
                                    ? const SizedBox()
                                    : const ErrorMessageWidget(
                                      message: "Invalid PAN number",
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Get.width * .02),
                    Column(
                      children: [
                        const CustomText(text: ""),
                        const SizedBox(height: 6),
                        Obx(
                          () => UploadButton(
                            buttonText: 'Upload Pan Card',
                            isLoading: customerController.isPanUploading.value,
                            fileName:
                                customerController.panCardFileName.value.isEmpty
                                    ? null
                                    : customerController.panCardFileName.value,
                            onPick: customerController.pickPanCard,
                            onUpload: customerController.uploadPanCard,
                            onRemove: customerController.removePanCard,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width * .2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: "Aadhar No",
                                color: blackColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              Obx(
                                () =>
                                    customerController.isAadharVerified.value
                                        ? const Icon(
                                          Icons.verified,
                                          color: Colors.green,
                                          size: 16,
                                        )
                                        : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          width: Get.width * 0.2,
                          controller: customerController.aadharController,
                          enabled: !customerController.isAadharVerified.value,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(12),
                          ],
                          // validator: customerController.validateAadhar,
                          suffixIcon: Obx(
                            () => customerController.getVerificationIcon(
                              customerController.isAadhaarVerifiedOnline.value,
                              customerController.isAadhaarVerifiedOffline.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: Get.width * .02),
                    Column(
                      children: [
                        const CustomText(text: ""),
                        const SizedBox(height: 14),
                        Obx(
                          () => Row(
                            children: [
                              CustomButton1(
                                buttonName:
                                    customerController.isAadharVerified.value
                                        ? 'Verified'
                                        : 'Verify',
                                isLoading:
                                    customerController
                                        .aadharVerificationResponse
                                        .value
                                        .status ==
                                    Status.LOADING,
                                onTap:
                                    customerController.isAadharVerified.value
                                        ? null
                                        : () {
                                          if (customerController
                                                  .aadharVerificationResponse
                                                  .value
                                                  .status !=
                                              Status.LOADING) {
                                            customerController.verifyAadhar();
                                          }
                                        },
                              ),
                              const SizedBox(width: 4),
                              Visibility(
                                visible:
                                    customerController
                                        .aadharVerificationResponse
                                        .value
                                        .status ==
                                    Status.ERROR,
                                child: ErrorMessageWidget(
                                  message:
                                      customerController
                                          .aadharVerificationResponse
                                          .value
                                          .message ??
                                      "Something went wrong",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: Get.width * .02),
                    Column(
                      children: [
                        const CustomText(text: ""),
                        const SizedBox(height: 12),
                        Obx(
                          () => UploadButton(
                            buttonText: 'Upload Aadhar Card',
                            isLoading:
                                customerController.isAadharUploading.value,
                            fileName:
                                customerController
                                        .aadharCardFileName
                                        .value
                                        .isEmpty
                                    ? null
                                    : customerController
                                        .aadharCardFileName
                                        .value,
                            onPick: customerController.pickAadharCard,
                            onUpload: customerController.uploadAadharCard,
                            onRemove: customerController.removeAadharCard,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width * .2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: "GST Details",
                                color: blackColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              Obx(
                                () => CustomText(
                                  text:
                                      customerController
                                          .gstDetailsResponse
                                          .value
                                          .data
                                          ?.gst_type ??
                                      "-",
                                  color: secondaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          width: Get.width * 0.2,
                          autofocus: true,
                          controller: customerController.gstController,
                          onChanged: (value) {
                            final capitalizedValue = value.toUpperCase();
                            final currentCursorPosition =
                                customerController
                                    .gstController
                                    .selection
                                    .baseOffset;
                            customerController
                                .gstController
                                .value = TextEditingValue(
                              text: capitalizedValue,
                              selection: TextSelection.collapsed(
                                offset: currentCursorPosition,
                              ),
                            );
                            customerController
                                .gstDetailsResponse
                                .value = ApiResponse.initial("Initial");
                            customerController.checkGSTAvailability(
                              capitalizedValue,
                            );
                          },
                          validator: customerController.validateGSTField,
                          suffixIcon: Obx(() {
                            if (customerController.isCheckingGST.value) {
                              return const SizedBox(
                                width: 10,
                                height: 10,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                  ),
                                ),
                              );
                            }
                            if (customerController
                                    .gstController
                                    .text
                                    .isNotEmpty &&
                                customerController.isGSTAvailable.value) {
                              return const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              );
                            }
                            if (!customerController.isGSTAvailable.value) {
                              return const Icon(Icons.error, color: Colors.red);
                            }
                            return const SizedBox.shrink();
                          }),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter GST number';
                          //   }
                          //   // Basic GST format validation
                          //   if (!RegExp(
                          //           r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}$')
                          //       .hasMatch(value)) {
                          //     return 'Invalid GST number format';
                          //   }
                          //   return null;
                          // },
                        ),
                      ],
                    ),
                    SizedBox(width: Get.width * .02),
                    Column(
                      children: [
                        const CustomText(text: ""),
                        const SizedBox(height: 14),
                        Obx(
                          () => Row(
                            children: [
                              CustomButton1(
                                buttonName: 'Verify',
                                isLoading:
                                    customerController
                                        .gstDetailsResponse
                                        .value
                                        .status ==
                                    Status.LOADING,
                                onTap: () {
                                  if (customerController
                                          .gstDetailsResponse
                                          .value
                                          .status !=
                                      Status.LOADING) {
                                    customerController.fetchGSTDetails();
                                  }
                                },
                              ),
                              const SizedBox(width: 4),
                              Visibility(
                                visible:
                                    customerController
                                        .gstDetailsResponse
                                        .value
                                        .status ==
                                    Status.ERROR,
                                child: ErrorMessageWidget(
                                  message:
                                      customerController
                                          .gstDetailsResponse
                                          .value
                                          .message ??
                                      "Something went wrong",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    //         final ledgerList = customerController
                    //                 .ledgerListResponse.value.data?.values ??
                    //             [];
                    //         return SizedBox(
                    //           width: 200,
                    //           child:
                    //               GenericAutocompleteDropdown<AccountMapping>(
                    //             items: ledgerList,
                    //             isLastRow: true,
                    //             controller: TextEditingController(
                    //                 text: customerController
                    //                         .selectedLedger.value?.groupName ??
                    //                     ''),
                    //             focusNode: FocusNode(),
                    //             getDisplayValue: (AccountMapping item) =>
                    //                 item.groupName ?? '-',
                    //             onSelected: (newSelection) {
                    //               customerController
                    //                   .onLedgerChanged(newSelection);
                    //               _deductionFocusNode.requestFocus();
                    //             },
                    //             validator: (value) {
                    //               if (value == null || value.isEmpty) {
                    //                 return "Select Ledger";
                    //               }
                    //               return null;
                    //             },
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(width: Get.width * .02),
                    CustomDropdownField(
                      focusNode: _deductionFocusNode,
                      name: 'Deduction',
                      width: Get.width * .1,
                      items: customerController.deductionItems,
                      selectedItem: customerController.selectedDeduction.value,
                      onChanged: customerController.onDeductionChanged,
                    ),
                    SizedBox(width: Get.width * .02),
                    CustomTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      controller: customerController.percentageController,
                      name: '',
                      width: Get.width * .1,
                      hintText: "Percentage",
                      validator: customerController.validateDeductionPercentage,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 54,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text:
                  widget.customerId == null ? 'Add Customer' : 'Edit Customer',
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              Get.back();
              customerController.resetFields();
            },
            child: Container(
              width: 160,
              height: 38,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CustomText(
                  text: "Ignore",
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => InkWell(
              onTap: () {
                customerController.submitCustomerDetails(widget.customerId);
              },
              child: Container(
                width: 160,
                height: 38,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child:
                      customerController.addCustomerResponse.value.status ==
                              Status.LOADING
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Save",
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: " (ctrl + s)",
                                color: whiteColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  final String buttonText;
  final bool isLoading;
  final VoidCallback? onUpload;
  final VoidCallback? onPick;
  final String? fileName;
  final VoidCallback? onRemove;

  const UploadButton({
    super.key,
    required this.buttonText,
    this.isLoading = false,
    this.onUpload,
    this.onPick,
    this.fileName,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Pick file button
            InkWell(
              onTap: isLoading ? null : onPick,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: fileName != null ? Colors.grey[300] : primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: primaryColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 16,
                      color: fileName != null ? primaryColor : whiteColor,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                      text: "Choose File",
                      fontSize: 12,
                      color: fileName != null ? primaryColor : whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Upload button
            if (fileName != null)
              InkWell(
                onTap: isLoading ? null : onUpload,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isLoading ? Colors.grey[300] : Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: whiteColor,
                            ),
                          )
                          : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                size: 16,
                                color: whiteColor,
                              ),
                              SizedBox(width: 4),
                              CustomText(
                                text: "Upload",
                                fontSize: 12,
                                color: whiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                ),
              ),
          ],
        ),

        // Show selected file name
        if (fileName != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.description, size: 14, color: primaryColor),
                const SizedBox(width: 4),
                Flexible(
                  child: CustomText(
                    text: fileName!,
                    fontSize: 11,
                    color: primaryColor,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: onRemove,
                  child: const Icon(Icons.close, size: 14, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
