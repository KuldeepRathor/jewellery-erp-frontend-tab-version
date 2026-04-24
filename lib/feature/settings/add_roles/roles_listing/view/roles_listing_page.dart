import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/roles_listing/models/get_roles_response.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../view_model/roles_listing_view_model.dart';

class RoleslistingPage extends StatefulWidget {
  const RoleslistingPage({super.key});

  @override
  State<RoleslistingPage> createState() => _RoleslistingPageState();
}

class _RoleslistingPageState extends State<RoleslistingPage> {
  final controller = Get.put<RoleslistingViewmodel>(RoleslistingViewmodel());
  // final SidebarController sidebarController = Get.find<SidebarController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getRolesListing(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    Get.delete<RoleslistingViewmodel>();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap: () {
          //   SidebarController sidebarController = Get.find();
          //   sidebarController.navigateToWidget(newChild: const AddRolesPage());
          // Get.to(() => const AddRolesPage());
          // Get.dialog(
          //   const AddRoleDialog(),
          // );
          controller.navigateToCreateRole();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: 'Roles'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(),
                    const SizedBox(height: 16),
                    _buildRolesTable(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        const Spacer(),
        CustomButton2(
          onTap: () {
            log("Add New Role Button Tapped");
            // SidebarController sidebarController = Get.find();
            // sidebarController.navigateToWidget(newChild: const AddRolesPage());
            // Get.to(() => const AddRolesPage());
            controller.navigateToCreateRole();
          },
          image: 'assets/svgs/add.svg',
          buttonName: 'Add New Role',
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        autofocus: true,
        onChanged: controller.setSeachQuery,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(color: greyTextColor),
          suffixIcon: Icon(Icons.search, size: 16),
        ),
      ),
    );
  }

  Widget _buildRolesTable(RoleslistingViewmodel controller) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Role Listing",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final apiStatus =
                      controller.getRolesListingResponse.value.status;

                  if (apiStatus == Status.COMPLETED) {
                    final data = controller.getRolesListingResponse.value.data;
                    if (data?.values?.isEmpty ?? true) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: LineWiseCustomTable(
                              headers: controller.headers.toList(),
                              columnWidths: controller.columnWidths.toList(),
                              itemCount: 0,
                              buildRow:
                                  (context, index, totalWidth) =>
                                      const SizedBox(),
                              isLoadingMore: false,
                              addBottomSpace: false,
                            ),
                          ),
                          Expanded(
                            flex: 15,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svgs/error/no_records_found.svg',
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return LineWiseCustomTable(
                      headers: controller.headers.toList(),
                      columnWidths: controller.columnWidths.toList(),
                      itemCount: data?.values?.length ?? 0,
                      controller: _scrollController,
                      isLoadingMore: controller.isLoadingMore.value,
                      buildRow: (context, index, totalWidth) {
                        final roleValue = data?.values?.elementAt(index);

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            focusColor: greyTextColor,
                            onTap: () {
                              controller.editRole(roleValue?.id ?? '');
                              // SidebarController sidebarController = Get.find();
                              // sidebarController.navigateToWidget(
                              //     newChild: AddRolesPage(
                              //   roleId: roleValue?.id,
                              // ));
                              // sidebarController.navigateToWidget(
                              //     newChild: RoleDashboardView(
                              //   roleId: roleValue?.id,
                              //   roleDetails: roleValue,
                              // ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Row(
                                children: List.generate(
                                  controller.headers.length,
                                  (cellIndex) {
                                    String cellContent = "-";
                                    switch (cellIndex) {
                                      case 0:
                                        cellContent = "${index + 1}";
                                        break;
                                      case 1:
                                        cellContent =
                                            roleValue?.readableId ?? "-";
                                        break;
                                      case 2:
                                        cellContent =
                                            roleValue?.roleType?.name ?? "-";
                                        break;
                                      case 3:
                                        cellContent =
                                            roleValue?.shop?.branchName ?? "-";
                                        break;

                                      case 4:
                                        cellContent =
                                            roleValue?.phoneNumber ?? "-";
                                        break;
                                      case 5:
                                        cellContent =
                                            roleValue?.isTwoFactorAuthEnabled ==
                                                    true
                                                ? "Enabled"
                                                : "Disabled";
                                        break;
                                      case 6:
                                        return _buildActionMenu(roleValue);
                                      default:
                                        cellContent = "-";
                                    }

                                    return SizedBox(
                                      width: getColumnWidthForSingleTableCell(
                                        totalWidth: totalWidth,
                                        columnWidth:
                                            controller.columnWidths[cellIndex],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                        ),
                                        child: Tooltip(
                                          message: cellContent,
                                          child: CustomText(
                                            text: cellContent,
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (apiStatus == Status.LOADING) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: 0,
                            buildRow:
                                (context, index, totalWidth) =>
                                    const SizedBox(),
                            addBottomSpace: false,
                          ),
                        ),
                        const Expanded(
                          flex: 14,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    );
                  } else if (apiStatus == Status.ERROR) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: 0,
                            buildRow:
                                (context, index, totalWidth) =>
                                    const SizedBox(),
                            addBottomSpace: false,
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Center(
                            child: Text(
                              controller
                                      .getRolesListingResponse
                                      .value
                                      .message ??
                                  "Something went wrong",
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionMenu(GetRolesResponseValue? roleValue) {
    return Theme(
      data: ThemeData(
        focusColor: greyTextColor,
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: CustomPopupMenuButtonWidget<String>(
        icon: const Icon(Icons.more_vert),
        itemBuilder:
            (BuildContext context) =>
                controller.popUpValues.map((element) {
                  return PopupMenuItem<String>(
                    value: element,
                    height: 0,
                    child: SizedBox(
                      width: 88,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          element,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
        onSelected: (String value) {
          switch (value) {
            case 'Edit':
              controller.editRole(roleValue?.id ?? "");
              break;
            case 'Delete':
              // Handle delete action
              break;
          }
        },
      ),
    );
  }
}
