import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_voucher_sections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_voucher_types_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/view_model/create_voucher_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';

class CreateVoucherPage extends StatefulWidget {
  const CreateVoucherPage({super.key});

  @override
  State<CreateVoucherPage> createState() => _CreateVoucherPageState();
}

class _CreateVoucherPageState extends State<CreateVoucherPage> {
  late final CreateVoucherController controller;

  @override
  void initState() {
    super.initState();
    // Create a new instance of the CreateVoucherController
    controller = Get.put(CreateVoucherController(), tag: 'createVoucher');
  }

  @override
  void dispose() {
    // Clean up the controller when the page is disposed
    Get.delete<CreateVoucherController>(tag: 'createVoucher');
    super.dispose();
  }

  void _goBack() {
    controller.goBack();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        SaveDesignIntent: CallbackAction<SaveDesignIntent>(
          onInvoke: (intent) {
            final isLoading = controller.isCreatingVoucher.value;
            if (!isLoading) controller.createVoucher();
            return;
          },
        ),
        DiscardIntent: CallbackAction<DiscardIntent>(
          onInvoke: (intent) {
            controller.resetForm();
            return;
          },
        ),
        RemoveRowIntent: CallbackAction<RemoveRowIntent>(
          onInvoke: (intent) {
            controller.removeLastRow();
            return;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveDesignIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.escape):
              const RemoveRowIntent(),
        },
        child: FocusScope(
          autofocus: true,
          child: Scaffold(
            backgroundColor: grey1,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildDetailsForm(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _buildTable(),
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Back button
                InkWell(
                  onTap: _goBack,
                  child: Container(
                    width: 27,
                    height: 35,
                    decoration: ShapeDecoration(
                      color: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const SizedBox(
                      width: 15,
                      height: 15,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: whiteColor,
                        size: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Page title
                Text(
                  'Add Voucher',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
              ],
            ),
            Container(
              height: 24,
              width: 24,
              decoration: const BoxDecoration(
                color: grey1,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsForm() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Details',
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: 200, child: _buildVoucherTypeDropdown()),
                const SizedBox(width: 16),
                SizedBox(width: 200, child: _buildVoucherSectionDropdown()),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _buildTable() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: IntrinsicWidth(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonShortcutWidget(
                    onTap: controller.addNewRow,
                    buttonName: "+ Add",
                    shortcut: "Enter",
                    color: primaryColor,
                    shortcutButtonBackgroundColor: shortcutGreyColor,
                    focusNode: FocusNode(canRequestFocus: false),
                    canRequestFocus: false,
                  ),
                  ButtonShortcutWidget(
                    onTap: controller.removeLastRow,
                    buttonName: "Remove",
                    shortcut: "Shift+Esc",
                    color: redTextColor,
                    shortcutButtonBackgroundColor: shortcutRedColor,
                    focusNode: FocusNode(canRequestFocus: false),
                    canRequestFocus: false,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(
                () => Table(
                  columnWidths: getColumnWidths(
                    columnWidths: controller.columnWidths,
                    context: context,
                  ),
                  children: [
                    TableRow(
                      children:
                          controller.headers
                              .map(
                                (header) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    header,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Table(
                columnWidths: getColumnWidths(
                  columnWidths: controller.columnWidths,
                  context: context,
                ),
                children: controller.buildRows(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFooter() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                height: 38,
                width: 140,
                decoration: BoxDecoration(
                  color: grey1,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined, color: primaryColor, size: 16),
                    SizedBox(width: 8),
                    CustomText(
                      text: "Remarks",
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 38,
                    width: 140,
                    decoration: BoxDecoration(
                      color: grey1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Center(
                      child: CustomText(
                        text: "Discard",
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton1(
                  buttonName: "Save",
                  onTap: () {
                    controller.createVoucher();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Voucher Type',
          color: Colors.indigo.shade900,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        Obx(() {
          final status = controller.voucherTypesResponse.value.status;

          if (status == Status.LOADING) {
            return Container(
              padding: const EdgeInsets.only(top: 8),
              child: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  CustomText(text: 'Loading...', fontSize: 12),
                ],
              ),
            );
          }

          if (status == Status.ERROR) {
            return Container(
              padding: const EdgeInsets.only(top: 8),
              child: const CustomText(
                text: 'Error loading voucher types',
                fontSize: 12,
                color: Colors.red,
              ),
            );
          }

          return GenericAutocompleteDropdown<GetVoucherTypeResponse>(
            controller: controller.voucherTypeController,
            padding: const EdgeInsets.only(top: 8),
            autofocus: false,
            focusNode: controller.voucherTypeFocusNode,
            items: controller.voucherTypes,
            getDisplayValue: (item) => item.name ?? '',
            onSelected: (item) {
              controller.setSelectedVoucherType(item);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller.voucherSectionFocusNode.canRequestFocus) {
                  controller.voucherSectionFocusNode.requestFocus();
                }
              });
            },
            onEditingComplete: () {
              FocusManager.instance.primaryFocus?.nextFocus();
            },
            validator: (value) => controller.validateVoucherType(value),
          );
        }),
      ],
    );
  }

  Widget _buildVoucherSectionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Voucher Section(Page)',
          color: Colors.indigo.shade900,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        Obx(() {
          final status = controller.voucherSectionsResponse.value.status;

          if (status == Status.LOADING) {
            return Container(
              padding: const EdgeInsets.only(top: 8),
              child: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  CustomText(text: 'Loading...', fontSize: 12),
                ],
              ),
            );
          }

          if (status == Status.ERROR) {
            return Container(
              padding: const EdgeInsets.only(top: 8),
              child: const CustomText(
                text: 'Error loading voucher sections',
                fontSize: 12,
                color: Colors.red,
              ),
            );
          }

          return GenericAutocompleteDropdown<GetVoucherSectionResponse>(
            controller: controller.voucherSectionController,
            padding: const EdgeInsets.only(top: 8),
            focusNode: controller.voucherSectionFocusNode,
            items: controller.voucherSections,
            getDisplayValue: (item) => item.name ?? '',
            borderColor: primaryColor,
            onSelected: (item) {
              controller.setSelectedVoucherSection(item);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller.ornamentTypeFocusNode.canRequestFocus) {
                  if (controller.rows.isNotEmpty) {
                    controller.rows.first.prefixFocus.requestFocus();
                  }
                }
              });
            },
            onEditingComplete: () {
              FocusManager.instance.primaryFocus?.nextFocus();
            },
            validator: (value) => controller.validateVoucherSection(value),
          );
        }),
      ],
    );
  }
}
