import 'package:flutter/material.dart';
import '../models/player.dart';
import 'game_board.dart';
import 'package:flutter/services.dart' show rootBundle;


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int nombreJoueurs = 2;
  String langueSelectionnee = 'Français'; // Valeur par défaut
  final List<TextEditingController> _controllers = [
    TextEditingController(text: 'Joueur 1'),
    TextEditingController(text: 'Joueur 2'),
    TextEditingController(text: 'Joueur 3'),
    TextEditingController(text: 'Joueur 4'),
  ];

  Future<String> _loadLicense() async {
    try {
      return await rootBundle.loadString('assets/LICENCE.md');
    } catch (e) {
      return 'Erreur de chargement du texte';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Scrabble - Accueil'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.info_outline),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'Licence',
                child: Text('Licence'),
              ),
              PopupMenuItem<String>(
                value: 'about',
                child: Text('À propos'),
              ),
            ],
            onSelected: (String value) {
              if (value == 'Licence') {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('LICENCE D\'UTILISATION'),
                    content: SingleChildScrollView(
                      child: FutureBuilder(
                        future: _loadLicense(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!);
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Fermer'),
                      ),
                    ],
                  ),
                );
              } else if (value == 'about') {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('À propos'),
                    content: Text('Version 2.0\nDéveloppé par ARKOUB Thiziri et MEDJADI Yanis '),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Fermer'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choisissez la langue :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: langueSelectionnee,
              onChanged: (String? nouvelleLangue) {
                setState(() {
                  langueSelectionnee = nouvelleLangue!;
                });
              },
              items: <String>['Français', 'Anglais', 'Kabyle']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
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
                    builder: (context) => GameBoardScreen(
                      players: joueurs,
                      langue: langueSelectionnee, // On passe la langue
                    ),
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
