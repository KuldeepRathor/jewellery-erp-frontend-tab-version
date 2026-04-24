// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/foundation.dart';

// class RemoteConfigService {
//   static RemoteConfigService? _instance;
//   static RemoteConfigService get instance {
//     _instance ??= RemoteConfigService._();
//     return _instance!;
//   }

//   RemoteConfigService._();

//   final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

//   String _serverEndpoint = '';

//   String get serverEndpoint => _serverEndpoint;

//   Future<void> initialize() async {
//     try {
//       // Set configuration settings
//       await _remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: const Duration(hours: 1),
//       ));

//       // Set default values
//       await _remoteConfig.setDefaults({
//         'server_endpoint': kReleaseMode
//             ? 'https://zivoro-backend-dev.1ounce.in'
//             : 'https://zivoro-backend-staging.1ounce.in',
//       });

//       // Fetch and activate
//       await _remoteConfig.fetchAndActivate();

//       // Get the server endpoint value
//       _serverEndpoint = _remoteConfig.getString('server_endpoint');

//       if (_serverEndpoint.isEmpty) {
//         // Fallback to default if empty
//         _serverEndpoint = kReleaseMode
//             ? 'https://zivoro-backend-dev.1ounce.in'
//             : 'https://zivoro-backend-staging.1ounce.in';
//       }

//       debugPrint(
//           'Remote Config initialized. Server endpoint: $_serverEndpoint');
//     } catch (e) {
//       debugPrint('Failed to initialize Remote Config: $e');
//       // Fallback to default values
//       _serverEndpoint = kReleaseMode
//           ? 'https://zivoro-backend-dev.1ounce.in'
//           : 'https://zivoro-backend-staging.1ounce.in';
//     }
//   }

//   Future<void> fetchAndActivate() async {
//     try {
//       final bool updated = await _remoteConfig.fetchAndActivate();
//       if (updated) {
//         _serverEndpoint = _remoteConfig.getString('server_endpoint');
//         if (_serverEndpoint.isEmpty) {
//           _serverEndpoint = kReleaseMode
//               ? 'https://zivoro-backend-dev.1ounce.in'
//               : 'https://zivoro-backend-staging.1ounce.in';
//         }
//         debugPrint(
//             'Remote Config updated. New server endpoint: $_serverEndpoint');
//       }
//     } catch (e) {
//       debugPrint('Failed to fetch Remote Config: $e');
//     }
//   }
// }
