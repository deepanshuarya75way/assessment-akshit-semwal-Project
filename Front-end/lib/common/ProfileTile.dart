import 'package:flutter/material.dart';

class CommonTile extends StatelessWidget {
  const CommonTile({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
    this.onTap,
    this.trailingIcon,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.showBorder = false,
    this.borderColor,
    this.height,
    this.width,
    this.titleMaxLines = 1,
    this.subtitleMaxLines = 1,
    this.overflow = TextOverflow.ellipsis, required Color iconBackgroundColor,
  });

  final String title;
  final String subtitle;
  final Icon icon;
  final VoidCallback? onTap;
  final Widget? trailingIcon;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool showBorder;
  final Color? borderColor;
  final double? height;
  final double? width;
  final int titleMaxLines;
  final int subtitleMaxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      height: height,
      width: width ?? double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: backgroundColor != null
              ? [backgroundColor!, backgroundColor!]
              : isDarkMode
                  ? [
                      theme.colorScheme.surfaceVariant,
                      theme.colorScheme.surface,
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFF8F9FA),
                    ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: showBorder
            ? Border.all(
                color: borderColor ?? theme.dividerColor.withOpacity(0.3),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          splashColor: theme.primaryColor.withOpacity(0.08),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                _buildLeadingIcon(context),
                const SizedBox(width: 18),
                _buildTextContent(context),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 12),
                  trailingIcon!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.15),
            theme.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: IconTheme.merge(
        data: IconThemeData(
          size: 22,
          color: icon.color ?? theme.primaryColor,
        ),
        child: icon,
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    final theme = Theme.of(context);

    final defaultTitleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: theme.colorScheme.onSurface,
    );

    final defaultSubtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle ?? defaultTitleStyle,
            maxLines: titleMaxLines,
            overflow: overflow,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: subtitleStyle ?? defaultSubtitleStyle,
            maxLines: subtitleMaxLines,
            overflow: overflow,
          ),
        ],
      ),
    );
  }
}
