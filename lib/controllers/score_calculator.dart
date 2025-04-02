import '../models/lettre.dart';
import 'dart:ui';

class ScoreCalculator {
  static const int boardSize = 15;
  final List<List<String?>> bonusBoard = List.generate(15, (_) => List.filled(15, null));

  ///Fonction principale de calcul du score
  static int calculScore(List<List<Lettre?>> board ,List<Offset> dejaPosees, List<Offset> poseesCeTour){
    int score = 0;
    List<Offset>? list = (poseesCeTour.isNotEmpty) ? poseesCeTour : null;
    bool isHorizontal =  poseesCeTour.every((p) => p.dx == poseesCeTour[0].dx);
    int indiceLigneACalculer;
    if (isHorizontal) {
      indiceLigneACalculer = poseesCeTour[0].dx.toInt();
    }else {
      indiceLigneACalculer = poseesCeTour[0].dy.toInt();
    }
    score = _scoreLigne(board, isHorizontal, indiceLigneACalculer, dejaPosees, null);
    if (isHorizontal) {
      for (final pos in poseesCeTour) {
        if (dejaPosees.contains(Offset(pos.dx+1, pos.dy))
            || dejaPosees.contains(Offset(pos.dx-1, pos.dy))) {
          score += _scoreLigne(board, !isHorizontal, pos.dy.toInt(), dejaPosees, list);
        }
      }
    }else {
      for (final pos in poseesCeTour) {
        if (dejaPosees.contains(Offset(pos.dx, pos.dy+1))
            || dejaPosees.contains(Offset(pos.dx, pos.dy-1))) {
          score += _scoreLigne(board, !isHorizontal, pos.dx.toInt(), dejaPosees, list);
        }
      }
    }
    return score;
  }

  static bool _compar(bool isHorizontal,int indice,Offset p){
    if(isHorizontal) {
      return p.dx == indice;
    }else {
      return p.dy == indice;
    }
  }

  ///OUTILS
  static int _scoreLigne(List<List<Lettre?>> board, bool isHorizontal, int indice
      , List<Offset> dejaPosees,List<Offset>? possesCeTour) {
    int total = 0;
    int multiplicateurMot = 1;
    for (final p in dejaPosees) {
      if (_compar(isHorizontal, indice, p)) {
        Lettre? lettre = board[p.dx.toInt()][p.dy.toInt()]!;
        bool isBonusActive = possesCeTour== null || ( possesCeTour != null && possesCeTour.contains(p));
        if (isBonusActive) {
          print('is active for ${p}');
          String? bonus = _getBonusAtPosition(p);
          switch (bonus) {
            case "DL":
              total += lettre.valeur * 2;
              break;
            case "TL":
              total += lettre.valeur * 3;
              break;
            case "DW":
              total += lettre.valeur;
              multiplicateurMot *= 2;
              break;
            case "TW":
              total += lettre.valeur;
              multiplicateurMot *= 3;
              break;
            default:
              total += lettre.valeur;
          }
        }else{
          total += lettre.valeur;
        }

      }
    }
    int pointsGagnees = total * multiplicateurMot;
    multiplicateurMot = 1;
    return pointsGagnees;
  }

  static String? _getBonusAtPosition(Offset position) {
    final Map<String, String> bonusMap = {
      '1,1': 'DW',
      '2,2': 'DW',
      '3,3': 'DW',
      '4,4': 'DW',
      '5,5': 'DW',
      '2,13': 'DW',
      '3,12': 'DW',
      '4,11': 'DW',
      '5,10': 'DW',
      '7,7': 'DW',
      '10,4': 'DW',
      '11,3': 'DW',
      '12,2': 'DW',
      '13,1': 'DW',
      '10,10': 'DW',
      '11,11': 'DW',
      '12,12': 'DW',
      '13,13': 'DW',


      '0,0': 'TW',
      '0,7': 'TW',
      '0,14': 'TW',
      '7,0': 'TW',
      '7,14': 'TW',
      '14,0': 'TW',
      '14,7': 'TW',
      '14,14': 'TW',

      '0,3': 'DL',
      '0,11': 'DL',
      '2,6': 'DL',
      '2,8': 'DL',
      '3,0': 'DL',
      '3,7': 'DL',
      '3,14': 'DL',
      '11,0': 'DL',
      '6,2': 'DL',
      '6,6': 'DL',
      '6,8': 'DL',
      '6,12': 'DL',
      '7,3': 'DL',
      '7,11': 'DL',
      '8,2': 'DL',
      '8,6': 'DL',
      '8,8': 'DL',
      '8,12': 'DL',
      '11,0': 'DL',
      '11,7': 'DL',
      '11,14': 'DL',
      '12,6': 'DL',
      '12,8': 'DL',
      '14,3': 'DL',
      '14,11': 'DL',

      '1,5': 'TL',
      '1,9': 'TL',
      '5,1': 'TL',
      '5,5': 'TL',
      '5,7': 'TL',
      '5,13': 'TL',
      '9,1': 'TL',
      '9,5': 'TL',
      '9,9': 'TL',
      '9,13': 'TL',
      '13,5': 'TL',
      '13,9': 'TL',
    };

    String key = '${position.dx.toInt()},${position.dy.toInt()}';

    return bonusMap[key];
  }


}