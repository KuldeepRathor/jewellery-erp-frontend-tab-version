import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_out_listing/view/branch_out_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view/widget/branch_out/branch_out_transfer_header.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view/widget/branch_transfer_footer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view/widget/branch_transfer_item_details.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_out_listing/view_model/branch_out_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/branch_out_transfer_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/branch_transfer_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:svg_flutter/svg.dart';

class BranchOutTransferPage extends StatefulWidget {
  const BranchOutTransferPage({super.key});

  @override
  State<BranchOutTransferPage> createState() => _BranchOutTransferPageState();
}

class _BranchOutTransferPageState extends State<BranchOutTransferPage> {
  @override
  void initState() {
    super.initState();

    // Register only when first used
    if (!Get.isRegistered<BranchOutTransferViewModel>()) {
      Get.lazyPut<BranchOutTransferViewModel>(
        () => BranchOutTransferViewModel(),
      );
    }

    if (!Get.isRegistered<BranchTransferItemDetailsController>()) {
      Get.lazyPut<BranchTransferItemDetailsController>(
        () => BranchTransferItemDetailsController(tabControllerIndex: 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: FocusScope(
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/svgs/auth/background.svg",
                fit: BoxFit.cover,
              ),
            ),
            GetBuilder<BranchOutTransferViewModel>(
              builder: (controller) {
                return controller.transferToDroopDownList.value.status ==
                        Status.LOADING
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderWidget(
                          header: 'Branch Transfer Out',
                          wantBackButton: true,
                          onBackButtonTap: () {
                            SidebarController sidebarController =
                                Get.find<SidebarController>();
                            Get.delete<BranchOutTransferViewModel>();
                            Get.put(BranchOutReportViewModel());
                            sidebarController.navigateToWidget(
                              newChild: const BranchOutListingPage(),
                            );
                          },
                          isReport: true,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const BranchOutTransferHeader(),
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
    );
  }
}
