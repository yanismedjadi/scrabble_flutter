import 'package:flutter/material.dart';
import '../../models/lettre.dart';

class PlateauWidget extends StatelessWidget {
  final List<List<Lettre?>> board;
  final List<Offset> lettresPoseesCeTour;
  final void Function(Lettre lettre, int row, int col) onLettrePlacee;
  final void Function(Lettre lettre, int row, int col) onLettreRetiree;
  final double tileSize;

  const PlateauWidget({
    super.key,
    required this.board,
    required this.lettresPoseesCeTour,
    required this.onLettrePlacee,
    required this.onLettreRetiree,
    required this.tileSize,
  });

  final List<List<String?>> bonusBoard = const [
    ["TW", null, null, "DL", null, null, null, "TW", null, null, null, "DL", null, null, "TW"],
    [null, "DW", null, null, null, "TL", null, null, null, "TL", null, null, null, "DW", null],
    [null, null, "DW", null, null, null, "DL", null, "DL", null, null, null, "DW", null, null],
    ["DL", null, null, "DW", null, null, null, "DL", null, null, null, "DW", null, null, "DL"],
    [null, null, null, null, "DW", null, null, null, null, null, "DW", null, null, null, null],
    [null, "TL", null, null, null, "TL", null, null, null, "TL", null, null, null, "TL", null],
    [null, null, "DL", null, null, null, "DL", null, "DL", null, null, null, "DL", null, null],
    ["TW", null, null, "DL", null, null, null, "★", null, null, null, "DL", null, null, "TW"],
    [null, null, "DL", null, null, null, "DL", null, "DL", null, null, null, "DL", null, null],
    [null, "TL", null, null, null, "TL", null, null, null, "TL", null, null, null, "TL", null],
    [null, null, null, null, "DW", null, null, null, null, null, "DW", null, null, null, null],
    ["DL", null, null, "DW", null, null, null, "DL", null, null, null, "DW", null, null, "DL"],
    [null, null, "DW", null, null, null, "DL", null, "DL", null, null, null, "DW", null, null],
    [null, "DW", null, null, null, "TL", null, null, null, "TL", null, null, null, "DW", null],
    ["TW", null, null, "DL", null, null, null, "TW", null, null, null, "DL", null, null, "TW"],
  ];
  Color getTileColor(int row, int col) {
    final bonus = bonusBoard[row][col];
    switch (bonus) {
      case "DL":
        return Colors.lightBlue.shade100;
      case "TL":
        return Colors.blue.shade300;
      case "DW":
        return Colors.pink.shade100;
      case "TW":
        return Colors.red.shade300;
      case"★" :
        return const Color.fromARGB(255, 255, 255, 7);
      default:
        return const Color(0xFF6B8E23) ;///fromARGB(255, 170, 245, 174);

    }
  }


  static const int boardSize = 15;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: boardSize,
        childAspectRatio: 1.0,
        mainAxisSpacing: 0.5,
        crossAxisSpacing: 0.5,
      ),
      itemCount: boardSize * boardSize,
      itemBuilder: (context, index) {
        final row = index ~/ boardSize;
        final col = index % boardSize;
        final lettre = board[row][col];
        final isNewLetter = lettresPoseesCeTour.any((offset) =>
        offset.dx.toInt() == row && offset.dy.toInt() == col);

        // Case vide
        if (lettre == null) {
          return DragTarget<Lettre>(
            onAccept: (newLettre) => onLettrePlacee(newLettre, row, col),
            builder: (context, _, __) => _buildCaseVide(row, col),
          );
        }

        // Case avec lettre
        return isNewLetter
            ? Draggable<Lettre>(
          data: lettre,
          feedback:Transform.scale(
            scale: 0.5,
            child:_lettreTile(lettre, const Color.fromARGB(255, 223, 130, 54), isDraggable: true),
          ),
          childWhenDragging: Container(),
          onDragCompleted: () => onLettreRetiree(lettre, row, col),
          child: _lettreTile(lettre, const Color(0xFF8B5A2B), isDraggable: true),
        )
            : _lettreTile(lettre, const Color(0xFF8B5A2B));
      },
    );
  }

  Widget _buildCaseVide(int row, int col) {
    return Container(
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        color: getTileColor(row, col),
        border: Border.all(color: Colors.brown),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          bonusBoard[row][col] ?? '',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _lettreTile(Lettre lettre, Color couleur, {bool isDraggable = false}) {
    return Container(
      width: tileSize,
      height: tileSize,
      ///margin: const EdgeInsets.zero,///symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: couleur,
        borderRadius: BorderRadius.circular(4),
        border: isDraggable
            ? Border.all(width: 2, color: const Color.fromARGB(255, 238, 22, 22))
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              lettre.lettre,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (lettre.valeur > 0)
            Positioned(
              right: 3,
              bottom: 1,
              child: Text(
                lettre.valeur.toString(),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
        ],
      ),
    );
  }
}