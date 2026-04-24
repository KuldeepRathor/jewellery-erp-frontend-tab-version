class MetalTypeUtils {
  // Metal type IDs (fixed values used in API and business logic)
  static const int gold = 1;
  static const int platinum = 2;
  static const int silver = 3;

  // Tab order configuration (for UI display)
  // Tab Index 0 = Gold, Tab Index 1 = Silver, Tab Index 2 = Platinum
  static const List<int> tabOrder = [gold, silver, platinum];

  // Get metal type from tab index
  static int getMetalTypeFromTabIndex(int tabIndex) {
    if (tabIndex < 0 || tabIndex >= tabOrder.length) {
      return gold; // Default to gold
    }
    return tabOrder[tabIndex];
  }

  // Get tab index from metal type
  static int getTabIndexFromMetalType(int metalType) {
    final index = tabOrder.indexOf(metalType);
    return index >= 0 ? index : 0; // Default to first tab
  }

  // Get metal type name
  static String getName(int metalType) {
    switch (metalType) {
      case gold:
        return 'Gold';
      case platinum:
        return 'Platinum';
      case silver:
        return 'Silver';
      default:
        return 'Unknown';
    }
  }

  // Get display name for tabs (in tab order)
  static String getTabDisplayName(int tabIndex) {
    return getName(getMetalTypeFromTabIndex(tabIndex));
  }

  // Tab labels in display order
  static const List<String> tabLabels = [
    'Gold Jewellery',
    'Silver Jewellery',
    'Platinum Jewellery',
  ];
}
