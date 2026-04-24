import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

/// Visible only in debug builds. Renders null (no FAB) in release/profile.
class DebugServerFab extends StatelessWidget {
  const DebugServerFab({super.key});

  void _showEndpointDialog(BuildContext context) {
    final controller = TextEditingController(
      text: AppUrl.debugOverride ?? AppUrl.defaultEndpoint,
    );

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.developer_mode, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Debug: Override Server URL',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Default (build-mode): ${AppUrl.defaultEndpoint}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Server endpoint',
                      hintText: 'https://your-server.example.com',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                    keyboardType: TextInputType.url,
                    onSubmitted: (_) => _applyAndClose(ctx, controller.text),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Currently active: ${AppUrl.baseUrl}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  AppUrl.setDebugOverride(null);
                  controller.clear();
                  Navigator.of(ctx).pop();
                  showInfoToast(
                    message: 'Reset to default: ${AppUrl.defaultEndpoint}',
                  );
                },
                child: const Text('Reset', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => _applyAndClose(ctx, controller.text),
                child: const Text('Apply'),
              ),
            ],
          ),
    );
  }

  void _applyAndClose(BuildContext ctx, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      AppUrl.setDebugOverride(null);
      showInfoToast(
        message: 'Override cleared. Using default: ${AppUrl.defaultEndpoint}',
      );
    } else {
      AppUrl.setDebugOverride(trimmed);
      showInfoToast(message: 'Override set → $trimmed');
    }
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return FloatingActionButton(
      tooltip: 'Debug: Change server URL',
      backgroundColor: Colors.orange,
      onPressed: () => _showEndpointDialog(context),
      child: const Icon(Icons.developer_mode),
    );
  }
}
