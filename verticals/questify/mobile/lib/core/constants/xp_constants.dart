class XpConstants {
  XpConstants._();

  static const Map<String, int> xpByDifficulty = {
    'trivial': 25,
    'easy': 50,
    'medium': 100,
    'hard': 250,
    'deadly': 500,
    'legendary': 1000,
  };

  static const Map<String, String> difficultyLabels = {
    'trivial': 'Trivial (CR 0-1)',
    'easy': 'Easy (CR 2-4)',
    'medium': 'Medium (CR 5-10)',
    'hard': 'Hard (CR 11-16)',
    'deadly': 'Deadly (CR 17-20)',
    'legendary': 'Legendary (CR 21+)',
  };

  static const Map<String, String> abilityScoreLabels = {
    'str': 'STR',
    'dex': 'DEX',
    'con': 'CON',
    'int_score': 'INT',
    'wis': 'WIS',
    'cha': 'CHA',
  };

  static const Map<String, String> abilityScoreFullLabels = {
    'str': 'Strength',
    'dex': 'Dexterity',
    'con': 'Constitution',
    'int_score': 'Intelligence',
    'wis': 'Wisdom',
    'cha': 'Charisma',
  };

  static int modifier(int score) => ((score - 10) / 2).floor();

  static String modifierString(int score) {
    final mod = modifier(score);
    return mod >= 0 ? '+$mod' : '$mod';
  }
}
