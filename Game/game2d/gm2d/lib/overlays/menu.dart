import 'package:flutter/material.dart';
import '../main.dart';

class MainMenuOverlay extends StatelessWidget {
  final AnimaSolsGame game;

  const MainMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0D1117).withOpacity(0.85),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ANIMA SOLS',
              style: TextStyle(
                color: Color(0xFF00FFCC),
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                shadows: [Shadow(color: Color(0xFF00FFCC), blurRadius: 20)],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Inspirado em Hollow Knight & Nine Sols',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E222B),
                  side: const BorderSide(color: Color(0xFF3F72AF), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  game.overlays.remove('MainMenu');
                  game.resumeEngine(); // Acorda o motor físico do Flame
                },
                child: const Text(
                  'INICIAR JOGO',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
