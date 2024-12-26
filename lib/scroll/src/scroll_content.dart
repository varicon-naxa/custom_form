import 'package:flutter/material.dart';

class ScrollContent extends StatefulWidget {
  final String id;
  final Widget child;
  final bool isNested; // Add this to identify nested content

  const ScrollContent({
    required this.id,
    required this.child,
    this.isNested = false, // Default to false
    super.key,
  });

  @override
  State<ScrollContent> createState() => _ScrollContentState();
}

class _ScrollContentState extends State<ScrollContent> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePosition();
    });
  }

  void _updatePosition() {
    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      // Get position relative to the viewport instead of global position
      final Offset localPosition = renderBox.localToGlobal(Offset.zero);
      final Size size = renderBox.size;
      final ScrollPosition scrollPosition = Scrollable.of(context).position;
      final double scrollOffset = scrollPosition.pixels;

      // Calculate the top position by subtracting the scroll offset
      final Offset adjustedPosition = Offset(
          localPosition.dx,
          localPosition.dy -
              scrollOffset -
              size.height // Subtract height to get starting position
          );

      if (widget.isNested) {
        ScrollContentPosition.addNestedPosition(widget.id, adjustedPosition);
      } else {
        ScrollContentPosition.positions[widget.id] = adjustedPosition;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}

class ScrollContentPosition {
  static final Map<String, Offset> positions = {};
  static final Map<String, Offset> nestedPositions = {};

  static void addNestedPosition(String id, Offset position) {
    nestedPositions[id] = position;
  }

  static Offset? getPosition(String id) {
    // Get the scroll offset for the element
    final Offset? position = nestedPositions[id] ?? positions[id];
    if (position == null) return Offset.zero;

    // Convert global position to scroll offset
    // You might need to adjust this based on any app bars or fixed headers
    return position;
  }
}
