import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/models/custom_table_model.dart';
import 'package:varicon_form_builder/src/state/custom_simple_table_row_provider.dart';
import 'package:varicon_form_builder/src/widget/expandable_widget.dart';
import '../../varicon_form_builder.dart';
import '../form_builder/varicon_input_fields.dart';
import '../state/required_id_provider.dart';
import '../widget/table_expandable_header_widget.dart';

class VariconSimpleTableField extends ConsumerWidget {
  const VariconSimpleTableField({
    super.key,
    required this.field,
    required this.labelText,
    required this.imageBuild,
    required this.apiCall,
    required this.attachmentSave,
    required this.customPainter,
    required this.locationData,
    required this.fileClick,
  });

  final TableField field;
  final String labelText;

  ///Function to build image
  final Widget Function(Map<String, dynamic>) imageBuild;

  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  final Widget Function(File imageFile) customPainter;
  final String locationData;
  final Function(Map<String, dynamic> url) fileClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a selective consumer for just the rows we need
    return Consumer(
      builder: (context, ref, child) {
        final currentTableState = ref.read(customSimpleRowProvider);
        final singleData = currentTableState
            .firstWhereOrNull((element) => element.id == field.id);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: (singleData?.rowList ?? []).mapIndexed((index, model) {
                // Each row is wrapped in its own consumer
                return _TableRow(
                  key: ValueKey(model.id),
                  index: index,
                  model: model,
                  field: field,
                  locationData: locationData,
                  apiCall: apiCall,
                  customPainter: customPainter,
                  imageBuild: imageBuild,
                  attachmentSave: attachmentSave,
                  fileClick: fileClick,
                );
              }).toList(),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: const BorderSide(color: Colors.grey),
              ),
              onPressed: () => _addNewRow(ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Row'),
            )
          ],
        );
      },
    );
  }

  void _addNewRow(WidgetRef ref) {
    if ((field.inputFields ?? []).isEmpty) return;

    List<InputField> newRow = (field.inputFields ?? [])[0].map((field) {
      return generateNewFieldId(field);
    }).toList();

    ref
        .read(requiredNotifierProvider.notifier)
        .addRequiredForEachTableRow(newRow);

    ref.read(customSimpleRowProvider.notifier).addNewRow(
          field.id,
          newRow,
        );
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
  InputField generateNewFieldId(InputField field) {
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
}

// Separate stateless widget for each row
class _TableRow extends ConsumerWidget {
  const _TableRow({
    Key? key,
    required this.index,
    required this.model,
    required this.field,
    required this.locationData,
    required this.apiCall,
    required this.customPainter,
    required this.imageBuild,
    required this.attachmentSave,
    required this.fileClick,
  }) : super(key: key);

  final int index;
  final CustomRowModel model;
  final TableField field;
  final String locationData;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;
  final Widget Function(File imageFile) customPainter;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;
  final Function(Map<String, dynamic> url) fileClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey(model.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) => _confirmDelete(context),
        onDismissed: (direction) => _deleteRow(ref),
        child: _buildExpandableContent(context, ref),
      ),
    );
  }

  Widget _buildExpandableContent(BuildContext context, WidgetRef ref) {
    return ExpandableWidget(
      key: ValueKey(model.id),
      initialExpanded: model.isExpanded,
      expandableHeader: TableExpandableHeaderWidget(
        index: index,
        hasError: false,
      ),
      expandedHeader: TableExpandableHeaderWidget(
        index: index,
        isExpanded: true,
        hasError: false,
      ),
      expandableChild: _ExpandedContent(
        model: model,
        locationData: locationData,
        apiCall: apiCall,
        customPainter: customPainter,
        imageBuild: imageBuild,
        attachmentSave: attachmentSave,
        fileClick: fileClick,
      ),
      onExpandChanged: (expanded) => _updateExpansion(ref, expanded),
    );
  }

  void _updateExpansion(WidgetRef ref, bool expanded) {
    ref.read(customSimpleRowProvider.notifier).changeExpansion(
          field.id,
          model.id ?? '',
          expanded,
        );
  }

  void _deleteRow(WidgetRef ref) {
    ref
        .read(requiredNotifierProvider.notifier)
        .deleteRow(model.inputFields ?? []);
    ref
        .read(customSimpleRowProvider.notifier)
        .deleteRow(field.id, model.id ?? '');
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Row'),
              content: const Text('Are you sure you want to delete this row?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      const Text('DELETE', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

// Separate widget for expanded content
class _ExpandedContent extends StatelessWidget {
  const _ExpandedContent({
    Key? key,
    required this.model,
    required this.locationData,
    required this.apiCall,
    required this.customPainter,
    required this.imageBuild,
    required this.attachmentSave,
    required this.fileClick,
  }) : super(key: key);

  final CustomRowModel model;
  final String locationData;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;
  final Widget Function(File imageFile) customPainter;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;
  final Function(Map<String, dynamic> url) fileClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: (model.inputFields ?? []).map<Widget>((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: VariconInputFields(
              key: ValueKey(item.id),
              field: item,
              locationData: locationData,
              apiCall: apiCall,
              customPainter: customPainter,
              imageBuild: imageBuild,
              attachmentSave: attachmentSave,
              fileClick: fileClick,
            ),
          );
        }).toList(),
      ),
    );
  }
}
