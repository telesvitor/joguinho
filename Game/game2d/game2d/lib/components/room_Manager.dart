import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../nine_souls_game.dart';
import '../platform.dart';
import '../base_enemy.dart';
import '../skeleton_enemy.dart';
import '../components/bonfire.dart';

enum RoomId {
  forgottenShrine,
  shadowPassage,
  brokenCourtyard,
  depthsOfDespair,
  throneOfSouls,
}

class RoomData {
  final String name;
  final List<PlatformData> platforms;
  final List<EnemySpawn> enemies;
  final BonfireData? bonfire;
  final bool isBossRoom;

  RoomData({
    required this.name,
    required this.platforms,
    required this.enemies,
    this.bonfire,
    this.isBossRoom = false,
  });
}

class PlatformData {
  final double x;
  final double y;
  final double width;
  final double height;
  final bool isBossRoom;

  PlatformData({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.isBossRoom = false,
  });
}

class BonfireData {
  final double x;
  final double y;

  BonfireData({required this.x, required this.y});
}

class EnemySpawn {
  final String type;
  final double x;
  final double y;

  EnemySpawn({required this.type, required this.x, required this.y});
}

class RoomManager extends Component with HasGameRef<NineSoulsGame> {
  RoomId _currentRoomId = RoomId.forgottenShrine;
  final List<Component> _roomComponents = [];
  bool _isLoadingRoom = false;
  bool _bossDefeated = false;

  RoomManager();

  final Map<RoomId, RoomData> _rooms = {
    RoomId.forgottenShrine: RoomData(
      name: 'Forgotten Shrine',
      platforms: [
        PlatformData(x: 0, y: 570, width: 200, height: 32),
        PlatformData(x: 250, y: 570, width: 200, height: 32),
        PlatformData(x: 500, y: 570, width: 200, height: 32),
        PlatformData(x: 750, y: 570, width: 210, height: 32),
        PlatformData(x: 120, y: 500, width: 80, height: 16),
        PlatformData(x: 400, y: 520, width: 80, height: 16),
        PlatformData(x: 680, y: 510, width: 80, height: 16),
      ],
      enemies: [
        EnemySpawn(type: 'skeleton', x: 100, y: 538),
        EnemySpawn(type: 'skeleton', x: 350, y: 538),
        EnemySpawn(type: 'skeleton', x: 600, y: 538),
        EnemySpawn(type: 'skeleton', x: 800, y: 538),
      ],
      bonfire: BonfireData(x: 850, y: 538),
    ),
    
    RoomId.shadowPassage: RoomData(
      name: 'Shadow Passage',
      platforms: [
        PlatformData(x: 0, y: 570, width: 150, height: 32),
        PlatformData(x: 180, y: 570, width: 150, height: 32),
        PlatformData(x: 360, y: 570, width: 150, height: 32),
        PlatformData(x: 540, y: 570, width: 150, height: 32),
        PlatformData(x: 720, y: 570, width: 150, height: 32),
        PlatformData(x: 900, y: 570, width: 150, height: 32),
        PlatformData(x: 50, y: 500, width: 100, height: 16),
        PlatformData(x: 300, y: 480, width: 100, height: 16),
        PlatformData(x: 550, y: 490, width: 100, height: 16),
        PlatformData(x: 800, y: 500, width: 100, height: 16),
      ],
      enemies: [
        EnemySpawn(type: 'skeleton', x: 80, y: 538),
        EnemySpawn(type: 'skeleton', x: 200, y: 538),
        EnemySpawn(type: 'skeleton', x: 420, y: 538),
        EnemySpawn(type: 'skeleton', x: 620, y: 538),
        EnemySpawn(type: 'skeleton', x: 780, y: 538),
        EnemySpawn(type: 'skeleton', x: 950, y: 538),
      ],
      bonfire: BonfireData(x: 50, y: 538),
    ),
    
    RoomId.brokenCourtyard: RoomData(
      name: 'Broken Courtyard',
      platforms: [
        PlatformData(x: 0, y: 570, width: 300, height: 32),
        PlatformData(x: 330, y: 570, width: 300, height: 32),
        PlatformData(x: 660, y: 570, width: 300, height: 32),
        PlatformData(x: 150, y: 520, width: 120, height: 16),
        PlatformData(x: 450, y: 480, width: 120, height: 16),
        PlatformData(x: 720, y: 500, width: 120, height: 16),
        PlatformData(x: 850, y: 440, width: 100, height: 16),
      ],
      enemies: [
        EnemySpawn(type: 'skeleton', x: 120, y: 538),
        EnemySpawn(type: 'skeleton', x: 380, y: 538),
        EnemySpawn(type: 'skeleton', x: 500, y: 538),
        EnemySpawn(type: 'skeleton', x: 720, y: 538),
        EnemySpawn(type: 'skeleton', x: 880, y: 468),
      ],
      bonfire: BonfireData(x: 680, y: 538),
    ),
    
    RoomId.depthsOfDespair: RoomData(
      name: 'Depths of Despair',
      platforms: [
        PlatformData(x: 0, y: 570, width: 200, height: 32),
        PlatformData(x: 250, y: 570, width: 200, height: 32),
        PlatformData(x: 500, y: 570, width: 200, height: 32),
        PlatformData(x: 750, y: 570, width: 210, height: 32),
        PlatformData(x: 100, y: 520, width: 80, height: 16),
        PlatformData(x: 400, y: 510, width: 80, height: 16),
        PlatformData(x: 650, y: 530, width: 80, height: 16),
        PlatformData(x: 200, y: 460, width: 100, height: 16),
        PlatformData(x: 600, y: 450, width: 100, height: 16),
      ],
      enemies: [
        EnemySpawn(type: 'skeleton', x: 150, y: 538),
        EnemySpawn(type: 'skeleton', x: 350, y: 538),
        EnemySpawn(type: 'skeleton', x: 600, y: 538),
        EnemySpawn(type: 'skeleton', x: 250, y: 428),
        EnemySpawn(type: 'skeleton', x: 650, y: 418),
      ],
      bonfire: BonfireData(x: 800, y: 538),
    ),
    
    RoomId.throneOfSouls: RoomData(
      name: 'Throne of Souls',
      platforms: [
        PlatformData(x: 0, y: 570, width: 960, height: 32, isBossRoom: true),
        PlatformData(x: 300, y: 520, width: 100, height: 16, isBossRoom: true),
        PlatformData(x: 560, y: 520, width: 100, height: 16, isBossRoom: true),
        PlatformData(x: 430, y: 460, width: 100, height: 16, isBossRoom: true),
      ],
      enemies: [
        EnemySpawn(type: 'skeleton', x: 400, y: 538),
        EnemySpawn(type: 'skeleton', x: 560, y: 538),
        EnemySpawn(type: 'skeleton', x: 480, y: 428),
      ],
      bonfire: null,
      isBossRoom: true,
    ),
  };

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Carrega a sala inicial
    await loadRoom(RoomId.forgottenShrine);
  }

  Future<void> loadRoom(RoomId roomId) async {
    if (_isLoadingRoom) return;
    _isLoadingRoom = true;
    
    _currentRoomId = roomId;
    _bossDefeated = false;
    
    // Clear existing room components
    for (final component in _roomComponents) {
      component.removeFromParent();
    }
    _roomComponents.clear();
    
    final room = _rooms[roomId]!;
    
    // Add platforms
    for (final platformData in room.platforms) {
      final platform = Platform(
        position: Vector2(platformData.x, platformData.y),
        size: Vector2(platformData.width, platformData.height),
        isBossRoom: platformData.isBossRoom,
      );
      await gameRef.add(platform);
      _roomComponents.add(platform);
    }
    
    // Add bonfire if exists
    if (room.bonfire != null) {
      final bonfire = Bonfire(
        position: Vector2(room.bonfire!.x, room.bonfire!.y),
        isLit: true,
      );
      await gameRef.add(bonfire);
      _roomComponents.add(bonfire);
      // Corrigido: Usar a propriedade activeSpawn do game
      gameRef.activeSpawn = bonfire;
    }
    
    // Add enemies
    for (final enemySpawn in room.enemies) {
      BaseEnemy? enemy;
      switch (enemySpawn.type) {
        case 'skeleton':
          enemy = SkeletonEnemy(position: Vector2(enemySpawn.x, enemySpawn.y));
          break;
        // Add more enemy types here as you create them
      }
      if (enemy != null) {
        await gameRef.add(enemy);
        _roomComponents.add(enemy);
      }
    }
    
    // Add boss for throne room
    if (roomId == RoomId.throneOfSouls) {
      final miniBoss = SkeletonEnemy(position: Vector2(480, 428));
      miniBoss.maxHp = 200;
      miniBoss.hp = 200;
      await gameRef.add(miniBoss);
      _roomComponents.add(miniBoss);
    }
    
    _isLoadingRoom = false;
  }
  
  void onEnemyDefeated(BaseEnemy enemy) {
    // Check if all enemies in current room are defeated
    final remainingEnemies = gameRef.children
        .whereType<BaseEnemy>()
        .where((e) => !e.isDead)
        .length;
    
    if (remainingEnemies == 0 && _rooms[_currentRoomId]!.isBossRoom && !_bossDefeated) {
      _bossDefeated = true;
      // Corrigido: Chamar o método existente no game
      gameRef.onBossDefeated();
    }
  }
  
  RoomId get currentRoomId => _currentRoomId;
  
  String get currentRoomName => _rooms[_currentRoomId]?.name ?? 'Unknown';
  
  bool isBossRoom() => _rooms[_currentRoomId]?.isBossRoom ?? false;
  
  void respawnEnemies() {
    // Reload current room to respawn enemies
    loadRoom(_currentRoomId);
  }
  
  void transitionToNextRoom() {
    switch (_currentRoomId) {
      case RoomId.forgottenShrine:
        loadRoom(RoomId.shadowPassage);
        break;
      case RoomId.shadowPassage:
        loadRoom(RoomId.brokenCourtyard);
        break;
      case RoomId.brokenCourtyard:
        loadRoom(RoomId.depthsOfDespair);
        break;
      case RoomId.depthsOfDespair:
        loadRoom(RoomId.throneOfSouls);
        break;
      case RoomId.throneOfSouls:
        // Game complete, handled elsewhere
        break;
    }
  }
}