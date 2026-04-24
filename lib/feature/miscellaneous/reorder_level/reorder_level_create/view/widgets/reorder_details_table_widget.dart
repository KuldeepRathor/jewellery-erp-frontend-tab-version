import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_create/view_model/reorder_detail_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class ReorderDetailsTable extends StatefulWidget {
  final String designId;

  const ReorderDetailsTable({required this.designId, super.key});

  @override
  State<ReorderDetailsTable> createState() => _ReorderDetailsTableState();
}

class _ReorderDetailsTableState extends State<ReorderDetailsTable> {
  final ReorderDetailsController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.loadReorderData(widget.designId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.hasError.value) {
        return Center(
          child: Text(controller.errorMessage ?? 'An error occurred'),
        );
      }

      return Form(
        key: controller.formKey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                //
                const SizedBox(height: 16),
                // Headers
                Row(
                  children: [
                    _buildMainHeader(
                      'Weight Group',
                      width: 250,
                      isCurved: true,
                    ),
                    _buildMainHeader('Size', width: 250),
                    _buildMainHeader('Purity', width: 250),
                    _buildMainHeader('Min', width: 150),
                    _buildMainHeader('Max', width: 150, isLast: true),
                  ],
                ),
                // Data rows
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      return _buildDataRow(item);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDataRow(ReorderItem item) {
    return SizedBox(
      height: 60,
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyS &&
              HardwareKeyboard.instance.isAltPressed) {
            controller.openSupplierDialog();
            return KeyEventResult.handled;
          }
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.keyC &&
              HardwareKeyboard.instance.isAltPressed) {
            log("Changeing values ");
            controller.cycleQuantityType();
            setState(() {});

            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.weightGroupName} (${item.weightGroupCode})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.sizeGroupName} (${item.sizeGroupCode})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    controller.getPurityDisplay(item.purity),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomTextField(
                      controller: item.controllers.minController,
                      focusNode: item.controllers.minFocusNode,
                      keyboardType: TextInputType.number,
                      validator: controller.validateMin,
                      prefixIcon:
                          item.vendorDetails != null
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 32,
                                  child: Text(
                                    item.vendorDetails?.code ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFFFC9B20),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              : null,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _getQuantityTypeDisplay(item.quantityType),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomTextField(
                      controller: item.controllers.maxController,
                      focusNode: item.controllers.maxFocusNode,
                      keyboardType: TextInputType.number,
                      validator: controller.validateMax,
                      prefixIcon:
                          item.vendorDetails != null
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 32,
                                  child: Text(
                                    item.vendorDetails?.code ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFFFC9B20),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              : null,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _getQuantityTypeDisplay(item.quantityType),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getQuantityTypeDisplay(String type) {
    switch (type) {
      case 'net_weight':
        return 'nwt';
      case 'gross_weight':
        return 'gwt';
      case 'pieces':
        return 'pcs';
      default:
        return type;
    }
  }

  Widget _buildMainHeader(
    String text, {
    required double width,
    bool isCurved = false,
    bool isLast = false,
  }) {
    return Container(
      width: width,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF4758EC),
        borderRadius: BorderRadius.only(
          topLeft: isCurved ? const Radius.circular(8) : Radius.zero,
          topRight: isLast ? const Radius.circular(8) : Radius.zero,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
