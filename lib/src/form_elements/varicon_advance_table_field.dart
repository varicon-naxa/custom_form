import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/models/custom_table_model.dart';
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
  });

  final AdvTableField field;
  final String labelText;

  ///Function to build image
  final Widget Function(Map<String, dynamic>) imageBuild;

  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTableState = ref.watch(customAdvanceRowProvider);

    return Column(
      children: currentTableState.map((singleData) {
        if (singleData.id == field.id) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  children:
                      (singleData.rowList ?? []).mapIndexed((index, model) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildTableRowContent(context, index, model, ref),
                );
              }).toList()),
            ],
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
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
          isExpanded: true,
          hasError: false,
        ),
        expandableChild: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: (model.inputFields ?? []).map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: VariconInputFields(
                  field: item,
                  apiCall: apiCall,
                  imageBuild: imageBuild,
                  attachmentSave: attachmentSave,
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
