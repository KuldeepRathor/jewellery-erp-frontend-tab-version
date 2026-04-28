import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_sequences_listing_grouped_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/view/create_voucher_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/view/edit_voucher_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/settings/settings_sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class VoucherSettingsController extends GetxController {
  final isUpdating = false.obs;
  final isLoading = false.obs;

  final AggregateRepository _aggregateRepository = AggregateRepository();

  final headers =
      [
        'Voucher Type',
        'Page',
        'Prefix',
        'Suffix',
        'Start From',
        'Restart Every FY',
        'Default',
        '',
      ].obs;

  final columnWidths =
      [
        0.40, // Voucher Type
        0.40, // Page
        0.40, // Prefix
        0.40, // Suffix
        0.40, // Start From
        0.40, // Restart Every FY
        0.25, // Default
        0.10, // Actions
      ].obs;
  final voucherSequencesResponse =
      Rx<ApiResponse<List<GetSequencesListingGroupedResponse>>>(
        ApiResponse.initial("INITIAL"),
      );

  // // Add/Update response for voucher sequences
  // final addVoucherSequenceResponse =
  //     Rx<ApiResponse<GetSequencesListingResponse>>(
  //         ApiResponse.initial("INITIAL"));

  // Get single voucher sequence response
  final getVoucherSequenceByIdResponse =
      Rx<ApiResponse<GetSequencesListingGroupedResponse>>(
        ApiResponse.initial("INITIAL"),
      );

  @override
  void onInit() {
    super.onInit();
    log("Voucher Settings Controller initiated");
    getVoucherSequencesList();
  }

  @override
  void onClose() {
    log("Voucher Settings Controller Deleted");
    super.onClose();
  }

  TableRow buildTableHeaders() {
    log("The controllers length : ${headers.length} ");
    List<Widget> cells = [];

    for (int i = 0; i < headers.length; i++) {
      cells.add(
        Row(
          children: [
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  List<TableRow> buildRows(BuildContext context) {
    return List.generate(
      voucherSequencesResponse.value.data?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["Edit", "Delete"];
  TableRow buildTableRow(int index) {
    final group = voucherSequencesResponse.value.data?.elementAt(index);
    final items = group?.sequenceLineItems ?? [];

    // Every cell uses this — stacked sub-rows + single divider at bottom
    Widget cell(List<Widget> subWidgets) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [...subWidgets, CustomDashedLineWidget(width: Get.width)],
      );
    }

    Widget subRow(String text, {Color? color}) => SizedBox(
      height: 38,
      child: Align(
        alignment: Alignment.centerLeft,
        child: CustomText(
          text: text.isEmpty ? '-' : text,
          fontSize: 14,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    Widget groupCell(String text) {
      return cell([
        SizedBox(
          height: 38,
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: text.isEmpty ? '-' : text,
              fontSize: 14,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Empty rows to match height of sub-items below
        ...List.generate(items.length - 1, (_) => const SizedBox(height: 38)),
      ]);
    }

    return TableRow(
      children: [
        // Voucher Type — once, rest empty
        groupCell(group?.voucherSeriesTypeName ?? '-'),

        // Page — once, rest empty
        groupCell(group?.voucherSeriesCommodityName ?? '-'),

        // Prefix
        cell(
          items
              .map((e) => subRow(e.prefix ?? '-', color: secondaryColor))
              .toList(),
        ),

        // Suffix
        cell(
          items
              .map((e) => subRow(e.suffix ?? '-', color: secondaryColor))
              .toList(),
        ),

        // Start From
        cell(items.map((e) => subRow(e.startFrom ?? '-')).toList()),

        // Restart Every FY
        cell(
          items.map((e) {
            final val = e.restartEveryYr ?? false;
            return subRow(
              val ? 'Yes' : 'No',
              color: val ? Colors.green : Colors.orange,
            );
          }).toList(),
        ),

        // Default
        cell(
          items.map((e) {
            final val = e.isDefault ?? false;
            return subRow(
              val ? 'Yes' : 'No',
              color: val ? Colors.green : Colors.grey,
            );
          }).toList(),
        ),

        // Actions — edit icon at top, empty rows to match height
        cell([
          SizedBox(
            height: 38,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Theme(
                data: ThemeData(focusColor: greyTextColor),
                child: CustomPopupMenuButtonWidget<String>(
                  icon: const Icon(Icons.edit, size: 18),
                  itemBuilder:
                      (context) =>
                          popUpValues
                              .map(
                                (element) => PopupMenuItem<String>(
                                  value: element,
                                  height: 0,
                                  child: SizedBox(
                                    width: 88,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          element,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        if (element != popUpValues.last)
                                          CustomDashedLineWidget(
                                            width: Get.width,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                  onSelected: (value) {
                    switch (value) {
                      case 'Edit':
                        _handleEditVoucherSequence(group);
                        break;
                      case 'Delete':
                        _handleDeleteVoucherSequence(group);
                        break;
                    }
                  },
                ),
              ),
            ),
          ),
          ...List.generate(items.length - 1, (_) => const SizedBox(height: 38)),
        ]),
      ],
    );
  }

  void _handleEditVoucherSequence(GetSequencesListingGroupedResponse? group) {
    if (group == null) return;
    final sidebarController = Get.find<SettingsSidebarController>(
      tag: 'globalSettings',
    );
    sidebarController.navigateToPage(
      EditVoucherPage(
        voucherSeriesType: group.voucherSeriesType?.toString() ?? '',
        voucherSeriesCommodity: group.voucherSeriesCommodity?.toString() ?? '',
        typeName: group.voucherSeriesTypeName ?? '',
        commodityName: group.voucherSeriesCommodityName ?? '',
      ),
    );
  }

  void _handleDeleteVoucherSequence(GetSequencesListingGroupedResponse? group) {
    if (group != null) {
      log("Delete voucher group: ${group.voucherSeriesTypeName}");
    }
  }

  Future<void> getVoucherSequencesList() async {
    voucherSequencesResponse.value = ApiResponse.loading("LOADING");
    isLoading.value = true;
    try {
      final response = await _aggregateRepository.getSequencesListingGrouped();
      voucherSequencesResponse.value = ApiResponse.completed(response);
    } catch (e) {
      voucherSequencesResponse.value = ApiResponse.error(e.toString());
      showErrorToast(
        message: 'Failed to load voucher sequences: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToCreateVoucher() {
    final sidebarController = Get.find<SettingsSidebarController>(
      tag: 'globalSettings',
    );
    sidebarController.navigateToPage(const CreateVoucherPage());
  }
}
