// widgets/permission_guard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'permission_service.dart';
import 'rbac_controller.dart';

class PermissionGuard extends StatelessWidget {
  final Widget child;
  final int? actionCode;
  final int? pageCode;
  final int? moduleCode;
  final List<int>? anyActionCodes;
  final List<int>? allActionCodes;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.child,
    this.actionCode,
    this.pageCode,
    this.moduleCode,
    this.anyActionCodes,
    this.allActionCodes,
    this.fallback,
  }) : assert(
            (actionCode != null) ||
                (pageCode != null) ||
                (moduleCode != null) ||
                (anyActionCodes != null) ||
                (allActionCodes != null),
            'At least one permission check must be provided');

  @override
  Widget build(BuildContext context) {
    final rbacController = Get.find<RBACController>();

    // Check permissions
    bool hasPermission = false;

    if (actionCode != null && rbacController.hasAction(actionCode!)) {
      hasPermission = true;
    } else if (pageCode != null && rbacController.hasPage(pageCode!)) {
      hasPermission = true;
    } else if (moduleCode != null && rbacController.hasModule(moduleCode!)) {
      hasPermission = true;
    } else if (anyActionCodes != null &&
        anyActionCodes!.isNotEmpty &&
        rbacController.hasAnyAction(anyActionCodes!)) {
      hasPermission = true;
    } else if (allActionCodes != null &&
        allActionCodes!.isNotEmpty &&
        rbacController.hasAllActions(allActionCodes!)) {
      hasPermission = true;
    }

    // Return appropriate widget
    if (hasPermission) {
      return child;
    } else {
      // If pageCode is passed but no fallback is provided, show access denied message
      if (pageCode != null && fallback == null) {
        // Get page name if available
        String pageName = 'this page';
        try {
          final pageDisplayName =
              PermissionsMappingService.getPageDisplayName(pageCode!);
          if (pageDisplayName != 'Unknown Page') {
            pageName = pageDisplayName;
          }
        } catch (_) {
          // Fallback to generic name if service fails
        }

        // Return access denied UI for page
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.block,
                size: 64,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Access Denied',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You are not allowed to view $pageName',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      // For other cases, use provided fallback or empty widget
      return fallback ?? const SizedBox.shrink();
    }
  }
}

// Example usage:
// PermissionGuard(
//   pageCode: 1050, // sales_list page
//   child: SalesListPage(),
//   // No fallback - will show "You are not allowed to view Sales List" message
// )
//
// PermissionGuard(
//   actionCode: 1052, // sales_list.add_new_sales
//   child: ElevatedButton(
//     onPressed: () => addNewSales(),
//     child: Text('Add New Sales'),
//   ),
//   fallback: Text('You don\'t have permission to add new sales'),
// )
