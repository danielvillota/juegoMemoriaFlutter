import 'package:flutter/material.dart';
import 'package:juego_memoria/components/memoryGame.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Memory'),
      ),
      body:Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple], // Colores del degradado
            begin: Alignment.topLeft,  // Dirección del degradado
            end: Alignment.bottomRight,
          ),
        ),
      
       child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
          crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
          children: [
            const Text('Entrena tus habilidades mentales', style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: 'Roboto')),
            const SizedBox(height: 30,),
            Image.asset('img/logo.png'),
            ElevatedButton(
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MemoryGame()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
             child: const Text('Iniciar Juego', style: TextStyle(fontSize: 15),),
            ),
          ],
        ),
      )
    ),
    );
  }
}