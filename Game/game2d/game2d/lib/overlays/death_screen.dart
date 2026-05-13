import 'package:flutter/material.dart';
import '../nine_souls_game.dart';

class DeathScreen extends StatelessWidget {
  final NineSoulsGame game;
  final VoidCallback onMenu;
  
  const DeathScreen({super.key, required this.game, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.black.withOpacity(0.95),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red,
                  Colors.black,
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.red, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Opção 1: Usar Icons.crisis_alert (se disponível)
                // const Icon(Icons.crisis_alert, size: 80, color: Colors.red),
                
                // Opção 2: Usar Icons.warning_amber_rounded
                const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
                
                // Opção 3: Usar texto com emoji
                // const Text('💀', style: TextStyle(fontSize: 80)),
                
                const SizedBox(height: 20),
                const Text(
                  '💀 GAME OVER 💀',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Almas Coletadas: ${game.nineSoulsCollected}/9',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Total de Almas: ${game.souls}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 40),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                      'MENU PRINCIPAL',
                      Icons.home,
                      () {
                        game.returnToMenu();
                        onMenu();
                      },
                      Colors.blue,
                    ),
                    const SizedBox(width: 20),
                    _buildButton(
                      'TENTAR NOVAMENTE',
                      Icons.refresh,
                      () {
                        game.startNewGame();
                      },
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildButton(String text, IconData icon, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
      ),
    );
  }
}