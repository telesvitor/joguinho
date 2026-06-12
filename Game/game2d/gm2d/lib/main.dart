import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'enemy.dart'; 
import 'player.dart'; 
import 'chiorbs.dart'; 
import 'overlays/snecery.dart'; 
import 'overlays/hud.dart';     
import 'overlays/menu.dart';    
import 'overlays/gameover.dart'; 
import 'overlays/chest.dart';           
import 'overlays/spikes.dart'; 

void main() {
  runApp(
    GameWidget<AnimaSolsGame>(
      game: AnimaSolsGame(),
      overlayBuilderMap: {
        'MainMenu': (context, game) => MainMenuOverlay(game: game),
        'GameOver': (context, game) => GameOverOverlay(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}

class AnimaSolsGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  PlayerCharacter? player;
  int currentRoom = 1;       
  bool canChangeRoom = false; 
  late TextComponent hudMessage;
  bool _isRoomLoaded = false; 

  final Map<LogicalKeyboardKey, bool> _pressedKeys = {};

  @override
  Color backgroundColor() => const Color(0xFF0D1117);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    if (overlays.isActive('MainMenu')) {
      pauseEngine();
    }
    
    hudMessage = TextComponent(
      text: '',
      position: Vector2(200, 80),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF00FFCC), 
          fontSize: 16, 
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Color(0xFF00FFCC), blurRadius: 10)],
        ),
      ),
    );

    player = PlayerCharacter(position: Vector2(150, 300));

    camera.viewport.add(GameHUD());
    add(hudMessage); 
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!_isRoomLoaded && size.x > 0 && size.y > 0 && player != null) {
      buildRoom1();
      _isRoomLoaded = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (player == null) return;

    if (player!.isDead && !overlays.isActive('GameOver')) {
      pauseEngine();
      overlays.add('GameOver');
    }
    _manageRoomTransitions();
  }

  void _manageRoomTransitions() {
    if (player == null || !player!.isMounted) return;

    if (player!.position.x > size.x && canChangeRoom && currentRoom == 1) {
      nextRoom();
    } else if (player!.position.x < 0 && currentRoom == 2) {
      previousRoom();
    }
  }

  void buildRoom1({bool spawnAtRight = false}) {
    if (player == null) return;
    currentRoom = 1;
    canChangeRoom = spawnAtRight ? true : false;

    removeAll(children.whereType<GamePlatform>());
    removeAll(children.whereType<SimpleEnemy>());
    removeAll(children.whereType<ChiOrb>());
    removeAll(children.whereType<RewardChest>());
    removeAll(children.whereType<SpikeHazard>());

    double groundY = (size.x > 0 && size.y > 0) ? size.y - 80 : 500;

    add(GamePlatform(position: Vector2(0, groundY), size: Vector2(size.x * 1.5, 80)));
    add(GamePlatform(position: Vector2(150, groundY - 120), size: Vector2(200, 20)));
    add(GamePlatform(position: Vector2(420, groundY - 210), size: Vector2(250, 20)));
    add(GamePlatform(position: Vector2(750, groundY - 120), size: Vector2(200, 20)));
    add(GamePlatform(position: Vector2(450, groundY - 370), size: Vector2(180, 20), color: const Color(0xFF0B2521)));

    player!.isDead = false;
    player!.currentHealth = player!.maxHealth;
    player!.currentChi = 0;
    player!.position = spawnAtRight ? Vector2(size.x - 80, groundY - 180) : Vector2(150, groundY - 180);
    player!.velocity = Vector2.zero();
    player!.hasDoubleJump = false;
    
    if (!player!.isMounted) {
      add(player!);
    }
    camera.follow(player!);
    
    if (!spawnAtRight) {
      add(SimpleEnemy(position: Vector2(600, groundY - 40)));
      add(SimpleEnemy(position: Vector2(900, groundY - 40)));
      add(SimpleEnemy(position: Vector2(480, groundY - 250)));
    } else {
      final openedChest = RewardChest(position: Vector2(540, groundY - 370));
      openedChest.isOpened = true;
      add(openedChest);
    }

    if (!overlays.isActive('MainMenu')) {
      resumeEngine();
    }
  }

  void buildRoom2() {
    if (player == null) return;
    currentRoom = 2;
    canChangeRoom = false;

    removeAll(children.whereType<GamePlatform>());
    removeAll(children.whereType<SimpleEnemy>());
    removeAll(children.whereType<ChiOrb>());
    removeAll(children.whereType<RewardChest>());
    removeAll(children.whereType<SpikeHazard>());

    double groundY = (size.x > 0 && size.y > 0) ? size.y - 80 : 500;

    add(GamePlatform(position: Vector2(0, groundY), size: Vector2(450, 80)));

    double destinationX = size.x > 1200 ? size.x - 350 : 850;
    add(GamePlatform(position: Vector2(destinationX, groundY - 80), size: Vector2(400, 160), color: const Color(0xFF161B22)));
    add(SpikeHazard(position: Vector2(450, groundY + 40), size: Vector2(destinationX - 450, 40)));

    player!.position = Vector2(80, groundY - 180);
    player!.velocity = Vector2.zero();
    player!.hasDoubleJump = true; 
    
    if (!player!.isMounted) add(player!);
    camera.follow(player!);

    add(SimpleEnemy(position: Vector2(destinationX + 150, groundY - 130)));

    updateHUDText("FASE 2: COMBINE PULO DUPLO + DASH OU USE O POGO NOS ESPINHOS!");
    resumeEngine(); 
  }

  void checkVictoryConditions() {
    if (player == null) return;
    if (currentRoom == 2) {
      updateHUDText("INIMIGO DERROTADO! VOCÊ DOMINOU AS MECÂNICAS!");
      return;
    }

    final remainingEnemies = children.whereType<SimpleEnemy>().length;
    double groundY = (size.x > 0 && size.y > 0) ? size.y - 80 : 500;

    if (remainingEnemies <= 1) { 
      player!.hasDoubleJump = true;
      add(RewardChest(position: Vector2(540, groundY - 370)));
      updateHUDText("ONDA CONCLUÍDA! USE O PULO DUPLO E QUEBRE O BAÚ NO ALTO!");
    }
  }

  void nextRoom() {
    buildRoom2();
  }

  void previousRoom() {
    buildRoom1(spawnAtRight: true); 
  }

  void updateHUDText(String text) {
    if (player != null && player!.isMounted) {
      hudMessage.text = text;
      hudMessage.position = Vector2(player!.position.x, player!.position.y - 100);
    }
    
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (hudMessage.text == text) hudMessage.text = '';
    });
  }

  void resetGame() {
    overlays.remove('GameOver');
    buildRoom1(); 
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (player == null || !player!.isMounted || overlays.isActive('MainMenu') || overlays.isActive('GameOver')) {
      return KeyEventResult.ignored;
    }

    if (event is KeyDownEvent) _pressedKeys[event.logicalKey] = true;
    if (event is KeyUpEvent) _pressedKeys[event.logicalKey] = false;

    if (player!.isHealing) {
      player!.horizontalInput = 0;
      if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.keyL) {
        player!.stopHealing();
      }
      return KeyEventResult.handled;
    }

    player!.horizontalInput = 0;
    player!.verticalInput = 0;
    
    if (_pressedKeys[LogicalKeyboardKey.keyA] == true) player!.horizontalInput = -1;
    if (_pressedKeys[LogicalKeyboardKey.keyD] == true) player!.horizontalInput = 1;
    if (_pressedKeys[LogicalKeyboardKey.keyW] == true) player!.verticalInput = -1; 
    if (_pressedKeys[LogicalKeyboardKey.keyS] == true) player!.verticalInput = 1;  

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) player!.jump();
      if (event.logicalKey == LogicalKeyboardKey.shiftLeft || event.logicalKey == LogicalKeyboardKey.shiftRight) {
        player!.triggerDash();
      }
      if (event.logicalKey == LogicalKeyboardKey.keyJ) player!.triggerAttack();
      if (event.logicalKey == LogicalKeyboardKey.keyK) player!.triggerParry();
      if (event.logicalKey == LogicalKeyboardKey.keyL) player!.startHealing();
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyL) player!.stopHealing();
    }

    return KeyEventResult.handled;
  }
}
