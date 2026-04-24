import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/attention_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/view/material_out_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/view/material_out_party_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/view/material_out_vendor_bill_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/view_model/material_out_bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/view_model/material_out_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/total_price_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:svg_flutter/svg.dart';

class MaterialOutPage extends StatefulWidget {
  const MaterialOutPage({super.key});

  @override
  MaterialOutPageState createState() => MaterialOutPageState();
}

class MaterialOutPageState extends State<MaterialOutPage> {
  final ItemDetailsController itemDetailsController = Get.put(
    ItemDetailsController(),
  );
  final MaterialOutVendorBillDetailsController vendorBillDetailsController =
      Get.put<MaterialOutVendorBillDetailsController>(
        MaterialOutVendorBillDetailsController(),
      );
  final MaterialOutViewModel materialOutViewModel =
      Get.put<MaterialOutViewModel>(MaterialOutViewModel());
  final PartyDetailsController partyDetailsController =
      Get.put<PartyDetailsController>(PartyDetailsController());
  final RemarksController remarksController = Get.find<RemarksController>();
  final FocusNode partyDetailsFocusNode = FocusNode();
  final FocusNode vendorBillDetailsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    remarksController.purchaseReturnRemarks.value = "";
    itemDetailsController.clearControllers();
    vendorBillDetailsController.clearControllers();
    partyDetailsController.clearControllers();
    itemDetailsController.getCodeList();
    vendorBillDetailsController.fetchNextInvoiceNumber(
      invoiceType: "material_out_number_vendor",
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      partyDetailsFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    partyDetailsFocusNode.dispose();
    vendorBillDetailsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        MoveToNextScreenIntent: CallbackAction<MoveToNextScreenIntent>(
          onInvoke: (intent) async {
            bool itemsValue = await itemDetailsController.validateRow();
            bool billValue = vendorBillDetailsController.validateBillDetails();
            if (itemsValue == true && billValue == true) {
              materialOutViewModel.validateAndPostMaterialOut();
            } else {
              showErrorToast(message: "Please enter valid data");
            }
            return;
          },
        ),
        EditPartyIntent: CallbackAction<EditPartyIntent>(
          onInvoke: (intent) {
            final selectedParty = partyDetailsController.selectedParty.value;
            if (selectedParty == null) {
              return;
            }

            if (selectedParty is CustomerSearchValue) {
              Get.dialog(AddCustomerDialog(customerId: selectedParty.id));
            } else if (selectedParty is VendorSearchValue) {
              Get.dialog(AddVendorDialog(vendorId: selectedParty.id));
            }
            return;
          },
        ),
        DiscardIntent: CallbackAction<DiscardIntent>(
          onInvoke: (intent) {
            SidebarController sidebarController = Get.find();
            sidebarController.popBackSelectedWidget();
            return;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const MoveToNextScreenIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyE):
              const EditPartyIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
        },
        child: FocusScope(
          // onKeyEvent: onNormalKeyEvent,
          autofocus: true,
          child: Container(
            color: grey1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    "assets/svgs/auth/background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      header: 'Material Out',
                      wantBackButton: true,
                      onBackButtonTap: () {
                        SidebarController sidebarController = Get.find();
                        sidebarController.popBackSelectedWidget();
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: MaterialOutPartyDetailsWidget(
                                      isPurchase: false,
                                      focusNode: partyDetailsFocusNode,
                                      nextFocusNode:
                                          vendorBillDetailsController
                                              .invoiceNumberFocusNode,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    flex: 2,
                                    child: MaterialOutVendorBillDetailsWidget(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const MaterialOutItemDetailsWidget(),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Obx(() {
                    return TotalPriceWidget(
                      isPurchase: false,
                      onDiscardTap: () {
                        Get.dialog(AttentionDialog());
                      },
                      onPrimaryBtnTap: () async {
                        bool itemsValue =
                            await itemDetailsController.validateRow();
                        bool billValue =
                            vendorBillDetailsController.validateBillDetails();
                        if (itemsValue == true && billValue == true) {
                          materialOutViewModel.validateAndPostMaterialOut();
                        } else {
                          showErrorToast(message: "Please enter valid data");
                        }
                      },
                      primaryBtnText: "Next",
                      totalPriceValue:
                          itemDetailsController.totalHeadersValue
                              .toList()[itemDetailsController
                                  .totalHeadersValue
                                  .length -
                              2],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
