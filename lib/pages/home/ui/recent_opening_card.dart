import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RecentOpeningCard extends StatefulWidget {
  final OpeningModel opening;
  final VoidCallback onPressed;

  const RecentOpeningCard({
    super.key,
    required this.opening,
    required this.onPressed,
  });

  @override
  State<RecentOpeningCard> createState() => _RecentOpeningCardState();
}

class _RecentOpeningCardState extends State<RecentOpeningCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Gaimon.selection();
        widget.onPressed.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: _isPressed ? theme.colorScheme.surfaceDim : Colors.transparent,
        ),
        child: SizedBox(
          height: screenWidth * 0.4,
          child: Row(
            spacing: 12,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Chessboard.fixed(
                  settings: ChessboardSettings(
                    border: BoardBorder(
                      color: theme.colorScheme.surfaceBright,
                      width: 8,
                    ),
                    enableCoordinates: false,
                    pieceAssets: PieceSet.meridaAssets,
                    colorScheme: ChessboardColorScheme.blue,
                  ),
                  fen: widget.opening.fen,
                  size: screenWidth * 0.4,
                  orientation: widget.opening.side,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.opening.name,
                          style: theme.textTheme.headlineMedium,
                        ),
                        Text(
                          'Continue were you left off!',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final currentUser = ref.watch(currentUserProvider);
                        final userLearnedOpenings =
                            currentUser?.learnedOpenings ?? [];

                        final progress = widget.opening.progressFor(
                          userLearnedOpenings,
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Line ${progress.learned} / ${progress.total}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            LinearPercentIndicator(
                              padding: const EdgeInsets.all(0),
                              barRadius: const Radius.circular(32),
                              lineHeight: 20,
                              animation: true,
                              animationDuration: 250,
                              animateFromLastPercent: true,
                              progressColor: theme.colorScheme.primary,
                              percent: progress.percentage,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:chessground/chessground.dart';
// import 'package:chesstrainer/modules/opening/models/opening.dart';
// import 'package:chesstrainer/modules/user/providers/user_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:gaimon/gaimon.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:material_symbols_icons/symbols.dart';
// import 'package:percent_indicator/percent_indicator.dart';

// class RecentOpeningCard extends StatefulWidget {
//   final OpeningModel opening;
//   final VoidCallback onPressed;
//   final double shadowHeight;
//   final EdgeInsetsGeometry padding;
//   final double borderRadius;
//   final Color? shadowColor;
//   final Color? backgroundColor;

//   const RecentOpeningCard({
//     super.key,
//     required this.opening,
//     required this.onPressed,
//     this.backgroundColor,
//     this.shadowHeight = 4,
//     this.shadowColor,
//     this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//     this.borderRadius = 16,
//   });

//   @override
//   State<RecentOpeningCard> createState() => _RecentOpeningCardState();
// }

// class _RecentOpeningCardState extends State<RecentOpeningCard> {
//   bool _isPressed = false;

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     final theme = Theme.of(context);
//     final backgroundColor = widget.backgroundColor ?? theme.colorScheme.primary;
//     final shadowColor =
//         widget.shadowColor ?? backgroundColor.withValues(alpha: 0.6);
//     // final textColor = widget.textColor ?? theme.colorScheme.onPrimary;

//     return GestureDetector(
//       onPanDown: (_) {
//         Gaimon.selection();
//         setState(() => _isPressed = true);
//       },
//       onTapUp: (_) {
//         setState(() => _isPressed = false);
//         widget.onPressed.call();
//       },
//       onTapCancel: () => setState(() => _isPressed = false),
//       child: Container(
//         transform: Matrix4.translationValues(
//           0,
//           _isPressed ? widget.shadowHeight : 0,
//           0,
//         ),
//         child: Container(
//           margin: EdgeInsets.only(bottom: widget.shadowHeight),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(widget.borderRadius),
//             boxShadow: _isPressed
//                 ? null
//                 : [
//                     BoxShadow(
//                       color: shadowColor,
//                       offset: Offset(0, widget.shadowHeight),
//                       blurRadius: 0,
//                       spreadRadius: 0,
//                     ),
//                   ],
//           ),
//           child: Container(
//             padding: widget.padding,
//             height:
//                 screenWidth * 0.4 +
//                 widget.shadowHeight +
//                 widget.padding.vertical +
//                 2,
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.circular(widget.borderRadius),
//               border: Border.all(color: shadowColor, width: 2),
//             ),
//             child: Row(
//               spacing: 12,
//               // crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Chessboard.fixed(
//                   settings: ChessboardSettings(
//                     enableCoordinates: false,
//                     borderRadius: BorderRadiusGeometry.circular(8),
//                     pieceAssets: PieceSet.meridaAssets,
//                     colorScheme: ChessboardColorScheme.blue,
//                   ),
//                   fen: widget.opening.fen,
//                   size: screenWidth * 0.4,
//                   orientation: widget.opening.side,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       widget.opening.name,
//                       style: theme.textTheme.headlineLarge,
//                     ),
//                     const Spacer(),
//                     Consumer(
//                       builder: (context, ref, child) {
//                         final currentUser = ref.watch(currentUserProvider);
//                         final userLearnedOpenings =
//                             currentUser?.learnedOpenings ?? [];

//                         final progress = widget.opening.progressFor(
//                           userLearnedOpenings,
//                         );

//                         return CircularPercentIndicator(
//                           progressColor: theme.colorScheme.secondary,
//                           circularStrokeCap: CircularStrokeCap.round,
//                           radius: 40,
//                           percent: progress.percentage,
//                           center: Text(
//                             '${progress.learned} / ${progress.total}',
//                             style: theme.textTheme.labelMedium,
//                           ),
//                           footer: Text(
//                             'Lines learned',
//                             style: theme.textTheme.labelLarge,
//                           ),
//                           lineWidth: 10,
//                           backgroundColor: theme.colorScheme.outline.withValues(
//                             alpha: 0.6,
//                           ),
//                         );
//                       },
//                     ),
//                     const Row(
//                       children: [
//                         Text('learn next line'),
//                         Icon(Symbols.line_end_arrow_notch_rounded),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
