import 'package:flutter/material.dart';
import '../nine_souls_game.dart';

class BonfireMenu extends StatelessWidget {
  final NineSoulsGame game;
  
  const BonfireMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Dialog(
          backgroundColor: Colors.black.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.orange, width: 2),
          ),
          child: Container(
            padding: const EdgeInsets.all(30),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department, size: 60, color: Colors.orange),
                const SizedBox(height: 10),
                const Text(
                  '🔥 FOgueira Sagrada 🔥',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '💀 Suas Almas: ${game.souls}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '❤️ Vida: ${game.currentHealth}/${game.maxHealth}',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Opções da Fogueira
                _buildMenuItem(
                  'Curar completamente (-10 almas)',
                  Icons.healing,
                  Colors.green,
                  () {
                    if (game.spendSouls(10)) {
                      game.heal(game.maxHealth);
                      game.closeBonfire();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Você foi curado!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Almas insuficientes!')),
                      );
                    }
                  },
                ),
                
                _buildMenuItem(
                  'Melhorar Vida Máxima (-50 almas)',
                  Icons.favorite,
                  Colors.red,
                  () {
                    if (game.spendSouls(50)) {
                      game.upgradeMaxHealth();
                      game.closeBonfire();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vida máxima aumentada para ${game.maxHealth}!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Almas insuficientes!')),
                      );
                    }
                  },
                ),
                
                _buildMenuItem(
                  'Menu de Evolução',
                  Icons.auto_awesome,
                  Colors.purple,
                  () {
                    game.closeBonfire();
                    game.openUpgradeMenu();
                  },
                ),
                
                const Divider(color: Colors.grey, height: 30),
                
                _buildMenuItem(
                  'Continuar Jornada',
                  Icons.arrow_forward,
                  Colors.white,
                  () => game.closeBonfire(),
                  isCloseButton: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuItem(String text, IconData icon, Color color, VoidCallback onTap, {bool isCloseButton = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isCloseButton ? Colors.grey : color,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}