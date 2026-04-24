import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class CustomHallmarkChargesWidget extends StatefulWidget {
  final double width;
  final Function(bool, String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool initialValue;
  final FocusNode? focusNode;
  const CustomHallmarkChargesWidget({
    super.key,
    required this.width,
    this.onChanged,
    this.controller,
    this.validator,
    this.initialValue = false,
    this.focusNode,
  });

  @override
  CustomHallmarkChargesWidgetState createState() =>
      CustomHallmarkChargesWidgetState();
}

class CustomHallmarkChargesWidgetState
    extends State<CustomHallmarkChargesWidget> {
  late bool _isYes;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _isYes = widget.initialValue;
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Hallmark Charges',
            color: primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          const SizedBox(height: 8),
          Container(
            height: 38,
            decoration: BoxDecoration(
              border: Border.all(color: secondaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    focusNode: widget.focusNode,
                    onTap: () => _updateSelection(!_isYes),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isYes ? grey1 : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isYes
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: _isYes ? secondaryColor : secondaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isYes ? 'Yes' : 'Yes',
                              style: TextStyle(
                                color: _isYes ? primaryColor : primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'Satoshi',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 1, color: secondaryColor),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      controller: _controller,
                      enabled: _isYes,
                      validator: widget.validator,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Satoshi',
                      ),
                      decoration: InputDecoration(
                        hintText: _isYes ? '' : '       -    ',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        if (widget.onChanged != null) {
                          widget.onChanged!(_isYes, value);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateSelection(bool isYes) {
    setState(() {
      _isYes = isYes;
      if (!_isYes) {
        _controller.clear();
      }
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_isYes, _controller.text);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
