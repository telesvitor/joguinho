import 'package:flutter/material.dart';
import '../nine_souls_game.dart';

class PauseMenu extends StatelessWidget {
  final NineSoulsGame game;
  final VoidCallback onMenu;
  
  const PauseMenu({super.key, required this.game, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pause_circle_filled, size: 70, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  'JOGO PAUSADO',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                
                _buildPauseButton(
                  '▶ CONTINUAR',
                  Icons.play_arrow,
                  Colors.green,
                  () {
                    game.resumeGame();
                  },
                ),
                const SizedBox(height: 15),
                
                _buildPauseButton(
                  '🏠 MENU PRINCIPAL',
                  Icons.home,
                  Colors.blue,
                  () {
                    game.returnToMenu();
                    onMenu();
                  },
                ),
                const SizedBox(height: 15),
                
                _buildPauseButton(
                  '❌ SAIR DO JOGO',
                  Icons.exit_to_app,
                  Colors.red,
                  () {
                    game.returnToMenu();
                    onMenu();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPauseButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}