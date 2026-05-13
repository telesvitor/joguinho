import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  final VoidCallback onContinue;
  
  const IntroScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Colors.deepPurple.shade900,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'A JORNADA DAS NOVE ALMAS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      
                      _buildStorySection(
                        'A Profecia',
                        'Em um reino esquecido pelo tempo, nove almas poderosas foram perdidas nas sombras.',
                        Icons.auto_stories,
                      ),
                      const SizedBox(height: 30),
                      
                      _buildStorySection(
                        'Sua Missão',
                        'Você foi escolhido para recuperar essas almas e restaurar o equilíbrio do mundo.',
                        Icons.queue,
                      ),
                      const SizedBox(height: 30),
                      
                      _buildStorySection(
                        'O Desafio',
                        'Enfrente criaturas sombrias, supere armadilhas mortais e colete as nove almas sagradas.',
                        Icons. sports,
                      ),
                      const SizedBox(height: 30),
                      
                      _buildStorySection(
                        'Poder das Almas',
                        'Cada alma coletada aumenta seu poder. Use sabiamente suas almas para evoluir.',
                        Icons.auto_awesome,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Dicas de gameplay
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.deepPurple),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '💡 DICAS IMPORTANTES',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildTip('Colete almas para evoluir seu personagem'),
                            _buildTip('Use fogueiras para descansar e melhorar stats'),
                            _buildTip('Cuidado! Você tem apenas 9 chances...'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Botão Continuar
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    '▶ COMEÇAR AVENTURA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStorySection(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.deepPurple),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}