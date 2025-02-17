import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

import 'current_form_provider.dart';

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
    state = {};

    // Iterate over each input field
    for (var field in inputFields) {
      // Check if the field is required
      if (field.isRequired) {
        // Add the field to the state
        // state = [...state, field.id];
        state.addAll({field.id: GlobalObjectKey(field.id)});
      }

      // Check if the field is a TableField or AdvTableField
      if (field is TableField || field is AdvTableField) {
        List<List<InputField>> tableList = [];
        if (field is TableField) {
          tableList.addAll(field.inputFields ?? []);
        } else if (field is AdvTableField) {
          tableList.addAll(field.inputFields ?? []);
        }
        // Iterate over each row in the table
        for (var row in tableList) {
          // Iterate over each field in the row
          for (var subField in row) {
            // Check if the subField is required
            if (subField.isRequired) {
              // Add the subField to the state
              state.addAll({field.id: GlobalObjectKey(field.id)});
            }
          }
        }
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
}
