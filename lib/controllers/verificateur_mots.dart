import 'package:flutter/services.dart' show rootBundle;
import '../models/lettre.dart';
import 'package:flutter/material.dart';


class VerificateurMots {
  late Set<String> dictionnaire;
  bool auMoinsUnMotValide = false; 

  VerificateurMots(String cheminFichier) {
    chargerDictionnaireDepuisAssets(cheminFichier).then((mots) {
      dictionnaire = mots;
    });
  }

  // Charger le dictionnaire depuis les assets
  Future<Set<String>> chargerDictionnaireDepuisAssets(String chemin) async {
    try {
      // Lire le fichier dans une chaîne de caractères
      String contenu = await rootBundle.loadString(chemin);

      // Transformer en un Set de mots (supprime les espaces et met en minuscule)
      return contenu.split('\n').map((mot) => mot.trim().toLowerCase()).toSet();
    } catch (e) {
      return {};
    }
  }
  // Vérifie si un mot est valide
  bool estMotValide(String mot) {
    return dictionnaire.contains(mot.toLowerCase()) ;
  }

  // Récupérer un mot horizontalement
  String recupererMotHorizontal(List<List<Lettre?>> board, int x, int y) {
    String mot = "";
    int start = y;

    // Trouver le début du mot
    while (start > 0 && board[x][start - 1] != null) {
      start--;
    }

    // Lire le mot entier
    int pos = start;
    while (pos < board.length && board[x][pos] != null) {
      mot += board[x][pos]!.lettre;
      pos++;
    }
    return mot;
  }

  // Récupérer un mot verticalement
  String recupererMotVertical(List<List<Lettre?>> board, int x, int y) {
    String mot = "";
    int start = x;

    // Trouver le début du mot
    while (start > 0 && board[start - 1][y] != null) {
      start--;
    }

    // Lire le mot entier
    int pos = start;
    while (pos < board.length && board[pos][y] != null) {
      mot += board[pos][y]!.lettre;
      pos++;
    }
    return mot;
  }

  // Vérifier tous les mots formés par les lettres posées ce tour
  bool verifierMots(List<List<Lettre?>> board, List<Offset> lettresPosees) {
    Set<String> motsFormes = {};

    for (Offset pos in lettresPosees) {
      int x = pos.dx.toInt();
      int y = pos.dy.toInt();

      // Vérifie le mot horizontal
      String motH = recupererMotHorizontal(board, x, y);
      if (motH.length > 1){
       motsFormes.add(motH);
       auMoinsUnMotValide = true;
      }
      // Vérifie le mot vertical
      String motV = recupererMotVertical(board, x, y);
      if (motV.length > 1) {
        motsFormes.add(motV);
        auMoinsUnMotValide = true ;
    }
    }
  
    return auMoinsUnMotValide && motsFormes.every(estMotValide);
  }
}
