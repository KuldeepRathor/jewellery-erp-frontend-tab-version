import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_to_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/view_model/add_roles_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

import '../../../../../res/colors/app_color.dart';
import '../../../../../utils/intents.dart';
import '../../../../../utils/latest_widgets/action_scope_widget.dart';
import '../../../../../utils/textstyle.dart';
import '../../../../../utils/widgets/custom_checkbox_widget.dart';
import '../../../../../utils/widgets/custom_int_button_widget.dart';
import '../../../../../utils/widgets/custom_text_field.dart';

// Import the permissions view model
import '../view_model/permissions_view_model.dart';
import '../model/get_role_types_model.dart';
import '../model/modules_response.dart';

class AddRolesPage extends StatefulWidget {
  final String? roleId; // Optional parameter for edit mode

  const AddRolesPage({super.key, this.roleId});

  @override
  State<AddRolesPage> createState() => _AddRolesPageState();
}

class _AddRolesPageState extends State<AddRolesPage> {
  // Initialize the permissions view model
  late final AddRolesViewModel controller;
  late final PermissionsViewModel permissionsViewModel;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AddRolesViewModel());
    permissionsViewModel = Get.put(PermissionsViewModel());

    // Check if we're in edit mode
    if (widget.roleId != null && widget.roleId!.isNotEmpty) {
      isEditMode = true;
      // Schedule the loading for after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadRoleById(widget.roleId!);
      });
    }
  }

  @override
  void dispose() {
    Get.delete<PermissionsViewModel>();
    Get.delete<AddRolesViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        additionalShortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveRoleIntent(),
        },
        additionalActions: {
          DiscardIntent: CallbackAction<DiscardIntent>(
            onInvoke: (intent) {
              controller.onDiscardTapped();
              return null;
            },
          ),
          SaveRoleIntent: CallbackAction<SaveRoleIntent>(
            onInvoke: (intent) {
              controller.onConfirmTapped();
              return null;
            },
          ),
        },
        child: Obx(() {
          // Show loading spinner while fetching role data in edit mode
          if (controller.isEditMode.value &&
              controller.roleByIdResponse.value.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error if loading failed
          if (controller.isEditMode.value &&
              controller.roleByIdResponse.value.status == Status.ERROR) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading role data: ${controller.roleByIdResponse.value.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  CustomInkButton(
                    onPressed: () {
                      if (controller.currentRoleId.value.isNotEmpty) {
                        controller.loadRoleById(controller.currentRoleId.value);
                      } else {
                        Get.back(); // Return to previous screen if no roleId
                      }
                    },
                    text: 'Retry',
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                header: controller.isEditMode.value ? 'Edit Role' : 'Add Role',
                wantBackButton: true,
                onBackButtonTap: () {
                  // SidebarController sidebarController = Get.find();
                  // sidebarController.popBackSelectedWidget();
                  controller.goBack();
                },
              ),
              Expanded(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      Expanded(child: _buildRolesSettings(context, controller)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAddRolesDetails(AddRolesViewModel controller) {
    return Container(
      margin: const EdgeInsets.all(14),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 38.0,
          right: 38.0,
          bottom: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.isEditMode.value
                  ? "Edit Role Details"
                  : "Role Details",
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  name: "Role ID",
                  width: 250,
                  autofocus: !controller.isEditMode.value,
                  enabled:
                      !controller
                          .isEditMode
                          .value, // Disable editing Role ID in edit mode
                  focusNode: controller.roleIdFocusNode,
                  controller: controller.roleId,
                  onChanged: (value) {
                    final capitalizedValue = value.toUpperCase();
                    final currentCursorPosition =
                        controller.roleId.selection.baseOffset;

                    controller.roleId.value = TextEditingValue(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(
                        offset: currentCursorPosition,
                      ),
                    );
                  },
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.nextFocus();
                  },
                  validator: (value) => controller.validateRoleId(value),
                  capitalizeText: true,
                ),
                const SizedBox(width: 20),
                CustomTextField(
                  name: "Enter 4 digit pin",
                  width: 250,
                  controller: controller.digitPin,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.nextFocus();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (value) => controller.validatePin(value),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: "Branch ID",
                        color: blackColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      Obx(
                        () => GenericAutocompleteDropdown<BranchValue>(
                          controller: controller.branchId.value,
                          focusNode: controller.branchIdFocusNode,
                          items: controller.branchOptions.toList(),
                          getDisplayValue: (branch) => branch.readableId ?? '',
                          onEditingComplete: () {
                            controller.roleTypeFocusNode.requestFocus();
                          },
                          padding: const EdgeInsets.only(top: 8),
                          onSelected: (value) {
                            controller.setSelectedBranch(value);
                            controller.roleTypeFocusNode.requestFocus();
                          },
                          borderColor: secondaryColor,
                          isLastRow: true,
                          validator:
                              (value) => controller.validateBranchId(value),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: "Role Type",
                        color: blackColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      GenericAutocompleteDropdown<GetRoleTypesResponse>(
                        controller: controller.roleType.value,
                        focusNode: controller.roleTypeFocusNode,
                        items: controller.roleTypeOptions.toList(),
                        getDisplayValue: (roleType) => roleType.roleType ?? "",
                        padding: const EdgeInsets.only(top: 8),
                        onSelected: (value) {
                          controller.setSelectedRoleType(value);
                          controller.twoFactorAuthenticationFocusNode
                              .requestFocus();
                        },
                        borderColor: secondaryColor,
                        isLastRow: true,
                        onEditingComplete: () {
                          controller.twoFactorAuthenticationFocusNode
                              .requestFocus();
                        },
                        validator:
                            (value) => controller.validateRoleType(value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDashedLineWidget(width: Get.width),
            const SizedBox(height: 16),

            Obx(
              () => Row(
                children: [
                  CustomCheckBoxWidget(
                    value: controller.twoFactorAuthentication.value,
                    focusNode: controller.twoFactorAuthenticationFocusNode,
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateConcent(value);
                      }
                    },
                  ),
                  const CustomText(
                    text: "Add two factor authentication for this role",
                    color: blackColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins",
                    fontSize: 16,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                name: "Enter mobile number for verification",
                width: 250,
                controller: controller.mobileNumber,
                onEditingComplete: () {
                  FocusManager.instance.primaryFocus?.nextFocus();
                },
                validator: (value) => controller.validateMobileNumber(value),
              ),
            ),
            const SizedBox(height: 16),
            CustomDashedLineWidget(width: Get.width),
            const SizedBox(height: 16),

            // Permissions Section Header
            const Text(
              "Permissions",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            // Permissions Row Layout
            Expanded(child: _buildPermissionsRow()),

            const SizedBox(height: 20),
            CustomDashedLineWidget(width: Get.width),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    controller.onDiscardTapped();
                  },
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
                const SizedBox(width: 40),
                Obx(
                  () => CustomInkButton(
                    onPressed: () {
                      // Add permissions data to controller before saving
                      final permissionsData =
                          permissionsViewModel.getPermissionsForSaving();
                      log(
                        'Permissions to save: ${permissionsData.map((e) => e.toRawJson()).toList()}',
                      );

                      // Call the confirm method
                      controller.onConfirmTapped();
                    },
                    text:
                        controller.isEditMode.value
                            ? "Update (ctrl+s)"
                            : "Confirm (ctrl+s)",
                    isLoading: controller.isLoading.value,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modules Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Modules"),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: permissionsViewModel.modules.length,
                      itemBuilder: (context, index) {
                        final module = permissionsViewModel.modules[index];
                        return _buildModuleListItem(module);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Pages Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Pages"),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() {
                    return _buildPagesList();
                  }),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Actions Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Actions"),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() {
                    return _buildActionsList();
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildModuleListItem(ModulePermission module) {
    return Obx(
      () => Container(
        decoration: ShapeDecoration(
          color:
              permissionsViewModel.selectedModuleId.value == module.moduleId
                  ? grey1
                  : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: ListTile(
          title: Text(
            module.displayName ?? "",
            style: TextStyle(
              fontWeight:
                  permissionsViewModel.selectedModuleId.value == module.moduleId
                      ? FontWeight.bold
                      : FontWeight.normal,
            ),
          ),
          selected:
              permissionsViewModel.selectedModuleId.value == module.moduleId,
          onTap: () {
            permissionsViewModel.selectModule(module.moduleId!);
          },
          trailing: CustomToggleSwitch(
            value: module.isActive!,
            onChanged: (value) {
              permissionsViewModel.toggleModule(module, value);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPagesList() {
    final pages = permissionsViewModel.pagesForSelectedModule;

    if (permissionsViewModel.selectedModuleId.value == null) {
      return const Center(child: Text('Please select a module first'));
    }

    if (pages.isEmpty) {
      return const Center(child: Text('No pages available for this module'));
    }

    return ListView.builder(
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final page = pages[index];
        return Obx(
          () => Container(
            decoration: ShapeDecoration(
              color:
                  permissionsViewModel.selectedPageId.value == page.pageId
                      ? grey1
                      : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: ListTile(
              title: Text(
                page.displayName ?? "",
                style: TextStyle(
                  fontWeight:
                      permissionsViewModel.selectedPageId.value == page.pageId
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
              selected:
                  permissionsViewModel.selectedPageId.value == page.pageId,
              onTap: () {
                permissionsViewModel.selectPage(page.pageId!);
              },
              trailing: CustomToggleSwitch(
                value: page.isActive!,
                onChanged: (value) {
                  permissionsViewModel.togglePage(page, value);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionsList() {
    final actions = permissionsViewModel.actionsForSelectedPage;

    if (permissionsViewModel.selectedPageId.value == null) {
      return const Center(child: Text('Please select a page first'));
    }

    if (actions.isEmpty) {
      return const Center(child: Text('No actions available for this page'));
    }

    return ListView.builder(
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return ListTile(
          title: Text(action.displayName ?? ""),
          trailing: CustomToggleSwitch(
            value: action.isActive!,
            onChanged: (value) {
              permissionsViewModel.toggleAction(action, value);
            },
          ),
        );
      },
    );
  }

  Widget _buildRolesSettings(
    BuildContext context,
    AddRolesViewModel controller,
  ) {
    return _buildAddRolesDetails(controller);
  }
}
