import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/ui/buttons/app_icon_button.dart';
import 'package:chesstrainer/ui/chips/tag_chip.dart';
import 'package:chesstrainer/ui/gamification/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';

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
    this.shadowHeight = 4,
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
    final theme = Theme.of(context);
    final backgroundColor =
        widget.backgroundColor ?? theme.colorScheme.tertiary;
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
            child: Column(
              // spacing: 12,
              children: [
                Row(
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
                      size: 128,
                      orientation: widget.opening.side,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.opening.name,
                            style: theme.textTheme.headlineLarge,
                          ),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: widget.opening.tags
                                .map((tag) => TagChip(label: tag))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        AppIconButton(
                          icon: Icons.play_arrow_rounded,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('3 / 15 Lines', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                const ProgressBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
