import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/get_lot_entries_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/lot_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class LotEntryDropdownDialog extends StatefulWidget {
  final Function(GetLotEntriesDropdownValue?) onLotSelected;

  const LotEntryDropdownDialog({super.key, required this.onLotSelected});

  @override
  State<LotEntryDropdownDialog> createState() => _LotEntryDropdownDialogState();
}

class _LotEntryDropdownDialogState extends State<LotEntryDropdownDialog> {
  final LotController _lotController = Get.find<LotController>();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _listFocusNode = FocusNode();
  int _selectedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _lotNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lotController.getLotEntries(resetList: true, isSearch: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _listFocusNode.dispose();
    _scrollController.dispose();
    _lotNumberController.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final lotEntries = _lotController.lotEntries;
      if (_selectedIndex == lotEntries.length - 3) {
        _lotController.loadMoreItems();
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          if (_selectedIndex < lotEntries.length - 1) {
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
        if (_selectedIndex >= 0 && _selectedIndex < lotEntries.length) {
          final selectedLot = lotEntries[_selectedIndex];
          widget.onLotSelected(selectedLot);
          Get.back();
        }
      }
    }
  }

  void _scrollToSelectedItem() {
    if (_selectedIndex >= 0 && _scrollController.hasClients) {
      const itemHeight = 40.0; // Adjust based on your row height
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
        height: Get.height * 0.6,
        width: Get.width * 0.4,
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
              _buildLotNumberInput(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildTableHeader(),
              ),
              Expanded(child: _buildLotEntriesList()),
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
            text: 'Lot Entry',
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

  Widget _buildLotNumberInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'LOT No.:',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _lotNumberController,
            autofocus: true,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            onChanged: (value) {
              _lotController.setSearchQuery(value);
              setState(() {
                _selectedIndex = -1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Date', flex: 2),
          _buildHeaderCell('Lot No.', flex: 2),
          _buildHeaderCell('Gross Wt (gm)', flex: 3),
          _buildHeaderCell('Net Wt (gm)', flex: 3),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: CustomText(
        text: text,
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLotEntriesList() {
    return Obx(() {
      final lotResponse = _lotController.getLotEntriesResponse.value;
      if (lotResponse.status == Status.COMPLETED) {
        final entries = _lotController.lotEntries;
        if (entries.isEmpty) {
          return const Center(child: Text('No lot entries found'));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // Check if we're at 80% of the way to the bottom to start loading more
            if (scrollInfo.metrics.pixels >
                    (scrollInfo.metrics.maxScrollExtent * 0.8) &&
                !_lotController.isLoadingMore.value &&
                _lotController.hasMorePages.value) {
              _lotController.loadMoreItems();
            }
            return true;
          },
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final isSelected = index == _selectedIndex;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      widget.onLotSelected(entry);
                      Get.back();
                    },
                    child: Container(
                      color:
                          isSelected
                              ? secondaryColor.withOpacity(0.1)
                              : Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    convertDateTimeToString(entry.createdAt),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    entry.lotEntryNumber ?? "",
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? secondaryColor
                                              : Colors.black,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(entry.grossWeight ?? ''),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(entry.netWeight ?? ""),
                                ),
                              ],
                            ),
                          ),
                          // Add purity types display
                          if (entry.purityTypes != null &&
                              entry.purityTypes!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: 8.0,
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Purities: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      entry.purityTypes!.join(', '),
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const CustomDashedLineWidget(width: double.maxFinite),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Loading indicator at the bottom when fetching more data
              if (_lotController.isLoadingMore.value)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    color: Colors.white.withOpacity(0.7),
                    child: const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      } else if (lotResponse.status == Status.ERROR) {
        return Center(
          child: Text('Error loading lot entries: ${lotResponse.message}'),
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
          // Cancel Button
          InkWell(
            onTap: () {
              // Set selected lot number to null when Cancel is clicked
              final lotController = Get.find<LotController>();
              lotController.setSelectedLot('');
              widget.onLotSelected(null);
              Get.back();
            },
            child: Container(
              width: 120,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: CustomText(
                  text: "Cancel",
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Save Button
          InkWell(
            onTap: () {
              final entries = _lotController.lotEntries;
              if (entries.isNotEmpty && _selectedIndex >= 0) {
                widget.onLotSelected(entries[_selectedIndex]);
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
