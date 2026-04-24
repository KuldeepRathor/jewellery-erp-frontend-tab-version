import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';

class RateCaratInput extends StatefulWidget {
  final void Function(double rate, String carat) onChanged;
  final bool readOnly;

  const RateCaratInput({
    super.key,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  State<RateCaratInput> createState() => _RateCaratInputState();
}

class _RateCaratInputState extends State<RateCaratInput> {
  final RateCaratInputController controller =
      Get.find<RateCaratInputController>();
  final FocusNode _focusNode = FocusNode();

  double containerHeight = 40;

  @override
  void initState() {
    controller.fetchGoldRates();
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      controller.startEditing();
    } else {
      controller.stopEditing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: 275,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rate/gm',
              style: TextStyle(
                color: Color(0xFF111111),
                fontSize: 12,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: containerHeight,
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xFF4758EC)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            '₹ ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child:
                              controller.getGoldRatesResponse.value.status ==
                                      Status.LOADING
                                  ? const Center(
                                    child: SizedBox(
                                      height: 26,
                                      width: 26,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                  : TextFormField(
                                    controller:
                                        controller.rateEditingController,
                                    focusNode: _focusNode,
                                    readOnly: widget.readOnly,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*'),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 13,
                                          ),
                                      hintText: controller.currentRate,
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        controller.updateRate(value);
                                        String caratValue = controller
                                            .getPurityFromCarat(
                                              controller.selectedCarat.value,
                                            );
                                        widget.onChanged(
                                          double.tryParse(value) ?? 0,
                                          caratValue,
                                        );
                                      }
                                    },
                                    onEditingComplete: () {
                                      FocusManager.instance.primaryFocus
                                          ?.nextFocus();
                                    },
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: containerHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const ShapeDecoration(
                    color: Color(0xFFE6E8FF),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFF4758EC)),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedCarat.value,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 20,
                      elevation: 16,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? newValue) {
                        controller.updateSelectedCarat(newValue);
                        if (newValue != null) {
                          widget.onChanged(
                            double.tryParse(controller.currentRate) ?? 0,
                            newValue,
                          );
                        }
                      },
                      menuMaxHeight: 250,
                      alignment: AlignmentDirectional.bottomCenter,
                      // ignore: invalid_use_of_protected_member
                      items:
                          controller.caratOptions.value
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
