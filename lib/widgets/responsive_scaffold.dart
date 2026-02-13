import 'package:flutter/material.dart';
import '../core/responsive/responsive_config.dart';
import '../core/responsive/responsive_extensions.dart';
import 'responsive_dock.dart';

/// Responsive scaffold that adapts layout based on device type
class ResponsiveScaffold extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<DockItem> dockItems;
  final DockPosition dockPosition;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;
  final Color? backgroundColor;

  const ResponsiveScaffold({
    Key? key,
    required this.body,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.dockItems,
    required this.dockPosition,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  bool _isDockCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final deviceType = context.deviceType;
    final isVerticalDock = widget.dockPosition == DockPosition.left ||
        widget.dockPosition == DockPosition.right;

    // On mobile, always use bottom dock and don't allow collapse
    if (deviceType == DeviceType.mobile) {
      return Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: widget.appBar,
        body: widget.body,
        bottomNavigationBar: ResponsiveDock(
          selectedIndex: widget.selectedIndex,
          onIndexChanged: widget.onIndexChanged,
          items: widget.dockItems,
          position: DockPosition.bottom,
          isCollapsed: false,
        ),
        floatingActionButton: widget.floatingActionButton,
      );
    }

    // On tablet/desktop, use adaptive layout
    if (isVerticalDock) {
      final dockWidth = _isDockCollapsed ? 60.0 : 80.0;
      final dockPosition = widget.dockPosition;

      return Scaffold(
        backgroundColor: widget.backgroundColor,
        body: Row(
          children: [
            if (dockPosition == DockPosition.left)
              ResponsiveDock(
                selectedIndex: widget.selectedIndex,
                onIndexChanged: widget.onIndexChanged,
                items: widget.dockItems,
                position: DockPosition.left,
                isCollapsed: _isDockCollapsed,
                onCollapseToggle: () {
                  setState(() => _isDockCollapsed = !_isDockCollapsed);
                },
              ),
            Expanded(
              child: Scaffold(
                backgroundColor: widget.backgroundColor,
                appBar: widget.appBar,
                body: widget.body,
                floatingActionButton: widget.floatingActionButton,
              ),
            ),
            if (dockPosition == DockPosition.right)
              ResponsiveDock(
                selectedIndex: widget.selectedIndex,
                onIndexChanged: widget.onIndexChanged,
                items: widget.dockItems,
                position: DockPosition.right,
                isCollapsed: _isDockCollapsed,
                onCollapseToggle: () {
                  setState(() => _isDockCollapsed = !_isDockCollapsed);
                },
              ),
          ],
        ),
      );
    } else {
      // Horizontal dock (top/bottom) on desktop
      return Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: widget.appBar,
        body: widget.body,
        bottomNavigationBar: ResponsiveDock(
          selectedIndex: widget.selectedIndex,
          onIndexChanged: widget.onIndexChanged,
          items: widget.dockItems,
          position: widget.dockPosition,
        ),
        floatingActionButton: widget.floatingActionButton,
      );
    }
  }
}
