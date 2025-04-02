import 'lettre.dart';

class Player {
  final String name;
  List<Lettre> letters;
  int score;

  Player({
    required this.name,
    this.letters = const [],
    this.score = 0,
  });

  void updateScore(int newScore) {
    this.score = this.score + newScore;
  }

}
