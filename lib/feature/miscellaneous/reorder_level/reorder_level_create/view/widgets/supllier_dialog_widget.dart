import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view_model/supplier_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';

class SupplierDialog extends StatefulWidget {
  const SupplierDialog({
    super.key,
    required this.onSelectForOne,
    required this.onSelectForAll,
    this.currentSupplierCode,
  });
  final Function(VendorSearchValue) onSelectForOne;
  final Function(VendorSearchValue) onSelectForAll;
  final String? currentSupplierCode;

  @override
  State<SupplierDialog> createState() => _SupplierDialogState();
}

class _SupplierDialogState extends State<SupplierDialog> {
  late final SupplierDialogController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      SupplierDialogController(
        onApplySingle: widget.onSelectForOne,
        onApplyAll: widget.onSelectForAll,
      ),
    );
    if (widget.currentSupplierCode != null) {
      controller.currentSupplier.value = widget.currentSupplierCode!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const ApplySingleIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
              const ApplyAllIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            ApplySingleIntent: CallbackAction<ApplySingleIntent>(
              onInvoke: (ApplySingleIntent intent) {
                controller.applySingle();
                return null;
              },
            ),
            ApplyAllIntent: CallbackAction<ApplyAllIntent>(
              onInvoke: (ApplyAllIntent intent) {
                controller.applyAll();
                return null;
              },
            ),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              clipBehavior: Clip.antiAlias,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildCurrentSupplier(),
                  const SizedBox(height: 16),
                  _buildSupplierInput(),
                  const SizedBox(height: 60),
                  _buildFooterActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Supplier',
              style: TextStyle(
                color: Color(0xFF28328B),
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w900,
              ),
            ),
            IconButton(
              onPressed: Get.back,
              icon: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSupplier() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Supplier:',
            style: TextStyle(
              color: Color(0xFF28328B),
              fontSize: 12,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
          Obx(
            () => SizedBox(
              width: 96,
              child: Text(
                controller.currentSupplier.value,
                style: const TextStyle(
                  color: Color(0xFF28328B),
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GenericAutocompleteDropdown<VendorSearchValue>(
        controller: controller.supplierController,
        focusNode: controller.supplierFocusNode,
        items: const [],
        isLastRow: true,
        getDisplayValue: (vendor) => vendor.name ?? '',
        onSelected: controller.onVendorSelected,

        // labelText: 'Search Supplier',
        customOptionsBuilder: (textEditingValue) async {
          return await controller.searchVendors(textEditingValue.text);
        },
      ),
    );
  }

  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionButton(
            'Apply single',
            const Color(0xFFFC9B20),
            'ctrl',
            'S',
            const Color(0x26A9A200),
            controller.applySingle,
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            'Apply to all',
            const Color(0xFF28328B),
            'ctrl',
            'A',
            const Color(0x264758EC),
            controller.applyAll,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color buttonColor,
    String shortcutKey1,
    String shortcutKey2,
    Color shortcutBgColor,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        focusColor: greyTextColor,
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            color: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: ShapeDecoration(
                      color: shortcutBgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: Text(
                      shortcutKey1,
                      style: const TextStyle(
                        color: whiteColor,
                        fontSize: 12,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Text(
                    '+',
                    style: TextStyle(
                      color: Color(0xFFE3E6FC),
                      fontSize: 10,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: ShapeDecoration(
                      color: shortcutBgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: Text(
                      shortcutKey2,
                      style: const TextStyle(
                        color: whiteColor,
                        fontSize: 12,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

class ApplySingleIntent extends Intent {
  const ApplySingleIntent();
}

class ApplyAllIntent extends Intent {
  const ApplyAllIntent();
}
