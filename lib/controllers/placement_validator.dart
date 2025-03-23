// 📄 lib/controllers/placement_validator.dart

import '../models/lettre.dart';
import 'dart:ui';

class PlacementValidator {
  static const int boardSize = 15;

  /// Vérifie si les lettres posées ce tour sont alignées
  static bool estAligne(List<Offset> positions) {
    if (positions.length <= 1) return true;
    final toutesSurLigne = positions.every((p) => p.dx == positions[0].dx);
    final toutesSurColonne = positions.every((p) => p.dy == positions[0].dy);
    return toutesSurLigne || toutesSurColonne;
  }

  /// Vérifie si le premier mot passe par le centre (7,7)
  static bool toucheCentre(List<Offset> positions) {
    return positions.any((p) => p.dx == 7 && p.dy == 7);
  }

  /// Vérifie si le mot est connecté à une lettre déjà existante
  static bool estConnecte(List<List<Lettre?>> board, List<Offset> positions) {
    for (final pos in positions) {
      final voisins = [
        Offset(pos.dx - 1, pos.dy),
        Offset(pos.dx + 1, pos.dy),
        Offset(pos.dx, pos.dy - 1),
        Offset(pos.dx, pos.dy + 1),
      ];
      for (final v in voisins) {
        if (v.dx >= 0 && v.dx < boardSize && v.dy >= 0 && v.dy < boardSize) {
          if (board[v.dx.toInt()][v.dy.toInt()] != null &&
              !positions.contains(v)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Vérifie si c'est le premier tour (plateau vide)
  static bool estPremierTour(List<List<Lettre?>> board) {
    for (var ligne in board) {
      for (var caseLettre in ligne) {
        if (caseLettre != null) return false;
      }
    }
    return true;
  }

  /// Valide le placement actuel selon toutes les règles
  static bool validerPlacement(
      List<List<Lettre?>> board,
      List<Offset> lettresPosees,
      ) {
    if (lettresPosees.isEmpty) return false;

    if (!estAligne(lettresPosees)) {
      return false;
    }

    if (estPremierTour(board)) {
      return toucheCentre(lettresPosees);
    } else {
      return estConnecte(board, lettresPosees);
    }
  }
}
