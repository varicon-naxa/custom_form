import 'package:flutter/material.dart';

import '../../../varicon_form_builder.dart';
import '../form_elements.dart';
import '../widgets/expandable_widget.dart';
import '../widgets/labeled_widget.dart';

/// Table input widget that handles both row and column based layouts
class TableInputWidget extends StatefulWidget {
  final TableField field;
  final String labelText;
  final bool isRequired;
  final TableStateManager tableManager;
  final Widget Function(InputField, BuildContext, {bool haslabel}) inputBuilder;

  const TableInputWidget({
    super.key,
    required this.field,
    required this.labelText,
    required this.isRequired,
    required this.tableManager,
    required this.inputBuilder,
  });

  @override
  State<TableInputWidget> createState() => TableInputWidgetState();
}

class TableInputWidgetState extends State<TableInputWidget> {
  late TableField currentField;
  final Map<String, GlobalKey> _fieldKeys = {};

  @override
  void initState() {
    super.initState();
    currentField =
        widget.tableManager.getTableState(widget.field.id) ?? widget.field;
    widget.tableManager.addListener(_onTableStateChanged);
    _initializeFieldKeys();
  }

  void _initializeFieldKeys() {
    if (currentField.inputFields != null) {
      for (var row in currentField.inputFields!) {
        for (var field in row) {
          _fieldKeys[field.id] = GlobalKey();
        }
      }
    }
  }

 // Add this method to handle scrolling to specific fields
  void scrollToField(String fieldId) {
    setState(() {
      // Find which row contains this field
      int? rowIndex;
      for (int i = 0; i < (widget.field.inputFields?.length ?? 0); i++) {
        if (widget.field.inputFields![i].any((field) => field.id == fieldId)) {
          rowIndex = i;
          break;
        }
      }

      if (rowIndex != null) {
        // Ensure the row is expanded
        // You might need to modify this based on your ExpandableWidget implementation
        // This is just a conceptual example
        Future.delayed(const Duration(milliseconds: 100), () {
          final context = this.context;
          if (context.mounted) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }
  void _onTableStateChanged() {
    setState(() {
      currentField =
          widget.tableManager.getTableState(widget.field.id) ?? widget.field;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LabeledWidget(
      labelText: widget.labelText,
      isRequired: widget.isRequired,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentField.isRow)
            _buildRowBasedTable(context)
          else
            _buildColumnBasedTable(context),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            onPressed: () async {
              await widget.tableManager.addRow(currentField);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Row'),
          )
        ],
      ),
    );
  }

  Widget _buildRowBasedTable(BuildContext context) {
    return Column(
      children: [
        for (int index = 0;
            index < (currentField.inputFields?.length ?? 0);
            index++)
          _buildTableRow(context, index),
      ],
    );
  }

  Widget _buildTableRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ExpandableWidget(
        expandableHeader: TableExpandableHeaderWidget(
          index: index,
          field: currentField,
        ),
        expandedHeader: TableExpandableHeaderWidget(
          index: index,
          field: currentField,
          isExpanded: true,
        ),
        expandableChild: Container(
          color: Colors.grey.shade200,
          child: Column(
            children:
                (currentField.inputFields?[index] ?? []).map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: KeyedSubtree(
                  key: _fieldKeys[item.id],
                  child: widget.inputBuilder(item, context, haslabel: true),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnBasedTable(BuildContext context) {
    return Column(
      children: [
        for (int columnIndex = 0;
            columnIndex < ((currentField.inputFields ?? [])[0]).length;
            columnIndex++)
          _buildColumnSection(context, columnIndex),
      ],
    );
  }

  Widget _buildColumnSection(BuildContext context, int columnIndex) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpandableWidget(
        initialExpanded: true,
        expandableHeader: _buildColumnHeader(columnIndex, false),
        expandedHeader: _buildColumnHeader(columnIndex, true),
        expandableChild: Column(
          children:
              (currentField.inputFields ?? []).asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final row = entry.value;
            final field = row[columnIndex];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: KeyedSubtree(
                key: _fieldKeys[field.id],
                child: widget.inputBuilder(
                  field,
                  context,
                  haslabel: rowIndex <= 0,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildColumnHeader(int columnIndex, bool isExpanded) {
    return Padding(
      padding: EdgeInsets.only(bottom: isExpanded ? 8 : 0),
      child: Row(
        children: [
          Text('Column ${columnIndex + 1}'),
          const Spacer(),
          Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fieldKeys.clear();
    widget.tableManager.removeListener(_onTableStateChanged);
    super.dispose();
  }
}
