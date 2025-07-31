import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardSize = screenWidth * 0.35;

    final backgroundColor =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainer;
    final shadowColor =
        widget.shadowColor ?? backgroundColor.withValues(alpha: 0.6);
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
            height: cardSize + widget.shadowHeight,
            // width: screenWidth * 0.4 + widget.shadowHeight,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Chessboard.fixed(
                    settings: const ChessboardSettings(
                      enableCoordinates: false,
                      pieceAssets: PieceSet.meridaAssets,
                      colorScheme: ChessboardColorScheme.blue,
                    ),
                    fen: widget.opening.fen,
                    size: cardSize,
                    orientation: widget.opening.side,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.opening.name,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: widget.opening.side == Side.black
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          Wrap(
                            // spacing: 8,
                            // runSpacing: 4,
                            children: widget.opening.tags
                                .map(
                                  (tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor: theme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                    labelStyle: theme.textTheme.labelMedium,
                                  ),
                                )
                                .toList(),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: LinearPercentIndicator(
                                  // backgroundColor: Colors.grey.shade300,
                                  barRadius: const Radius.circular(8),
                                  lineHeight: 8,
                                  animation: true,
                                  animationDuration: 250,
                                  animateFromLastPercent: true,
                                  progressColor: theme.colorScheme.primary,
                                  percent: 25 / 100,
                                ),
                              ),
                              const Icon(Symbols.line_end_arrow_notch_rounded),
                            ],
                          ),
                        ],
                      ),
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
