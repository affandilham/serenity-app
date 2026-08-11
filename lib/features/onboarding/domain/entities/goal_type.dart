enum GoalType {
  quit,
  reduce,
  understandPatterns;

  String get storageValue => switch (this) {
    GoalType.quit => 'quit',
    GoalType.reduce => 'reduce',
    GoalType.understandPatterns => 'understand_patterns',
  };

  String get label => switch (this) {
    GoalType.quit => 'Saya mau berhenti sepenuhnya',
    GoalType.reduce => 'Saya mau mengurangi dulu',
    GoalType.understandPatterns =>
      'Saya belum tahu, saya mau memahami pola saya',
  };

  static GoalType fromStorage(String value) => switch (value) {
    'quit' => GoalType.quit,
    'reduce' => GoalType.reduce,
    'understand_patterns' => GoalType.understandPatterns,
    _ => throw ArgumentError.value(value, 'value', 'Unknown goal type'),
  };
}
