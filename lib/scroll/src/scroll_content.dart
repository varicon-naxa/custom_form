import 'package:flutter/material.dart';

/// ScrollContent is a widget that provides the ability to get the height of its child widget.
/// `id` and `child` are required parameters.
class ScrollContent extends StatelessWidget {
  /// Name the id to get scroll position.
  final String id;

  /// Scroll position is the top of child.
  final Widget child;

  const ScrollContent({required this.id, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return child; // Return the widget that you want to display
  }
}
