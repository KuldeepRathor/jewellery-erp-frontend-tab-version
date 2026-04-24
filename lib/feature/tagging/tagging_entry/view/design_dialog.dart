import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/model/get_deisgn_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class DesignDialog extends StatefulWidget {
  final Function(GetDesignResponseModel) onDesignSelected;

  const DesignDialog({super.key, required this.onDesignSelected});

  @override
  State<DesignDialog> createState() => _DesignDialogState();
}

class _DesignDialogState extends State<DesignDialog> {
  final TaggingController _taggingController = Get.find<TaggingController>();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _listFocusNode = FocusNode();
  int _selectedIndex = -1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _taggingController.getDesignListing(resetList: true, isSearch: false);

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _listFocusNode.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadMoreDesigns();
    }
  }

  Future<void> _loadMoreDesigns() async {
    if (!_taggingController.isLoadingMore.value &&
        _taggingController.hasMorePages.value) {
      await _taggingController.getDesignListing(
        resetList: false,
        isSearch: false,
      );
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      // FIX: Use getDesignDropdownResponse instead of getDesignListingResponse
      final designs =
          _taggingController.getDesignDropdownResponse.value.data?.values ?? [];

      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          if (_selectedIndex < designs.length - 1) {
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
        if (_selectedIndex >= 0 && _selectedIndex < designs.length) {
          final selectedDesign = designs[_selectedIndex];

          // Show loading and fetch full design details
          Get.dialog(
            const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );

          _taggingController.fetchDesignDetails(selectedDesign.id!).then((
            fullDesign,
          ) {
            // Close loading dialog
            if (Get.isDialogOpen!) {
              Get.back();
            }

            if (fullDesign != null) {
              widget.onDesignSelected(fullDesign);
              Get.back();
            }
          });
        }
      }
    }
  }

  void _scrollToSelectedItem() {
    if (_selectedIndex >= 0 && _scrollController.hasClients) {
      const itemHeight = 56.0;
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
      child: Container(
        height: Get.height * .6,
        width: Get.width * .3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: KeyboardListener(
          focusNode: _listFocusNode,
          onKeyEvent: _handleKeyEvent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchField(),
              Expanded(child: _buildDesignList()),
              _buildFooter(),
            ],
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
        color: whiteColor,
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
            text: 'Change Design',
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
        onChanged: (value) {
          _taggingController.setSearchQuery(value);
          setState(() {
            _selectedIndex = -1;
          });
        },
      ),
    );
  }

  Future<void> _selectDesign(GetDesignDropdownValue design) async {
    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Fetch full design details
    final fullDesign = await _taggingController.fetchDesignDetails(design.id!);

    // Close loading dialog
    if (Get.isDialogOpen!) {
      Get.back();
    }

    if (fullDesign != null) {
      widget.onDesignSelected(fullDesign);
      Get.back();
    }
  }

  Widget _buildDesignList() {
    return Obx(() {
      final designResponse = _taggingController.getDesignDropdownResponse.value;
      if (designResponse.status == Status.COMPLETED) {
        final designs = designResponse.data?.values ?? [];
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _taggingController.loadMoreDesigns();
            }
            return true;
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount:
                designs.length +
                (_taggingController.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= designs.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final design = designs[index];
              final isSelected = index == _selectedIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    setState(() {
                      _selectedIndex = index;
                    });

                    // Show loading indicator
                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    // Fetch full design details
                    final fullDesign = await _taggingController
                        .fetchDesignDetails(design.id!);

                    // Close loading dialog
                    if (Get.isDialogOpen!) {
                      Get.back();
                    }

                    if (fullDesign != null) {
                      widget.onDesignSelected(fullDesign);
                      Get.back();
                    }
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
                                text: design.name ?? '',
                                fontSize: 14,
                                color:
                                    isSelected ? secondaryColor : Colors.black,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                              if (design.code != null)
                                CustomText(
                                  text: ' - ${design.code}',
                                  fontSize: 14,
                                  color: Colors.black,
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
      } else if (designResponse.status == Status.ERROR) {
        return Center(
          child: Text('Error loading designs: ${designResponse.message}'),
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
        color: whiteColor,
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
          // In _buildFooter method of DesignDialog
          InkWell(
            onTap: () async {
              final designs =
                  _taggingController
                      .getDesignDropdownResponse
                      .value
                      .data
                      ?.values ??
                  [];
              if (designs.isNotEmpty) {
                await _selectDesign(designs.first);
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
                  color: whiteColor,
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
