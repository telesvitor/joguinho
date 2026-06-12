import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'player.dart';
import 'main.dart';
import 'package:flame/components.dart';
import 'package:gm2d/main.dart';
import 'package:gm2d/player.dart';



class PlayerAnimationHelper {
  static Future<Map<PlayerState, SpriteAnimation>> loadPlayerAnimations({
    required AnimaSolsGame gameRef,
  }) async {
    const String imageName = 'sprit_player.png';
    final image = await gameRef.images.load(imageName);

    // Sistema matemático rígido por coordenadas em pixels
    SpriteAnimation sliceAnimation({
      required double pixelY,
      required double width,
      required double height,
      required int framesCount,
      required double stepTime,
      bool loop = true,
    }) {
      final frames = <SpriteAnimationFrame>[];
      for (int i = 0; i < framesCount; i++) {
        final sprite = Sprite(
          image,
          srcPosition: Vector2(i * width, pixelY),
          srcSize: Vector2(width, height),
        );
        frames.add(SpriteAnimationFrame(sprite, stepTime));
      }
      return SpriteAnimation(frames)..loop = loop;
    }

    // ─── Linhas de Movimento Padrão (64x64px) ───
    final idle    = sliceAnimation(pixelY: 0.0,   width: 64, height: 64, framesCount: 4, stepTime: 0.18);
    final walk    = sliceAnimation(pixelY: 64.0,  width: 64, height: 64, framesCount: 6, stepTime: 0.14);
    final run     = sliceAnimation(pixelY: 128.0, width: 64, height: 64, framesCount: 6, stepTime: 0.08);
    final jump    = sliceAnimation(pixelY: 192.0, width: 64, height: 64, framesCount: 4, stepTime: 0.08, loop: false);
    final fall    = sliceAnimation(pixelY: 256.0, width: 64, height: 64, framesCount: 4, stepTime: 0.10);
    final land    = sliceAnimation(pixelY: 320.0, width: 64, height: 64, framesCount: 4, stepTime: 0.06, loop: false);

    // ─── Linhas de Ataque de Combate (96x96px) ───
    final atk     = sliceAnimation(pixelY: 384.0, width: 96, height: 96, framesCount: 5, stepTime: 0.05, loop: false);
    final atkDown = sliceAnimation(pixelY: 480.0, width: 96, height: 96, framesCount: 5, stepTime: 0.05, loop: false);
    final atkUp   = sliceAnimation(pixelY: 576.0, width: 96, height: 96, framesCount: 4, stepTime: 0.05, loop: false);

    // ─── Linhas de Ação Restantes (64x64px) ───
    final crouch  = sliceAnimation(pixelY: 672.0,       width: 64, height: 64, framesCount: 3, stepTime: 0.15);
    final dash    = sliceAnimation(pixelY: 672.0 + 64,  width: 64, height: 64, framesCount: 3, stepTime: 0.06, loop: false);
    final climb   = sliceAnimation(pixelY: 672.0 + 128, width: 64, height: 64, framesCount: 4, stepTime: 0.12);
    final hurt    = sliceAnimation(pixelY: 672.0 + 192, width: 64, height: 64, framesCount: 2, stepTime: 0.10, loop: false);
    final death   = sliceAnimation(pixelY: 672.0 + 256, width: 64, height: 64, framesCount: 6, stepTime: 0.12, loop: false);

    return {
      PlayerState.idle:           idle,
      PlayerState.walking:        walk,
      PlayerState.running:        run,
      PlayerState.jumping:        jump,
      PlayerState.falling:        fall,
      PlayerState.landing:        land,
      PlayerState.attacking:      atk,
      PlayerState.downwardAttack: atkDown,
      PlayerState.upwardAttack:   atkUp,
      PlayerState.crouching:      crouch,
      PlayerState.dashing:        dash,
      PlayerState.dashingBack:    dash,
      PlayerState.climbing:       climb,
      PlayerState.hit:            hurt,
      PlayerState.death:          death,
    };
  }
}