import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/create_jewellery_plan/create_jewellery_plan_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';

class SetupJewelleryPlanPage extends StatefulWidget {
  const SetupJewelleryPlanPage({super.key});

  @override
  State<SetupJewelleryPlanPage> createState() => _SetupJewelleryPlanPageState();
}

class _SetupJewelleryPlanPageState extends State<SetupJewelleryPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        children: [
          CustomHeaderWidget(header: "Setup New Plan"),
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/pngs/plan_jewel.png', width: 428),
                  const CustomText(
                    text: "You don't have any jewellery schemes created",
                    fontSize: 22,
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 15),
                  CustomButton1(
                    buttonName: "Setup New Plan",
                    onTap: () {
                      SidebarController sidebarController =
                          Get.find<SidebarController>();
                      sidebarController.navigateToWidget(
                        newChild: const CreateJewelleryPlanPage(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
