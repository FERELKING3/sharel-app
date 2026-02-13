import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:sharel_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/responsive/responsive_config.dart';
import '../core/responsive/responsive_extensions.dart';
import '../core/providers/settings_provider.dart';
import 'responsive_dock.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _selectedIndex = 0;
  DateTime? _lastBackPressed;
  bool _isDockCollapsed = false;

  void _onNavDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/files');
        break;
      case 2:
        context.go('/discovery');
        break;
      case 3:
        context.go('/me');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final dockPosition = ref.watch(dockPositionProvider);
    final deviceType = context.deviceType;
    final isVerticalDock =
        dockPosition == DockPosition.left || dockPosition == DockPosition.right;

    final dockItems = [
      DockItem(
        label: t?.bottomNavHome ?? 'Accueil',
        icon: Icons.home_outlined,
      ),
      DockItem(
        label: t?.labelFiles ?? 'Fichiers',
        icon: Icons.folder_outlined,
      ),
      DockItem(
        label: t?.bottomNavDiscovery ?? 'Découvrir',
        icon: Icons.travel_explore,
      ),
      DockItem(
        label: t?.bottomNavMe ?? 'Profil',
        icon: Icons.person_outline,
      ),
    ];

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        if (context.canPop()) {
          context.pop();
          return;
        }

        final now = DateTime.now();
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
          _lastBackPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appuyez de nouveau pour quitter')),
          );
          return;
        }

        SystemNavigator.pop();
      },
      child: _buildResponsiveLayout(
        context,
        theme,
        deviceType,
        isVerticalDock,
        dockPosition,
        dockItems,
      ),
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    ThemeData theme,
    DeviceType deviceType,
    bool isVerticalDock,
    DockPosition dockPosition,
    List<DockItem> dockItems,
  ) {
    // Mobile: Bottom dock always
    if (deviceType == DeviceType.mobile) {
      return Scaffold(
        body: widget.child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: ResponsiveDock(
            selectedIndex: _selectedIndex,
            onIndexChanged: _onNavDestinationSelected,
            items: dockItems,
            position: DockPosition.bottom,
            isCollapsed: false,
          ),
        ),
      );
    }

    // Tablet/Desktop with vertical dock
    if (isVerticalDock) {
      final dockWidth = _isDockCollapsed ? 60.0 : 80.0;

      return Row(
        children: [
          if (dockPosition == DockPosition.left)
            Container(
              width: dockWidth,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color:
                        theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: ResponsiveDock(
                selectedIndex: _selectedIndex,
                onIndexChanged: _onNavDestinationSelected,
                items: dockItems,
                position: DockPosition.left,
                isCollapsed: _isDockCollapsed,
                onCollapseToggle: () {
                  setState(() => _isDockCollapsed = !_isDockCollapsed);
                },
              ),
            ),
          Expanded(
            child: Scaffold(
              body: widget.child,
            ),
          ),
          if (dockPosition == DockPosition.right)
            Container(
              width: dockWidth,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  left: BorderSide(
                    color:
                        theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: ResponsiveDock(
                selectedIndex: _selectedIndex,
                onIndexChanged: _onNavDestinationSelected,
                items: dockItems,
                position: DockPosition.right,
                isCollapsed: _isDockCollapsed,
                onCollapseToggle: () {
                  setState(() => _isDockCollapsed = !_isDockCollapsed);
                },
              ),
            ),
        ],
      );
    }

    // Tablet/Desktop with horizontal dock (top/bottom)
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: dockPosition == DockPosition.bottom
          ? Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: ResponsiveDock(
                selectedIndex: _selectedIndex,
                onIndexChanged: _onNavDestinationSelected,
                items: dockItems,
                position: DockPosition.bottom,
                isCollapsed: false,
              ),
            )
          : null,
    );
  }
}
