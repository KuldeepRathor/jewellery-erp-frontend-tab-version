import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/attention_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/vendor_payment_details_dailog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/vendor_purchase/view/vendor_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/total_price_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/vendor_purchase/view_model/vendor_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:svg_flutter/svg.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/bill_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/item_details_widget.dart';

class PartyVendorPurchasePage extends StatefulWidget {
  const PartyVendorPurchasePage({super.key});

  @override
  PartyVendorPurchasePageState createState() => PartyVendorPurchasePageState();
}

class PartyVendorPurchasePageState extends State<PartyVendorPurchasePage> {
  final ItemDetailsController itemDetailsController = Get.put(
    ItemDetailsController(),
  );
  final VendorBillDetailsController vendorBillDetailsController =
      Get.put<VendorBillDetailsController>(VendorBillDetailsController());
  final VendorDetailsController vendorDetailsController =
      Get.put<VendorDetailsController>(VendorDetailsController());

  final RemarksController remarksController = Get.find<RemarksController>();

  final FocusNode partyDetailsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    remarksController.purchaseRemarks.value = "";
    itemDetailsController.clearControllers();
    vendorBillDetailsController.clearControllers();
    vendorDetailsController.clearControllers();
    itemDetailsController.getCodeList();

    vendorBillDetailsController.loadSequencesDropdown(
      voucherType: "4",
      voucherSection: "10",
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      partyDetailsFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    partyDetailsFocusNode.dispose();

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
            bool partySelected =
                vendorDetailsController.selectedParty.value != null;
            if (itemsValue == true &&
                billValue == true &&
                partySelected == true) {
              Get.dialog(const VendorPaymentDetailsDialog());
            } else {
              if (partySelected == false) {
                showErrorToast(message: "Please select Party");
              } else {
                showErrorToast(message: "Please enter valid data");
              }
            }
            return;
          },
        ),
        EditPartyIntent: CallbackAction<EditPartyIntent>(
          onInvoke: (intent) {
            final selectedParty = vendorDetailsController.selectedParty.value;
            if (selectedParty == null) {
              return;
            }

            // if (selectedParty is CustomerSearchValue) {
            //   Get.dialog(AddCustomerDialog(customerId: selectedParty.id));
            // } else
            if (selectedParty is VendorSearchValue) {
              Get.dialog(AddVendorDialog(vendorId: selectedParty.id));
            }
            return;
          },
        ),
        DiscardIntent: CallbackAction<DiscardIntent>(
          onInvoke: (intent) {
            Get.dialog(AttentionDialog());
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
                      header: 'Vendor Purchase',
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
                                    child: VendorDetailsWidget(
                                      isPurchase: true,
                                      focusNode: partyDetailsFocusNode,
                                      nextFocusNode:
                                          vendorBillDetailsController
                                              .invoiceNumberFocusNode,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    flex: 2,
                                    child: VendorBillDetailsWidget(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const ItemDetailsWidget(),
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
                      isPurchase: true,
                      onDiscardTap: () {
                        Get.dialog(AttentionDialog());
                      },
                      onPrimaryBtnTap: () async {
                        bool itemsValue =
                            await itemDetailsController.validateRow();
                        bool billValue =
                            vendorBillDetailsController.validateBillDetails();
                        bool partySelected =
                            vendorDetailsController.selectedParty.value != null;
                        if (itemsValue == true &&
                            billValue == true &&
                            partySelected == true) {
                          Get.dialog(const VendorPaymentDetailsDialog());
                        } else {
                          if (partySelected == false) {
                            showErrorToast(message: "Please select Party");
                          } else {
                            showErrorToast(message: "Please enter valid data");
                          }
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
