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
  final Map<int, bool> _expandedRows = {};
  // Track which rows have validation errors
  final Map<int, bool> _rowValidationErrors = {};

  @override
  void initState() {
    super.initState();
    currentField =
        widget.tableManager.getTableState(widget.field.id) ?? widget.field;
    widget.tableManager.addListener(_onTableStateChanged);
    _initializeFieldKeys();
    _initializeExpandedState();
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
          widget.tableManager.getTableState(widget.field.id) ?? widget.field;
      _initializeFieldKeys();
      // Clear validation errors when data changes
      _rowValidationErrors.clear();
    });
  }

  void _initializeExpandedState() {
    for (int i = 0; i < (currentField.inputFields?.length ?? 0); i++) {
      _expandedRows[i] = true;
    }
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
    // Don't allow swipe delete for first row
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _buildRowContent(context, index),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey('row_$index'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        confirmDismiss: (direction) async {
          // Show confirmation dialog
          return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Row'),
                content:
                    const Text('Are you sure you want to delete this row?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'DELETE',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          // Call delete row on table manager
          widget.tableManager.deleteRow(currentField, index);
        },
        child: _buildRowContent(context, index),
      ),
    );
  }

  // Extract row content to separate method
  Widget _buildRowContent(BuildContext context, int index) {
    final isExpanded = isRowExpanded(index);
    print('Building row $index with expanded state: $isExpanded'); // Debug

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandableWidget(
          initialExpanded: isExpanded,
          expandableHeader: TableExpandableHeaderWidget(
            index: index,
            field: currentField,
            hasError: hasRequiredFieldErrors(index),
          ),
          expandedHeader: TableExpandableHeaderWidget(
            index: index,
            field: currentField,
            isExpanded: true,
            hasError: hasRequiredFieldErrors(index),
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
          onExpandChanged: (expanded) {
            print('Row $index expansion changed to: $expanded'); // Debug
            setRowExpanded(index, expanded);
          },
        ),
        if (hasRequiredFieldErrors(index))
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              'This row contains required fields',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  // Method to check if a row has required field errors
  bool hasRequiredFieldErrors(int index) {
    return _rowValidationErrors[index] ?? false;
  }

  // Method to be called during form validation
  void validateRow(int index) {
    bool hasError = false;
    for (var field in currentField.inputFields![index]) {
      var fieldKey = _fieldKeys[field.id];
      if (fieldKey?.currentContext != null) {
        final formState = Form.of(fieldKey!.currentContext!);
        if (formState != null) {
          if (!formState.validate()) {
            hasError = true;
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        if (hasError) {
          _rowValidationErrors[index] = true;
        } else {
          _rowValidationErrors.remove(index); // Remove error state if valid
        }
      });
    }
  }

  // Method to validate all rows
  void validateAllRows() {
    for (int i = 0; i < (currentField.inputFields?.length ?? 0); i++) {
      validateRow(i);
    }
  }

  bool isRowExpanded(int index) {
    return _expandedRows[index] ?? true;
  }

  void setRowExpanded(int index, bool expanded) {
    print('Setting row $index expanded state to: $expanded'); // Debug
    if (mounted) {
      setState(() {
        _expandedRows[index] = expanded;
      });
    }
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
