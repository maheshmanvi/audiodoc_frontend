import 'dart:async';

class Debounce {
  Timer? _timer;

  void call(Function callback, Duration delay) {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer(delay, () => callback());
  }

  void dispose() {
    _timer?.cancel();
  }
}