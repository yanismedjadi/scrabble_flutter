import 'package:flutter/material.dart';
import '../models/player.dart';

class FinDePartieScreen extends StatelessWidget {
  final List<Player> joueurs;

  const FinDePartieScreen({super.key, required this.joueurs});

  @override
  Widget build(BuildContext context) {
    final joueursTries = [...joueurs]..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fin de la Partie'),
        backgroundColor: Colors.green[800],
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const Text(
            'Classement final',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...joueursTries.map((joueur) => Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.emoji_events),
        title: Text(joueur.name),
        trailing: Text('${joueur.score} pts'),
      ),
    )),
    const Spacer(),
    ElevatedButton.icon(
      icon: const Icon(Icons.home),
      label: const Text("Retour à l'accueil "),
      style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      backgroundColor: Colors.green,
      ),
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
    )
    ],
    ),
    ),
    );
  }
}