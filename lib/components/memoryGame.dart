import 'dart:async';
import 'package:flutter/material.dart';
import 'cardModel.dart';
import 'memoryCard.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<CardModel> cards = [];
  CardModel? firstSelectedCard;
  CardModel? secondSelectedCard;
  bool isGameStarted = false; // Para controlar si el juego ha comenzado
  Timer? _timer;
  int _elapsedSeconds = 0; // Contador de segundos

  @override
  void initState() {
    super.initState();
    _initializeCards();
    _revealCardsTemporarily(); // Muestra las cartas temporalmente
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el temporizador si la pantalla se cierra
    super.dispose();
  }

  void _initializeCards() {
    List<int> numbers = [1, 2, 3, 4, 5, 6];
    cards = numbers
        .expand((number) => [
              CardModel(id: UniqueKey().hashCode, number: number),
              CardModel(id: UniqueKey().hashCode, number: number)
            ])
        .toList();
    cards.shuffle();
  }

  // Función para mostrar temporalmente las cartas al inicio del juego
  void _revealCardsTemporarily() {
    // Mostrar las cartas durante 1 segundos antes de voltearlas
    setState(() {
      for (var card in cards) {
        card.isFlipped = true; // Voltear todas las cartas
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        for (var card in cards) {
          card.isFlipped = false; // Volver a voltear las cartas
        }
        isGameStarted = true; // Iniciar el juego oficialmente
         _startTimer(); // Iniciar el cronómetro
      });
    });
  }

  // Iniciar el cronómetro
  void _startTimer() {
    _timer?.cancel(); // Asegurarse de cancelar cualquier temporizador anterior
    _elapsedSeconds = 0; // Reiniciar el cronómetro
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++; // Incrementar el contador de segundos
      });
    });
  }

  // Detener el cronómetro
  void _stopTimer() {
    _timer?.cancel();
  }

 
  final Map<int, String> imagePaths = {
    1: 'img/img_1.png',
    2: 'img/img_2.png',
    3: 'img/img_3.png',
    4: 'img/img_4.png',
    5: 'img/img_6.png',
    6: 'img/img_7.png',
  };

  // Función para reiniciar el juego
  void _restartGame() {
     _stopTimer(); // Detener el cronómetro 
    setState(() {
      firstSelectedCard = null;
      secondSelectedCard = null;
      isGameStarted = false;
       _elapsedSeconds = 0; // Reiniciar el cronómetro
      _initializeCards(); // Rebarajar las cartas
      _revealCardsTemporarily(); // Mostrar temporalmente las cartas de nuevo
    });
     _startTimer();
  }

  void _onCardTap(CardModel card) {
    if (!isGameStarted || firstSelectedCard != null && secondSelectedCard != null) {
      return;
    }

    setState(() {
      card.isFlipped = true;

      if (firstSelectedCard == null) {
        firstSelectedCard = card;
      } else if (secondSelectedCard == null) {
        secondSelectedCard = card;

        // Comprobar si las cartas coinciden
        if (firstSelectedCard!.number == secondSelectedCard!.number) {
          firstSelectedCard!.isMatched = true;
          secondSelectedCard!.isMatched = true;

          // Verificar si el jugador ha ganado
          if (cards.every((card) => card.isMatched)) {
            _stopTimer(); // Detener el cronómetro
          }

          _resetSelection();
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              firstSelectedCard!.isFlipped = false;
              secondSelectedCard!.isFlipped = false;
              _resetSelection();
            });
          });
        }
      }
    });
  }

  void _resetSelection() {
    firstSelectedCard = null;
    secondSelectedCard = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Memoria'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame, // Reinicia el juego
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple], 
            begin: Alignment.topLeft, 
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tiempo: $_elapsedSeconds segundos',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return MemoryCard(
                    card: card,
                    onTap: () => _onCardTap(card),
                    imagePaths: imagePaths,
                  );
                },
              ),
            )
          ],
        )
      )
    );
  }
}