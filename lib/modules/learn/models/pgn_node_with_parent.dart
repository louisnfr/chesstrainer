// Extension pour ajouter la navigation parent-child aux nodes PGN

import 'package:dartchess/dartchess.dart';

/// Extension du PgnNode pour supporter la navigation vers le parent
class PgnNodeWithParent<T extends PgnNodeData> {
  PgnNodeWithParent<T>? parent;
  final List<PgnChildNodeWithParent<T>> children = [];

  PgnNodeWithParent([this.parent]);

  /// Implémente mainline() comme dans PgnNode original
  Iterable<T> mainline() sync* {
    var node = this;
    while (node.children.isNotEmpty) {
      final child = node.children[0];
      yield child.data;
      node = child;
    }
  }

  /// Trouve le nœud racine en remontant vers les parents
  PgnNodeWithParent<T> getRoot() {
    var current = this;
    while (current.parent != null) {
      current = current.parent!;
    }
    return current;
  }

  /// Retourne le chemin depuis la racine jusqu'à ce nœud
  List<PgnNodeWithParent<T>> getPathFromRoot() {
    final path = <PgnNodeWithParent<T>>[];
    var current = this;

    // Collecte le chemin en remontant
    while (current.parent != null) {
      path.insert(0, current);
      current = current.parent!;
    }
    path.insert(0, current); // Ajoute la racine

    return path;
  }

  /// Retourne la profondeur du nœud dans l'arbre
  int getDepth() {
    int depth = 0;
    var current = this;
    while (current.parent != null) {
      depth++;
      current = current.parent!;
    }
    return depth;
  }

  /// Transform method adapté pour PgnNodeWithParent
  PgnNodeWithParent<U> transform<U extends PgnNodeData, C>(
    C context,
    (C, U)? Function(C context, T data, int childIndex) f,
  ) {
    final root = PgnNodeWithParent<U>();
    final stack = [(before: this, after: root, context: context)];

    while (stack.isNotEmpty) {
      final frame = stack.removeLast();
      for (
        int childIdx = 0;
        childIdx < frame.before.children.length;
        childIdx++
      ) {
        C ctx = frame.context;
        final childBefore = frame.before.children[childIdx];
        final transformData = f(ctx, childBefore.data, childIdx);
        if (transformData != null) {
          final (newCtx, data) = transformData;
          ctx = newCtx;
          final childAfter = PgnChildNodeWithParent(data, frame.after);
          frame.after.children.add(childAfter);
          stack.add((before: childBefore, after: childAfter, context: ctx));
        }
      }
    }
    return root;
  }
}

/// Extension du PgnChildNode pour supporter la navigation vers le parent
class PgnChildNodeWithParent<T extends PgnNodeData>
    extends PgnNodeWithParent<T> {
  T data;

  PgnChildNodeWithParent(this.data, [PgnNodeWithParent<T>? parent])
    : super(parent);
}

/// Utilitaire pour convertir un PgnNode existant en PgnNodeWithParent
class PgnNodeConverter {
  /// Convertit un PgnNode en PgnNodeWithParent en ajoutant les références parent
  static PgnNodeWithParent<T> addParentReferences<T extends PgnNodeData>(
    PgnNode<T> originalNode, [
    PgnNodeWithParent<T>? parent,
  ]) {
    final newNode = PgnNodeWithParent<T>(parent);

    // Parcours récursif des enfants
    for (final child in originalNode.children) {
      final newChild = PgnChildNodeWithParent<T>(child.data, newNode);
      newNode.children.add(newChild);

      // Récursion pour les sous-arbres
      _addParentReferencesRecursive(child, newChild);
    }

    return newNode;
  }

  static void _addParentReferencesRecursive<T extends PgnNodeData>(
    PgnNode<T> originalNode,
    PgnNodeWithParent<T> newParent,
  ) {
    for (final child in originalNode.children) {
      final newChild = PgnChildNodeWithParent<T>(child.data, newParent);
      newParent.children.add(newChild);

      // Récursion pour les sous-arbres
      _addParentReferencesRecursive(child, newChild);
    }
  }
}
