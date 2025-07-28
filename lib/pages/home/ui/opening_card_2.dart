import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';

class OpeningCard2 extends StatefulWidget {
  final OpeningModel opening;
  final VoidCallback onPressed;
  final double shadowHeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? shadowColor;
  final Color? backgroundColor;

  const OpeningCard2({
    super.key,
    required this.opening,
    required this.onPressed,
    this.backgroundColor,
    this.shadowHeight = 4,
    this.shadowColor,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    this.borderRadius = 16,
  });

  @override
  State<OpeningCard2> createState() => _OpeningCard2State();
}

class _OpeningCard2State extends State<OpeningCard2> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.surface;
    final shadowColor = widget.shadowColor ?? theme.colorScheme.outline;
    // final textColor = widget.textColor ?? theme.colorScheme.onPrimary;

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
            // height: screenWidth * 0.4 + widget.shadowHeight,
            width: screenWidth * 0.4 + widget.shadowHeight,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: shadowColor, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.borderRadius - 2),
                topRight: Radius.circular(widget.borderRadius - 2),
                bottomLeft: Radius.circular(widget.borderRadius - 2),
              ),
              child: Column(
                children: [
                  Chessboard.fixed(
                    settings: const ChessboardSettings(
                      enableCoordinates: false,
                      pieceAssets: PieceSet.meridaAssets,
                      colorScheme: ChessboardColorScheme.blue,
                    ),
                    fen: widget.opening.fen,
                    size: screenWidth * 0.4,
                    orientation: widget.opening.side,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      widget.opening.name,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
