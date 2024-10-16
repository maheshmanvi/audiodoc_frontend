abstract class Either<L, R> {

  const Either();

  factory Either.left(L value) = Left<L, R>;

  factory Either.right(R value) = Right<L, R>;

  bool get isPresent => isRight && right != null;

  bool get isAbsent => isLeft || right == null;

  T fold<T>(T Function(L) leftFn, T Function(R) rightFn);

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L get left => (this as Left).value;
  R get right => (this as Right).value;

}

class Left<L, R> extends Either<L, R> {
  final L value;

  Left(this.value);

  @override
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) => leftFn(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;

  Right(this.value);

  @override
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) => rightFn(value);
}
