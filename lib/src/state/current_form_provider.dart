import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:varicon_form_builder/src/state/custom_simple_table_row_provider.dart';
import '../../varicon_form_builder.dart';
import 'link_label_provider.dart';

final currentStateNotifierProvider =
    StateNotifierProvider<CurrentFormNotifier, Map<String, dynamic>>((ref) {
  return CurrentFormNotifier(ref);
});

class CurrentFormNotifier extends StateNotifier<Map<String, dynamic>> {
  CurrentFormNotifier(this.ref) : super({});

  Ref ref;

  Map<String, dynamic> initialAnswer = {};

  void remove(String k) => state.remove(k);
  void autoremove(String k) => state.remove(k);

  bool checkInitialFinalAnswerIdentical() {
    final deepEq = const DeepCollectionEquality().equals;
    return deepEq(state, initialAnswer);
  }

  InputField singlefieldAnswer(
      InputField currentField, Map<String, dynamic> selectedListLabel) {
    InputField field = currentField;
    if (field is TextInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is SignatureInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is MultiSignatureInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is DateInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is TimeInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is UrlInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is NumberInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is PhoneInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is EmailInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is DateTimeInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is DropdownInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
        if (selectedListLabel.containsKey(field.id)) {
          field = field.copyWith(answerList: selectedListLabel[field.id]);
        }
      }
    } else if (field is MultipleInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
        if (selectedListLabel.containsKey(field.id)) {
          field = field.copyWith(answerList: selectedListLabel[field.id]);
        }
      }
    } else if (field is CheckboxInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
        if (selectedListLabel.containsKey(field.id)) {
          field = field.copyWith(answerList: selectedListLabel[field.id]);
        }
      }
    } else if (field is RadioInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
        if (selectedListLabel.containsKey(field.id)) {
          field = field.copyWith(
              selectedLinkListLabel: selectedListLabel[field.id]);
        }
      }
    } else if (field is YesNoInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
        if (selectedListLabel.containsKey(field.id)) {
          field = field.copyWith(
              selectedLinkListLabel: selectedListLabel[field.id]);
        }
      }
    } else if (field is YesNoNaInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
        if (selectedListLabel.containsKey(field.id)) {
          field = field.copyWith(
              selectedLinkListLabel: selectedListLabel[field.id]);
        }
      }
    } else if (field is FileInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is ImageInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is MapField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else {}
    return field;
  }

  List<Map<String, dynamic>> getFinalAnswer(
    List<InputField> initialValue,
  ) {
    List<InputField> finalAnswer = [];
    finalAnswer.addAll(initialValue);

    final selectedListLabel = ref.read(linklabelProvider);

    for (int i = 0; i < finalAnswer.length; i++) {
      var field = finalAnswer[i];
      if (field is TableField || field is AdvTableField) {
        if (field is TableField) {
          final cuurentTableField = ref
              .read(customSimpleRowProvider.notifier)
              .convertIdinTableField(field);
          List<List<InputField>> tableList = [];
          for (var row in cuurentTableField.inputFields ?? []) {
            for (int j = 0; j < row.length; j++) {
              row[j] = singlefieldAnswer(row[j], selectedListLabel);
            }
            tableList.add(row);
          }
          field = field.copyWith(inputFields: tableList);
        } else if (field is AdvTableField) {
          List<List<InputField>> tableList = field.inputFields ?? [];
          for (var row in tableList) {
            for (int j = 0; j < row.length; j++) {
              row[j] = singlefieldAnswer(row[j], selectedListLabel);
            }
          }
          field = field.copyWith(inputFields: tableList);
        }
      } else {
        field = singlefieldAnswer(field, selectedListLabel);
      }

      finalAnswer[i] =
          field; // Update the finalAnswer list with the modified field
    }
    return finalAnswer.map((e) => e.toJson()).toList();
  }

  void saveinitialAnswer(List<InputField> inputFields) {
    try {
      // Clear the current state
      state = {};
      initialAnswer = {};

      // Iterate over each input field
      for (var field in inputFields) {
        // Check if the field is required

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
              if (subField.answer != null) {
                if (subField.answer is Map<String, dynamic>) {
                  if (subField.answer.isNotEmpty) {
                    state.addAll({subField.id: subField.answer});
                    initialAnswer.addAll({subField.id: subField.answer});
                  }
                } else if (subField.answer is List) {
                  if (subField.answer.isNotEmpty) {
                    state.addAll({subField.id: subField.answer});
                    initialAnswer.addAll({subField.id: subField.answer});
                  }
                } else if (subField.answer is String) {
                  if (subField.answer != '') {
                    state.addAll({subField.id: subField.answer});
                    initialAnswer.addAll({subField.id: subField.answer});
                  }
                }
              }
            }
          }
        } else {
          if (field.answer is Map<String, dynamic>) {
            if (field.answer.isNotEmpty) {
              state.addAll({field.id: field.answer});
              initialAnswer.addAll({field.id: field.answer});
            }
          } else if (field.answer is List) {
            if (field.answer.isNotEmpty) {
              state.addAll({field.id: field.answer});
              initialAnswer.addAll({field.id: field.answer});
            }
          } else if (field.answer is String) {
            if (field.answer != '') {
              state.addAll({field.id: field.answer});
              initialAnswer.addAll({field.id: field.answer});
            }
          }
        }
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  List getListValue(String k) {
    return state[k] ?? [];
  }

  void saveNum(String k, num? v) {
    if (v == null) {
      state.remove(k);
    } else {
      state[k] = v;
    }
  }

  void saveString(String k, String? v) {
    if (v == null || v.isEmpty) {
      state.remove(k.trim());
    } else {
      state[k] = v;
    }
  }

  void saveMap(String k, Map<String, dynamic> v) {
    if (v.isEmpty) {
      state.remove(k);
    } else {
      state[k] = v;
    }
  }

  void saveStringAsNum(String k, String? v) {
    if (v == null || v.isEmpty) {
      state.remove(k);
    } else {
      state[k] = num.parse(v);
    }
  }

  void saveList(String k, List? v) {
    try {
      if (v == null || v.isEmpty) {
        state[k] = [];
      } else {
        state[k] = v;
      }
    } catch (e) {
      log('Error: $e');
    }
    log('IMAGE VALUES: \n\n KEy=$k');
  }

  InputField getFieldWithAnswer(InputField singleField) {
    InputField field = singleField;
    if (field is TextInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is SignatureInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is MultiSignatureInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is DateInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is TimeInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is UrlInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is NumberInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is PhoneInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is EmailInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is DateTimeInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is DropdownInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is MultipleInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is CheckboxInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is RadioInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is YesNoInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is YesNoNaInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is FileInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is ImageInputField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else if (field is MapField) {
      if (state.containsKey(field.id)) {
        field = field.copyWith(answer: state[field.id]);
      }
    } else {}
    return field;
  }
}
