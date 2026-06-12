import 'package:flame/components.dart';
import 'player.dart';

class GameCollisionManager {
  
  /// Trata a colisão do jogador com o chão ou plataformas móveis
  static void handlePlatformCollision(PlayerCharacter player, PositionComponent platform) {
    if (player.isAttacking && player.attackDirection == 1 && !player.isGrounded && player.velocity.y > 0) {
      if (player.position.y <= platform.position.y + 12) {
        player.executePogoJump();
        return;
      }
    }

    if (player.velocity.y >= 0) {
      final playerBottom = player.position.y;
      final platformTop = platform.position.y;

      // Mantém a tolerância de 24 pixels para evitar noclip
      if (playerBottom <= platformTop + 24 && playerBottom >= platformTop - 8) {
        final playerLeft = player.position.x - (player.size.x / 2);
        final playerRight = player.position.x + (player.size.x / 2);
        final platformLeft = platform.position.x;
        final platformRight = platform.position.x + platform.size.x;

        if (playerRight > platformLeft && playerLeft < platformRight) {
          player.position.y = platformTop;
          player.velocity.y = 0;
          // Como o método _onLand era privado no player, usamos a mecânica pública resettando o pulo
          player.isGrounded = true;
          player.jumpCount = 0;
          player.canDashInAir = true;
          player.landingTimer = 0.1;
        }
      }
    }
  }

  /// Trata o dano ou Pogo Jump do jogador ao cair em espinhos
  static void handleSpikeCollision(PlayerCharacter player, PositionComponent spike) {
    if (player.isAttacking && player.attackDirection == 1 && player.velocity.y > 0) {
      if (player.position.y <= spike.position.y + 12) {
        player.executePogoJump();
        return;
      }
    }
    if (!player.isInvulnerable && !player.isDead) {
      player.applyDamageKnockback(spike.position.x);
      player.velocity.y = -220;
    }
  }

  /// Trata o combate e dano entre jogador e inimigos
  static void handleEnemyCollision(PlayerCharacter player, PositionComponent enemy) {
    if (player.isDashing) return;

    if (player.isAttacking && player.attackDirection == 1 && !player.isGrounded) {
      if (player.position.y <= enemy.position.y) {
        player.executePogoJump();
        return;
      }
    }

    if (player.isParrying) {
      player.gainChi(25);
      player.isParrying = false;
      player.knockbackDirection = (player.position.x < enemy.position.x) ? -1.0 : 1.0;
      player.knockbackTimer = 0.10;
    } else if (!player.isInvulnerable && !player.isAttacking && !player.isHealing) {
      player.applyDamageKnockback(enemy.position.x);
      player.velocity.y = -180;
    }
  }
}
