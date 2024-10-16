enum PlayerSpeed {
  x0_25('0.25x', 0.25),
  x0_5('0.5x', 0.5),
  x1('1x', 1.0),
  x1_5('1.5x', 1.5),
  x1_75('1.75x', 1.75),
  x2('2x', 2.0);

  final String name;
  final double value;

  const PlayerSpeed(this.name, this.value);

  @override
  String toString() => name;
}
