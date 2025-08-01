import 'package:flutter/foundation.dart' show immutable;

@immutable
class OpeningProgress {
  final int learned;
  final int total;
  final double percentage;

  const OpeningProgress({
    required this.learned,
    required this.total,
    required this.percentage,
  });

  factory OpeningProgress.fromCounts(int learned, int total) {
    return OpeningProgress(
      learned: learned,
      total: total,
      percentage: total > 0 ? learned / total : 0.0,
    );
  }

  bool get isCompleted => learned == total;
  bool get isStarted => learned > 0;

  @override
  String toString() {
    return 'OpeningProgress('
        'learned: $learned, '
        'total: $total, '
        'percentage: ${(percentage * 100).toStringAsFixed(1)}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OpeningProgress &&
        other.learned == learned &&
        other.total == total &&
        other.percentage == percentage;
  }

  @override
  int get hashCode => Object.hash(learned, total, percentage);
}
