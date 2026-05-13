import 'package:flutter/material.dart';
import '../nine_souls_game.dart';

class UpgradeMenu extends StatelessWidget {
  final NineSoulsGame game;
  
  const UpgradeMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Dialog(
          backgroundColor: Colors.black.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          child: Container(
            padding: const EdgeInsets.all(30),
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 50, color: Colors.deepPurple),
                const SizedBox(height: 10),
                const Text(
                  '⭐ EVOLUÇÃO DAS ALMAS ⭐',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Almas Disponíveis: ${game.souls}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Upgrades disponíveis
                _buildUpgradeCard(
                  title: 'Força da Alma',
                  description: 'Aumenta o dano em 20%',
                  cost: 30,
                  icon: Icons.flash_on,
                  color: Colors.orange,
                  onUpgrade: () {
                    if (game.spendSouls(30)) {
                      // Implementar aumento de dano
                      game.closeUpgradeMenu();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dano aumentado!')),
                      );
                    } else {
                      _showError(context);
                    }
                  },
                ),
                
                _buildUpgradeCard(
                  title: 'Defesa Espiritual',
                  description: 'Reduz dano recebido em 20%',
                  cost: 30,
                  icon: Icons.shield,
                  color: Colors.blue,
                  onUpgrade: () {
                    if (game.spendSouls(30)) {
                      // Implementar aumento de defesa
                      game.closeUpgradeMenu();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Defesa aumentada!')),
                      );
                    } else {
                      _showError(context);
                    }
                  },
                ),
                
                _buildUpgradeCard(
                  title: 'Velocidade Espectral',
                  description: 'Aumenta velocidade em 15%',
                  cost: 25,
                  icon: Icons.speed,
                  color: Colors.green,
                  onUpgrade: () {
                    if (game.spendSouls(25)) {
                      // Implementar aumento de velocidade
                      game.closeUpgradeMenu();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Velocidade aumentada!')),
                      );
                    } else {
                      _showError(context);
                    }
                  },
                ),
                
                const SizedBox(height: 20),
                
                ElevatedButton.icon(
                  onPressed: () => game.closeUpgradeMenu(),
                  icon: const Icon(Icons.close),
                  label: const Text('FECHAR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildUpgradeCard({
    required String title,
    required String description,
    required int cost,
    required IconData icon,
    required Color color,
    required VoidCallback onUpgrade,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: color, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '$cost',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const Text('almas', style: TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: onUpgrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    minimumSize: const Size(60, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('EVOLUIR', style: TextStyle(fontSize: 10)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Almas insuficientes para evoluir!'),
        backgroundColor: Colors.red,
      ),
    );
  }
}