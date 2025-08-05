import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:dartchess/dartchess.dart';

const openings = <OpeningModel>[viennaGambit, frenchDefense];

// * Vienna Gambit Opening

const viennaGambitLines = <Line>[
  Line(
    id: 'vienna_gambit_1',
    name: 'TBD',
    description: 'TBD',
    path: 'assets/openings/vienna_gambit/vienna_gambit_1.pgn',
  ),
  Line(
    id: 'vienna_gambit_2',
    name: 'TBD',
    description: 'TBD',
    path: 'assets/openings/vienna_gambit/vienna_gambit_2.pgn',
  ),
  Line(
    id: 'vienna_gambit_3',
    name: 'TBD',
    description: 'TBD',
    path: 'assets/openings/vienna_gambit/vienna_gambit_3.pgn',
  ),
  Line(
    id: 'vienna_gambit_4',
    name: 'TBD',
    description: 'TBD',
    path: 'assets/openings/vienna_gambit/vienna_gambit_4.pgn',
  ),
  Line(
    id: 'vienna_gambit_5',
    name: 'TBD',
    description: 'TBD',
    path: 'assets/openings/vienna_gambit/vienna_gambit_5.pgn',
  ),
];

const viennaGambit = OpeningModel(
  id: 'vienna_gambit',
  name: 'Vienna Gambit',
  description:
      'Sacrifice your f-pawn for explosive attacking chances! '
      'White gets rapid piece development and dangerous threats against '
      'the enemy king. Perfect for players who love tactical fireworks '
      'over quiet positional play.',
  tags: ['e4', 'Aggressive', 'Intermediate'],
  linePaths: viennaGambitLines,
  side: Side.white,
  ecoCode: 'C29',
  fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4PP2/2N5/PPPP2PP/R1BQKBNR b KQkq - 0 3',
);

// * French Defense Opening

const frenchDefenseLines = <Line>[
  Line(
    id: 'french_defense_1',
    name: 'TBD',
    description: 'TBD',
    path: 'assets/openings/french_defense/french_defense_1.pgn',
  ),
  Line(
    id: 'french_defense_2',
    name: 'TBD',
    description: 'TBD',
    path: 'assets/openings/french_defense/french_defense_2.pgn',
  ),
];

const frenchDefense = OpeningModel(
  id: 'french_defense',
  name: 'French Defense',
  description:
      'Build a rock-solid pawn chain and launch devastating counterattacks '
      'from a secure position. The French gives you excellent piece '
      'coordination and long-term winning chances, even when facing '
      "early pressure from White's space advantage.",
  tags: ['e4', 'Solid', 'Beginner'],
  linePaths: frenchDefenseLines,
  side: Side.black,
  ecoCode: 'C00',
  fen: 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
);
