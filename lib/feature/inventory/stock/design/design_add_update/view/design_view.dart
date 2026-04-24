import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/generic_attention_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/design_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/design_image_upload_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/design_making_charges_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/design_settings_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_image_upload_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_making_charges_table_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view_model/design_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_footer_add_discard_remarks_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';

class DesignView extends StatefulWidget {
  final String? id;
  final String? designType;
  final String metal_type;

  const DesignView({
    super.key,
    this.id,
    this.designType = "Gold",
    this.metal_type = "1",
  });

  @override
  State<DesignView> createState() => _DesignViewState();
}

class _DesignViewState extends State<DesignView> {
  late DesignViewModel designViewModel;
  late TableMakingChargesController tableMakingChargesController;
  late DesignDetailsController designDetailsController;
  late DesignSettingsController designSettingsController;
  late DesignImageGalleryController designImageGalleryController;
  bool dataPopulated = false;
  final RemarksController remarksController = Get.find<RemarksController>();

  @override
  void initState() {
    super.initState();
    designViewModel = Get.put(DesignViewModel());
    tableMakingChargesController = Get.put(TableMakingChargesController());
    designDetailsController = Get.put(DesignDetailsController());
    designSettingsController = Get.put(DesignSettingsController());
    designImageGalleryController = Get.put(DesignImageGalleryController());
    _clearAllControllers();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        designViewModel.getDesignById(
          id: widget.id!,
          tableMakingChargesController: tableMakingChargesController,
          designDetailsController: designDetailsController,
          designSettingsController: designSettingsController,
          designImageGalleryController: designImageGalleryController,
        );
      });
    }
  }

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    log("build called $counter");
    counter++;
    return Actions(
      actions: <Type, Action<Intent>>{
        // CloseDialogIntent: CallbackAction<CloseDialogIntent>(
        //   onInvoke: (intent) {
        //     log("close escape pressed");
        //     _clearAllControllers();
        //     // onClose?.call();
        //     return;
        //   },
        // ),
        SaveDesignIntent: CallbackAction<SaveDesignIntent>(
          onInvoke: (intent) {
            bool isLoading =
                designViewModel.postDesignResponse.value.status ==
                    Status.LOADING ||
                (widget.id != null &&
                    designViewModel.updateDesignResponse.value.status ==
                        Status.LOADING);
            if (isLoading == false) {
              _handleSaveOrUpdate();
            }
            // actions.;
            return;
          },
        ),
        DiscardIntent: CallbackAction<DiscardIntent>(
          onInvoke: (intent) {
            _clearAllControllers(shouldAddRow: true);
            setState(() {});
            return;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          // LogicalKeySet(LogicalKeyboardKey.escape): const CloseDialogIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveDesignIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
        },
        child: FocusScope(
          autofocus: true,
          child: Container(
            color: grey1,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      header:
                          widget.id != null
                              ? 'Edit ${widget.designType} Design'
                              : 'Add ${widget.designType} Design',
                      // wantBackButton: widget.id != null,
                      wantBackButton: true,
                      onBackButtonTap: () {
                        SidebarController sidebarController = Get.find();
                        log("Popping values from ");
                        sidebarController.popBackSelectedWidget();
                      },
                    ),
                    Expanded(
                      child: Obx(() {
                        designViewModel.getDesignByIdResponse.value.status;
                        if (widget.id != null) {
                          switch (designViewModel
                              .getDesignByIdResponse
                              .value
                              .status) {
                            case Status.LOADING:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case Status.ERROR:
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Error: ${designViewModel.getDesignByIdResponse.value.message}',
                                    ),
                                    CustomInkButton(
                                      onPressed:
                                          () => designViewModel.getDesignById(
                                            id: widget.id!,
                                            tableMakingChargesController:
                                                tableMakingChargesController,
                                            designDetailsController:
                                                designDetailsController,
                                            designSettingsController:
                                                designSettingsController,
                                            designImageGalleryController:
                                                designImageGalleryController,
                                          ),
                                      text: ('Retry'),
                                    ),
                                  ],
                                ),
                              );
                            case Status.COMPLETED:
                              // Populate controllers with fetched data
                              log("populating values ");
                              _populateControllersWithFetchedData();
                              break;
                            default:
                              break;
                          }
                        }

                        return _buildDesignForm();
                      }),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Obx(() => _buildFooter()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesignForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DesignDetailsWidget(
                        isEditMode: widget.id != null,
                        metal_type: widget.metal_type,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: SettingsWidget(isEditMode: widget.id != null),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TableMakingChargesWidget(
                    isEditMode: widget.id != null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: ImageGalleryWidget(
              // isEditMode: widget.id != null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    bool isLoading =
        designViewModel.postDesignResponse.value.status == Status.LOADING ||
        (widget.id != null &&
            designViewModel.updateDesignResponse.value.status ==
                Status.LOADING);

    return CustomFooterAddDiscardRemark(
      onRemarkPressed: () async {
        RemarksController remarksController = Get.find<RemarksController>();

        String? remarks = await Get.dialog(
          AddRemarkDialog(
            initialTextString:
                widget.id != null
                    ? designViewModel
                            .getDesignByIdResponse
                            .value
                            .data
                            ?.remarks ??
                        ""
                    : remarksController.designRemarks.value,
          ),
        );
        if (remarks != null) {
          remarksController.setDesignRemarkString(remarksSent: remarks);
        } else {
          remarksController.setDesignRemarkString(remarksSent: "");
        }
      },
      onDiscardPressed: () => _clearAllControllers(shouldAddRow: true),
      onNextPressed: isLoading ? null : _handleSaveOrUpdate,
      remarkText: "Remarks",
      discardText: "Discard (esc)",
      nextText: widget.id != null ? "Update" : "Save",
      saveBtnVisibility: !isLoading,
      backgroundColor: grey1,
    );
  }

  void _clearAllControllers({bool shouldAddRow = false}) {
    PermissionGuardUtil.withActionPermission(4253, () {
      tableMakingChargesController.clearControllers(shouldAddRow: shouldAddRow);
      designDetailsController.clearControllers();
      designSettingsController.clearControllers();
      designImageGalleryController.clearControllers();
      remarksController.designRemarks.value = "";

      designDetailsController.designNameFocusNode.requestFocus();
    });
  }

  bool _hasShownDialog = false;
  bool applyChangesToFurtherPieces = false;
  void _handleSaveOrUpdate() {
    PermissionGuardUtil.withActionPermission(4253, () {
      if (widget.id != null) {
        if (!_hasShownDialog && widget.id != null) {
          _hasShownDialog = true;
          Get.dialog(
            GenericAttentionDialog(
              title: 'VA Changed',
              message:
                  'Do you want to apply changes to further pieces?', // TODO: Further to Existing
              actions: [
                DialogAction(
                  text: '''Don't''',
                  onPressed: () {
                    // Handle 'No' action
                    setState(() {
                      applyChangesToFurtherPieces = false;
                      _updateDesign(false);
                    });
                    Get.back();
                  },
                  shortcut: 'esc',
                ),
                DialogAction(
                  text: 'Apply',
                  onPressed: () {
                    // Handle 'Yes' action
                    log("From parent");
                    setState(() {
                      applyChangesToFurtherPieces = true;
                      _updateDesign(true);
                    });
                    Get.back();
                  },
                  isDefault: true,
                  shortcut: 'Enter',
                ),
              ],
            ),
          );
        }
      } else {
        _addDesign();
      }
    });
  }

  void _addDesign() {
    designViewModel.addDesign(
      tableMakingChargesController: tableMakingChargesController,
      designDetailsController: designDetailsController,
      designSettingsController: designSettingsController,
      designImageGalleryController: designImageGalleryController,
    );
    // .then(_handleApiResponse);
  }

  void _updateDesign(bool changeExistingTags) {
    designViewModel.updateDesign(
      id: widget.id ?? "-",
      tableMakingChargesController: tableMakingChargesController,
      designDetailsController: designDetailsController,
      designSettingsController: designSettingsController,
      designImageGalleryController: designImageGalleryController,
      changeExistingTags: changeExistingTags,
    );
  }

  void _populateControllersWithFetchedData() {
    final designData = designViewModel.getDesignByIdResponse.value.data;
    if (designData != null && dataPopulated == false) {
      designDetailsController.populateWithFetchedData(designData);
      designSettingsController.populateWithFetchedData(designData);
      tableMakingChargesController.populateWithFetchedData(designData);
      designImageGalleryController.populateWithFetchedData(designData);

      log("The populated design 2 : ${designData.toRawJson()}");
      dataPopulated = true;
    }
  }
}
