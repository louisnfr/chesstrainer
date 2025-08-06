import 'package:chesstrainer/ui/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearProgressBar extends StatefulWidget {
  const LinearProgressBar({
    super.key,
    required this.percent,
    this.lineHeight = 16,
    this.animation = true,
    this.animationDuration = 250,
    this.animateFromLastPercent = true,
  });

  final double percent;
  final double lineHeight;
  final bool animation;
  final int animationDuration;
  final bool animateFromLastPercent;

  @override
  State<LinearProgressBar> createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _previousPercent = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration),
      vsync: this,
    );

    _animation =
        Tween<double>(
          begin: widget.animateFromLastPercent ? _previousPercent : 0,
          end: widget.percent,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.linear),
        );

    if (widget.animation) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(LinearProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.percent != widget.percent) {
      _previousPercent = oldWidget.percent;

      _animation =
          Tween<double>(
            begin: widget.animateFromLastPercent ? _previousPercent : 0,
            end: widget.percent,
          ).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.linear),
          );

      if (widget.animation) {
        _animationController.reset();
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        final highlightPadding = 12.0;

        return SizedBox(
          child: Stack(
            children: [
              // Barre principale
              LinearPercentIndicator(
                padding: const EdgeInsets.all(0),
                barRadius: Radius.circular(widget.lineHeight / 2),
                lineHeight: widget.lineHeight,
                animation: widget.animation,
                animationDuration: widget.animationDuration,
                animateFromLastPercent: widget.animateFromLastPercent,
                progressColor: AppColors.success,
                percent: widget.percent,
              ),
              // Effet de surlignement - animé avec la même durée
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final currentPercent = widget.animation
                      ? _animation.value
                      : widget.percent;
                  final progressWidth = barWidth * currentPercent;

                  if (currentPercent <= 0) return const SizedBox.shrink();

                  return Positioned(
                    left: highlightPadding,
                    top: widget.lineHeight / 4,
                    child: Container(
                      width: (progressWidth - highlightPadding * 2).clamp(
                        0.0,
                        double.infinity,
                      ),
                      height: widget.lineHeight / 3,
                      decoration: BoxDecoration(
                        color: AppColors.successTint,
                        borderRadius: BorderRadius.circular(
                          widget.lineHeight / 4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
