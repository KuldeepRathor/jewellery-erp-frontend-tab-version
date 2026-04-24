import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/1x1_banner_upload/view/banner_onexone_upload_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/2x2_banner_upload/view/banner_twoxtwo_upload_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/4x4_banner_upload/view/banner_fourxfour_upload_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/category_upload/view/category_upload_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/collection_upload/view/collection_upload_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/view/hero_slides_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/testimonial/view/testimonial_page.dart';

class SidebarItem {
  final String title;
  final IconData icon;
  final String pageId;

  SidebarItem({
    required this.title,
    this.icon = Icons.chevron_right,
    required this.pageId,
  });
}

class BannersController extends GetxController {
  // Observable variables
  final RxString selectedSection = 'Hero Slides'.obs;
  final RxList<SidebarItem> sidebarItems = <SidebarItem>[].obs;
  // Track the previous section to handle controller deletion
  final RxString previousSection = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSidebarItems();
  }

  void _initializeSidebarItems() {
    sidebarItems.assignAll([
      SidebarItem(title: 'Hero Slides', pageId: 'hero_slides'),
      SidebarItem(title: 'Category Upload', pageId: 'category_upload'),
      SidebarItem(title: 'Collection Upload', pageId: 'collection_upload'),
      SidebarItem(title: '1 x 1 Banner', pageId: '1x1_banner'),
      SidebarItem(title: '2 x 2 Banner', pageId: '2x2_banner'),
      SidebarItem(title: '4 x 4 Banner', pageId: '4x4_banner'),
      SidebarItem(title: 'Top Seller', pageId: 'top_seller'),
      SidebarItem(title: 'Testimonial', pageId: 'testimonial'),
    ]);
  }

  Widget _buildPlaceholderPage(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Content for this section will go here'),
        ],
      ),
    );
  }

  // // Method to delete the previous controller when switching tabs
  // void _deleteControllerIfNeeded(String previousSectionId) {
  //   switch (previousSectionId) {
  //     case 'hero_slides':
  //       if (Get.isRegistered<HeroSlidesController>()) {
  //         Get.delete<HeroSlidesController>();
  //       }
  //       break;
  //     case 'category_upload':
  //       if (Get.isRegistered<CategoryUploadController>()) {
  //         Get.delete<CategoryUploadController>();
  //       }
  //       break;
  //     case 'collection_upload':
  //       if (Get.isRegistered<CollectionUploadController>()) {
  //         Get.delete<CollectionUploadController>();
  //       }
  //     case '1x1_banner':
  //       break;
  //     // Add other controllers if needed
  //   }
  // }

  void changeSection(String sectionTitle) {
    // Store the previous section
    final previousItem = sidebarItems.firstWhere(
      (item) => item.title == selectedSection.value,
      orElse: () => SidebarItem(title: '', pageId: ''),
    );

    previousSection.value = previousItem.pageId;

    // Change the section
    selectedSection.value = sectionTitle;

    // Delete the previous controller to force a refresh
    // _deleteControllerIfNeeded(previousItem.pageId);
  }

  Widget getCurrentPage() {
    final item = sidebarItems.firstWhere(
      (item) => item.title == selectedSection.value,
      orElse: () => SidebarItem(title: '', pageId: ''),
    );

    // Create a new instance based on the pageId
    switch (item.pageId) {
      case 'hero_slides':
        return const HeroSlidesPage();
      case 'category_upload':
        // Force create a new CategoryUploadPage which will create a new controller
        return const CategoryUploadPage();
      case 'collection_upload':
        return const CollectionUploadPage();
      case '1x1_banner':
        return const BannerOneXOneUploadPage();
      case '2x2_banner':
        return const BannerTwoXTwoUploadPage();
      case '4x4_banner':
        return const BannerFourXFourUploadPage();
      case 'top_seller':
        return _buildPlaceholderPage('Top Seller');
      case 'testimonial':
        return const TestimonialPage();
      default:
        return Container();
    }
  }

  void goBack() {
    Get.back();
  }
}
