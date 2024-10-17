import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  Duration? delay;
  Timer? _timer;

  Debounce({this.delay}) {
    delay ??= const Duration(milliseconds: 500);
  }

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(delay!, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
