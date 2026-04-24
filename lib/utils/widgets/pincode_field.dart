// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class PinCodeField extends StatefulWidget {
  final int length;
  final Function(String) onChanged;
  final TextEditingController? controller;

  const PinCodeField({
    super.key,
    this.length = 4,
    required this.onChanged,
    this.controller,
  });

  @override
  PinCodeFieldState createState() => PinCodeFieldState();
}

class PinCodeFieldState extends State<PinCodeField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _pin;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _pin = List.generate(widget.length, (index) => '');

    // Listen to external controller changes if provided
    widget.controller?.addListener(_handleExternalControllerChange);
  }

  void _handleExternalControllerChange() {
    if (widget.controller != null) {
      String pin = widget.controller!.text;
      if (pin.length <= widget.length) {
        // Update individual controllers
        for (int i = 0; i < widget.length; i++) {
          if (i < pin.length) {
            _controllers[i].text = pin[i];
            _pin[i] = pin[i];
          } else {
            _controllers[i].text = '';
            _pin[i] = '';
          }
        }
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleExternalControllerChange);
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleTextChanged(String value, int index) {
    setState(() {
      if (value.isNotEmpty) {
        _pin[index] = value;
        if (index < widget.length - 1) {
          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
        } else {
          _focusNodes[index].unfocus();
        }
      }
      String currentPin = _pin.join();
      widget.controller?.text = currentPin;
      widget.onChanged(currentPin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.length, (index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                // height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: secondaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (RawKeyEvent event) {
                    if (event is RawKeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.backspace) {
                        if (_controllers[index].text.isEmpty && index > 0) {
                          _pin[index] = '';
                          _controllers[index].text = '';
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[index - 1]);
                          _controllers[index - 1].text = '';
                          _pin[index - 1] = '';

                          String currentPin = _pin.join();
                          widget.controller?.text = currentPin;
                          widget.onChanged(currentPin);
                        }
                      }
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,

                      // obscureText: true, // Uncomment for PIN security
                      onChanged: (value) => _handleTextChanged(value, index),
                      onTap: () {
                        _controllers[index]
                            .selection = TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        fillColor: whiteColor,
                        filled: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),
              if (index < widget.length - 1) const SizedBox(width: 22),
            ],
          );
        }),
      ),
    );
  }
}
