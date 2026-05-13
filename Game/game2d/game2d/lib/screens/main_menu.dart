import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onCredits;
  
  const MainMenuScreen({
    super.key,
    required this.onPlay,
    required this.onCredits,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade900,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título do jogo
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.purple, Colors.deepPurple, Colors.purple],
                ).createShader(bounds),
                child: const Text(
                  'NINE SOULS',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Colete as 9 Almas Perdidas',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 80),
              
              // Botão Play
              _buildMenuButton(
                onPressed: onPlay,
                text: '▶ INICIAR JOGO',
                icon: Icons.play_arrow,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              
              // Botão Créditos
              _buildMenuButton(
                onPressed: onCredits,
                text: 'ℹ CRÉDITOS',
                icon: Icons.info,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              
              // Botão Sair (opcional)
              _buildMenuButton(
                onPressed: () => Navigator.of(context).maybePop(),
                text: '✕ SAIR',
                icon: Icons.exit_to_app,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        minimumSize: const Size(250, 50),
      ),
    );
  }
}