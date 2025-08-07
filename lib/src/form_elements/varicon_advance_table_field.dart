import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/models/custom_table_model.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import 'package:varicon_form_builder/src/widget/expandable_widget.dart';
import '../../varicon_form_builder.dart';
import '../form_builder/varicon_input_fields.dart';
import '../state/custom_advance_table_row_provider.dart';
import '../widget/table_expandable_header_widget.dart';

class VariconAdvanceTableField extends ConsumerWidget {
  const VariconAdvanceTableField({
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

  final AdvTableField field;
  final String labelText;
  final String locationData;

  ///Function to build image
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Widget Function(File imageFile) customPainter;

  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;
  final Function(Map<String, dynamic> url) fileClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTableState = ref.watch(customAdvanceRowProvider);
    final singleData =
        currentTableState.firstWhereOrNull((element) => element.id == field.id);

    return Column(
        children: (singleData?.rowList ?? []).mapIndexed((index, model) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _buildTableRowContent(context, index, model, ref),
      );
    }).toList());
  }

  Widget _buildTableRowContent(
      BuildContext context, int index, CustomRowModel model, WidgetRef ref) {
    return KeyedSubtree(
      key: ValueKey(const Uuid().v4()),
      child: ExpandableWidget(
        initialExpanded: model.isExpanded,
        expandableHeader: TableExpandableHeaderWidget(
          index: index,
          hasError: false,
        ),
        expandedHeader: TableExpandableHeaderWidget(
          index: index,
          isExpanded: false,
          hasError: false,
        ),
        expandableChild: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: (model.inputFields ?? []).map<Widget>((item) {
              final singleField = ref
                  .read(currentStateNotifierProvider.notifier)
                  .getFieldWithAnswer(item);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: VariconInputFields(
                  locationData: locationData,
                  key: ValueKey(item.id), // Ensure unique key for each field
                  field: singleField,
                  apiCall: apiCall,
                  customPainter: customPainter,
                  hasCustomPainter: true,
                  imageBuild: imageBuild,
                  attachmentSave: attachmentSave,
                  fileClick: fileClick,
                ),
              );
            }).toList(),
          ),
        ),
        onExpandChanged: (expanded) {
          ref.read(customAdvanceRowProvider.notifier).changeExpansion(
                field.id,
                model.id ?? '',
                expanded,
              );
        },
      ),
    );
  }
}
