import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

class DevToolsLauncher {
  static Future<void> openDevTools(BuildContext context) async {
    // if (!kDebugMode) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('DevTools only available in debug mode')),
    //   );
    //   return;
    // }

    try {
      // Get the VM service URL
      final serviceInfo = await developer.Service.getInfo();
      final serverUri = serviceInfo.serverUri;

      if (serverUri == null) {
        throw Exception('VM service not available');
      }

      // DevTools URL format
      final devToolsUrl = Uri.parse(
          'http://127.0.0.1:9100/?uri=${Uri.encodeComponent(serverUri.toString())}');

      log('Opening DevTools: $devToolsUrl');

      // Launch in browser
      if (await canLaunchUrl(devToolsUrl)) {
        await launchUrl(
          devToolsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Could not launch DevTools');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening DevTools: $e')),
      );
    }
  }
}
