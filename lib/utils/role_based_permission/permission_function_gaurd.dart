import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

import 'permission_service.dart';
import 'rbac_controller.dart';

/// A utility class that provides methods to guard functions with permission checks
class PermissionGuardUtil {
  /// Execute a synchronous function only if the user has the specific action permission
  /// Returns true if the function was executed, false if permission was denied
  static bool withActionPermission(
    int actionCode,
    Function() function, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasAction(actionCode)) {
      function();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          actionCode: actionCode,
          customErrorMessage: customErrorMessage,
        );
      }
      return false;
    }
  }

  /// Execute an async function only if the user has the specific action permission
  /// Returns a Future<bool> that resolves to true if the function was executed, false if permission was denied
  static Future<bool> withActionPermissionAsync(
    int actionCode,
    Future<void> Function() asyncFunction, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) async {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasAction(actionCode)) {
      await asyncFunction();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          actionCode: actionCode,
          customErrorMessage: customErrorMessage,
        );
      }
      return false;
    }
  }

  /// Execute a synchronous function only if the user has the specific page permission
  /// Returns true if the function was executed, false if permission was denied
  static bool withPagePermission(
    int pageCode,
    Function() function, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasPage(pageCode)) {
      function();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          pageCode: pageCode,
          customErrorMessage: customErrorMessage,
        );
      }
      return false;
    }
  }

  /// Execute an async function only if the user has the specific page permission
  /// Returns a Future<bool> that resolves to true if the function was executed, false if permission was denied
  static Future<bool> withPagePermissionAsync(
    int pageCode,
    Future<void> Function() asyncFunction, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) async {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasPage(pageCode)) {
      await asyncFunction();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          pageCode: pageCode,
          customErrorMessage: customErrorMessage,
        );
      }
      return false;
    }
  }

  /// Execute a synchronous function only if the user has the specific module permission
  /// Returns true if the function was executed, false if permission was denied
  static bool withModulePermission(
    int moduleCode,
    Function() function, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasModule(moduleCode)) {
      function();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          moduleCode: moduleCode,
          customErrorMessage: customErrorMessage,
        );
      }
      return false;
    }
  }

  /// Execute an async function only if the user has the specific module permission
  /// Returns a Future<bool> that resolves to true if the function was executed, false if permission was denied
  static Future<bool> withModulePermissionAsync(
    int moduleCode,
    Future<void> Function() asyncFunction, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) async {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasModule(moduleCode)) {
      await asyncFunction();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          moduleCode: moduleCode,
          customErrorMessage: customErrorMessage,
        );
      }
      return false;
    }
  }

  /// Execute a synchronous function only if the user has any of the specified action permissions
  /// Returns true if the function was executed, false if permission was denied
  static bool withAnyActionPermission(
    List<int> actionCodes,
    Function() function, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasAnyAction(actionCodes)) {
      function();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          customErrorMessage:
              customErrorMessage ??
              'You do not have permission to perform this action',
        );
      }
      return false;
    }
  }

  /// Execute an async function only if the user has any of the specified action permissions
  /// Returns a Future<bool> that resolves to true if the function was executed, false if permission was denied
  static Future<bool> withAnyActionPermissionAsync(
    List<int> actionCodes,
    Future<void> Function() asyncFunction, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) async {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasAnyAction(actionCodes)) {
      await asyncFunction();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          customErrorMessage:
              customErrorMessage ??
              'You do not have permission to perform this action',
        );
      }
      return false;
    }
  }

  /// Execute a synchronous function only if the user has all of the specified action permissions
  /// Returns true if the function was executed, false if permission was denied
  static bool withAllActionPermissions(
    List<int> actionCodes,
    Function() function, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasAllActions(actionCodes)) {
      function();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          customErrorMessage:
              customErrorMessage ??
              'You do not have all required permissions to perform this action',
        );
      }
      return false;
    }
  }

  /// Execute an async function only if the user has all of the specified action permissions
  /// Returns a Future<bool> that resolves to true if the function was executed, false if permission was denied
  static Future<bool> withAllActionPermissionsAsync(
    List<int> actionCodes,
    Future<void> Function() asyncFunction, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) async {
    final rbacController = Get.find<RBACController>();

    if (rbacController.hasAllActions(actionCodes)) {
      await asyncFunction();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          customErrorMessage:
              customErrorMessage ??
              'You do not have all required permissions to perform this action',
        );
      }
      return false;
    }
  }

  /// Execute a synchronous function based on a custom permission check function
  /// Returns true if the function was executed, false if permission was denied
  static bool withCustomPermissionCheck(
    bool Function() permissionCheck,
    Function() function, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) {
    if (permissionCheck()) {
      function();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          customErrorMessage:
              customErrorMessage ??
              'You do not have permission to perform this action',
        );
      }
      return false;
    }
  }

  /// Execute an async function based on a custom permission check function
  /// Returns a Future<bool> that resolves to true if the function was executed, false if permission was denied
  static Future<bool> withCustomPermissionCheckAsync(
    bool Function() permissionCheck,
    Future<void> Function() asyncFunction, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) async {
    if (permissionCheck()) {
      await asyncFunction();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          customErrorMessage:
              customErrorMessage ??
              'You do not have permission to perform this action',
        );
      }
      return false;
    }
  }

  /// Execute an async function based on an async custom permission check function
  /// Returns a Future<bool> that resolves to true if the function was executed, false if permission was denied
  static Future<bool> withAsyncCustomPermissionCheckAsync(
    Future<bool> Function() asyncPermissionCheck,
    Future<void> Function() asyncFunction, {
    bool showErrorMessage = true,
    String? customErrorMessage,
  }) async {
    if (await asyncPermissionCheck()) {
      await asyncFunction();
      return true;
    } else {
      if (showErrorMessage) {
        _showPermissionDeniedMessage(
          customErrorMessage:
              customErrorMessage ??
              'You do not have permission to perform this action',
        );
      }
      return false;
    }
  }

  /// Helper method to show a permission denied message
  static void _showPermissionDeniedMessage({
    int? actionCode,
    int? pageCode,
    int? moduleCode,
    required String? customErrorMessage,
  }) {
    String errorMessage =
        customErrorMessage ??
        'You do not have permission to perform this action';

    // If no custom message is provided, generate one based on the code
    if (customErrorMessage == null) {
      if (actionCode != null) {
        final actionName = PermissionsMappingService.getActionDisplayName(
          actionCode,
        );
        errorMessage =
            'You do not have permission to ${actionName.toLowerCase()}';
      } else if (pageCode != null) {
        final pageName = PermissionsMappingService.getPageDisplayName(pageCode);
        errorMessage =
            'You do not have permission to access ${pageName.toLowerCase()}';
      } else if (moduleCode != null) {
        final moduleName = PermissionsMappingService.getModuleDisplayName(
          moduleCode,
        );
        errorMessage =
            'You do not have permission to access the ${moduleName.toLowerCase()} module';
      }
    }

    // Show snackbar with error message
    // Get.snackbar(
    //   'Permission Denied',
    //   errorMessage,
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.red.withOpacity(0.8),
    //   colorText: Colors.white,
    //   duration: const Duration(seconds: 3),
    // );
    showErrorToast(message: errorMessage);
  }
}
