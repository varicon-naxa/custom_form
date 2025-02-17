import 'package:riverpod/riverpod.dart';

final currentStateNotifierProvider =
    StateNotifierProvider<CurrentFormNotifier, Map<String, dynamic>>((ref) {
  return CurrentFormNotifier();
});

class CurrentFormNotifier extends StateNotifier<Map<String, dynamic>> {
  CurrentFormNotifier() : super({});

  void remove(String k) => state.remove(k);
  void autoremove(String k) => state.remove(k);

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
