import 'package:flutter/material.dart';

///Custom form labeled widget
// ignore: must_be_immutable
class LabelWidget extends StatelessWidget {
  LabelWidget({
    super.key,
    required this.labelText,
    required this.child,
    required this.isRequired,
    this.hasSpacing = true,
    this.isEditable = true,
  });
  String? labelText;
  bool isEditable;

  ///Check if field is required
  final bool isRequired;

  ///Field child widget
  Widget child;
  bool hasSpacing;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEditable,
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(
            hasSpacing ? 12.0 : 0,
          ),
          child: Column(
            spacing: 6.0,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((labelText ?? '').isNotEmpty)
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: labelText,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.black),
                      ),
                      if (isRequired)
                        const TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
