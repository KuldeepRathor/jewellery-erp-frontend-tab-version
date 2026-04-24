import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/branch_out_transfer_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class BranchOutTransferHeader extends GetView<BranchOutTransferViewModel> {
  const BranchOutTransferHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BranchOutTransferViewModel>(
      builder: (_) {
        return Container(
          padding: const EdgeInsets.only(left: 16, top: 10, bottom: 6),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTransferToDropdown(),
                const SizedBox(width: 8),
                _buildTransferByDropdown(),
                const Spacer(),
                SizedBox(width: Get.width * 0.03),
                _buildScanner(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransferToDropdown() {
    return SizedBox(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Transfer to',
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: primaryBtnColor,
            ),
            const SizedBox(height: 6),
            Focus(
              canRequestFocus: false,
              child: SizedBox(
                height: 38,
                child: DropdownMenu<String>(
                  hintText: 'Select',
                  controller: controller.branchTransferFrom,
                  requestFocusOnTap: true,
                  enableSearch: false,
                  enableFilter: true,
                  filterCallback: (entries, filter) {
                    final String trimmedFilter = filter.trim().toLowerCase();
                    if (trimmedFilter.isEmpty) return entries;
                    return entries
                        .where(
                          (entry) =>
                              entry.label.toLowerCase().contains(trimmedFilter),
                        )
                        .toList();
                  },
                  enabled:
                      controller.transferToDroopDownList.value.status ==
                      Status.COMPLETED,
                  initialSelection: 'Select',
                  menuStyle: const MenuStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    fixedSize: WidgetStatePropertyAll(Size.fromHeight(150)),
                  ),
                  onSelected: (String? value) {
                    if (value != null) {
                      controller.branchTransferToUUID = value;
                    }
                  },
                  dropdownMenuEntries:
                      (controller.transferToDroopDownList.value.data?.values ??
                              [])
                          .map((item) {
                            return DropdownMenuEntry<String>(
                              value: item.id ?? '',
                              label: item.branchName ?? '',
                              labelWidget: Column(
                                children: [
                                  CustomText(
                                    text: item.branchName!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  const CustomDashedLineWidget(
                                    width: double.infinity,
                                  ),
                                ],
                              ),
                            );
                          })
                          .toList(),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  expandedInsets: EdgeInsets.zero,
                  trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  inputDecorationTheme: const InputDecorationTheme(
                    isDense: true,
                    constraints: BoxConstraints(
                      maxHeight: 38,
                      minWidth: double.maxFinite,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferByDropdown() {
    return SizedBox(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Transfer By',
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: primaryBtnColor,
            ),
            const SizedBox(height: 6),
            Focus(
              canRequestFocus: false,
              child: SizedBox(
                height: 38,
                child: DropdownMenu<String>(
                  controller: controller.branchTransferBy,
                  hintText: 'Select',
                  requestFocusOnTap: true,
                  enableSearch: false,
                  enableFilter: true,
                  filterCallback: (entries, filter) {
                    final String trimmedFilter = filter.trim().toLowerCase();
                    if (trimmedFilter.isEmpty) return entries;
                    return entries
                        .where(
                          (entry) =>
                              entry.label.toLowerCase().contains(trimmedFilter),
                        )
                        .toList();
                  },
                  enabled:
                      controller.transferByDroopDownList.value.status ==
                      Status.COMPLETED,
                  initialSelection: 'Select',
                  menuStyle: const MenuStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    fixedSize: WidgetStatePropertyAll(Size.fromHeight(150)),
                  ),
                  onSelected: (String? value) {
                    if (value != null) {
                      controller.branchTransferByUUID = value;
                    }
                  },
                  dropdownMenuEntries:
                      (controller.transferByDroopDownList.value.data?.values ??
                              [])
                          .map((item) {
                            return DropdownMenuEntry<String>(
                              value: item.id ?? '',
                              label: '${item.firstName} ${item.lastName}',
                              labelWidget: Column(
                                children: [
                                  CustomText(
                                    text: '${item.firstName} ${item.lastName}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  const CustomDashedLineWidget(
                                    width: double.infinity,
                                  ),
                                ],
                              ),
                            );
                          })
                          .toList(),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  expandedInsets: EdgeInsets.zero,
                  trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  inputDecorationTheme: const InputDecorationTheme(
                    isDense: true,
                    constraints: BoxConstraints(
                      maxHeight: 38,
                      minWidth: double.maxFinite,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanner() {
    return const SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner_outlined,
              color: totalGreenColor,
              size: 24,
            ),
            SizedBox(width: 24),
            Text(
              'Item Scanning',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: totalGreenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
