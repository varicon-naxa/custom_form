import 'package:riverpod/riverpod.dart';

final tableRowKeyProvider =
    StateNotifierProvider<TableRowNotifier, Map<String, List<String>>>((ref) {
  return TableRowNotifier(ref);
});

class TableRowNotifier extends StateNotifier<Map<String, List<String>>> {
  TableRowNotifier(this.ref) : super({});

  Ref ref;

  void addNewData(String k, List<String> v) {
    state[k] = v;
  }

  String getLastId() {
    Map<String, List<String>> newState = state;
    String lastId = newState.keys.last;
    int index = int.parse(lastId.split('-').last) + 1;
    String initialLastId = lastId.split('-').first;
    String newId = '$initialLastId-$index';
    return newId;
  }

  void deteteRow(int index) {
    state = Map.fromEntries(state.entries.toList()..removeAt(index));
  }

  void addNewId(String k, String v) {
    if (state[k] == null) {
      state[k] = [];
    }
    state[k]!.add(v);
  }

  (int, String) getIndex(String index) {
    Map<String, List<String>> data = state;

    List<String> keysList = data.keys.toList(); // Get keys as a list

    for (int i = 0; i < keysList.length; i++) {
      String key = keysList[i];
      if (data[key]!.contains(index)) {
        return (i, key);
      }
    }
    return (-1, '');
  }
}
