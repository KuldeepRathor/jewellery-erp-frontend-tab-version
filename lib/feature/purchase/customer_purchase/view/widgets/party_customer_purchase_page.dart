import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/attention_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/customer_payment_details_dailog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/customer_purchase/view/widgets/customer_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/customer_purchase/view_model/customer_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/customer_purchase/view_model/customer_purchase_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/total_price_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/metal_type_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:svg_flutter/svg.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/bill_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/item_details_widget.dart';

class PartyCustomerPurchasePage extends StatefulWidget {
  final int initialIndex;
  const PartyCustomerPurchasePage({super.key, this.initialIndex = 0});

  @override
  PartyCustomerPurchasePageState createState() =>
      PartyCustomerPurchasePageState();
}

class PartyCustomerPurchasePageState extends State<PartyCustomerPurchasePage>
    with SingleTickerProviderStateMixin {
  final ItemDetailsController itemDetailsController = Get.put(
    ItemDetailsController(),
  );
  final VendorBillDetailsController vendorBillDetailsController =
      Get.put<VendorBillDetailsController>(VendorBillDetailsController());
  final CustomerDetailsController customerDetailsController =
      Get.put<CustomerDetailsController>(CustomerDetailsController());
  final customerPurchaseController = Get.find<CustomerPurchaseViewModel>();

  final RemarksController remarksController = Get.find<RemarksController>();

  final FocusNode partyDetailsFocusNode = FocusNode();
  late TabController _tabController;

  void _loadSequenceForTab(int tabIndex) {
    String voucherSection = "1";
    if (tabIndex == 1) {
      voucherSection = "3";
    } else if (tabIndex == 2) {
      voucherSection = "2";
    }
    // voucherType "3" is used for customer purchase
    vendorBillDetailsController.loadSequencesDropdown(
      voucherType: "3",
      voucherSection: voucherSection,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: MetalTypeUtils.tabLabels.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    remarksController.purchaseRemarks.value = "";
    itemDetailsController.clearControllers();
    vendorBillDetailsController.clearControllers();
    customerDetailsController.clearControllers();
    itemDetailsController.getCodeList();
    // vendorBillDetailsController.fetchNextInvoiceNumber(
    //     invoiceType: "invoice_number_vendor");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      partyDetailsFocusNode.requestFocus();
      _loadSequenceForTab(widget.initialIndex);
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
                customerDetailsController.selectedParty.value != null;
            if (itemsValue == true &&
                billValue == true &&
                partySelected == true) {
              Get.dialog(const CustomerPaymentDetailsDailog());
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
            final selectedParty = customerDetailsController.selectedParty.value;
            if (selectedParty == null) {
              return;
            }

            if (selectedParty is CustomerSearchValue) {
              Get.dialog(AddCustomerDialog(customerId: selectedParty.id));
            }
            // else if (selectedParty is VendorSearchValue) {
            //   Get.dialog(AddVendorDialog(vendorId: selectedParty.id));
            // }
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
                      header: 'Customer Purchase',
                      wantBackButton: true,
                      onBackButtonTap: () {
                        SidebarController sidebarController = Get.find();
                        sidebarController.popBackSelectedWidget();
                      },
                    ),
                    _buildTabBar(),
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
                                    child: CustomerDetailsWidget(
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
                            customerDetailsController.selectedParty.value !=
                            null;
                        if (itemsValue == true &&
                            billValue == true &&
                            partySelected == true) {
                          Get.dialog(const CustomerPaymentDetailsDailog());
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

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (value) {
            customerPurchaseController.selectedTabIndex.value = value;
            _loadSequenceForTab(value);
          },
          tabs:
              MetalTypeUtils.tabLabels
                  .map((label) => Tab(text: label))
                  .toList(),
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          tabAlignment: TabAlignment.start,
        ),
      ),
    );
  }
}
