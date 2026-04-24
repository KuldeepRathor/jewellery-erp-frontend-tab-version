import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageLink {
  final String id;
  final String name;
  final String url;

  PageLink({required this.id, required this.name, required this.url});
}

class PageLinkController extends GetxController {
  // Page related variables
  final RxList<PageLink> pageOptions = <PageLink>[].obs;

  // Map to store TextEditingControllers and FocusNodes for each slide
  final RxMap<String, TextEditingController> pageControllers =
      <String, TextEditingController>{}.obs;
  final RxMap<String, FocusNode> pageFocusNodes = <String, FocusNode>{}.obs;

  // Map to store selected page for each slide
  final RxMap<String, PageLink?> selectedPages = <String, PageLink?>{}.obs;

  // Predefined list of page links
  final List<PageLink> _allPageLinks = [
    PageLink(id: '1', name: 'Home', url: '/home'),
    PageLink(id: '2', name: 'About Us', url: '/about'),
    PageLink(id: '3', name: 'Shop', url: '/shop'),
    PageLink(id: '4', name: 'Contact', url: '/contact'),
    PageLink(id: '5', name: 'Blog', url: '/blog'),
    PageLink(id: '6', name: 'FAQ', url: '/faq'),
    PageLink(id: '7', name: 'Terms & Conditions', url: '/terms'),
    PageLink(id: '8', name: 'Privacy Policy', url: '/privacy'),
  ];

  @override
  void onInit() {
    super.onInit();
    pageOptions.assignAll(_allPageLinks);
  }

  @override
  void onClose() {
    // Dispose all controllers and focus nodes
    for (var controller in pageControllers.values) {
      controller.dispose();
    }
    for (var focusNode in pageFocusNodes.values) {
      focusNode.dispose();
    }
    super.onClose();
  }

  // Get or create controller for a specific slide
  TextEditingController getControllerForSlide(String slideId) {
    if (!pageControllers.containsKey(slideId)) {
      pageControllers[slideId] = TextEditingController();
    }
    return pageControllers[slideId]!;
  }

  // Get or create focus node for a specific slide
  FocusNode getFocusNodeForSlide(String slideId) {
    if (!pageFocusNodes.containsKey(slideId)) {
      pageFocusNodes[slideId] = FocusNode();
    }
    return pageFocusNodes[slideId]!;
  }

  void searchPages(String query) {
    if (query.isEmpty) {
      pageOptions.assignAll(_allPageLinks);
    } else {
      final filteredPages = _allPageLinks
          .where(
              (page) => page.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      pageOptions.assignAll(filteredPages);
    }
  }

  void setSelectedPage(String slideId, PageLink? page) {
    selectedPages[slideId] = page;
    if (page != null && pageControllers.containsKey(slideId)) {
      pageControllers[slideId]!.text = page.name;
    }
  }

  void clearSelection(String slideId) {
    selectedPages[slideId] = null;
    if (pageControllers.containsKey(slideId)) {
      pageControllers[slideId]!.text = '';
    }
  }

  void clearAllSelections() {
    for (var slideId in selectedPages.keys) {
      clearSelection(slideId);
    }
  }

  String? getSelectedPageUrl(String slideId) {
    return selectedPages[slideId]?.url;
  }

  void preSelectPage(String slideId, String pageUrl) {
    // Find the page in options and select it
    final page = _allPageLinks.firstWhere(
      (p) => p.url == pageUrl,
      orElse: () => PageLink(id: '', name: '', url: ''),
    );

    if (page.id.isNotEmpty) {
      selectedPages[slideId] = page;

      // Create controller if it doesn't exist
      if (!pageControllers.containsKey(slideId)) {
        pageControllers[slideId] = TextEditingController();
      }

      pageControllers[slideId]!.text = page.name;
    }
  }

  // Clean up resources for a specific slide (when removed)
  void disposeSlideResources(String slideId) {
    if (pageControllers.containsKey(slideId)) {
      pageControllers[slideId]!.dispose();
      pageControllers.remove(slideId);
    }

    if (pageFocusNodes.containsKey(slideId)) {
      pageFocusNodes[slideId]!.dispose();
      pageFocusNodes.remove(slideId);
    }

    selectedPages.remove(slideId);
  }
}
