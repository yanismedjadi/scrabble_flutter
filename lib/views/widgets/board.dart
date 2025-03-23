import 'package:flutter/material.dart';
import '../../models/lettre.dart';

class PlateauWidget extends StatelessWidget {
  final List<List<Lettre?>> board;
  final void Function(Lettre lettre, int row, int col) onLettrePlacee;
  final double tileSize;

  const PlateauWidget({
    required this.board,
    required this.onLettrePlacee,
    required this.tileSize,
    super.key,
  });

  static const int boardSize = 15;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: boardSize,
      ),
      itemCount: boardSize * boardSize,
      itemBuilder: (context, index) {
        int row = index ~/ boardSize;
        int col = index % boardSize;

        return DragTarget<Lettre>(
          onAccept: (lettre) => onLettrePlacee(lettre, row, col),
          builder: (context, candidateData, rejectedData) => Container(
            width: tileSize,
            height: tileSize,
            decoration: BoxDecoration(
              color: board[row][col] != null ? Colors.orange[300] : Colors.white,
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Text(
                board[row][col]?.lettre ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
