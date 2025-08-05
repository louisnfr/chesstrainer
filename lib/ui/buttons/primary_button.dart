import 'package:chesstrainer/ui/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? textColor;
  final double shadowHeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.shadowColor,
    this.textColor,
    this.shadowHeight = 4,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
    this.borderRadius = 16,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final shadowColor =
        widget.shadowColor ?? backgroundColor.withValues(alpha: 0.6);
    final textColor = widget.textColor ?? theme.colorScheme.onPrimary;

    return GestureDetector(
      onPanDown: (_) {
        setState(() => _isPressed = true);
        Gaimon.selection();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Transform.translate(
        offset: Offset(0, _isPressed ? widget.shadowHeight : 0),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: widget.icon != null ? 8 : 0,
              children: [
                if (widget.icon != null) widget.icon!,
                Text(
                  widget.text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Nunito',
                    shadows: [
                      const Shadow(
                        color: AppColors.surfaceBright,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
