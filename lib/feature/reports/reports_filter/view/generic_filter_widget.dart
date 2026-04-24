import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_checkbox_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';

enum FilterType { checkbox, range, dateRange, toggle }

class ToggleFilterValue {
  bool isEnabled;
  ToggleFilterValue({this.isEnabled = false});
}

class RangeFilterValues {
  String? min;
  String? max;

  RangeFilterValues({this.min, this.max}) {
    // Normalize empty strings to null
    if (min != null && min!.isEmpty) min = null;
    if (max != null && max!.isEmpty) max = null;
  }

  // Helper method to check if this range has any values
  bool get hasValues => min != null || max != null;

  // Helper method to create an empty range
  static RangeFilterValues empty() => RangeFilterValues(min: null, max: null);
}

class DateRangeFilterValues {
  DateTime? from;
  DateTime? to;

  DateRangeFilterValues({this.from, this.to});

  // Helper method to check if this range has any values
  bool get hasValues => from != null || to != null;

  // Helper method to create an empty date range
  static DateRangeFilterValues empty() =>
      DateRangeFilterValues(from: null, to: null);
}

// Add a custom method to FilterGroup class to properly reset range values
// This would be an extension of the FilterGroup class
extension FilterGroupExtension on FilterGroup {
  void resetRangeValues() {
    if (filterType == FilterType.range) {
      // Explicitly set to null to ensure it's properly cleared
      rangeValues = RangeFilterValues.empty();
    }
  }
}

class FilterItem {
  final String id;
  final String name;
  bool isSelected; // Made mutable

  FilterItem({required this.id, required this.name, this.isSelected = false});
}

class FilterGroup {
  final String title;
  List<FilterItem> options;
  final bool isLoading;
  final String? error;
  String searchQuery = '';
  FilterType filterType;
  // Don't set a default value here
  RangeFilterValues rangeValues;
  DateRangeFilterValues dateRangeValues;
  ToggleFilterValue toggleValue;
  final BaseFilterController? controller; // Add reference to controller

  FilterGroup({
    required this.title,
    required this.options,
    this.isLoading = false,
    this.error,
    this.filterType = FilterType.checkbox,
    // Remove the default value from the parameter
    RangeFilterValues? rangeValues,
    DateRangeFilterValues? dateRangeValues,
    ToggleFilterValue? toggleValue,
    this.controller,
  }) : rangeValues = rangeValues ?? RangeFilterValues(),
       dateRangeValues = dateRangeValues ?? DateRangeFilterValues(),
       toggleValue = toggleValue ?? ToggleFilterValue();

  List<String> get selectedIds =>
      options.where((item) => item.isSelected).map((item) => item.id).toList();

  List<FilterItem> get selectedItems =>
      options.where((item) => item.isSelected).toList();

  List<FilterItem> get filteredOptions =>
      options
          .where(
            (item) =>
                item.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
}

class FilterDialog extends StatefulWidget {
  final List<FilterGroup> filterGroups;
  final Function(
    Map<String, List<String>>,
    Map<String, RangeFilterValues>,
    Map<String, DateRangeFilterValues>,
    Map<String, bool>,
  )
  onApply;
  final bool showLoading;
  final VoidCallback? onReset;
  final BaseFilterController? controller;

  const FilterDialog({
    super.key,
    required this.filterGroups,
    required this.onApply,
    this.showLoading = false,
    this.onReset,
    this.controller,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  int? selectedGroupIndex = 0;
  // Map to store controllers for each filter group
  final Map<String, List<TextEditingController>> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each filter group
    for (var group in widget.filterGroups) {
      if (group.filterType == FilterType.range) {
        _controllers[group.title] = [
          TextEditingController(text: group.rangeValues.min),
          TextEditingController(text: group.rangeValues.max),
        ];
      }
    }

    // Sync filter items with controller state
    _syncFilterItemsWithController();
  }

  void _syncFilterItemsWithController() {
    if (widget.controller == null) return;

    for (var group in widget.filterGroups) {
      if (group.filterType == FilterType.checkbox) {
        // Sync each item's selected state with the controller
        for (var item in group.options) {
          switch (group.title) {
            case 'Metal Type':
              item.isSelected = widget.controller!.isMetalTypeSelected(item.id);
              break;
            case 'Ornament':
              item.isSelected = widget.controller!.isOrnamentSelected(item.id);
              break;
            case 'Stock Head':
              item.isSelected = widget.controller!.isStockHeadSelected(item.id);
              break;
            case 'Counter':
              item.isSelected = widget.controller!.isCounterSelected(item.id);
              break;
            case 'Purity':
              item.isSelected = widget.controller!.isPuritySelected(item.id);
              break;
            case 'Design':
              item.isSelected = widget.controller!.isDesignSelected(item.id);
              break;
            case 'Weight Group':
              item.isSelected = widget.controller!.isWeightGroupSelected(
                item.id,
              );
              break;
            case 'Vendor':
              item.isSelected = widget.controller!.isVendorSelected(item.id);
              break;
            case 'Tagged By':
              item.isSelected = widget.controller!.isTaggedBySelected(item.id);
              break;
            case 'Branch':
              item.isSelected = widget.controller!.isBranchSelected(item.id);
              break;
            case 'Size':
              item.isSelected = widget.controller!.isSizeSelected(item.id);
              break;
            case 'Status':
              item.isSelected = widget.controller!.isStatusSelected(item.id);
              break;
            case 'Item Status':
              item.isSelected =
                  widget.controller!.selectedItemStatus.value?.value == item.id;
              break;
            case 'Invoice Status':
              item.isSelected =
                  widget.controller!.selectedInvoiceStatus.value?.value ==
                  item.id;
              break;
            case 'Payment Status':
              item.isSelected =
                  widget.controller!.selectedPaymentStatus.value?.value ==
                  item.id;
              break;
            case 'Transaction Types':
              item.isSelected =
                  widget.controller!.selectedTransactionTypes.value?.value ==
                  item.id;
              break;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _controllers.forEach((_, controllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    });
    super.dispose();
  }

  // Update controllers when filter groups change
  @override
  void didUpdateWidget(FilterDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update existing controllers and add new ones if needed
    for (var group in widget.filterGroups) {
      if (group.filterType == FilterType.range) {
        if (!_controllers.containsKey(group.title)) {
          _controllers[group.title] = [
            TextEditingController(text: group.rangeValues.min),
            TextEditingController(text: group.rangeValues.max),
          ];
        } else {
          // Update controller text only if it's different to avoid cursor position issues
          if (_controllers[group.title]![0].text != group.rangeValues.min) {
            _controllers[group.title]![0].text = group.rangeValues.min ?? '';
          }
          if (_controllers[group.title]![1].text != group.rangeValues.max) {
            _controllers[group.title]![1].text = group.rangeValues.max ?? '';
          }
        }
      }
    }

    // Re-sync filter items with controller
    _syncFilterItemsWithController();
  }

  List<Widget> _buildSelectedFilterChips() {
    final List<Widget> chips = [];
    for (var group in widget.filterGroups) {
      // For range filters, add a chip if min or max values are set
      if (group.filterType == FilterType.range) {
        if ((group.rangeValues.min != null &&
                group.rangeValues.min!.isNotEmpty) ||
            (group.rangeValues.max != null &&
                group.rangeValues.max!.isNotEmpty)) {
          String rangeText = "";
          if (group.rangeValues.min != null &&
              group.rangeValues.min!.isNotEmpty) {
            rangeText += "Min: ${group.rangeValues.min}";
          }

          if (group.rangeValues.max != null &&
              group.rangeValues.max!.isNotEmpty) {
            if (rangeText.isNotEmpty) {
              rangeText += ", ";
            }
            rangeText += "Max: ${group.rangeValues.max}";
          }

          chips.add(
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Chip(
                backgroundColor: secondaryColor.withOpacity(0.1),
                side: BorderSide.none,
                label: Text(
                  '${group.title}: $rangeText',
                  style: const TextStyle(color: secondaryColor, fontSize: 12),
                ),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                  color: secondaryColor,
                ),
                onDeleted: () {
                  setState(() {
                    // Create a completely new RangeFilterValues with null values
                    group.rangeValues = RangeFilterValues(min: null, max: null);

                    // Also clear the controllers for this group
                    if (_controllers.containsKey(group.title)) {
                      _controllers[group.title]![0].text = '';
                      _controllers[group.title]![1].text = '';
                    }
                  });
                },
              ),
            ),
          );
        }
      } else if (group.filterType == FilterType.dateRange) {
        if (group.dateRangeValues.from != null ||
            group.dateRangeValues.to != null) {
          String rangeText = "";
          if (group.dateRangeValues.from != null) {
            rangeText += "From: ${_formatDate(group.dateRangeValues.from!)}";
          }

          if (group.dateRangeValues.to != null) {
            if (rangeText.isNotEmpty) {
              rangeText += ", ";
            }
            rangeText += "To: ${_formatDate(group.dateRangeValues.to!)}";
          }

          chips.add(
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Chip(
                backgroundColor: secondaryColor.withOpacity(0.1),
                side: BorderSide.none,
                label: Text(
                  '${group.title}: $rangeText',
                  style: const TextStyle(color: secondaryColor, fontSize: 12),
                ),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                  color: secondaryColor,
                ),
                onDeleted: () {
                  setState(() {
                    // Create a completely new DateRangeFilterValues with null values
                    group.dateRangeValues = DateRangeFilterValues(
                      from: null,
                      to: null,
                    );
                  });
                },
              ),
            ),
          );
        }
      } else {
        // For checkbox filters, add chips for each selected option
        for (var item in group.selectedItems) {
          chips.add(
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Chip(
                backgroundColor: secondaryColor.withOpacity(0.1),
                side: BorderSide.none,
                label: Text(
                  '${group.title}: ${item.name}',
                  style: const TextStyle(color: secondaryColor, fontSize: 12),
                ),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                  color: secondaryColor,
                ),
                onDeleted: () {
                  setState(() {
                    item.isSelected = false;
                    // Update controller state
                    _updateControllerSelection(group, item, false);
                  });
                },
              ),
            ),
          );
        }
      }
    }
    return chips;
  }

  void _updateControllerSelection(
    FilterGroup group,
    FilterItem item,
    bool isSelected,
  ) {
    if (widget.controller == null) return;

    final dropdownItem = DropdownItem(id: item.id, name: item.name);

    switch (group.title) {
      case 'Metal Type':
        widget.controller!.toggleMetalType(dropdownItem);
        break;
      case 'Ornament':
        widget.controller!.toggleOrnament(dropdownItem);
        break;
      case 'Stock Head':
        widget.controller!.toggleStockHead(dropdownItem);
        break;
      case 'Counter':
        widget.controller!.toggleCounter(dropdownItem);
        break;
      case 'Purity':
        widget.controller!.togglePurity(dropdownItem);
        break;
      case 'Design':
        widget.controller!.toggleDesign(dropdownItem);
        break;
      case 'Weight Group':
        widget.controller!.toggleWeightGroup(dropdownItem);
        break;
      case 'Vendor':
        widget.controller!.toggleVendor(dropdownItem);
        break;
      case 'Tagged By':
        widget.controller!.toggleTaggedBy(dropdownItem);
        break;
      case 'Branch':
        widget.controller!.toggleBranch(dropdownItem);
        break;
      case 'Size':
        widget.controller!.toggleSize(dropdownItem);
        break;
      case 'Status':
        widget.controller!.toggleStatus(dropdownItem);
        break;
      case 'Item Status':
        widget.controller!.toggleItemStatus(dropdownItem.id);
        break;
      case 'Invoice Status':
        widget.controller!.toggleInvoiceStatus(dropdownItem.id);
        break;
      case 'Payment Status':
        widget.controller!.togglePaymentStatus(dropdownItem.id);
        break;
      case 'Transaction Types':
        widget.controller!.toggleTransactionTypes(dropdownItem.id);
        break;
      case 'Other':
        widget.controller!.toggleOther(dropdownItem.id);
        break;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  Future<void> _selectDate(
    BuildContext context, {
    required bool isFromDate,
    required FilterGroup group,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isFromDate
              ? group.dateRangeValues.from ?? DateTime.now()
              : group.dateRangeValues.to ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          group.dateRangeValues = DateRangeFilterValues(
            from: picked,
            to: group.dateRangeValues.to,
          );
        } else {
          group.dateRangeValues = DateRangeFilterValues(
            from: group.dateRangeValues.from,
            to: picked,
          );
        }
      });
    }
  }

  void collectAndSubmitFilters() {
    final selectedFilters = <String, List<String>>{};
    final rangeFilters = <String, RangeFilterValues>{};
    final dateRangeFilters = <String, DateRangeFilterValues>{};
    final toggleFilters = <String, bool>{};

    // Collect filters
    for (var group in widget.filterGroups) {
      if (group.filterType == FilterType.checkbox) {
        // Get selected IDs for multi-select
        final selectedIds = group.selectedIds;
        if (selectedIds.isNotEmpty) {
          selectedFilters[group.title] = selectedIds;
        }
      } else if (group.filterType == FilterType.range) {
        if (group.rangeValues.min != null || group.rangeValues.max != null) {
          rangeFilters[group.title] = group.rangeValues;
        }
      } else if (group.filterType == FilterType.dateRange) {
        if (group.dateRangeValues.hasValues) {
          dateRangeFilters[group.title] = group.dateRangeValues;
        }
      } else if (group.filterType == FilterType.toggle) {
        toggleFilters[group.title] = group.toggleValue.isEnabled;
      }
    }

    // Now pass these to your handler
    widget.onApply(
      selectedFilters,
      rangeFilters,
      dateRangeFilters,
      toggleFilters,
    );
  }

  Widget _buildOptionsView(FilterGroup group) {
    if (group.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (group.error != null) {
      return Center(
        child: Text(group.error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (group.filterType == FilterType.toggle) {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Yes",
                    // group.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  CustomCheckBoxWidget(
                    value: group.toggleValue.isEnabled,
                    onChanged: (bool? value) {
                      setState(() {
                        group.toggleValue.isEnabled = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }

    if (group.filterType == FilterType.range) {
      // Get the controllers for this group
      if (!_controllers.containsKey(group.title)) {
        _controllers[group.title] = [
          TextEditingController(text: group.rangeValues.min),
          TextEditingController(text: group.rangeValues.max),
        ];
      }

      final minController = _controllers[group.title]![0];
      final maxController = _controllers[group.title]![1];

      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "From",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 38,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: minController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Min",
                                  ),
                                  onChanged: (value) {
                                    // Update the model without rebuilding the entire dialog
                                    group.rangeValues = RangeFilterValues(
                                      min: value,
                                      max: group.rangeValues.max,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "To",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 38,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: maxController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Max",
                                  ),
                                  onChanged: (value) {
                                    // Update the model without rebuilding the entire dialog
                                    group.rangeValues = RangeFilterValues(
                                      min: group.rangeValues.min,
                                      max: value,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (group.filterType == FilterType.dateRange) {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // From Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "From Date",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap:
                        () => _selectDate(
                          context,
                          isFromDate: true,
                          group: group,
                        ),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              group.dateRangeValues.from != null
                                  ? _formatDate(group.dateRangeValues.from!)
                                  : "Select start date",
                              style: TextStyle(
                                color:
                                    group.dateRangeValues.from != null
                                        ? Colors.black87
                                        : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // To Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To Date",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap:
                        () => _selectDate(
                          context,
                          isFromDate: false,
                          group: group,
                        ),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              group.dateRangeValues.to != null
                                  ? _formatDate(group.dateRangeValues.to!)
                                  : "Select end date",
                              style: TextStyle(
                                color:
                                    group.dateRangeValues.to != null
                                        ? Colors.black87
                                        : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Checkbox filter view with "Select All" button
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search ${group.title}...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        group.searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      final allSelected = group.filteredOptions.every(
                        (item) => item.isSelected,
                      );
                      for (var item in group.filteredOptions) {
                        item.isSelected = !allSelected;
                        _updateControllerSelection(group, item, !allSelected);
                      }
                    });
                  },
                  child: Text(
                    group.filteredOptions.every((item) => item.isSelected)
                        ? 'Deselect All'
                        : 'Select All',
                    style: const TextStyle(color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: group.filteredOptions.length,
              itemBuilder: (context, index) {
                final item = group.filteredOptions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      CustomCheckBoxWidget(
                        value: item.isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            item.isSelected = value ?? false;
                            _updateControllerSelection(
                              group,
                              item,
                              value ?? false,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Text(
                    'Filter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.close, color: Colors.red),
                ),
              ],
            ),
            // Selected Filters Chips
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(children: _buildSelectedFilterChips()),
            ),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  // Left side - Filter Groups
                  SizedBox(
                    width: 160,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.filterGroups.length,
                      itemBuilder: (context, index) {
                        final group = widget.filterGroups[index];
                        final isSelected = selectedGroupIndex == index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedGroupIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? secondaryColor : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      group.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.w500
                                                : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black45,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Vertical Divider
                  Container(width: 1, color: grey2),
                  // Right side - Options
                  Expanded(
                    child:
                        selectedGroupIndex != null
                            ? _buildOptionsView(
                              widget.filterGroups[selectedGroupIndex!],
                            )
                            : const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Select a filter type',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  collectAndSubmitFilters();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3D8F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.check, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final List<FilterGroup> filterGroups;
  final Function(
    Map<String, List<String>>,
    Map<String, RangeFilterValues>,
    Map<String, DateRangeFilterValues>,
    Map<String, bool>,
  )
  onFiltersApplied;
  final bool isLoading;
  final VoidCallback? onReset;
  final BaseFilterController? controller;

  const FilterButton({
    super.key,
    required this.filterGroups,
    required this.onFiltersApplied,
    this.isLoading = false,
    this.onReset,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton2(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => FilterDialog(
                filterGroups: filterGroups,
                onApply: onFiltersApplied,
                showLoading: isLoading,
                onReset: onReset,
                controller: controller,
              ),
        );
      },
      image: 'assets/svgs/filter.svg',
      buttonName: 'Filter',
    );
  }
}
