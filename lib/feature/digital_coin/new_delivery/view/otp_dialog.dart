import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/pincode_field.dart';

class OtpDialog extends StatefulWidget {
  const OtpDialog({super.key});

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  String _otp = '';
  bool _isLoading = false;

  void _handleVerify() async {
    if (_otp.length != 4) return;

    setState(() => _isLoading = true);
    Get.back(result: _otp);
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape): const CloseDialogIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyV): const VerifyIntent(),
      },
      child: Actions(
        actions: {
          CloseDialogIntent: CallbackAction<CloseDialogIntent>(
            onInvoke: (intent) => Get.back(),
          ),
          VerifyIntent: CallbackAction<VerifyIntent>(
            onInvoke: (intent) => _handleVerify(),
          ),
        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomText(
                        text: 'Enter OTP',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: Get.height * .03),
                      PinCodeField(
                        length: 4,
                        onChanged: (value) => setState(() => _otp = value),
                      ),
                      SizedBox(height: Get.height * .03),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : InkWell(
                            onTap: _handleVerify,
                            child: Container(
                              height: 38,
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ButtonShortcutWidget(
                                buttonName: "Verify",
                                color: whiteColor,
                                shortcut: 'V',
                                shortcutButtonBackgroundColor: grey1,
                                shortcutButtonColor: primaryColor,
                              ),
                            ),
                          ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Resend OTP'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: shortcutRedColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const CustomText(text: 'esc', color: redTextColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyIntent extends Intent {
  const VerifyIntent();
}
