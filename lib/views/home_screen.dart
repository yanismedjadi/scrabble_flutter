import 'package:flutter/material.dart';
import '../models/player.dart';
import 'game_board.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int nombreJoueurs = 2;
  final List<TextEditingController> _controllers = [
    TextEditingController(text: 'Joueur 1'),
    TextEditingController(text: 'Joueur 2'),
    TextEditingController(text: 'Joueur 3'),
    TextEditingController(text: 'Joueur 4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Scrabble - Accueil'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choisir le nombre de joueurs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: nombreJoueurs,
              items: [2, 3, 4].map((n) {
                return DropdownMenuItem(
                  value: n,
                  child: Text('$n Joueurs'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  nombreJoueurs = value!;
                });
              },
            ),
            SizedBox(height: 16),
            ...List.generate(nombreJoueurs, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _controllers[index],
                  decoration: InputDecoration(
                    labelText: 'Nom du joueur ${index + 1}',
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }),
            Spacer(),
            ElevatedButton.icon(
              icon: Icon(Icons.play_arrow, color: Colors.white),
              label: Text(
                'COMMENCER LA PARTIE',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final joueurs = _controllers
                    .take(nombreJoueurs)
                    .map((ctrl) => Player(name: ctrl.text))
                    .toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameBoardScreen(players: joueurs),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
