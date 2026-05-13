import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'managers/room_manager.dart';
import 'components/bonfire.dart';
import 'player.dart';

class NineSoulsGame extends FlameGame {
  final VoidCallback onReturnToMenu;
  bool _isGameRunning = false;
  
  // Variáveis do jogo
  int _currentHealth = 100;
  int _maxHealth = 100;
  int _souls = 0;
  int _nineSoulsCollected = 0;
  
  // Gerenciadores e componentes
  late RoomManager roomManager;
  Bonfire? activeSpawn;
  late Player player;
  
  NineSoulsGame({required this.onReturnToMenu});
  
  int get currentHealth => _currentHealth;
  int get maxHealth => _maxHealth;
  int get souls => _souls;
  int get nineSoulsCollected => _nineSoulsCollected;
  bool get isGameRunning => _isGameRunning;
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Criar e adicionar o player
    player = Player();
    await add(player);
    
    // Inicializa o gerenciador de salas
    roomManager = RoomManager();
    await add(roomManager);
  }
  
  void startNewGame() {
    _isGameRunning = true;
    _currentHealth = _maxHealth;
    _souls = 0;
    _nineSoulsCollected = 0;
    
    // Reset player stats
    player.reset();
    
    // Mostrar HUD
    overlays.remove('Pause');
    overlays.remove('Death');
    overlays.remove('Victory');
    overlays.remove('Bonfire');
    overlays.remove('Upgrade');
    overlays.add('HUD');
    
    // Reinicia a primeira sala
    roomManager.loadRoom(RoomId.forgottenShrine);
  }
  
  void pauseGame() {
    if (_isGameRunning) {
      overlays.add('Pause');
    }
  }
  
  void resumeGame() {
    if (_isGameRunning) {
      overlays.remove('Pause');
    }
  }
  
  void returnToMenu() {
    _isGameRunning = false;
    onReturnToMenu();
  }
  
  void takeDamage(int damage) {
    if (!_isGameRunning) return;
    
    _currentHealth -= damage;
    if (_currentHealth <= 0) {
      _currentHealth = 0;
      gameOver();
    }
  }
  
  void heal(int amount) {
    if (!_isGameRunning) return;
    _currentHealth = (_currentHealth + amount).clamp(0, _maxHealth);
  }
  
  void addSouls(int amount) {
    if (!_isGameRunning) return;
    _souls += amount;
  }
  
  void collectNineSoul() {
    if (!_isGameRunning) return;
    _nineSoulsCollected++;
    
    if (_nineSoulsCollected >= 9) {
      victory();
    }
  }
  
  void gameOver() {
    _isGameRunning = false;
    overlays.add('Death');
  }
  
  void victory() {
    _isGameRunning = false;
    overlays.add('Victory');
  }
  
  void openBonfire() {
    if (_isGameRunning) {
      overlays.add('Bonfire');
    }
  }
  
  void closeBonfire() {
    overlays.remove('Bonfire');
  }
  
  void openUpgradeMenu() {
    if (_isGameRunning) {
      overlays.add('Upgrade');
    }
  }
  
  void closeUpgradeMenu() {
    overlays.remove('Upgrade');
  }
  
  bool spendSouls(int amount) {
    if (_souls >= amount) {
      _souls -= amount;
      return true;
    }
    return false;
  }
  
  void upgradeMaxHealth() {
    if (spendSouls(50)) {
      _maxHealth += 20;
      _currentHealth = _maxHealth;
    }
  }
  
  void onBossDefeated() {
    if (!_isGameRunning) return;
    collectNineSoul();
  }
  
  void delay(double attackWindup, VoidCallback callback) {
    Future.delayed(Duration(milliseconds: (attackWindup * 1000).round()), callback);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
  }
  
  // REMOVA ou COMENTE estes métodos se estiverem causando erro:

  @override
  bool onTapDown(TapDownInfo info) {
    return true;
  }
  
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return true;
  }
  
}