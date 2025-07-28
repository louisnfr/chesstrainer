import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';

class ActionButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? textColor;
  final double shadowHeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double iconSize;

  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.shadowColor,
    this.textColor,
    this.shadowHeight = 4,
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    this.borderRadius = 16,
    this.iconSize = 32,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final shadowColor =
        widget.shadowColor ?? backgroundColor.withValues(alpha: 0.6);
    final iconColor = widget.textColor ?? theme.colorScheme.onPrimary;

    return GestureDetector(
      onPanDown: (_) {
        setState(() => _isPressed = true);
        Gaimon.selection();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        transform: Matrix4.translationValues(
          0,
          _isPressed ? widget.shadowHeight : 0,
          0,
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: widget.shadowHeight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: _isPressed
                ? null
                : [
                    BoxShadow(
                      color: shadowColor,
                      offset: Offset(0, widget.shadowHeight),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
          ),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: shadowColor, width: 2),
            ),
            child: Center(
              child: Row(
                children: [
                  if (widget.label != null)
                    Text(
                      widget.label!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: iconColor,
                      ),
                    ),
                  Icon(widget.icon, color: iconColor, size: widget.iconSize),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
