import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class CustomReusableOtpDialog extends StatefulWidget {
  final int otpLength;
  final String title;
  final String message;
  final VoidCallback? onResendOtp;
  final Function(String) onSubmit;
  final bool showResendButton;
  final Duration? resendAfter;

  const CustomReusableOtpDialog({
    super.key,
    this.otpLength = 6,
    this.title = 'Enter OTP',
    this.message =
        'Please enter the verification code sent to your mobile number',
    this.onResendOtp,
    required this.onSubmit,
    this.showResendButton = true,
    this.resendAfter = const Duration(seconds: 30),
  });

  @override
  State<CustomReusableOtpDialog> createState() =>
      _CustomReusableOtpDialogState();
}

class _CustomReusableOtpDialogState extends State<CustomReusableOtpDialog> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _canResend = false;
  int _resendTimer = 0;

  @override
  void initState() {
    super.initState();
    if (widget.showResendButton && widget.resendAfter != null) {
      _startResendTimer();
    } else {
      _canResend = true;
    }
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = widget.resendAfter?.inSeconds ?? 30;
      _canResend = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendTimer--;
        });
        if (_resendTimer <= 0) {
          setState(() {
            _canResend = true;
          });
          return false;
        }
      }
      return true;
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 46,
      height: 46,
      textStyle: const TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
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

    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.message),
          const SizedBox(height: 20),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              length: widget.otpLength,
              controller: _pinController,
              focusNode: _pinFocusNode,
              autofocus: true,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: widget.onSubmit,
            ),
          ),
          if (widget.showResendButton) ...[
            const SizedBox(height: 20),
            TextButton(
              onPressed:
                  _canResend
                      ? () {
                        if (widget.onResendOtp != null) {
                          widget.onResendOtp!();
                          if (widget.resendAfter != null) {
                            _startResendTimer();
                          }
                        }
                      }
                      : null,
              child: Text(
                _canResend
                    ? 'Resend OTP'
                    : 'Resend OTP in $_resendTimer seconds',
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () => widget.onSubmit(_pinController.text),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

// Function to show the OTP dialog using Get.dialog
void showCustomReusableOtpDialog({
  int otpLength = 6,
  String title = 'Enter OTP',
  String message =
      'Please enter the verification code sent to your mobile number',
  VoidCallback? onResendOtp,
  required Function(String) onSubmit,
  bool showResendButton = true,
  Duration? resendAfter = const Duration(seconds: 30),
}) {
  Get.dialog(
    CustomReusableOtpDialog(
      otpLength: otpLength,
      title: title,
      message: message,
      onResendOtp: onResendOtp,
      onSubmit: onSubmit,
      showResendButton: showResendButton,
      resendAfter: resendAfter,
    ),
    barrierDismissible: false,
  );
}
