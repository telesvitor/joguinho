import 'package:flutter/material.dart';
import '../nine_souls_game.dart';

class HudOverlay extends StatelessWidget {
  final NineSoulsGame game;
  
  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Barra de Vida
              _buildHealthBar(),
              
              // Informações
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepPurple),
                ),
                child: Row(
                  children: [
                    _buildStatItem(Icons.favorite, '${game.currentHealth}/${game.maxHealth}', Colors.red),
                    const SizedBox(width: 20),
                    _buildStatItem(Icons.star, '${game.souls}', Colors.amber),
                    const SizedBox(width: 20),
                    _buildStatItem(Icons.lens, '${game.nineSoulsCollected}/9', Colors.deepPurple),
                  ],
                ),
              ),
              
              // Botão Pausa
              _buildPauseButton(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHealthBar() {
    double healthPercent = game.currentHealth / game.maxHealth;
    
    return Container(
      width: 200,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FractionallySizedBox(
              widthFactor: healthPercent,
              child: Container(
                color: Colors.red,
                height: 30,
              ),
            ),
          ),
          Center(
            child: Text(
              '${game.currentHealth}/${game.maxHealth}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPauseButton() {
    return GestureDetector(
      onTap: () => game.pauseGame(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white),
        ),
        child: const Icon(Icons.pause, color: Colors.white, size: 24),
      ),
    );
  }
}