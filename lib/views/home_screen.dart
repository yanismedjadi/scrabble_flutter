import 'package:flutter/material.dart';
import 'game_board.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Scrabble'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.play_arrow, color: Colors.white),
          label: Text(
            'COMMENCER UNE PARTIE',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameBoardScreen()),
            );
          },
        ),
      ),
    );
  }
}
