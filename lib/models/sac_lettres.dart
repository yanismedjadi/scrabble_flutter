import 'dart:convert';
import 'package:flutter/services.dart';
import 'lettre.dart';

class SacLettres {
  List<Lettre> lettres = [];
  final String langue;

  SacLettres({required this.langue});

  Future<void> initialiser() async {
    try {
      final chemin = _getCheminDistribution();
      final jsonString = await rootBundle.loadString(chemin);
      final distribution = jsonDecode(jsonString) as Map<String, dynamic>;

      lettres = distribution.entries.expand((entry) {
        final lettre = entry.key;
        final valeur = entry.value['valeur'] as int;
        final quantite = entry.value['quantite'] as int;
        
        return List.generate(
          quantite, 
          (_) => Lettre(lettre: lettre, valeur: valeur,quantite: 1)
        );
      }).toList();

      lettres.shuffle();
      print('Sac initialisé avec ${lettres.length} lettres ($langue)');
    } catch (e) {
      throw Exception('Erreur de chargement des lettres: $e');
    }
  }

  String _getCheminDistribution() {
    switch (langue) {
      case 'Kabyle':
        return 'assets/lettre_kb.json';
      case 'Anglais':
        return 'assets/lettres_en.json';
      case 'Français':
      default:
        return 'assets/lettres_fr.json';
    }
  }

  String getCheminDictionnaire() {
    switch (langue) {
      case 'Kabyle':
        return 'assets/dictionnaire_kb.txt';
      case 'Anglais':
        return 'assets/dictionnaire_en.txt';
      case 'Français':
      default:
        return 'assets/dictionnaire_fr.txt';
    }
  }

  Lettre? tirerLettre() => lettres.isNotEmpty ? lettres.removeLast() : null;

  void ajouterLettre(Lettre lettre) => lettres.add(lettre);
}