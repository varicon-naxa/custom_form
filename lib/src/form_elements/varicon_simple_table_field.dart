import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/state/table_row_provider.dart';
import 'package:varicon_form_builder/src/widget/expandable_widget.dart';
import 'package:varicon_form_builder/src/widget/label_widget.dart';
import '../../varicon_form_builder.dart';
import '../form_builder/varicon_input_fields.dart';
import '../state/required_id_provider.dart';
import '../state/table_row_expanded_provider.dart';
import '../widget/table_expandable_header_widget.dart';

class VariconSimpleTableField extends StatefulHookConsumerWidget {
  const VariconSimpleTableField({
    super.key,
    required this.field,
    required this.labelText,
    required this.imageBuild,
    required this.apiCall,
    required this.attachmentSave,
  });

  final TableField field;
  final String labelText;

  ///Function to build image
  final Widget Function(Map<String, dynamic>) imageBuild;

  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  ConsumerState<VariconSimpleTableField> createState() =>
      _VariconSimpleTableFieldState();
}

class _VariconSimpleTableFieldState
    extends ConsumerState<VariconSimpleTableField> {
  List<List<InputField>> rows = [];

  @override
  void initState() {
    super.initState();
    rows.addAll(widget.field.inputFields ?? []);
    setState(() {});
  }

  void addNewRow() {
    if ((widget.field.inputFields ?? []).isEmpty) return;

    List<InputField> newRow = (widget.field.inputFields ?? [])[0].map((field) {
      return _generateNewFieldId(field);
    }).toList();
    rows.add(newRow);
    ref
        .read(requiredNotifierProvider.notifier)
        .addRequiredForEachTableRow(newRow);
    setState(() {});
  }

  /// Generates a new unique ID for a field and its nested components.
  ///
  /// This method:
  /// - Creates a deep copy of the field
  /// - Generates new UUIDs for all field IDs
  /// - Clears any existing answers or keys
  /// - Maintains other field properties
  ///
  /// [field] The field to generate new IDs for
  /// Returns a new [InputField] with updated IDs
  InputField _generateNewFieldId(InputField field) {
    var uuid = const Uuid();

    Map<String, dynamic> updateId(Map<String, dynamic> item) {
      return Map.from(item).map((key, value) {
        if (key == 'id' && value is String) {
          return MapEntry(key, 'item-${uuid.v4()}');
        }
        if (key == 'key' || key == 'answer') {
          return MapEntry(key, null);
        }
        if (value is Map<String, dynamic>) {
          return MapEntry(key, updateId(value));
        }
        if (value is List) {
          return MapEntry(
              key,
              value
                  .map((e) => e is Map<String, dynamic> ? updateId(e) : e)
                  .toList());
        }
        return MapEntry(key, value);
      });
    }

    // Preserve attachments for instruction fields
    if (field is InstructionInputField) {
      return InstructionInputField.fromJson({
        ...updateId(field.toJson()),
        'attachments': field.attachments, // Keep existing attachments
      });
    }

    return InputField.fromJson(updateId(field.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return LabelWidget(
      labelText: widget.labelText,
      isRequired: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              for (int index = 0; index < ((rows).length); index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: index == 0
                      ? TableRowContent(
                          index: index,
                          field: widget.field,
                          rows: rows,
                          apiCall: widget.apiCall,
                          imageBuild: widget.imageBuild,
                          attachmentSave: widget.attachmentSave,
                        )
                      : Dismissible(
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
                                  content: const Text(
                                      'Are you sure you want to delete this row?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('CANCEL'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Call delete row on table manager
                                        Navigator.of(context).pop(true);
                                      },
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
                            ref
                                .read(requiredNotifierProvider.notifier)
                                .deleteRow(rows[
                                    index]); // Call delete row on table manager

                            ref
                                .read(tableRowKeyProvider.notifier)
                                .deteteRow(index);
                            rows.removeAt(index);
                          },
                          child: TableRowContent(
                            index: index,
                            field: widget.field,
                            rows: rows,
                            apiCall: widget.apiCall,
                            imageBuild: widget.imageBuild,
                            attachmentSave: widget.attachmentSave,
                          ),
                        ),
                ),
            ],
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            onPressed: () {
              addNewRow();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Row'),
          )
        ],
      ),
    );
  }
}

class TableRowContent extends ConsumerWidget {
  final int index;
  final TableField field;
  final List<List<InputField>> rows;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  const TableRowContent({
    Key? key,
    required this.index,
    required this.field,
    required this.rows,
    required this.apiCall,
    required this.imageBuild,
    required this.attachmentSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandState = ref.watch(expandStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandableWidget(
          initialExpanded: expandState,
          expandableHeader: TableExpandableHeaderWidget(
            index: index,
            field: field.copyWith(inputFields: rows),
            hasError: false,
          ),
          expandedHeader: TableExpandableHeaderWidget(
            index: index,
            field: field.copyWith(inputFields: rows),
            isExpanded: true,
            hasError: false,
          ),
          expandableChild: Container(
            color: Colors.grey.shade200,
            child: Column(
              children: rows[index].map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: KeyedSubtree(
                    key: ObjectKey(item.id),
                    child: VariconInputFields(
                      field: item,
                      apiCall: apiCall,
                      imageBuild: imageBuild,
                      attachmentSave: attachmentSave,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          onExpandChanged: (expanded) {
            ref.read(expandStateProvider.notifier).state =
                !(ref.read(expandStateProvider.notifier).state);
          },
        ),
      ],
    );
  }
}

final expandStateProvider = StateProvider<bool>((ref) => true);
