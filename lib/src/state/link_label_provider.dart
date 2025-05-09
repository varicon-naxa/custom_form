import 'package:riverpod/riverpod.dart';

final linklabelProvider =
    StateNotifierProvider<LinkLabelNotifier, Map<String, dynamic>>((ref) {
  return LinkLabelNotifier(ref);
});

class LinkLabelNotifier extends StateNotifier<Map<String, dynamic>> {
  LinkLabelNotifier(this.ref) : super({});
  Ref ref;

  void remove(String k) => state.remove(k);

  void saveString(String k, String? v) {
    if (v == null || v.isEmpty) {
      state.remove(k);
    } else {
      state[k] = v;
    }
  }
}
