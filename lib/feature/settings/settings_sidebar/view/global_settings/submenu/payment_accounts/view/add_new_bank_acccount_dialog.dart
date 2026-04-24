import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/model/get_account_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/view_model/bank_accounts_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddBankAccountSaveIntent extends Intent {
  const AddBankAccountSaveIntent();
}

class AddBankAccountDialog extends StatefulWidget {
  final String? accountId;

  const AddBankAccountDialog({super.key, this.accountId});

  @override
  State<AddBankAccountDialog> createState() => _AddBankAccountDialogState();
}

class _AddBankAccountDialogState extends State<AddBankAccountDialog> {
  final BankAccountsController controller = Get.put(BankAccountsController());
  final FocusNode _paymentCodeFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController paymentCodeController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.accountId != null) {
      // Load existing account data for editing
      _loadAccountData();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_paymentCodeFocus);
    });
  }

  void _loadAccountData() async {
    await controller.getAccountById(widget.accountId!);
  }

  void _populateFormFields() {
    final accountData = controller.getAccountByIdResponse.value.data;
    if (accountData != null) {
      paymentCodeController.text = accountData.paymentCode ?? '';
      accountNameController.text = accountData.accountName ?? '';
      accountNumberController.text = accountData.accountNumber ?? '';
      ifscController.text = accountData.ifsc ?? '';
      branchController.text = accountData.branch ?? '';
    }
  }

  @override
  void dispose() {
    _paymentCodeFocus.dispose();
    paymentCodeController.dispose();
    accountNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const AddBankAccountSaveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            AddBankAccountSaveIntent: CallbackAction<AddBankAccountSaveIntent>(
              onInvoke: (AddBankAccountSaveIntent intent) => _submitForm(),
            ),
          },
          child: Focus(
            autofocus: true,
            onKeyEvent: onNormalKeyEvent,
            child: Container(
              height: Get.height * .475,
              width: Get.width * .475,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Expanded(
                      child:
                          widget.accountId == null
                              ? _buildBankAccountForm()
                              : Obx(() => _buildBankAccountForm()),
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

  Widget _buildBankAccountForm() {
    // Handle loading state for edit mode
    if (widget.accountId != null &&
        controller.getAccountByIdResponse.value.status == Status.LOADING) {
      return const Center(child: CircularProgressIndicator());
    } else if (widget.accountId != null &&
        controller.getAccountByIdResponse.value.status == Status.ERROR) {
      return Center(
        child: Text(
          controller.getAccountByIdResponse.value.message ??
              "Something went wrong",
        ),
      );
    } else if (widget.accountId != null &&
        controller.getAccountByIdResponse.value.status == Status.COMPLETED) {
      // Populate fields when data is loaded (only once)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (paymentCodeController.text.isEmpty) {
          _populateFormFields();
        }
      });
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: Payment Code and Account Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  focusNode: _paymentCodeFocus,
                  controller: paymentCodeController,
                  name: 'Account Payment Code(Nick Name)*',
                  width: Get.width * .2,
                  enabled: widget.accountId == null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Payment code is required';
                    }
                    return null;
                  },
                ),
                SizedBox(width: Get.width * .02),
                CustomTextField(
                  controller: accountNameController,
                  name: 'Account Name*',
                  width: Get.width * .2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Account name is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: Get.height * .02),

            // Second Row: Account Number and IFSC
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: accountNumberController,
                  name: 'Account No.*',
                  width: Get.width * .2,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Account number is required';
                    }
                    if (value.length < 9 || value.length > 18) {
                      return 'Account number must be 9-18 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(width: Get.width * .02),
                CustomTextField(
                  controller: ifscController,
                  name: 'IFSC*',
                  width: Get.width * .2,
                  capitalizeText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'IFSC code is required';
                    }
                    // IFSC validation pattern: 4 letters + 7 characters (numbers/letters)
                    if (!RegExp(
                      r'^[A-Z]{4}[0][A-Z0-9]{6}$',
                    ).hasMatch(value.toUpperCase())) {
                      return 'Invalid IFSC code format';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Auto-capitalize IFSC
                    final capitalizedValue = value.toUpperCase();
                    final currentCursorPosition =
                        ifscController.selection.baseOffset;
                    ifscController.value = TextEditingValue(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(
                        offset: currentCursorPosition,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: Get.height * .02),

            // Third Row: Branch
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: branchController,
                  name: 'Branch*',
                  width: Get.width * .2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Branch is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: Get.height * .02),
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
                  widget.accountId == null
                      ? 'Add Bank Account'
                      : 'Edit Bank Account',
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
              _resetFields();
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
              onTap: controller.isLoading.value ? null : _submitForm,
              child: Container(
                width: 200,
                height: 38,
                decoration: BoxDecoration(
                  color:
                      controller.isLoading.value
                          ? primaryColor.withOpacity(0.7)
                          : primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Next",
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create bank account data using response model
        final bankAccountData = GetAccountSettingsResponse(
          paymentCode: paymentCodeController.text.trim(),
          accountName: accountNameController.text.trim(),
          accountNumber: accountNumberController.text.trim(),
          ifsc: ifscController.text.trim().toUpperCase(),
          branch: branchController.text.trim(),
        );

        // Call controller method to save/update bank account
        if (widget.accountId == null) {
          await controller.addBankAccount(bankAccountData);
        } else {
          await controller.updateBankAccount(
            widget.accountId!,
            bankAccountData,
          );
        }

        // Close dialog and show success message
        Get.back();
        showSuccessToast(
          message:
              widget.accountId == null
                  ? 'Bank account added successfully'
                  : 'Bank account updated successfully',
        );

        // Refresh the accounts list
        await controller.getAccountSettingsList();
      } catch (e) {
        showErrorToast(message: 'Failed to save bank account: ${e.toString()}');
      }
    } else {
      showErrorToast(message: "Please check the data");
    }
  }

  void _resetFields() {
    paymentCodeController.clear();
    accountNameController.clear();
    accountNumberController.clear();
    ifscController.clear();
    branchController.clear();
  }
}
