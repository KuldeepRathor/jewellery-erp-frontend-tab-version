import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';

class ActionScopeWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onNewButtonTap;
  final Map<LogicalKeySet, Intent>? additionalShortcuts;
  final Map<Type, Action<Intent>>? additionalActions;

  const ActionScopeWidget({
    super.key,
    required this.child,
    this.onNewButtonTap,
    this.additionalShortcuts,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    // Base shortcuts that are always included
    final baseShortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(
            LogicalKeyboardKey.control,
            // LogicalKeyboardKey.shift,
            LogicalKeyboardKey.keyN,
          ):
          const NewButtonClickIntent(),
    };

    // Base actions that are always included
    final baseActions = <Type, Action<Intent>>{
      NewButtonClickIntent: CallbackAction<NewButtonClickIntent>(
        onInvoke: (NewButtonClickIntent intent) {
          if (onNewButtonTap != null) {
            onNewButtonTap!();
          }
          return null;
        },
      ),
    };

    // Merge additional shortcuts and actions if provided
    if (additionalShortcuts != null) {
      baseShortcuts.addAll(additionalShortcuts!);
    }
    if (additionalActions != null) {
      baseActions.addAll(additionalActions!);
    }

    return Actions(
      actions: baseActions,
      child: Shortcuts(
        shortcuts: baseShortcuts,
        child: FocusScope(autofocus: true, child: child),
      ),
    );
  }
}
