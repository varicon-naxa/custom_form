
import 'package:flutter/material.dart';

class TableExpandableHeaderWidget extends StatelessWidget {
  final int index;
  final dynamic field;
  final bool isExpanded;
  final bool hasError;

  const TableExpandableHeaderWidget({
    super.key,
    required this.index,
    required this.field,
    this.isExpanded = false,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(
          color: hasError
              ? Theme.of(context).colorScheme.error
              : isExpanded
                  ? Colors.transparent
                  : Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            'Row ${index + 1}',
            style: TextStyle(
              color: hasError ? Theme.of(context).colorScheme.error : null,
              fontWeight: hasError ? FontWeight.bold : null,
            ),
          ),
          const Spacer(),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 18,
              ),
            ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: hasError ? Theme.of(context).colorScheme.error : null,
          ),
        ],
      ),
    );
  }
}
