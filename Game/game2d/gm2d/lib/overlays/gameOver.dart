import 'package:flutter/material.dart';
import '../main.dart';

class GameOverOverlay extends StatelessWidget {
  final AnimaSolsGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0505).withOpacity(0.9), // Vermelho escuro gótico semitransparente
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título Vermelho Neon estilo Hollow Knight / Nine Sols
            const Text(
              'FIM DE JOGO',
              style: TextStyle(
                color: Color(0xFFFF3333),
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
                shadows: [
                  Shadow(color: Color(0xFFFF3333), blurRadius: 25),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'A ALMA SE DESFEZ NA ESCURIDÃO',
              style: TextStyle(
                color: Colors.white38, 
                fontSize: 14, 
                letterSpacing: 2,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 50),

            // Botão Tentar Novamente
            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF221111),
                  side: const BorderSide(color: Color(0xFFFF3333), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: () {
                  // Apaga o overlay da tela e reinicia o estado
                  game.overlays.remove('GameOver');
                  game.resetGame();
                },
                child: const Text(
                  'TENTAR NOVAMENTE',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
