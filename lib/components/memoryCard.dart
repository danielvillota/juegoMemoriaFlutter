import 'package:flutter/material.dart';
import 'cardModel.dart';

class MemoryCard extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;
  final Map<int, String> imagePaths;

  MemoryCard({
    required this.card,
    required this.onTap,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.isFlipped ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Image.asset(imagePaths[card.number]!) // Muestra la imagen
              : Image.asset('img/dorso_card.png'), // Dorso de la carta
        ),
      ),
    );
  }
}