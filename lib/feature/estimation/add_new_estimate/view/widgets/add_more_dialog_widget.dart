import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/advance_booking/advance_booking_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/digital_coin/estimate_digital_coin_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/jewellery_plan/jewellery_plan_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/old_gold/old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/orders/add_orders_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/quick_estimate/quick_estimate_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/quick_old_gold/quick_old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/estimation_payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class AddMoreDialogWidget extends StatefulWidget {
  const AddMoreDialogWidget({super.key});

  @override
  State<AddMoreDialogWidget> createState() => _AddMoreDialogWidgetState();
}

class _AddMoreDialogWidgetState extends State<AddMoreDialogWidget> {
  final EstimationItemDetailsController controller =
      Get.find<EstimationItemDetailsController>();
  Offset? _tapPosition;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        focusColor: greyTextColor,
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: InkWell(
        onTapDown: (details) {
          _tapPosition = details.globalPosition;
        },
        child: CustomPopupMenuButtonWidget<String>(
          icon: const Text(
            "Add More",
            style: TextStyle(
              fontSize: 16,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          itemBuilder:
              (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  height: 0,
                  onTap: () {
                    Get.back();
                    Get.dialog(const OldGoldDialog());
                  },
                  child: const SizedBox(
                    width: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          "Add/Edit Old Gold",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  height: 0,
                  onTap: () {
                    Get.back();
                    Get.dialog(const QuickEstimateDialog());
                  },
                  child: const SizedBox(
                    width: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          "Add/Edit Estimate",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  height: 0,
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 0), () {
                      // ignore: use_build_context_synchronously
                      _showPopupMenu(context, _tapPosition ?? Offset.zero);
                    });
                  },
                  child: const SizedBox(
                    width: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          "Others",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
        ),
      ),
    );
    // Stack(
    //   children: [
    //     Container(
    //       height: Get.height * 0.2,
    //       width: Get.width * 0.6,
    //       padding: const EdgeInsets.all(16),
    //       decoration: BoxDecoration(
    //         color: whiteColor,
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           TextWithShortcutButton(
    //             text: 'Add/Edit Old Gold',
    //             controlKey: 'Ctrl',
    //             functionKey: 'F4',
    //             onPressed: () {
    //               print('Button pressed!');
    //               // bool isItemsDataValid =
    //               //     controller.validateRow();
    //               // if (isItemsDataValid == false) {
    //               //   showErrorToast(
    //               //       message: "Invalid Item Data");
    //               // } else {}
    //               Get.back();
    //               Get.dialog(
    //                 const OldGoldDialog(),
    //               );
    //               // Add your desired action here
    //             },
    //           ),
    //           const SizedBox(
    //             width: 16,
    //           ),
    //           TextWithShortcutButton(
    //             text: 'Add/Edit Estimate',
    //             controlKey: 'Ctrl',
    //             functionKey: 'F5',
    //             onPressed: () {
    //               print('Button pressed!');
    //               Get.back();
    //               // Add your desired action here
    //               Get.dialog(
    //                 const QuickEstimateDialog(),
    //               );
    //             },
    //           ),
    //           const SizedBox(
    //             width: 16,
    //           ),
    //           TextWithShortcutButton(
    //             text: 'Others',
    //             controlKey: 'Ctrl',
    //             functionKey: 'F6',
    //             onTapDown: (details) {
    //               log("The details are ${details.globalPosition}");
    //               _showPopupMenu(context, details.globalPosition);
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //     Positioned(
    //         top: 5,
    //         right: 10,
    //         child: IconButton(
    //             onPressed: () {
    //               Get.back();
    //             },
    //             icon: const Icon(
    //               Icons.close,
    //               color: redTextColor,
    //             )))
    //   ],
    // );
  }

  void _showPopupMenu(BuildContext context, Offset offset) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(offset, offset.translate(0, 0)),
      Offset.zero & overlay.size,
    );

    final String? selectedValue = await showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'advance_booking',
          child: _buildMenuItem('Add Advance Booking', 'F9'),
          onTap: () {
            bool isItemsDataValid = controller.validateRow();
            if (isItemsDataValid == false) {
              showErrorToast(message: "Invalid Item Data");
            } else {
              Get.dialog(const AdvanceBookingDialog());
            }
          },
        ),
        PopupMenuItem<String>(
          value: 'jewellery_plan',
          child: _buildMenuItem('Add Jewellery Plan', 'F10'),
          onTap: () {
            bool isItemsDataValid = controller.validateRow();
            if (isItemsDataValid == false) {
              showErrorToast(message: "Invalid Item Data");
            } else {
              Get.dialog(const JewelleryPlanDialog());
            }
          },
        ),
        PopupMenuItem<String>(
          value: 'old_gold_estimate',
          child: _buildMenuItem('Add Old Gold Estimate', 'F8'),
          onTap: () {
            // bool isItemsDataValid = controller.validateRow();
            // if (isItemsDataValid == false) {
            //   showErrorToast(message: "Invalid Item Data");
            // } else {
            Get.dialog(const QuickOldGoldDialog());
            // }
          },
        ),
        PopupMenuItem<String>(
          value: 'digital_gold',
          child: _buildMenuItem('Add Digital Gold', 'F7'),
          onTap: () {
            bool isItemsDataValid = controller.validateRow();
            if (isItemsDataValid == false) {
              showErrorToast(message: "Invalid Item Data");
            } else {
              Get.dialog(const EstimationDigitalGoldDialog());
            }
          },
        ),
        PopupMenuItem<String>(
          value: 'orders',
          child: _buildMenuItem('Add orders', 'F11'),
          onTap: () {
            bool isItemsDataValid = controller.validateRow();
            if (isItemsDataValid == false) {
              showErrorToast(message: "Invalid Item Data");
            } else {
              Get.dialog(const AddOrdersDialog());
            }
          },
        ),
        PopupMenuItem<String>(
          value: 'payment_details',
          child: _buildMenuItem('Add Payment Details', '-'),
          onTap: () {
            bool isItemsDataValid = controller.validateRow();
            if (isItemsDataValid == false) {
              showErrorToast(message: "Invalid Item Data");
            } else {
              Get.dialog(const EstimationPaymentDetailsDialog());
            }
          },
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
    );

    if (selectedValue != null) {
      // Handle the selected action here
    }
  }

  Widget _buildMenuItem(String text, String shortcut) {
    return Text(
      '$text ($shortcut)',
      style: const TextStyle(
        color: Color(0xFF28328B),
        fontSize: 16,
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
