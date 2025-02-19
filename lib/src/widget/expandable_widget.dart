import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  const ExpandableWidget({
    super.key,
    required this.expandableHeader,
    required this.expandedHeader,
    required this.expandableChild,
    this.initialExpanded = false,
    this.onExpandChanged,
  });

  final Widget expandableHeader;
  final Widget expandedHeader;
  final Widget expandableChild;
  final bool? initialExpanded;
  final Function(bool)? onExpandChanged;

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  late ExpandableController controller;

  @override
  void initState() {
    super.initState();
    controller =
        ExpandableController(initialExpanded: widget.initialExpanded ?? false);
    controller.addListener(_onExpandedChanged);
  }

  void _onExpandedChanged() {
    widget.onExpandChanged?.call(controller.expanded);
  }

  @override
  void dispose() {
    controller.removeListener(_onExpandedChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: controller,
      child: Expandable(
        collapsed: ExpandableButton(
          child: widget.expandableHeader,
        ),
        expanded: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpandableButton(
              child: widget.expandedHeader,
            ),
            widget.expandableChild,
          ],
        ),
      ),
    );
  }
}
