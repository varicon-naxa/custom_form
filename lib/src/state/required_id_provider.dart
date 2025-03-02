import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:varicon_form_builder/src/state/custom_advance_table_row_provider.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

import 'current_form_provider.dart';
import 'custom_simple_table_row_provider.dart';

final requiredNotifierProvider =
    StateNotifierProvider<RequiredIdNotifier, Map<String, dynamic>>((ref) {
  return RequiredIdNotifier(ref);
});

class RequiredIdNotifier extends StateNotifier<Map<String, dynamic>> {
  RequiredIdNotifier(this.ref) : super({});
  Ref ref;

  void remove(String k) => state.remove(k);

  void addRequiredField(String k, GlobalObjectKey key) {
    state.addAll({k: key});
  }

  void removeRequiredField(String k) {
    state.remove(k);
  }

  void initialList(List<InputField> inputFields) {
    // Clear the current state

    // Iterate over each input field
    for (var field in inputFields) {
      // Check if the field is required
      if (field.isRequired) {
        // Add the field to the state
        // state = [...state, field.id];
        addKey(field);

        // state.addAll({field.id: GlobalObjectKey(field.id)});
      }

      // Check if the field is a TableField or AdvTableField
      if (field is TableField || field is AdvTableField) {
        // String id = field.id;
        List<List<InputField>> tableList = [];
        if (field is TableField) {
          ref.read(customSimpleRowProvider.notifier).addInitialTableList(field);
          tableList.addAll(field.inputFields ?? []);
        } else if (field is AdvTableField) {
          ref
              .read(customAdvanceRowProvider.notifier)
              .addInitialTableList(field);

          tableList.addAll(field.inputFields ?? []);
        }
        // Iterate over each row in the table
        for (var rowEntry in tableList.asMap().entries) {
          // Iterate over each field in the row
          for (var subField in rowEntry.value) {
            // Check if the subField is required
            if (subField.isRequired) {
              // Add the subField to the state
              addKey(subField);

              // state.addAll({subField.id: GlobalObjectKey(subField.id)});
            }
          }
        }
      }
    }
  }

  addKey(InputField field) {
    if (field is TextInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_text')});
    } else if (field is NumberInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_number')});
    } else if (field is EmailInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_email')});
    } else if (field is PhoneInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_phone')});
    } else if (field is DateInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_date')});
    } else if (field is TimeInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_time')});
    } else if (field is DateTimeInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_datetime')});
    } else if (field is SignatureInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_signature')});
    } else if (field is MultiSignatureInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_multi_signature')});
    } else if (field is ImageInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_image')});
    } else if (field is FileInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_file')});
    } else if (field is RadioInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_radio')});
    } else if (field is YesNoInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_yesno')});
    } else if (field is YesNoNaInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_yesnona')});
    } else if (field is CheckboxInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_checkbox')});
    } else if (field is DropdownInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_dropdown')});
    } else if (field is MultipleInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_multiple')});
    } else if (field is SectionInputField) {
      state.addAll({field.id: GlobalObjectKey('${field.id}_section')});
    } else {
      state.addAll({field.id: GlobalObjectKey(field.id)});
    }
  }

  void addRequiredForEachTableRow(List<InputField> inputFields) {
    // Iterate over each input field
    for (var field in inputFields) {
      // Check if the field is required
      if (field.isRequired) {
        // Add the field to the state
        // state = [...state, field.id];
        addKey(field);

        // state.addAll({field.id: GlobalObjectKey(field.id)});
      }
    }
  }

  void deleteRow(List<InputField> inputFields) {
    Map<String, dynamic> answer = state;
    // Iterate over each input field
    for (var field in inputFields) {
      // Check if the field is required
      if (field.isRequired) {
        // Remove the field to the state
        // state = [...state, field.id];
        answer.remove(field.id);
      }
    }
  }

  BuildContext? getInitialRequiredContext() {
    Map<String, dynamic> answer = ref.read(currentStateNotifierProvider);
    for (var key in state.keys) {
      if (!answer.containsKey(key)) {
        return state[key].currentContext;
      }
    }
    return null;
  }

  String? getInitialRequiredContextId() {
    Map<String, dynamic> answer = ref.read(currentStateNotifierProvider);
    for (var key in state.keys) {
      if (!answer.containsKey(key)) {
        return key;
      }
    }
    return null;
  }
}
