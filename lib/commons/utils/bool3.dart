import 'package:get/get.dart';

enum Bool3 {
  T,
  F,
  N;

  bool get isTrue => this == Bool3.T;

  bool get isNotTrue => this != Bool3.T;

  bool get isFalse => this == Bool3.F;

  bool get isNotFalse => this != Bool3.F;

  bool get isNone => this == Bool3.N;

  bool get isNotNone => this != Bool3.N;

  Bool3 get inverse => this == Bool3.T ? Bool3.F : Bool3.T;

  bool? get boolValue => this == Bool3.T
      ? true
      : this == Bool3.F
          ? false
          : null;

  factory Bool3.trueOrNone(bool? value) {
    if (value == true) return Bool3.T;
    return Bool3.N;
  }

  factory Bool3.falseOrNone(bool? value) {
    if (value == false) return Bool3.F;
    return Bool3.N;
  }

  factory Bool3.fromBool(bool value) {
    return value ? Bool3.T : Bool3.F;
  }

  factory Bool3.bool(bool? b) {
    if (b == null) return Bool3.N;
    return b ? Bool3.T : Bool3.F;
  }

  toggleTrueFalse() {
    return this == Bool3.T ? Bool3.F : Bool3.T;
  }

}

class RxBool3 extends Rx<Bool3> {
  RxBool3([super.initial = Bool3.N]);

  RxBool3.trueOrNone(bool? value) : super(Bool3.trueOrNone(value));

  RxBool3.falseOrNone(bool? value) : super(Bool3.falseOrNone(value));

  void toggle() {
    value = value.inverse;
  }
}
