// import 'package:flutter/material.dart';

// /// ScrollContent is widget for you to get the height of its widget.
// /// id and child is required parameter.
// class ScrollContent {
//   /// Name the id to get scroll position.
//   final String id;

//   /// scroll position is the top of child.
//   final Widget child;

//   ScrollContent({required this.id, required this.child});
// }
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