import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:dartchess/dartchess.dart';

const allOpenings = <OpeningModel>[viennaGambit];

const viennaGambitLines = <Line>[
  Line(
    id: 'vienna_gambit_1',
    name: 'Main Line',
    description: 'The classic Vienna Gambit main continuation',
    path: 'assets/openings/vienna_gambit/vienna_gambit_1.pgn',
  ),
  Line(
    id: 'vienna_gambit_2',
    name: 'Alternative Line',
    description: 'Alternative continuation for Vienna Gambit',
    path: 'assets/openings/vienna_gambit/vienna_gambit_2.pgn',
  ),
  Line(
    id: 'vienna_gambit_3',
    name: 'Declined Variation',
    description: 'When Black declines the gambit',
    path: 'assets/openings/vienna_gambit/vienna_gambit_3.pgn',
  ),
];

const viennaGambit = OpeningModel(
  id: 'vienna-gambit',
  name: 'Vienna Gambit',
  description: 'A classic opening that leads to rich tactical battles.',
  tags: ['e4', 'Aggressive'],
  linePaths: viennaGambitLines,
  side: Side.white,
  ecoCode: 'C29',
  fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4PP2/2N5/PPPP2PP/R1BQKBNR b KQkq - 0 3',
);
