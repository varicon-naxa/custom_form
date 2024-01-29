import 'dart:async';

import 'package:flutter/material.dart';

///Debouncer class for search feature
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 1000});

  ///checks the timer with durations
  run(VoidCallback action) {
    if (_timer != null || (_timer?.isActive ?? false)) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}