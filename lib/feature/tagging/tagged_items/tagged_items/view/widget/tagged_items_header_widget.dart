import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class TaggedItemsHeaderWidget extends StatelessWidget {
  const TaggedItemsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // SidebarController sidebarController = Get.find();
                  // sidebarController.popBackSelectedWidget();
                  Get.back();
                },
                child: Container(
                  width: 27,
                  height: 35,
                  decoration: ShapeDecoration(
                    color: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const SizedBox(
                    width: 15,
                    height: 15,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: whiteColor,
                      size: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), //
              const Text(
                'Tagged Items',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Add some spacing between texts
          const Row(
            children: [
              Text(
                'Sales Counter 2',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
