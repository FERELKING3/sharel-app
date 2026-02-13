import 'package:flutter/material.dart';

/// Premium header widget for Sharel
class SharelHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onLeadingPressed;
  final Color? backgroundColor;
  final double elevation;
  final bool blurred;
  final bool centerTitle;

  const SharelHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.onLeadingPressed,
    this.backgroundColor,
    this.elevation = 2,
    this.blurred = false,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.scrim.withValues(alpha: 0.05),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation / 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Leading widget or back button
              if (leading != null)
                leading!
              else if (onLeadingPressed != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onLeadingPressed,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                )
              else
                const SizedBox(width: 8),

              const SizedBox(width: 8),

              // Title and subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: centerTitle
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              if (actions != null) ...[
                const SizedBox(width: 8),
                ...actions!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Preset header styles factory
class SharelHeaderFactory {
  /// Home screen header
  static SharelHeader home(
    BuildContext context, {
    List<Widget>? actions,
  }) {
    return SharelHeader(
      title: 'SHAREL',
      centerTitle: false,
      actions: actions ?? [],
      elevation: 1,
    );
  }

  /// Standard page header
  static SharelHeader page(
    BuildContext context, {
    required String title,
    String? subtitle,
    VoidCallback? onBack,
    List<Widget>? actions,
  }) {
    return SharelHeader(
      title: title,
      subtitle: subtitle,
      onLeadingPressed: onBack,
      actions: actions,
      elevation: 1,
    );
  }

  /// Settings header
  static SharelHeader settings(
    BuildContext context, {
    VoidCallback? onBack,
  }) {
    return SharelHeader(
      title: 'Paramètres',
      onLeadingPressed: onBack,
      elevation: 1,
    );
  }
}
