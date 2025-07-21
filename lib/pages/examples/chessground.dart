import 'dart:async';
import 'dart:math';
import 'package:chesstrainer/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:chessground/chessground.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:dartchess/dartchess.dart';

String pieceShiftMethodLabel(PieceShiftMethod method) {
  switch (method) {
    case PieceShiftMethod.drag:
      return 'Drag';
    case PieceShiftMethod.tapTwoSquares:
      return 'Tap two squares';
    case PieceShiftMethod.either:
      return 'Either';
  }
}

enum Mode { botPlay, inputMove, freePlay }

const screenPadding = 16.0;
const screenPortraitSplitter = screenPadding / 2;
const screenLandscapeSplitter = screenPadding;
const buttonHeight = 50.0;
const buttonsSplitter = screenPadding;
const smallButtonsSplitter = screenPadding / 2;

class ChessgroundExample extends StatefulWidget {
  const ChessgroundExample({super.key, required this.title});

  final String title;

  @override
  State<ChessgroundExample> createState() => _ChessgroundExampleState();
}

class _ChessgroundExampleState extends State<ChessgroundExample> {
  Position position = Chess.initial;
  Side orientation = Side.white;
  String fen = kInitialBoardFEN;
  NormalMove? lastMove;
  NormalMove? promotionMove;
  NormalMove? premove;
  ValidMoves validMoves = IMap(const {});
  Side sideToMove = Side.white;
  PieceSet pieceSet = PieceSet.gioco;
  PieceShiftMethod pieceShiftMethod = PieceShiftMethod.either;
  DragTargetKind dragTargetKind = DragTargetKind.circle;
  bool drawMode = true;
  bool pieceAnimation = true;
  bool dragMagnify = true;
  Mode playMode = Mode.botPlay;
  Position? lastPos;
  ISet<Shape> shapes = ISet();
  bool showBorder = false;

  @override
  Widget build(BuildContext context) {
    Widget buildNewRoundButton() => FilledButton.icon(
      icon: const Icon(Icons.refresh_rounded),
      label: const Text('New Round'),
      onPressed: () {
        setState(() {
          position = Chess.initial;
          fen = position.fen;
          validMoves = makeLegalMoves(position);
          lastMove = null;
          lastPos = null;
        });
      },
    );

    Widget buildUndoButton() => FilledButton.icon(
      icon: const Icon(Icons.undo_rounded),
      label: const Text('Undo'),
      onPressed: lastPos != null
          ? () => setState(() {
              position = lastPos!;
              fen = position.fen;
              validMoves = makeLegalMoves(position);
              lastPos = null;
            })
          : null,
    );

    Widget buildControlButtons() => SizedBox(
      height: buttonHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: buildNewRoundButton()),
          if (playMode == Mode.freePlay) const SizedBox(width: buttonsSplitter),
          if (playMode == Mode.freePlay) Expanded(child: buildUndoButton()),
        ],
      ),
    );

    Widget buildSettingsButton({
      required String label,
      required String value,
      required VoidCallback onPressed,
    }) => ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );

    final settingsWidgets = ListView(
      children: [
        ExpansionTile(
          title: const Text('Settings'),
          initiallyExpanded: true,
          shape: const RoundedRectangleBorder(),
          minTileHeight: 0,
          children: [
            Wrap(
              spacing: smallButtonsSplitter,
              runSpacing: smallButtonsSplitter,
              alignment: WrapAlignment.spaceBetween,
              children: [
                buildSettingsButton(
                  label: 'Magnify drag',
                  value: dragMagnify ? 'ON' : 'OFF',
                  onPressed: () {
                    setState(() {
                      dragMagnify = !dragMagnify;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Drag target',
                  value: dragTargetKind.name,
                  onPressed: () => _showChoicesPicker<DragTargetKind>(
                    context,
                    choices: DragTargetKind.values,
                    selectedItem: dragTargetKind,
                    labelBuilder: (t) => Text(t.name),
                    onSelectedItemChanged: (DragTargetKind value) {
                      setState(() {
                        dragTargetKind = value;
                      });
                    },
                  ),
                ),
                buildSettingsButton(
                  label: 'Orientation',
                  value: orientation.name,
                  onPressed: () {
                    setState(() {
                      orientation = orientation.opposite;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Show border',
                  value: showBorder ? 'ON' : 'OFF',
                  onPressed: () {
                    setState(() {
                      showBorder = !showBorder;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Piece set',
                  value: pieceSet.label,
                  onPressed: () => _showChoicesPicker<PieceSet>(
                    context,
                    choices: PieceSet.values,
                    selectedItem: pieceSet,
                    labelBuilder: (t) => Text(t.label),
                    onSelectedItemChanged: (PieceSet? value) {
                      setState(() {
                        if (value != null) {
                          pieceSet = value;
                        }
                      });
                    },
                  ),
                ),
                buildSettingsButton(
                  label: 'Piece animation',
                  value: pieceAnimation ? 'ON' : 'OFF',
                  onPressed: () {
                    setState(() {
                      pieceAnimation = !pieceAnimation;
                    });
                  },
                ),
                buildSettingsButton(
                  label: 'Piece Shift',
                  value: pieceShiftMethodLabel(pieceShiftMethod),
                  onPressed: () => _showChoicesPicker<PieceShiftMethod>(
                    context,
                    choices: PieceShiftMethod.values,
                    selectedItem: pieceShiftMethod,
                    labelBuilder: (t) => Text(pieceShiftMethodLabel(t)),
                    onSelectedItemChanged: (PieceShiftMethod? value) {
                      setState(() {
                        if (value != null) {
                          pieceShiftMethod = value;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    final inputMoveWidgets = TextField(
      decoration: const InputDecoration(
        labelText: 'Enter move in UCI format',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (String value) {
        final move = NormalMove.fromUci(value);
        _playMove(move);
        _tryPlayPremove();
      },
    );

    Widget buildChessBoardWidget() => Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Chessboard(
            size: min(constraints.maxWidth, constraints.maxHeight),
            settings: ChessboardSettings(
              pieceAssets: pieceSet.assets,
              enableCoordinates: true,

              animationDuration: pieceAnimation
                  ? const Duration(milliseconds: 200)
                  : Duration.zero,
              dragFeedbackScale: dragMagnify ? 2.0 : 1.0,
              // dragTargetKind: dragTargetKind,
              drawShape: DrawShapeOptions(
                enable: drawMode,
                onCompleteShape: _onCompleteShape,
                onClearShapes: () {
                  setState(() {
                    shapes = ISet();
                  });
                },
              ),
              pieceShiftMethod: pieceShiftMethod,
              autoQueenPromotionOnPremove: false,
              pieceOrientationBehavior: playMode == Mode.freePlay
                  ? PieceOrientationBehavior.facingUser
                  : PieceOrientationBehavior.facingUser,
            ),
            orientation: orientation,
            fen: fen,
            lastMove: lastMove,
            game: GameData(
              playerSide:
                  (playMode == Mode.botPlay || playMode == Mode.inputMove)
                  ? PlayerSide.white
                  : (position.turn == Side.white
                        ? PlayerSide.white
                        : PlayerSide.black),
              validMoves: validMoves,
              sideToMove: position.turn == Side.white ? Side.white : Side.black,
              isCheck: position.isCheck,
              promotionMove: promotionMove,
              onMove: playMode == Mode.botPlay
                  ? _onUserMoveAgainstBot
                  : _playMove,
              onPromotionSelection: _onPromotionSelection,
              premovable: (onSetPremove: _onSetPremove, premove: premove),
            ),
            shapes: shapes.isNotEmpty ? shapes : null,
          );
        },
      ),
    );

    Widget buildPortrait() => Padding(
      padding: const EdgeInsets.only(bottom: screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildChessBoardWidget(),
          if (playMode == Mode.inputMove)
            const SizedBox(height: screenPortraitSplitter),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenPadding),
              child: playMode == Mode.inputMove
                  ? inputMoveWidgets
                  : settingsWidgets,
            ),
          ),
          if (playMode != Mode.inputMove)
            const SizedBox(height: screenPortraitSplitter),
          if (playMode != Mode.inputMove)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: screenPadding),
              child: buildControlButtons(),
            ),
        ],
      ),
    );

    Widget buildLandscape() => Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Row(
        children: [
          Expanded(child: buildChessBoardWidget()),
          const SizedBox(width: screenLandscapeSplitter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: playMode == Mode.inputMove
                      ? inputMoveWidgets
                      : settingsWidgets,
                ),
                if (playMode != Mode.inputMove)
                  const SizedBox(height: screenPortraitSplitter),
                if (playMode != Mode.inputMove) buildControlButtons(),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      primary: MediaQuery.of(context).orientation == Orientation.portrait,
      appBar: AppBar(
        title: switch (playMode) {
          Mode.botPlay => const Text('Random Bot'),
          Mode.inputMove => const Text('Enter opponent move'),
          Mode.freePlay => const Text('Free Play'),
        },
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Random Bot'),
              onTap: () {
                setState(() {
                  playMode = Mode.botPlay;
                });
                if (position.turn == Side.black) {
                  _playBlackMove();
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Enter opponent move'),
              onTap: () {
                setState(() {
                  playMode = Mode.inputMove;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Free Play'),
              onTap: () {
                setState(() {
                  playMode = Mode.freePlay;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? buildPortrait()
            : buildLandscape(),
      ),
    );
  }

  void _tryPlayPremove() {
    if (premove != null) {
      Timer.run(() {
        _playMove(premove!, isPremove: true);
      });
    }
  }

  void _onCompleteShape(Shape shape) {
    if (shapes.any((element) => element == shape)) {
      setState(() {
        shapes = shapes.remove(shape);
      });
      return;
    } else {
      setState(() {
        shapes = shapes.add(shape);
      });
    }
  }

  void _showChoicesPicker<T extends Enum>(
    BuildContext context, {
    required List<T> choices,
    required T selectedItem,
    required Widget Function(T choice) labelBuilder,
    required void Function(T choice) onSelectedItemChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 12),
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: choices
                .map((value) {
                  return RadioListTile<T>(
                    title: labelBuilder(value),
                    value: value,
                    groupValue: selectedItem,
                    onChanged: (value) {
                      if (value != null) onSelectedItemChanged(value);
                      Navigator.of(context).pop();
                    },
                  );
                })
                .toList(growable: false),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    validMoves = makeLegalMoves(position);
    super.initState();
  }

  void _onSetPremove(NormalMove? move) {
    setState(() {
      premove = move;
    });
  }

  void _onPromotionSelection(Role? role) {
    if (role == null) {
      _onPromotionCancel();
    } else if (promotionMove != null) {
      if (playMode == Mode.botPlay) {
        _onUserMoveAgainstBot(promotionMove!.withPromotion(role));
      } else {
        _playMove(promotionMove!.withPromotion(role));
      }
    }
  }

  void _onPromotionCancel() {
    setState(() {
      promotionMove = null;
    });
  }

  void _playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    lastPos = position;
    if (isPromotionPawnMove(move)) {
      setState(() {
        promotionMove = move;
      });
    } else if (position.isLegal(move)) {
      setState(() {
        position = position.playUnchecked(move);
        lastMove = move;
        fen = position.fen;
        validMoves = makeLegalMoves(position);
        promotionMove = null;
        if (isPremove == true) {
          premove = null;
        }
      });
    }
  }

  void _onUserMoveAgainstBot(NormalMove move, {isDrop}) async {
    lastPos = position;
    if (isPromotionPawnMove(move)) {
      setState(() {
        promotionMove = move;
      });
    } else {
      setState(() {
        position = position.playUnchecked(move);
        lastMove = move;
        fen = position.fen;
        validMoves = IMap(const {});
        promotionMove = null;
      });
      await _playBlackMove();
      _tryPlayPremove();
    }
  }

  Future<void> _playBlackMove() async {
    unawaited(
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        setState(() {});
      }),
    );
    if (position.isGameOver) return;

    final random = Random();
    await Future.delayed(Duration(milliseconds: random.nextInt(1000) + 500));
    final allMoves = [
      for (final entry in position.legalMoves.entries)
        for (final dest in entry.value.squares)
          NormalMove(from: entry.key, to: dest),
    ];
    if (allMoves.isNotEmpty) {
      NormalMove mv = (allMoves..shuffle()).first;
      // Auto promote to a random non-pawn role
      if (isPromotionPawnMove(mv)) {
        final potentialRoles = Role.values
            .where((role) => role != Role.pawn)
            .toList();
        final role = potentialRoles[random.nextInt(potentialRoles.length)];
        mv = mv.withPromotion(role);
      }

      setState(() {
        position = position.playUnchecked(mv);
        lastMove = NormalMove(
          from: mv.from,
          to: mv.to,
          promotion: mv.promotion,
        );
        fen = position.fen;
        validMoves = makeLegalMoves(position);
      });
      lastPos = position;
    }
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && position.turn == Side.black) ||
            (move.to.rank == Rank.eighth && position.turn == Side.white));
  }
}
