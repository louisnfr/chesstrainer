import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AnnotationNotifier
    extends FamilyNotifier<IMap<Square, Annotation>?, PgnGame> {
  @override
  IMap<Square, Annotation>? build(PgnGame pgnGame) {
    return null;
  }

  void setAnnotation(Square square, {required bool correct}) {
    final annotation = Annotation(
      symbol: correct ? '✓' : 'X',
      color: correct ? Colors.green : Colors.red,
    );

    state = IMap({square: annotation});
  }

  void clearAnnotations() {
    state = null;
  }
}

final annotationProvider = NotifierProvider.autoDispose
    .family<AnnotationNotifier, IMap<Square, Annotation>?, PgnGame>(
      AnnotationNotifier.new,
    );
