import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';

import '../../varicon_form_builder.dart';

final currentStateNotifierProvider =
    StateNotifierProvider<CurrentFormNotifier, Map<String, dynamic>>((ref) {
  return CurrentFormNotifier();
});

class CurrentFormNotifier extends StateNotifier<Map<String, dynamic>> {
  CurrentFormNotifier() : super({});

  Map<String, dynamic> initialAnswer = {};

  void remove(String k) => state.remove(k);
  void autoremove(String k) => state.remove(k);

  bool checkInitialFinalAnswerIdentical() {
    final deepEq = const DeepCollectionEquality().equals;
    return deepEq(state, initialAnswer);
  }

  void saveinitialAnswer(List<InputField> inputFields) {
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
      state.remove(k);
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
      print('Error: $e');
    }
    print('IMAGE VALUES: \n\n KEy=$k');
  }
}
