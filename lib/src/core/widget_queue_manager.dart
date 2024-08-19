import 'dart:developer';

import 'package:flutter/material.dart';

class WidgetQueueManager {
  final List<Widget Function()> _queue = [];
  final int _maxConcurrentLoads;
  int _currentLoads = 0;
  final List<Widget> _processedWidgets = [];

  WidgetQueueManager({int maxConcurrentLoads = 1})
      : _maxConcurrentLoads = maxConcurrentLoads;

  void addWidget(Widget Function() widgetBuilder) {
    _queue.add(widgetBuilder);
    _processQueue();
  }

  void _processQueue() {
    // Check if there are more widgets to process and if we are below the max concurrent load limit
    while (_queue.isNotEmpty && _currentLoads < _maxConcurrentLoads) {
      final widgetBuilder = _queue.removeAt(0);
      _currentLoads++;

      // Simulate widget processing
      Future.delayed(const Duration(milliseconds: 100), () {
        log('Widget processed');
        // You can perform any asynchronous operations here
        _processedWidgets.add(widgetBuilder());
        _currentLoads--;
        _processQueue(); // Continue processing the queue
      });
    }
  }

  List<Widget> getProcessedWidgets() {
    return _processedWidgets;
  }
}
