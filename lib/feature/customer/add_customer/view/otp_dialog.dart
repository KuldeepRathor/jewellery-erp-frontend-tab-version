import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class CustomOtpDialog extends StatefulWidget {
  final String title;
  final String message;
  final String? identifier;
  final Function(String) onVerify;
  final bool isLoading;
  final int otpLength;

  const CustomOtpDialog({
    super.key,
    this.title = 'Enter OTP',
    required this.message,
    this.identifier,
    required this.onVerify,
    this.isLoading = false,
    this.otpLength = 6, // Default OTP length is 6
  });

  @override
  State<CustomOtpDialog> createState() => _CustomOtpDialogState();
}

class _CustomOtpDialogState extends State<CustomOtpDialog> {
  final pinController = TextEditingController();

  final focusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Request focus after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: secondaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primaryColor, width: 2),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white,
        border: Border.all(color: primaryColor),
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(widget.message, textAlign: TextAlign.center),
              if (widget.identifier != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.identifier!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 24),
              Directionality(
                // This is needed for proper cursor movement
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: widget.otpLength,
                  controller: pinController,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter OTP';
                    }
                    if (value.length != widget.otpLength) {
                      return 'Please enter complete OTP';
                    }
                    return null;
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  autofocus: true,
                  showCursor: true,
                  // onCompleted: (pin) {
                  //   if (formKey.currentState!.validate()) {
                  //     onVerify(pin);
                  //   }
                  // },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton1(
                    buttonName: 'Cancel',
                    onTap: () => Get.back(result: false),
                  ),
                  const SizedBox(width: 16),
                  CustomButton1(
                    buttonName: 'Verify',
                    isLoading: widget.isLoading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        widget.onVerify(pinController.text);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
