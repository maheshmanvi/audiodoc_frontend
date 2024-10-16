class Pair<First, Second> {
  final First first;
  final Second second;

  Pair(this.first, this.second);

  @override
  String toString() => 'Pair($first, $second)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}

class Triple<First, Second, Third> {
  final First first;
  final Second second;
  final Third third;

  Triple(this.first, this.second, this.third);

  @override
  String toString() => 'Triple($first, $second, $third)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Triple &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second &&
          third == other.third;

  @override
  int get hashCode => first.hashCode ^ second.hashCode ^ third.hashCode;
}
