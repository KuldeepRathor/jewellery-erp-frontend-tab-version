import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/view/daily_rates_listing_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/view/widgets/add_daily_rates_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class CustomGoldRatePopup extends StatelessWidget {
  CustomGoldRatePopup({super.key});

  final GoldRateController controller = Get.put(GoldRateController());

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: primaryColor.withBlue(190),
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: Obx(() {
        final response = controller.getGoldRatesResponse.value;

        if (response.status == Status.LOADING) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (response.status == Status.ERROR) {
          return PopupMenuButton<void>(
            offset: const Offset(0, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(width: 1, color: Color(0xFFE6E8FF)),
            ),
            color: Colors.white,
            elevation: 4,
            itemBuilder: (context) {
              return [
                PopupMenuItem<void>(
                  enabled: false,
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GoldRateItem(type: 'Gold 22k', price: "0.00"),
                        const Center(
                          child: CustomDashedLineWidget(
                            width: double.maxFinite,
                          ),
                        ),
                        const GoldRateItem(type: 'Gold 18k', price: "0.00"),
                        const Center(
                          child: CustomDashedLineWidget(
                            width: double.maxFinite,
                          ),
                        ),
                        const GoldRateItem(type: 'Silver', price: "0.00"),
                        const Center(
                          child: CustomDashedLineWidget(
                            width: double.maxFinite,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                                Get.to(const DailyRatesListingView());

                                Get.dialog(const AddDailyRatesDialog()).then((
                                  value,
                                ) {
                                  controller.fetchGoldRates();
                                });
                              },
                              child: const CustomText(
                                text: 'Change Rates',
                                textAlign: TextAlign.center,
                                color: secondaryColor,
                                fontSize: 16,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ];
            },
            child: const GoldRateDisplay(currentRate: "0.00"),
          );
        }
        if (response.status == Status.COMPLETED) {
          final goldRates = response.data!;
          return PopupMenuButton<void>(
            offset: const Offset(0, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(width: 1, color: Color(0xFFE6E8FF)),
            ),
            color: Colors.white,
            elevation: 4,
            itemBuilder: (context) {
              return [
                PopupMenuItem<void>(
                  enabled: false,

                  // height: 280, // Adjust based on the number of items
                  padding: EdgeInsets.zero,

                  // height: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GoldRateItem(
                        //     type: 'Gold 24k', price: goldRates.price24k ?? "-"),
                        GoldRateItem(
                          type: 'Gold 22k',
                          price: goldRates.price22k ?? "0.00",
                        ),
                        const Center(
                          child: CustomDashedLineWidget(
                            width: double.maxFinite,
                          ),
                        ),

                        GoldRateItem(
                          type: 'Gold 18k',
                          price: goldRates.price18k ?? "0.00",
                        ),
                        const Center(
                          child: CustomDashedLineWidget(
                            width: double.maxFinite,
                          ),
                        ),
                        // GoldRateItem(
                        //     type: 'Gold Plain',
                        //     price: goldRates.pricePlain ?? "-"),
                        GoldRateItem(
                          type: 'Silver',
                          price: goldRates.priceSilver ?? "0.00",
                        ),
                        const Center(
                          child: CustomDashedLineWidget(
                            width: double.maxFinite,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                                // SidebarController sidebarController =
                                //     Get.find();
                                // sidebarController.selectPage(11);
                                Get.to(const DailyRatesListingView());

                                Get.dialog(const AddDailyRatesDialog()).then((
                                  value,
                                ) {
                                  controller.fetchGoldRates();
                                });
                              },
                              child: const CustomText(
                                text: 'Change Rates',
                                textAlign: TextAlign.center,
                                color: secondaryColor,
                                fontSize: 16,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // GoldRateItem(
                        //     type: 'Silver 999',
                        //     price: goldRates.priceSilver999 ?? "-"),
                        // GoldRateItem(
                        //     type: 'Platinum',
                        //     price: goldRates.pricePlatinum ?? "-"),
                      ],
                    ),
                  ),
                ),
              ];
            },
            child: GoldRateDisplay(currentRate: goldRates.price22k ?? "0.00"),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}

class GoldRateDisplay extends StatelessWidget {
  final String currentRate;

  const GoldRateDisplay({super.key, required this.currentRate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Gold Rate:',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '₹$currentRate',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(width: 26),
          Transform(
            transform: Matrix4.identity()..rotateZ(1.57),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class GoldRateItem extends StatelessWidget {
  final String type;
  final String price;

  const GoldRateItem({super.key, required this.type, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 157,
      // height: 30,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: const TextStyle(
              color: Color(0xFF28328B),
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(width: 24),
          Text(
            '₹$price',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class GoldRateInfo {
  final String type;
  final String price;

  GoldRateInfo({required this.type, required this.price});
}
