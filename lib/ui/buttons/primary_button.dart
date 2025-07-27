import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
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
      onTapDown: (_) {
        Gaimon.selection();
        setState(() => _isPressed = true);
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
              child: Text(
                widget.text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
