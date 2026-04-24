// ignore_for_file: library_private_types_in_public_api, unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TypeableDropdownWithShortcut extends StatefulWidget {
  const TypeableDropdownWithShortcut({super.key});

  @override
  _TypeableDropdownWithShortcutState createState() =>
      _TypeableDropdownWithShortcutState();
}

class _TypeableDropdownWithShortcutState
    extends State<TypeableDropdownWithShortcut> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String _selectedValue = '';
  bool _isDropdownOpen = false;

  List<String> options = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'];
  List<String> filteredOptions = [];

  @override
  void initState() {
    super.initState();
    filteredOptions = options;

    // Handle focus change
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isDropdownOpen = true;
        });
      } else {
        setState(() {
          _isDropdownOpen = false;
        });
      }
    });
  }

  // Filter options based on input
  void _filterOptions(String query) {
    setState(() {
      filteredOptions = options
          .where((option) => option.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Handle keyboard shortcuts
  void _handleKeyPress(RawKeyEvent event) {
    // Check if the Ctrl + D keys are pressed
    if (event.isControlPressed && event.logicalKey == LogicalKeyboardKey.keyD) {
      // Focus the TextField
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(), // Add a focus node for the keyboard listener
      onKey: (RawKeyEvent event) {
        _handleKeyPress(event);
      },
      autofocus: true, // Ensure the widget is listening for keyboard events
      child: Column(
        children: [
          // The TextField to type into
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: 'Type to select',
              suffixIcon: Icon(_isDropdownOpen
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down),
            ),
            onChanged: (value) {
              _filterOptions(value);
            },
          ),

          // The Dropdown list of filtered options
          if (_isDropdownOpen)
            SizedBox(
              height: 200,
              child: ListView(
                children: filteredOptions.map((option) {
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      setState(() {
                        _controller.text = option;
                        _selectedValue = option;
                        _isDropdownOpen = false;
                        _focusNode.unfocus();
                      });
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
