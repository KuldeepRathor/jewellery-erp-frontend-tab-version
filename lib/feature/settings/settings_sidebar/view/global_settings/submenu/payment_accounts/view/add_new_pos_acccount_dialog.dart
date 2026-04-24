import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/model/get_account_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/view_model/pos_accounts_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class AddPosAccountSaveIntent extends Intent {
  const AddPosAccountSaveIntent();
}

class AddPosAccountDialog extends StatefulWidget {
  const AddPosAccountDialog({super.key});

  @override
  State<AddPosAccountDialog> createState() => _AddPosAccountDialogState();
}

class _AddPosAccountDialogState extends State<AddPosAccountDialog> {
  final PosAccountsController controller = Get.put(PosAccountsController());
  final FocusNode _paymentCodeFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController paymentCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_paymentCodeFocus);
    });
  }

  @override
  void dispose() {
    _paymentCodeFocus.dispose();
    paymentCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const AddPosAccountSaveIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            AddPosAccountSaveIntent: CallbackAction<AddPosAccountSaveIntent>(
              onInvoke: (AddPosAccountSaveIntent intent) => _submitForm(),
            ),
          },
          child: Focus(
            autofocus: true,
            onKeyEvent: onNormalKeyEvent,
            child: Container(
              height: Get.height * .25,
              width: Get.width * .25,
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
                    Expanded(child: _buildPosAccountForm()),
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

  Widget _buildPosAccountForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Code Field
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  focusNode: _paymentCodeFocus,
                  controller: paymentCodeController,
                  name: 'Account Payment Code(Nick Name)*',
                  width: Get.width * .2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Payment code is required';
                    }
                    return null;
                  },
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
            const CustomText(
              text: 'Add POS Account',
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
          const SizedBox(width: 10),
          Obx(
            () => InkWell(
              onTap: controller.isLoading.value ? null : _submitForm,
              child: Container(
                width: 150,
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
                                text: "Add",
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: " (Ctrl + s)",
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
        // Create POS account data using response model
        final posAccountData = GetAccountSettingsResponse(
          paymentCode: paymentCodeController.text.trim(),
        );

        // Call controller method to add POS account
        await controller.addBankAccount(posAccountData);

        // Close dialog and show success message
        Get.back();
        showSuccessToast(message: 'POS account added successfully');

        // Refresh the accounts list
        await controller.getAccountSettingsList();
      } catch (e) {
        showErrorToast(message: 'Failed to add POS account: ${e.toString()}');
      }
    } else {
      showErrorToast(message: "Please check the data");
    }
  }
}
