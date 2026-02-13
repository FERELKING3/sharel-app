import 'package:flutter/material.dart';
import '../../core/responsive/responsive_config.dart';
import '../../core/responsive/responsive_extensions.dart';
import '../../core/theme/design_system.dart';

/// Responsive dock navigation widget (vertical or horizontal)
class ResponsiveDock extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<DockItem> items;
  final DockPosition position;
  final bool isCollapsed;
  final VoidCallback? onCollapseToggle;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const ResponsiveDock({
    Key? key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.items,
    required this.position,
    this.isCollapsed = false,
    this.onCollapseToggle,
    this.backgroundColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<ResponsiveDock> createState() => _ResponsiveDockState();
}

class _ResponsiveDockState extends State<ResponsiveDock>
    with SingleTickerProviderStateMixin {
  late AnimationController _collapseController;
  late Animation<double> _collapseAnimation;

  @override
  void initState() {
    super.initState();
    _collapseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _collapseAnimation =
        Tween<double>(begin: 0, end: 1).animate(_collapseController);

    if (widget.isCollapsed) {
      _collapseController.forward();
    }
  }

  @override
  void didUpdateWidget(ResponsiveDock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCollapsed != widget.isCollapsed) {
      if (widget.isCollapsed) {
        _collapseController.forward();
      } else {
        _collapseController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _collapseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.position == DockPosition.left ||
        widget.position == DockPosition.right;

    if (isVertical) {
      return _buildVerticalDock(context);
    } else {
      return _buildHorizontalDock(context);
    }
  }

  Widget _buildVerticalDock(BuildContext context) {
    return AnimatedBuilder(
      animation: _collapseAnimation,
      builder: (context, child) {
        final width = Tween<double>(
          begin: 80,
          end: 60,
        ).evaluate(_collapseAnimation);

        return Container(
          width: width,
          decoration: BoxDecoration(
            color: widget.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            border: Border(
              right: widget.position == DockPosition.left
                  ? BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.1),
                    )
                  : BorderSide.none,
              left: widget.position == DockPosition.right
                  ? BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.1),
                    )
                  : BorderSide.none,
            ),
          ),
          child: SafeArea(
            right: widget.position == DockPosition.left,
            left: widget.position == DockPosition.right,
            child: Column(
              children: [
                const SizedBox(height: 8),
                ...List.generate(widget.items.length, (index) {
                  final item = widget.items[index];
                  final isSelected = widget.selectedIndex == index;

                  return Tooltip(
                    message: item.label,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => widget.onIndexChanged(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              Icon(
                                item.icon,
                                size: 24,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textGrey,
                              ),
                              if (!widget.isCollapsed) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textGrey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                if (widget.onCollapseToggle != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onCollapseToggle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Icon(
                          widget.isCollapsed
                              ? Icons.keyboard_arrow_right
                              : Icons.keyboard_arrow_left,
                          size: 20,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalDock(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        border: Border(
          top: widget.position == DockPosition.bottom
              ? BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.1),
                )
              : BorderSide.none,
          bottom: widget.position == DockPosition.top
              ? BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.1),
                )
              : BorderSide.none,
        ),
      ),
      child: SafeArea(
        top: widget.position == DockPosition.top,
        bottom: widget.position == DockPosition.bottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            final isSelected = widget.selectedIndex == index;

            return Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => widget.onIndexChanged(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 24,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textGrey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Dock item model
class DockItem {
  final String label;
  final IconData icon;

  DockItem({
    required this.label,
    required this.icon,
  });
}
