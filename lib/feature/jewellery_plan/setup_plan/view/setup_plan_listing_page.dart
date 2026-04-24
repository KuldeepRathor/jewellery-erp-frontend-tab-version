// setup_plan_listing_page.dart
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/custom_header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/widgets/plan_card_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/setup_jewellery_plan_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class SetupPlanListingPage extends StatefulWidget {
  const SetupPlanListingPage({super.key});

  @override
  State<SetupPlanListingPage> createState() => _SetupPlanListingPageState();
}

class _SetupPlanListingPageState extends State<SetupPlanListingPage> {
  final SetupPlanController controller = Get.put(SetupPlanController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.keyS &&
            HardwareKeyboard.instance.isAltPressed) {
          controller.addNewPlan();
        }
      },
      child: Scaffold(
        backgroundColor: grey1,
        body: Column(
          children: [
            CustomHeaderWidget(
              header: "Setup New Plan",
              wantBackButton: true,
              onBackButtonTap: () {
                SidebarController sidebarController = Get.find();
                sidebarController.popBackSelectedWidget();
              },
            ),
            _buildSearchAndAddButton(),
            Expanded(child: _buildPlansGrid()),
            // _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndAddButton() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      color: whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            // Using ConstrainedBox instead of SizedBox
            constraints: const BoxConstraints(
              maxWidth: 250, // Set an appropriate max width
            ),
            child: ElevatedButton.icon(
              onPressed: controller.addNewPlan,
              icon: const Icon(Icons.add, color: primaryColor),
              label: const IntrinsicWidth(
                // Using IntrinsicWidth to handle content size
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: "Add New Plan",
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(width: 5),
                    CustomText(
                      text: "Alt + S",
                      fontSize: 12,
                      color: primaryColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: grey1,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ), // Adjusted padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansGrid() {
    return Obx(() {
      final response = controller.getJewelleryPlanResponse.value;

      if (response.status == Status.LOADING && controller.plans.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (response.status == Status.ERROR) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${response.message}'),
              ElevatedButton(
                onPressed: controller.refreshPlans,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.plans.isEmpty) {
        return const Center(child: Text('No plans found'));
      }

      return RefreshIndicator(
        onRefresh: controller.refreshPlans,
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount:
              controller.plans.length + (controller.hasMoreData.value ? 1 : 0),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == controller.plans.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final plan = controller.plans[index];
            return PlanCardWidget(
              plan: plan,
              onTap: () => controller.selectPlan(plan),
            );
          },
        ),
      );
    });
  }
}
