class Lettre {
  final String lettre;
  final int valeur;
  int quantite;
  String? remplace;
  bool estJoker() => lettre == '?';

  Lettre({
    required this.lettre,
    required this.valeur,
    required this.quantite,
  });
}
