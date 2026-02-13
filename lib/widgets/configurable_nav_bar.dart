import 'package:flutter/material.dart';

/// Navigation bar style enum (23 styles total)
enum NavBarStyle {
  style1, style2, style3, style4, style5, style6, style7,
  style8, // Default
  style9, style10, style11, style12, style13, style14, style15,
  style16, style17,
  // Convex styles
  convex1, convex2, convex3, convex4, convex5,
}

/// Navigation item
class NavBarItem {
  final String label;
  final IconData icon;
  final Color? activeColor;
  final Color? inactiveColor;

  const NavBarItem({
    required this.label,
    required this.icon,
    this.activeColor,
    this.inactiveColor,
  });
}

/// Configurable navigation bar widget (simplified MVP version)
class ConfigurableNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NavBarItem> items;
  final NavBarStyle style;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  const ConfigurableNavBar({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.items,
    this.style = NavBarStyle.style8,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    // MVP: Use standard Material NavigationBar
    // TODO: Full integration with persistent_bottom_nav_bar_v2 + convex_bottom_bar in v7.7
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: NavigationBar(
        backgroundColor: bgColor,
        selectedIndex: selectedIndex,
        destinations: items
            .map((item) => NavigationDestination(
                  icon: Icon(item.icon),
                  label: item.label,
                ))
            .toList(),
        onDestinationSelected: onIndexChanged,
      ),
    );
  }
}
