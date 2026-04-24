import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_item_details_controller.dart';

import 'tagging_controller.dart';

class TableKeyEventHandler {
  final TaggingItemDetailsController controller;
  final taggingController = Get.find<TaggingController>();

  TableKeyEventHandler(this.controller);

  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event, int rowIndex) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    // Extract current row data for better readability
    final rowData = controller.controllers[rowIndex];
    final isStoneColumn = controller.currentColIndex.value == 7;

    // Handle scale integration with Alt+W shortcut
    if (event.logicalKey == LogicalKeyboardKey.keyW &&
        HardwareKeyboard.instance.isAltPressed &&
        controller.currentColIndex.value == 3) {
      if (taggingController.isAutoWeightInput.value) {
        controller.readWeightFromScale(rowIndex);
      }
      return KeyEventResult.handled;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.enter:
        return _handleEnterKey(node, event, rowData, isStoneColumn, rowIndex);

      case LogicalKeyboardKey.tab:
        return _handleTabKey(node, event, rowData, isStoneColumn, rowIndex);

      case LogicalKeyboardKey.arrowUp:
        return _handleArrowKey(node, LogicalKeyboardKey.arrowUp);

      case LogicalKeyboardKey.arrowDown:
        return _handleArrowKey(node, LogicalKeyboardKey.arrowDown);

      case LogicalKeyboardKey.escape:
        return _handleEscapeKey(rowIndex);

      default:
        return KeyEventResult.ignored;
    }
  }

  KeyEventResult _handleEnterKey(
    FocusNode node,
    KeyEvent event,
    dynamic rowData,
    bool isStoneColumn,
    int rowIndex,
  ) {
    if (HardwareKeyboard.instance.isShiftPressed) {
      return KeyEventResult.ignored;
    }
    if (controller.currentColIndex.value == 2) {
      if (taggingController.isAutoWeightInput.value) {
        controller.readWeightFromScale(rowIndex);
      }
    }

    controller.moveNextFocus(event: event);
    if (isStoneColumn) {
      _handleStoneColumn(rowData, rowIndex);
    }
    return KeyEventResult.handled;
  }

  KeyEventResult _handleTabKey(
    FocusNode node,
    KeyEvent event,
    dynamic rowData,
    bool isStoneColumn,
    int rowIndex,
  ) {
    if (HardwareKeyboard.instance.isShiftPressed) {
      controller.movePreviousFocus(node);
    } else {
      controller.moveNextFocus(event: event);
    }

    if (isStoneColumn) {
      _handleStoneColumn(rowData, rowIndex);
    }
    return KeyEventResult.handled;
  }

  KeyEventResult _handleArrowKey(FocusNode node, LogicalKeyboardKey direction) {
    return controller.moveFocus(
      KeyEventResult.handled,
      direction,
      nextFocusNode: node,
      previousFocusNode: node,
    );
  }

  KeyEventResult _handleEscapeKey(int rowIndex) {
    if (HardwareKeyboard.instance.isShiftPressed) {
      controller.removeCurrentRow(rowIndex);
    } else {
      controller.currentColIndex.value = 2;
      controller.controllers[rowIndex].tableFocusNodes[2].requestFocus();
      controller.resetRow(rowIndex);
    }
    return KeyEventResult.ignored;
  }

  void _handleStoneColumn(dynamic rowData, int rowIndex) {
    if (rowData.isStoneRequired) {
      // controller.showStoneDialog(rowIndex);
    }
  }
}
