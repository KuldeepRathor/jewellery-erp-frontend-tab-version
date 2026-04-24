import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/add_remark_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view/widgets/create_order_add_notes_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view/widgets/create_order_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view/widgets/create_order_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view/widgets/create_order_old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view/widgets/create_order_payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg.dart';

class SaveOrderIntent extends Intent {
  const SaveOrderIntent();
}

class DiscardOrderIntent extends Intent {
  const DiscardOrderIntent();
}

class OpenOldGoldDialogIntent extends Intent {
  const OpenOldGoldDialogIntent();
}

class OpenNotesDialogIntent extends Intent {
  const OpenNotesDialogIntent();
}

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final CreateOrderViewModel controller = Get.put<CreateOrderViewModel>(
    CreateOrderViewModel(),
  );
  final CreateOrderPartyDetailsController partyDetailsController =
      Get.put<CreateOrderPartyDetailsController>(
        CreateOrderPartyDetailsController(),
      );
  final RateCaratInputController rateCaratInputController =
      Get.put<RateCaratInputController>(RateCaratInputController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.partyDetailsFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        SaveOrderIntent: CallbackAction<SaveOrderIntent>(
          onInvoke: (intent) async {
            Get.dialog(const CreateOrderPaymentDetailsDialog());
            return null;
          },
        ),
        DiscardOrderIntent: CallbackAction<DiscardOrderIntent>(
          onInvoke: (intent) async {
            // Clear all fields including old gold
            controller.clearAllFields();

            // Also clear old gold controller if it exists
            if (Get.isRegistered<CreateOrderOldGoldController>()) {
              final oldGoldController =
                  Get.find<CreateOrderOldGoldController>();
              oldGoldController.clearTextController();
            }

            return null;
          },
        ),
        OpenOldGoldDialogIntent: CallbackAction<OpenOldGoldDialogIntent>(
          onInvoke: (intent) async {
            await Get.dialog(const CreateOrderOldGoldDialog());
            return null;
          },
        ),
        OpenNotesDialogIntent: CallbackAction<OpenNotesDialogIntent>(
          onInvoke: (intent) async {
            Get.dialog(const AddNotesDialog());
            return null;
          },
        ),
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveOrderIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardOrderIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.f4):
              const OpenOldGoldDialogIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.f5):
              const OpenNotesDialogIntent(),
        },
        child: Scaffold(
          backgroundColor: grey1,
          body: Focus(
            autofocus: true,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    "assets/svgs/auth/background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    HeaderWidget(
                      header: 'Create Order',
                      wantBackButton: true,
                      onBackButtonTap: () {
                        SidebarController sidebarController = Get.find();
                        sidebarController.popBackSelectedWidget();
                        controller.clearAllFields();
                      },
                    ),
                    const SizedBox(height: 16),
                    CreateOrderDetailsWidget(
                      controller: controller,
                      partyDetailsController: partyDetailsController,
                      rateCaratInputController: rateCaratInputController,
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CreateOrderItemDetailsWidget(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _footerWidget(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: whiteColor,
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              Get.dialog(const AddRemarkDialog());
            },
            child: Container(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: grey1,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, color: primaryColor),
                  SizedBox(width: 4),
                  CustomText(
                    text: "Remarks",
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(width: Get.width * 0.01),
          InkWell(
            onTap: () {
              controller.clearAllFields();
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
          SizedBox(width: Get.width * 0.01),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                Get.dialog(const CreateOrderPaymentDetailsDialog());
              },
              child: Ink(
                height: 38,
                width: 140,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Save",
                          fontSize: 16,
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: CustomText(
                            text: "Ctrl + S",
                            fontSize: 12,
                            color: whiteColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
