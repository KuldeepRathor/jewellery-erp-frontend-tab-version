import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class VendorDialog extends StatefulWidget {
  final Function(String, String) onVendorSelected;

  const VendorDialog({super.key, required this.onVendorSelected});

  @override
  State<VendorDialog> createState() => _VendorDialogState();
}

class _VendorDialogState extends State<VendorDialog> {
  final TaggingController _taggingController = Get.find<TaggingController>();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _listFocusNode = FocusNode();
  int _selectedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _taggingController.getVendorListingDetails(
      resetList: true,
      isSearch: false,
    );

    // Multiple approaches to ensure focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // First, unfocus everything
      FocusScope.of(context).unfocus();

      // Then request focus after a small delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _searchFocusNode.requestFocus();
        }
      });
    });

    // Future.delayed(const Duration(milliseconds: 100), () {
    //   if (mounted) {
    //     _searchFocusNode.requestFocus();
    //   }
    // });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // focusScope.requestFocus();
    //   Future.delayed(
    //     const Duration(seconds: 2),
    //     () {
    //       log("called focus");
    //       setState(() {
    //         _searchFocusNode.requestFocus();
    //         log("called focus setstate");
    //       });
    //     },
    //   );
    // });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _listFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final vendors =
          _taggingController.getVendorDropdownResponse.value.data?.values ?? [];

      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          if (_selectedIndex < vendors.length - 1) {
            _selectedIndex++;
            _scrollToSelectedItem();
          }
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          if (_selectedIndex > 0) {
            _selectedIndex--;
            _scrollToSelectedItem();
          }
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_selectedIndex >= 0 && _selectedIndex < vendors.length) {
          final selectedVendor = vendors[_selectedIndex];
          widget.onVendorSelected(
            selectedVendor.id ?? '',
            selectedVendor.code ?? '',
          );
          Get.back();
        }
      }
    }
  }

  void _scrollToSelectedItem() {
    if (_selectedIndex >= 0 && _scrollController.hasClients) {
      const itemHeight = 56.0; // Approximate height of ListTile
      final scrollPosition = _selectedIndex * itemHeight;

      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: FocusScope(
        autofocus: true,
        child: Container(
          height: Get.height * .6,
          width: Get.width * .3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: KeyboardListener(
            onKeyEvent: _handleKeyEvent,
            focusNode: _listFocusNode,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSearchField(),
                Expanded(child: _buildVendorList()),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 54,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Change Vendor',
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: CustomTextField(
        name: "Name",
        autofocus: true,
        focusNode: _searchFocusNode,
        // focusNode: _searchFocusNode,
        onChanged: (value) {
          _taggingController.setSearchQuery(value);
          setState(() {
            _selectedIndex = -1; // Reset selection when search changes
          });
        },
      ),
    );
  }

  Widget _buildVendorList() {
    return Obx(() {
      final vendorResponse = _taggingController.getVendorDropdownResponse.value;
      if (vendorResponse.status == Status.COMPLETED) {
        final vendors = vendorResponse.data?.values ?? [];
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _taggingController.loadMoreItems();
            }
            return true;
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              final isSelected = index == _selectedIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    widget.onVendorSelected(vendor.id ?? '', vendor.code ?? '');
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? secondaryColor.withOpacity(0.1)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: vendor.name ?? '',
                                fontSize: 14,
                                color:
                                    isSelected ? secondaryColor : Colors.black,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                              if (vendor.code != null &&
                                  vendor.code!.isNotEmpty)
                                CustomText(
                                  text: ' - ${vendor.code}',
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else if (vendorResponse.status == Status.ERROR) {
        return Center(
          child: Text('Error loading vendors: ${vendorResponse.message}'),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, -1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              final vendors =
                  _taggingController
                      .getVendorDropdownResponse
                      .value
                      .data
                      ?.values ??
                  [];
              if (vendors.isNotEmpty) {
                widget.onVendorSelected(
                  vendors.first.id ?? '',
                  vendors.first.code ?? '',
                );
                Get.back();
              }
            },
            child: Container(
              width: 120,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CustomText(
                  text: "Save",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
