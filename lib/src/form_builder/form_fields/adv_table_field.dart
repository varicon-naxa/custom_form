import 'package:flutter/material.dart';

import '../../../varicon_form_builder.dart';
import '../form_elements.dart';
import '../widgets/expandable_widget.dart';
import '../widgets/labeled_widget.dart';

/// Advanced Table input widget that handles both row and column based layouts
/// Similar to TableInputWidget but without the ability to add rows
class AdvTableInputWidget extends StatefulWidget {
  final AdvTableField field;
  final String labelText;
  final bool isRequired;
  final TableStateManager tableManager;
  final Widget Function(InputField, BuildContext, {bool haslabel}) inputBuilder;

  const AdvTableInputWidget({
    super.key,
    required this.field,
    required this.labelText,
    required this.isRequired,
    required this.tableManager,
    required this.inputBuilder,
  });

  @override
  State<AdvTableInputWidget> createState() => AdvTableInputWidgetState();
}

class AdvTableInputWidgetState extends State<AdvTableInputWidget> {
  late AdvTableField currentField;

  final Map<String, GlobalKey> _fieldKeys = {};

  final Map<int, bool> _expandedRows = {};
  // Track which rows have validation errors
  final Map<int, bool> _rowValidationErrors = {};
  // Add new map to track column validation errors
  final Map<int, bool> _columnValidationErrors = {};

  @override
  void initState() {
    super.initState();
    currentField =
        widget.tableManager.getAdvTableState(widget.field.id) ?? widget.field;
    widget.tableManager.addListener(_onTableStateChanged);
    _initializeFieldKeys();
  }

  void _initializeFieldKeys() {
    _fieldKeys.clear();
    if (currentField.inputFields != null) {
      for (var row in currentField.inputFields!) {
        for (var field in row) {
          if (!_fieldKeys.containsKey(field.id)) {
            _fieldKeys[field.id] = GlobalKey();
          }
        }
      }
    }
  }

  void _onTableStateChanged() {
    setState(() {
      currentField =
          widget.tableManager.getAdvTableState(widget.field.id) ?? widget.field;
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
        initialExpanded: true,
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

  // Method to validate all rows and clear resolved errors
  void validateAndClearErrors() {
    for (int i = 0; i < (currentField.inputFields?.length ?? 0); i++) {
      validateAdvTableRow(i); // Validate each row
    }
    // Clear any rows that are valid
    setState(() {
      _rowValidationErrors
          .removeWhere((key, value) => !value); // Remove valid rows
    });
  }

  // Method to validate all rows
  void validateAllRows() {
    for (int i = 0; i < (currentField.inputFields?.length ?? 0); i++) {
      validateAdvTableRow(i); // Validate each row
    }
  }

  // Method to validate a specific row
  void validateAdvTableRow(int index) {
  bool hasError = false;
    for (var field in currentField.inputFields![index]) {
      var fieldKey = _fieldKeys[field.id];
      if (fieldKey?.currentContext != null) {
        // Use Form.of() to get the form state
        final formState = Form.of(fieldKey!.currentContext!);
        // Validate the specific field
        if (field.isRequired && !formState.validate()) {
          hasError = true;
          break;
        }
      }
    }

    if (mounted) {
      setState(() {
        if (hasError) {
          _rowValidationErrors[index] = true;
        } else {
          // Remove the error state when all required fields are filled
          _rowValidationErrors.remove(index);
        }
      });
    }
  }

  // Call validateAndClearErrors when the user submits the form
  void onSubmit() {
    validateAndClearErrors(); // Validate and clear errors
    // Additional submission logic...
  }

  // Call validateAllRows when needed, e.g., on a button press
  void onValidateAll() {
    validateAllRows(); // Validate all rows
  }

  bool isRowExpanded(int index) {
    return _expandedRows[index] ?? true;
  }

  void setRowExpanded(int index, bool expanded) {
    if (mounted) {
      setState(() {
        _expandedRows[index] = expanded;
      });
    }
  }

    // Method to get row context
  BuildContext? getRowContext(int index) {
    return _fieldKeys[currentField.inputFields![index].first.id]
        ?.currentContext;
  }

  @override
  void dispose() {
    _fieldKeys.clear();
    widget.tableManager.removeListener(_onTableStateChanged);
    super.dispose();
  }
}
