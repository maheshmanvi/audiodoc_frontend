import 'dart:async';

import 'package:flutter/material.dart';

Future<void> waitForFrame() {
  final Completer<void> completer = Completer<void>();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    completer.complete();
  });
  return completer.future;
}