import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

// Define intents for yes and no actions
class ConfirmIntent extends Intent {}

class CancelIntent extends Intent {}

class CancelPaymentDialog extends StatefulWidget {
  final Future<void> Function() onYesPressed;
  final String subtitle;

  const CancelPaymentDialog({
    super.key,
    required this.onYesPressed,
    this.subtitle = 'Are you sure you want to cancel this ?',
  });

  @override
  State<CancelPaymentDialog> createState() => _CancelPaymentDialogState();
}

class _CancelPaymentDialogState extends State<CancelPaymentDialog> {
  bool _isLoading = false;

  Future<void> _handleYesPressed() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onYesPressed();
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {
        ConfirmIntent: CallbackAction<ConfirmIntent>(
          onInvoke: (intent) => _handleYesPressed(),
        ),
        CancelIntent: CallbackAction<CancelIntent>(
          onInvoke: (intent) => Navigator.of(context).pop(false),
        ),
      },
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): ConfirmIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): CancelIntent(),
        },
        child: Focus(
          autofocus: true,
          child: Dialog(
            backgroundColor: whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Warning !',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ButtonShortcutWidget(
                        onTap: () => Navigator.of(context).pop(false),
                        buttonName: 'No',
                        shortcut: 'Esc',
                        color: primaryColor,
                        shortcutButtonBackgroundColor: grey1,
                        shortcutButtonColor: primaryColor,
                        buttonsize: 14,
                      ),
                      const SizedBox(width: 24),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: primaryColor,
                        ),
                        child: ButtonShortcutWidget(
                          onTap: _isLoading ? null : _handleYesPressed,
                          buttonName: _isLoading ? 'Processing...' : 'Yes',
                          shortcut: 'Enter',
                          color: whiteColor,
                          shortcutButtonBackgroundColor: grey1,
                          shortcutButtonColor: primaryColor,
                          buttonsize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
