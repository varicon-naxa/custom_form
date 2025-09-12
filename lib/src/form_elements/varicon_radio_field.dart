import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import 'package:varicon_form_builder/src/state/link_label_provider.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/custom_form_builder_radio_group.dart';
import '../models/value_text.dart';
import '../state/required_id_provider.dart';

class VariconRadioField extends ConsumerWidget {
  const VariconRadioField(
      {super.key,
      required this.field,
      required this.labelText,
      required this.imageBuild,
      this.isResponse,
      this.crossAxisCount,
      this.childAspectRatio});

  final RadioInputField field;
  final String labelText;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final bool? isResponse;
  final int? crossAxisCount;
  final double? childAspectRatio;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Debouncer debouncer = Debouncer(milliseconds: 500);

    // ValueText? initialValue = (field.answer ?? '').isEmpty
    //     ? null
    //     : field.choices
    //         .firstWhereOrNull((element) => element.value == field.answer);

    final currentValue = ref.watch(currentStateNotifierProvider)[field.id];
    ValueText? initialValue = currentValue != null && currentValue.isNotEmpty
        ? field.choices
            .firstWhereOrNull((element) => element.value == currentValue)
        : (field.answer ?? '').isEmpty
            ? null
            : field.choices
                .firstWhereOrNull((element) => element.value == field.answer);

    return CustomFromBuilderRadioGroup(
      name: const Uuid().v4(),
      isResponse: isResponse,
      actionMessage: field.actionMessage,

      /// if any of the choices has image not null then use horizontal otherwise 
      orientation:  field.choices.any((element) => element.image != null)
          ? OptionsOrientation.horizontal
          : OptionsOrientation.vertical,
      imageBuild: imageBuild,
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      otherText: (initialValue?.isOtherField == true &&
              field.selectedLinkListLabel != null)
          ? field.selectedLinkListLabel
          : null,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (field.isRequired && value == null) {
          return 'This field is required';
        } else if (value?.isOtherField == true &&
            (value?.value ?? '').trim().isEmpty) {
          return 'Please specify other in textbox';
        }
        return null;
      },
      onChanged: (value) {
        if (value != null) {
          ref
              .read(currentStateNotifierProvider.notifier)
              .saveString(field.id, value.value);
          ref.read(linklabelProvider.notifier).saveString(field.id, value.text);
        }
      },
      onOtherSelectedValue: (isSelected, text) {
        if (isSelected && field.isRequired == false) {
          ref
              .read(requiredNotifierProvider.notifier)
              .addRequiredField(field.id, GlobalObjectKey(field.id));
        } else if (isSelected == false && field.isRequired == false) {
          ref.read(requiredNotifierProvider.notifier).remove(field.id);
        }
        if (isSelected == true) {
          // debouncer.run(() {
          ref.read(linklabelProvider.notifier).saveString(field.id, text);
          ref.read(radiotherFieldValue.notifier).state =
              ValueText(isOtherField: isSelected, value: text, text: '');
          // });
        } else {
          ref.read(linklabelProvider.notifier).remove(field.id);
        }
      },
      options: field.choices
          .map((lang) => FormBuilderFieldOption(
                value: lang,
                child: Text((lang.isOtherField ?? false)
                    ? 'Other (please specify)'
                    : lang.text),
              ))
          .toList(growable: false),
    );
  }
}

final radiotherFieldValue = StateProvider<ValueText?>((ref) => null);
