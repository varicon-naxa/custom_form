import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableWidget extends StatelessWidget {
  const ExpandableWidget({
    super.key,
    required this.expandableHeader,
    required this.expandedHeader,
    required this.expandableChild,
    this.initialExpanded = false,
  });

  final Widget expandableHeader;
  final Widget expandedHeader;
  final Widget expandableChild;
  final bool? initialExpanded;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: initialExpanded,
      child: Expandable(
          collapsed: ExpandableButton(child: expandableHeader),
          expanded: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExpandableButton(
                child: expandedHeader,
              ),
              expandableChild,
            ],
          )),
    );
  }
}

