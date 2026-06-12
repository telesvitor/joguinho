import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'main.dart';
import 'player_animations.dart';

enum PlayerState {
  idle, walking, running, jumping, falling, landing,
  attacking, downwardAttack, upwardAttack, crouching,
  dashing, dashingBack, climbing, hit, death,
}

class PlayerCharacter extends SpriteAnimationGroupComponent<PlayerState> with HasGameRef<AnimaSolsGame>, CollisionCallbacks {
  // ─── Inputs e Direção ───
  int horizontalInput = 0;   
  int verticalInput = 0; 
  double facingDirection = 1.0; 

  // ─── Física e Movimento ───
  Vector2 velocity = Vector2.zero();
  final double gravity = 980.0;
  final double runSpeed = 160.0;
  double jumpForce = -500.0; 
  int jumpCount = 0;
  bool hasDoubleJump = true;
  bool isGrounded = false;
  bool canDashInAir = true;
  
  // ─── Estados de Combate e Habilidades ───
  bool isAttacking = false;
  int attackDirection = 0; // -1: cima, 0: frente, 1: baixo
  double attackTimer = 0;
  double attackDuration = 0.25;

  bool isDashing = false;
  double dashTimer = 0;
  double dashDuration = 0.22; 
  double dashCooldownTimer = 0;
  double dashCooldown = 0.6;

  bool isParrying = false;
  double parryTimer = 0;
  double parryDuration = 0.15;

  bool isHealing = false;
  double healTimer = 0;

  bool isInvulnerable = false;
  double invulnerableTimer = 0;
  bool isDead = false;

  double knockbackTimer = 0;
  double knockbackDirection = 0;
  double landingTimer = 0;

  // ─── Atributos Vitais Internos ───
  int currentHealth = 5; 
  final int maxHealth = 5;     
  double currentChi = 0;
  final double maxChi = 100;

  PlayerCharacter({super.position});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(64, 64);
    anchor = Anchor.bottomCenter;

    currentHealth = maxHealth;
    currentChi = 0;
    isDead = false;

    animations = await PlayerAnimationHelper.loadPlayerAnimations(gameRef: gameRef);
    current = PlayerState.idle;

    add(RectangleHitbox(
      position: Vector2(18, 6), 
      size: Vector2(28, 54),
    ));
  }

  @override
  void update(double dt) {
    if (isDead) {
      super.update(dt);
      return;
    }

    _updateTimers(dt);

    if (isHealing) {
      _executeHealingLogic(dt);
    } else {
      _executePhysicsLogic(dt);
    }

    _updatePlayerAnimationState();
    _adjustComponentSizeToAnimation();
    super.update(dt);
  }

  void _updateTimers(double dt) {
    if (invulnerableTimer > 0) {
      invulnerableTimer -= dt;
      if (invulnerableTimer <= 0) isInvulnerable = false;
    }
    if (dashCooldownTimer > 0) dashCooldownTimer -= dt;
    if (landingTimer > 0) landingTimer -= dt;
  }

  void _executeHealingLogic(double dt) {
    velocity.setZero();
    healTimer += dt;
    if (healTimer >= 2.4) completeHealing();
  }

  void _executePhysicsLogic(double dt) {
    if (knockbackTimer > 0) {
      knockbackTimer -= dt;
      velocity.x = knockbackDirection * 140.0;
      velocity.y += gravity * dt;
      position += velocity * dt;
      return;
    }

    if (isDashing) {
      dashTimer -= dt;
      velocity.x = facingDirection * 650.0; 
      velocity.y = 0.0; 
      if (dashTimer <= 0) isDashing = false;
      position += velocity * dt;
      return;
    }

    if (isAttacking) {
      attackTimer -= dt;
      if (attackTimer <= 0) {
        isAttacking = false;
        attackDirection = 0;
      }
    }

    if (isParrying) {
      parryTimer -= dt;
      if (parryTimer <= 0) isParrying = false;
    }

    if (horizontalInput > 0) facingDirection = 1.0;
    else if (horizontalInput < 0) facingDirection = -1.0;
    
    velocity.x = horizontalInput * runSpeed;

    if (!isGrounded) {
      velocity.y += gravity * dt;
      if (velocity.y > 450.0) velocity.y = 450.0;
    }

    position += velocity * dt;
  }

  void _updatePlayerAnimationState() {
    if (knockbackTimer > 0) {
      current = PlayerState.hit;
      return;
    }
    if (isDashing) {
      current = PlayerState.dashing;
      return;
    }
    if (isAttacking) {
      if (attackDirection == -1) current = PlayerState.upwardAttack;
      else if (attackDirection == 1) current = PlayerState.downwardAttack;
      else current = PlayerState.attacking;
      return;
    }

    if (!isGrounded) {
      current = (velocity.y < 0) ? PlayerState.jumping : PlayerState.falling;
    } else {
      if (velocity.x.abs() > 50.0) current = PlayerState.running;
      else if (velocity.x.abs() > 5.0) current = PlayerState.walking;
      else current = PlayerState.idle;
    }
  }

  void _adjustComponentSizeToAnimation() {
    if (!isMounted || position.y == 0) return;

    final isAttackState = current == PlayerState.attacking ||
                          current == PlayerState.downwardAttack ||
                          current == PlayerState.upwardAttack;

    if (isAttackState) {
      if (size.x != 96) {
        if (current == PlayerState.downwardAttack && !isGrounded && velocity.y > 0) {
          position.y -= (96 - size.y);
        }
        size.setValues(96, 96);
      }
    } else {
      if (size.x != 64) {
        if (current == PlayerState.downwardAttack && !isGrounded) {
          position.y += (size.y - 64);
        }
        size.setValues(64, 64);
      }
    }
  }

  void _onLand() {
    isGrounded = true;
    jumpCount = 0;
    canDashInAir = true;
    landingTimer = 0.1;
  }

  void executePogoJump() {
    velocity.y = jumpForce * 0.85;
    isGrounded = false;
    isAttacking = false;
    jumpCount = 1;
    canDashInAir = true;
  }

  void applyDamageKnockback(double otherX) {
    takeDamage();
    knockbackDirection = (position.x < otherX) ? -1.0 : 1.0;
    knockbackTimer = 0.22;
  }

  // ─── Inputs de Ação Públicos ───
  void jump() {
    if (knockbackTimer > 0 || isDashing || isDead || isHealing) return;
    if (isGrounded) {
      velocity.y = jumpForce;
      isGrounded = false;
      jumpCount = 1;
    } else if (hasDoubleJump && jumpCount < 2) {
      velocity.y = jumpForce * 0.85;
      jumpCount = 2;
    }
  }

  void triggerDash() {
    if (dashCooldownTimer > 0 || isDashing || knockbackTimer > 0 || isHealing || isDead) return;
    if (!isGrounded) {
      if (!canDashInAir) return;
      canDashInAir = false;
    }
    isDashing = true;
    dashTimer = dashDuration;
    dashCooldownTimer = dashCooldown;
  }

  void triggerParry() {
    if (isParrying || isDashing || knockbackTimer > 0 || isDead || isHealing) return;
    isParrying = true;
    parryTimer = parryDuration;
  }

  void triggerAttack() {
    if (isAttacking || isDashing || knockbackTimer > 0 || isDead || isHealing) return;
    isAttacking = true;
    attackTimer = attackDuration;

    if (verticalInput == -1) {
      attackDirection = -1;
    } else if (verticalInput == 1 && !isGrounded) {
      attackDirection = 1;
    } else {
      attackDirection = 0;
    }
    animationTicker?.reset();
  }

  void startHealing() {
    if (!isGrounded || currentHealth >= maxHealth || currentChi < 33.0 || isDashing || isAttacking || isDead) return;
    isHealing = true;
    healTimer = 0.0;
  }

  void stopHealing() {
    isHealing = false;
    healTimer = 0.0;
  }

  void completeHealing() {
    if (currentChi >= 33.0 && currentHealth < maxHealth) {
      currentHealth++;
      currentChi -= 33.0;
    }
    healTimer = 0.0;
    if (currentHealth >= maxHealth || currentChi < 33.0) stopHealing();
  }

  void takeDamage() {
    if (isInvulnerable || isDead) return;
    
    currentHealth--;
    isInvulnerable = true;
    invulnerableTimer = 1.0;
    
    if (currentHealth <= 0) {
      currentHealth = 0;
      _triggerDeath();
    }
  }

  void _triggerDeath() async {
    isDead = true;
    velocity.setZero();
    current = PlayerState.death;
    
    if (animationTicker != null) {
      await animationTicker!.completed;
    }
  }

  void onSuccessfulHit() => gainChi(10);

  void gainChi(double amount) {
    currentChi = (currentChi + amount).clamp(0.0, maxChi);
  }
}
