import 'package:get/get.dart';

import '../model/get_role_types_model.dart';
import '../model/modules_response.dart';

class PermissionsViewModel extends GetxController {
  // Selected items
  final selectedModuleId = Rx<int?>(null);
  final selectedPageId = Rx<int?>(null);

  // Data
  final modules = <ModulePermission>[].obs;

  void clearController() {
    selectedModuleId.value = null;
    selectedPageId.value = null;
    modules.clear();
    modules.refresh();
  }

  ModulePermission? get selectedModule {
    if (selectedModuleId.value == null) return null;
    try {
      return modules.firstWhere((m) => m.moduleId == selectedModuleId.value);
    } catch (e) {
      return null;
    }
  }

  List<PagePermission> get pagesForSelectedModule {
    return selectedModule?.pages ?? [];
  }

  PagePermission? get selectedPage {
    if (selectedPageId.value == null) return null;
    final pages = pagesForSelectedModule;
    if (pages.isEmpty) return null;

    try {
      return pages.firstWhere((p) => p.pageId == selectedPageId.value);
    } catch (e) {
      return null;
    }
  }

  List<ActionPermission> get actionsForSelectedPage {
    return selectedPage?.actions ?? [];
  }

  void selectModule(int moduleId) {
    selectedModuleId.value = moduleId;
    selectedPageId.value = null;

    // Auto-select first page if available
    final newSelectedModule = selectedModule;
    if (newSelectedModule != null && newSelectedModule.pages!.isNotEmpty) {
      selectedPageId.value = newSelectedModule.pages!.firstOrNull?.pageId;
    }
  }

  void selectPage(int pageId) {
    selectedPageId.value = pageId;
  }

  void toggleModule(ModulePermission module, bool value) {
    // Update this module
    int index = modules.indexWhere((m) => m.moduleId == module.moduleId);
    if (index != -1) {
      modules[index].isActive = value;

      // Update all pages and actions in this module
      for (var page in modules[index].pages!) {
        page.isActive = value;
        for (var action in page.actions!) {
          action.isActive = value;
        }
      }

      modules.refresh();
    }
  }

  void togglePage(PagePermission page, bool value) {
    final module = selectedModule;
    if (module == null) return;

    int moduleIndex = modules.indexWhere((m) => m.moduleId == module.moduleId);
    if (moduleIndex == -1) return;

    int pageIndex =
        modules[moduleIndex].pages!.indexWhere((p) => p.pageId == page.pageId);
    if (pageIndex == -1) return;

    // Update this page
    modules[moduleIndex].pages![pageIndex].isActive = value;

    // Update all actions in this page
    for (var action in modules[moduleIndex].pages![pageIndex].actions!) {
      action.isActive = value;
    }

    // Update module status based on pages
    modules[moduleIndex].isActive =
        modules[moduleIndex].pages!.any((p) => p.isActive!);

    modules.refresh();
  }

  void toggleAction(ActionPermission action, bool value) {
    final module = selectedModule;
    final page = selectedPage;
    if (module == null || page == null) return;

    int moduleIndex = modules.indexWhere((m) => m.moduleId == module.moduleId);
    if (moduleIndex == -1) return;

    int pageIndex =
        modules[moduleIndex].pages!.indexWhere((p) => p.pageId == page.pageId);
    if (pageIndex == -1) return;

    int actionIndex = modules[moduleIndex]
        .pages![pageIndex]
        .actions!
        .indexWhere((a) => a.actionId == action.actionId);
    if (actionIndex == -1) return;

    // Update this action
    modules[moduleIndex].pages![pageIndex].actions![actionIndex].isActive =
        value;

    // If enabling an action, ensure its page and module are also enabled
    if (value) {
      modules[moduleIndex].pages![pageIndex].isActive = true;
      modules[moduleIndex].isActive = true;
    } else {
      // Update page status based on actions
      modules[moduleIndex].pages![pageIndex].isActive = modules[moduleIndex]
          .pages![pageIndex]
          .actions!
          .any((a) => a.isActive!);

      // Update module status based on pages
      modules[moduleIndex].isActive =
          modules[moduleIndex].pages!.any((p) => p.isActive!);
    }

    modules.refresh();
  }

  // Get permissions data for saving - returns a filtered list of ModulePermission objects
  List<ModulePermission> getPermissionsForSaving() {
    // Create a filtered copy of the modules list with only active permissions
    List<ModulePermission> result = [];

    for (final module in modules) {
      // Include module if it's active
      if (module.isActive == true) {
        // Process pages within the module
        List<PagePermission> activePages = [];

        for (final page in module.pages ?? <PagePermission>[]) {
          // Include page if it's active
          if (page.isActive == true) {
            // Process actions within the page
            List<ActionPermission> activeActions = [];

            // Include all active actions
            for (final action in page.actions ?? <ActionPermission>[]) {
              if (action.isActive == true) {
                activeActions.add(ActionPermission(
                    actionId: action.actionId,
                    name: action.name,
                    displayName: action.displayName,
                    isActive: true));
              }
            }

            // Add the page with its active actions (even if the action list is empty)
            activePages.add(PagePermission(
              pageId: page.pageId,
              name: page.name,
              displayName: page.displayName,
              isActive: true,
              actions: activeActions,
            ));
          }
        }

        // Add the module with its active pages (even if the page list is empty)
        result.add(ModulePermission(
          moduleId: module.moduleId,
          name: module.name,
          displayName: module.displayName,
          isActive: true,
          pages: activePages,
        ));
      }
    }

    return result;
  }

  void setPermissionsFromRoleType(GetRoleTypesResponse roleTypeData) {
    if (roleTypeData.modules != null) {
      // Replace the current modules with the ones from the selected role type
      modules.assignAll(roleTypeData.modules!);

      // Reset selections
      if (modules.isNotEmpty) {
        selectedModuleId.value = modules.first.moduleId;

        if (modules.first.pages != null && modules.first.pages!.isNotEmpty) {
          selectedPageId.value = modules.first.pages!.first.pageId;
        } else {
          selectedPageId.value = null;
        }
      } else {
        selectedModuleId.value = null;
        selectedPageId.value = null;
      }

      modules.refresh();
    }
  }

  // New method to load existing permissions for editing
  void loadExistingPermissions(List<ModulePermission> existingModules) {
    // Replace the current modules with the existing ones
    modules.assignAll(existingModules);

    // Reset selections
    if (modules.isNotEmpty) {
      selectedModuleId.value = modules.first.moduleId;

      if (modules.first.pages != null && modules.first.pages!.isNotEmpty) {
        selectedPageId.value = modules.first.pages!.first.pageId;
      } else {
        selectedPageId.value = null;
      }
    } else {
      selectedModuleId.value = null;
      selectedPageId.value = null;
    }

    modules.refresh();
  }
}
