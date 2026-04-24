// home_page_webstore.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/webstore_sidebar/view_model/banners_webstore_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class BannersWebstore extends StatefulWidget {
  const BannersWebstore({super.key});

  @override
  State<BannersWebstore> createState() => _BannersWebstoreState();
}

class _BannersWebstoreState extends State<BannersWebstore> {
  late final BannersController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BannersController());
  }

  @override
  void dispose() {
    Get.delete<BannersController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        children: [
          // Universal header
          _buildHeader(controller),

          // Main content area
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar
                _buildSidebar(controller),

                // Main content
                Expanded(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(16),
                    child: Obx(() => controller.getCurrentPage()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BannersController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: const Row(
        children: [
          // SizedBox(
          //   width: 20,
          // ),
          Text(
            'Banners',
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Spacer(),
          // You can add avatar or other widgets here
        ],
      ),
    );
  }

  Widget _buildSidebar(BannersController controller) {
    return Container(
      width: 250,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              'Sections',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.sidebarItems.length,
                itemBuilder: (context, index) {
                  return _buildSidebarItem(
                    controller,
                    controller.sidebarItems[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BannersController controller, SidebarItem item) {
    return Obx(() {
      final isSelected = controller.selectedSection.value == item.title;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? grey1 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(item.icon, color: primaryColor),
          title: Text(
            item.title,
            style: TextStyle(
              color: primaryColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          onTap: () => controller.changeSection(item.title),
        ),
      );
    });
  }
}
