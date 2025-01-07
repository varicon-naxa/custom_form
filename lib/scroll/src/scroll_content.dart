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
      // print('Updating position for: ${widget.id}');

      // Get position relative to the viewport
      final Offset localPosition = renderBox.localToGlobal(Offset.zero);
      final Size size = renderBox.size;

      try {
        final ScrollPosition scrollPosition = Scrollable.of(context).position;
        final double scrollOffset = scrollPosition.pixels;
        // final double viewportHeight = scrollPosition.viewportDimension;

        // Calculate padding to show full field
        final double fieldPadding =
            size.height + 16.0; // Add some extra padding

        // Calculate absolute position with field-aware adjustment
        final double absoluteDy =
            localPosition.dy + scrollOffset - fieldPadding;

        // print('Position calculation for ${widget.id}:');
        // print('localPosition.dy: ${localPosition.dy}');
        // print('scrollOffset: $scrollOffset');
        // print('viewportHeight: $viewportHeight');
        // print('fieldHeight: ${size.height}');
        // print('absoluteDy: $absoluteDy');

        final Offset adjustedPosition = Offset(
          localPosition.dx,
          absoluteDy,
        );

        if (widget.isNested) {
          ScrollContentPosition.addNestedPosition(widget.id, adjustedPosition);
        } else {
          ScrollContentPosition.positions[widget.id] = adjustedPosition;
        }
      } catch (e) {
        print('Error updating position: $e');
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
