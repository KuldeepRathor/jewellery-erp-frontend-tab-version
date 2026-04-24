import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class CustomDebouncer {
  final int milliseconds;
  Timer? _timer;

  CustomDebouncer({this.milliseconds = 500});

  run(VoidCallback action) {
    if (_timer != null) {
      log("cancelled timer");
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
