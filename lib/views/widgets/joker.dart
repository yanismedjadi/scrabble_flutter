import 'package:flutter/material.dart';


Future<String?> demanderLettrePourJoker(BuildContext context,String langue ) async {
List<String> lettres;
  switch (langue) {
    case 'Kabyle':
      lettres = ['A', 'B', 'C', 'Č', 'D', 'Ḍ', 'E', 'F', 'G', 'Ǧ', 'H', 'Ḥ', 'I', 'J',
       'K', 'L', 'M', 'N', 'Q', 'R', 'Ṛ', 'S', 'Ṣ', 'T', 'Ṭ', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Ẓ'];
      break;
    case 'Français':
    case 'Anglais':
    default:
      lettres = List.generate(26, (index) => String.fromCharCode(65 + index)); 

  }
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Joker",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          height:MediaQuery.of(context).size.height / 4,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount:lettres.length,
            itemBuilder: (context, index) {
              final lettre = lettres[index];
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context, lettre),
                child: Text(
                  lettre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "❌",
                style: TextStyle(fontSize: 16),
            ),
          ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );
    },
  );
  
}