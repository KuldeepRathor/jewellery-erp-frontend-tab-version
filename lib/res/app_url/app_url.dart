import 'dart:io';
import 'package:flutter/foundation.dart';
// import 'package:jewellery_erp_frontend_tab_version/services/remote_config_service.dart';

class AppUrl {
  static const String productionEndpoint =
      "https://zivoro-backend-dev.1ounce.in";
  static const String stagingEndpoint =
      "https://zivoro-backend-staging.1ounce.in";

  // Holds the runtime override — only ever populated in debug mode
  static String? _debugOverrideUrl;

  /// Call this only from debug tooling. The `assert` block guarantees
  /// the setter compiles away entirely in release/profile builds.
  static void setDebugOverride(String? url) {
    assert(() {
      _debugOverrideUrl =
          (url != null && url.trim().isEmpty) ? null : url?.trim();
      return true;
    }());
  }

  static String? get debugOverride => kDebugMode ? _debugOverrideUrl : null;

  static String get defaultEndpoint =>
      kReleaseMode ? productionEndpoint : stagingEndpoint;

  static String get baseUrl {
    // final remoteConfigUrl = RemoteConfigService.instance.serverEndpoint;

    // Use Remote Config value if available, otherwise fallback to defaults
    // if (remoteConfigUrl.isNotEmpty) {
    //   return remoteConfigUrl;
    // }
    //    "https://zivoro-backend-dev.1ounce.in";

    return kReleaseMode
        ? "https://zivoro-backend-dev.1ounce.in"
        : "https://zivoro-backend-staging.1ounce.in";
  }

  static String get customerBaseUrl => "$baseUrl/customer-service";
  static String get vendorBaseUrl => "$baseUrl/vendor-service";
  static const String localBaseUrl = "http://localhost:3000";
  static String get purchaseBaseUrl => "$baseUrl/purchase-service";
  static String get inventoryBaseUrl => "$baseUrl/inventory-service";
  static String get organizationBaseUrl => "$baseUrl/organization-service";
  static String get estimationBaseUrl => "$baseUrl/estimation-service";
  static String get webStoreBaseUrl => "$baseUrl/webstore-service";

  //Report
  static String get stockAndValueStatementBaseUrl =>
      "$baseUrl/aggregate-service/inward-outward-report";

  static String get branchInReportListBaseUrl =>
      "$baseUrl/aggregate-service/paginated_branch_in";
  static String get branchOutReportListBaseUrl =>
      "$baseUrl/aggregate-service/paginated_branch_out";

  static const String jewelleryPlanBaseUrl =
      "https://sipserver.1ounce.in/posync";
  static const String jewelleryPlanBaseUrl1 = "https://sipserver.1ounce.in";
  static String get aggregateBaseUrl => "$baseUrl/aggregate-service";

  // exe and other ui urls
  final String carouselImageUrl =
      "https://jewellers-images.s3.amazonaws.com/053f7540-b2a9-4134-ac06-05905688ed7e/20000000-0000-0000-0000-000000000001/webstore/banner_oxo/cropped_1742967635460_1742967671.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVA5YK5SBCIDO364N%2F20250401%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20250401T045801Z&X-Amz-Expires=18000&X-Amz-SignedHeaders=host&X-Amz-Signature=cac664d3e50c4509db66cbe265e5ec87d4cc47074a967a7ea7e120d4a93805c1";

  /// The installer/DMG download URL, selected by platform + build mode.
  /// On macOS this is a DMG link (opened in the browser — cannot be run silently).
  /// On Windows this is the .exe path (downloaded and launched by the updater).
  String get setup_url {
    if (Platform.isMacOS) {
      return kReleaseMode
          ? "https://zivoro-frontend-setup.s3.amazonaws.com/macos/zivoro-macos.dmg"
          : "https://zivoro-frontend-setup.s3.amazonaws.com/macos/debug/zivoro-macos-debug.dmg";
    }
    // Windows
    return kReleaseMode
        ? "https://zivoro-frontend-setup.s3.ap-south-1.amazonaws.com/zivoro.exe"
        : "https://zivoro-frontend-setup.s3.ap-south-1.amazonaws.com/debug/zivoro-debug.exe";
  }

  /// The update-check JSON URL, selected by platform + build mode.
  String get update_json_url {
    if (Platform.isMacOS) {
      return kReleaseMode
          ? "https://zivoro-frontend-setup.s3.amazonaws.com/macos/update-macos.json"
          : "https://zivoro-frontend-setup.s3.amazonaws.com/macos/debug/update-macos-debug.json";
    }
    // Windows
    return kReleaseMode
        ? "https://zivoro-frontend-setup.s3.ap-south-1.amazonaws.com/update.json"
        : "https://zivoro-frontend-setup.s3.ap-south-1.amazonaws.com/debug/update-debug.json";
  }
}
