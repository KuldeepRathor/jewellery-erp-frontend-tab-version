import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_in_listing/view/branch_in_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view/widget/branch_in/branch_in_transfer_header.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view/widget/branch_transfer_confirmation_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view/widget/branch_transfer_footer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view/widget/branch_transfer_item_details.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_in_listing/view_model/branch_in_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/branch_in_transfer_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/branch_transfer_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:svg_flutter/svg.dart';

class BranchInTransferPage extends StatelessWidget {
  const BranchInTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BranchTransferItemDetailsController(tabControllerIndex: 0));
    return Scaffold(
      backgroundColor: grey1,
      body: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveBranchTransferIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.escape):
              const RemoveBranchRowIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            // SAVE
            SaveBranchTransferIntent: CallbackAction<SaveBranchTransferIntent>(
              onInvoke: (intent) async {
                final controller = Get.find<BranchInTransferViewModel>();

                if (controller.formKey.currentState?.validate() ?? false) {
                  Get.dialog(
                    BranchTransferConfirmationDialog(controller: controller),
                  );
                }
                return null;
              },
            ),

            // Discard
            DiscardIntent: CallbackAction<DiscardIntent>(
              onInvoke: (intent) {
                final controller = Get.find<BranchInTransferViewModel>();
                controller.discardAndReset();
                return null;
              },
            ),

            // REMOVE ROW
            RemoveBranchRowIntent: CallbackAction<RemoveBranchRowIntent>(
              onInvoke: (intent) {
                final controller = Get.find<BranchInTransferViewModel>();
                controller.removeLastRow();
                return null;
              },
            ),
          },
          child: FocusScope(
            autofocus: true,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    "assets/svgs/auth/background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                GetBuilder<BranchInTransferViewModel>(
                  builder: (controller) {
                    return controller.transferToDroopDownList.value.status ==
                            Status.LOADING
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderWidget(
                              header: 'Branch Transfer In',
                              wantBackButton: true,
                              onBackButtonTap: () {
                                SidebarController sidebarController =
                                    Get.find<SidebarController>();
                                Get.delete<BranchInTransferViewModel>();
                                Get.put(BranchInReportViewModel());
                                sidebarController.navigateToWidget(
                                  newChild: const BranchInListingPage(),
                                );
                              },
                              isReport: true,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const BranchInTransferHeader(),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: BranchTransferItemDetails(
                                        controller: controller,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            BranchTransferFooter(controller: controller),
                          ],
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
