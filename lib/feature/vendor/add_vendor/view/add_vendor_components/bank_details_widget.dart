// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/bank_account_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_components/gst_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view_model/add_vendor_tabbar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class BankDetailsWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController accountNameController;
  final TextEditingController accountNumberController;
  final TextEditingController ifscController;

  final String? vendorId;

  BankDetailsWidget({
    super.key,
    required this.formKey,
    required this.accountNameController,
    required this.accountNumberController,
    required this.ifscController,
    this.vendorId,
  });

  void _submitForm(AddVendorTabController controller) {
    controller.addAccount();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    AddVendorTabController controller = Get.find();
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.shift):
            const AddSavedCardIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const NextTabIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NextTabIntent: CallbackAction<NextTabIntent>(
            onInvoke: (NextTabIntent intent) => controller.nextTab(vendorId),
          ),
          AddSavedCardIntent: CallbackAction<AddSavedCardIntent>(
            onInvoke: (AddSavedCardIntent intent) => _submitForm(controller),
          ),
        },
        child: FocusScope(
          autofocus: true,
          onKeyEvent: onNormalKeyEvent,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * .02),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Accounts",
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        SizedBox(height: Get.height * .02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              name: 'A/c Name',
                              width: Get.width * .2,
                              autofocus: true,
                              controller: controller.accountNameController,
                              validator: _validateAccountName,
                            ),
                            SizedBox(width: Get.width * .02),
                            CustomTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$'),
                                ),
                              ],
                              name: 'A/c Number',
                              width: Get.width * .2,
                              controller: controller.accountNumberController,
                              validator: _validateAccountNumber,
                            ),
                            SizedBox(width: Get.width * .02),
                            CustomTextField(
                              name: 'IFSC',
                              width: Get.width * .2,
                              controller: controller.ifscController,
                              validator: _validateIFSC,
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * .02),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .02),
                const CustomText(
                  text: "Saved",
                  color: primaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                SizedBox(height: Get.height * .02),
                Obx(
                  () => SizedBox(
                    // color: Colors.redAccent,
                    height: Get.height * .377,
                    child:
                        controller.savedAccounts.isEmpty
                            ? const Center(child: Text("No saved accounts"))
                            : Scrollbar(
                              controller: _scrollController,
                              child: ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.savedAccounts.length,
                                itemBuilder:
                                    (context, index) => Padding(
                                      padding: EdgeInsets.only(
                                        right: Get.width * .02,
                                      ),
                                      child: SavedCardWidgets(
                                        account:
                                            controller.savedAccounts[index],
                                        onTap:
                                            () =>
                                                controller.selectAccount(index),
                                        onDelete:
                                            () =>
                                                controller.deleteAccount(index),
                                      ),
                                    ),
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateAccountName(String? value) {
    // if (value == null || value.isEmpty) {
    //   return 'Account name is required';
    // }
    return null;
  }

  String? _validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if ((value.length) < 9 || (value.length) > 18) {
      return 'Account number should be 9-18 digits';
    }
    return null;
  }

  String? _validateIFSC(String? value) {
    if (value == null || value.isEmpty) {
      // return 'IFSC code is required';
      return null;
    }
    // if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
    //   return 'Invalid IFSC code';
    // }
    return null;
  }
}

class SavedCardWidgets extends StatelessWidget {
  final BankAccount account;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SavedCardWidgets({
    super.key,
    required this.account,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: Get.width * 0.2,
            height: Get.height * .375,
            padding: EdgeInsets.all(Get.width * .02),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x1428328B),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "A/c Name",
                  color: primaryColor,
                  fontSize: 12,
                ),
                SizedBox(height: Get.height * .02),
                CustomText(
                  text: account.holder_name ?? "",
                  color: primaryTextColor,
                  fontSize: 14,
                ),
                SizedBox(height: Get.height * .02),
                const CustomText(
                  text: "A/c Number",
                  color: primaryColor,
                  fontSize: 12,
                ),
                SizedBox(height: Get.height * .02),
                CustomText(
                  text: account.account_number ?? "",
                  color: primaryTextColor,
                  fontSize: 14,
                ),
                SizedBox(height: Get.height * .02),
                const CustomText(
                  text: "IFSC",
                  color: primaryColor,
                  fontSize: 12,
                ),
                SizedBox(height: Get.height * .02),
                CustomText(
                  text: account.ifsc_code ?? "",
                  color: primaryTextColor,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}
