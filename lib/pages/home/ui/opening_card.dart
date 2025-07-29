import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:percent_indicator/percent_indicator.dart';

class OpeningCard extends StatefulWidget {
  final OpeningModel opening;
  final VoidCallback onPressed;
  final double shadowHeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? shadowColor;
  final Color? backgroundColor;

  const OpeningCard({
    super.key,
    required this.opening,
    required this.onPressed,
    this.backgroundColor,
    this.shadowHeight = 2,
    this.shadowColor,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    this.borderRadius = 16,
  });

  @override
  State<OpeningCard> createState() => _OpeningCardState();
}

class _OpeningCardState extends State<OpeningCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.surface;
    final shadowColor = widget.shadowColor ?? theme.colorScheme.outline;
    // final textColor = widget.textColor ?? theme.colorScheme.onPrimary;

    return GestureDetector(
      onPanDown: (_) {
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
            height:
                screenWidth * 0.4 +
                widget.shadowHeight +
                widget.padding.vertical +
                2,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: shadowColor, width: 2),
            ),
            child: Row(
              spacing: 12,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chessboard.fixed(
                  settings: ChessboardSettings(
                    enableCoordinates: false,
                    borderRadius: BorderRadiusGeometry.circular(8),
                    pieceAssets: PieceSet.meridaAssets,
                    colorScheme: ChessboardColorScheme.blue,
                  ),
                  fen: widget.opening.fen,
                  size: screenWidth * 0.4,
                  orientation: widget.opening.side,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.opening.name,
                      style: theme.textTheme.headlineLarge,
                    ),
                    const Spacer(),
                    CircularPercentIndicator(
                      progressColor: theme.colorScheme.secondary,
                      circularStrokeCap: CircularStrokeCap.round,
                      radius: 40,
                      percent: 0.2,
                      center: Text(
                        '2 / 12',
                        style: theme.textTheme.labelMedium,
                      ),
                      footer: Text(
                        'Lines learned',
                        style: theme.textTheme.labelLarge,
                      ),
                      lineWidth: 10,
                      backgroundColor: theme.colorScheme.outline.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
