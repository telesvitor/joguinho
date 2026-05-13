class PlayerStats {
  int maxHealth   = 120;
  int health      = 120;
  int soulOrbs    = 0;
  int attackLevel = 1;   // 1-5
  int dashCount   = 1;   // max consecutive dashes
  int healPower   = 25;

  // Derived
  double get attackMultiplier => 1.0 + (attackLevel - 1) * 0.20;

  void collectOrb() => soulOrbs++;

  bool spendOrbs(int cost) {
    if (soulOrbs < cost) return false;
    soulOrbs -= cost;
    return true;
  }

  void heal(int amount) {
    health = (health + amount).clamp(0, maxHealth);
  }
}