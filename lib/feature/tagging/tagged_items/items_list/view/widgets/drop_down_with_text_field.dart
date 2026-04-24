import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class DropDownWithTextField extends StatefulWidget {
  final List<String> items;
  final bool showSearch;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  const DropDownWithTextField({
    super.key,
    required this.items,
    this.showSearch = false,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<DropDownWithTextField> createState() => _DropDownWithTextFieldState();
}

class _DropDownWithTextFieldState extends State<DropDownWithTextField> {
  final controller = MenuController();
  String? selectedValue;
  final TextEditingController _searchController =
      TextEditingController(); // Add text controller
  List<String> _filteredItems = []; // Add filtered list

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    _filteredItems = widget.items; // Initialize with all items

    _searchController.addListener(() {
      // Listen for changes
      setState(() {
        final query = _searchController.text.toLowerCase();
        _filteredItems =
            query.isEmpty
                ? widget.items
                : widget.items
                    .where((item) => item.toLowerCase().contains(query))
                    .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: controller,
      builder: (context, controller, child) {
        return InkWell(
          onTap: () {
            controller.open();
          },
          child:
              selectedValue == null
                  ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 14),
                  )
                  : Text(selectedValue!),
        );
      },
      menuChildren: [
        Container(
          width: 200,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showSearch) ...[
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: secondaryColor, width: 2),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController, // Attach controller
                    decoration: const InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      isDense: true,
                      suffixIcon: Icon(Icons.search, color: secondaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ],
              ..._filteredItems.map((item) {
                // Use filtered list
                return ListTile(
                  dense: true,
                  leading: Container(
                    height: 16,
                    width: 16,
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      selectedValue = item;
                    });
                    widget.onChanged?.call(item);
                    controller.close();
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
