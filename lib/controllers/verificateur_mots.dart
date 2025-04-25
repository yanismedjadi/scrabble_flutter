import 'package:flutter/services.dart' show rootBundle;
import '../models/lettre.dart';
import 'package:flutter/material.dart';


class VerificateurMots {
  late Set<String> dictionnaire;
  bool auMoinsUnMotValide = false; 
  final String langue;

  VerificateurMots(this.langue) {
    chargerDictionnaireDepuisAssets().then((mots) {
      dictionnaire = mots;
    });
  }

  // Charger le dictionnaire depuis les assets
  Future<Set<String>> chargerDictionnaireDepuisAssets() async {
    try {
      // Lire le fichier dans une chaîne de caractères
      String contenu = await rootBundle.loadString(getCheminDictionnaire());

      // Transformer en un Set de mots (supprime les espaces et met en minuscule)
      return contenu.split('\n').map((mot) => mot.trim().toLowerCase()).toSet();
    } catch (e) {
      print(" Erreur de chargement du dictionnaire : $e");
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
    while (start > 0 && board[x][start - 1] != null) {
      start--;
    }
    int pos = start;
    while (pos < board.length && board[x][pos] != null) {
      final lettre = board[x][pos]!;
      mot += lettre.estJoker() ? lettre.remplace! : lettre.lettre;
      pos++;
    }
    return mot;
  }

  // Récupérer un mot verticalement
  String recupererMotVertical(List<List<Lettre?>> board, int x, int y) {
    String mot = "";
    int start = x;
    while (start > 0 && board[start - 1][y] != null) {
      start--;
    }
    int pos = start;
    while (pos < board.length && board[pos][y] != null) {

      final lettre = board[pos][y]!;
      mot += lettre.estJoker() ? lettre.remplace! : lettre.lettre;

      pos++;
    }
    return mot;
  }

  // récupérer tous les mots formés par les lettres posées ce tour
 Set<String>  recupereMots(List<List<Lettre?>> board, List<Offset> lettresPosees)
 {
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
    return motsFormes;
 }
   // Vérifier tous les mots formés par les lettres posées ce tour

  bool verifierMots(List<List<Lettre?>> board, List<Offset> lettresPosees) {
    Set<String> mots = recupereMots( board,lettresPosees);
    // Vérifie si tous les mots sont valides
    return auMoinsUnMotValide && mots.every(estMotValide);
  }
  String getCheminDictionnaire() {
    switch (langue) {
      case 'Kabyle':
        return 'assets/dictionnaire_kabyle.txt';
      case 'Anglais':
        return 'assets/dictionnaire_en.txt';
      case 'Français':
      default:
        return 'assets/dictionnaire.txt';
    }
  }
}
