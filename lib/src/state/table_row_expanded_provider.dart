// import 'dart:developer';

// import 'package:riverpod/riverpod.dart';

// final currentTableRowProvider =
//     StateNotifierProvider<TableRowExpandedNotifier, Map<String, bool>>((ref) {
//   return TableRowExpandedNotifier(ref);
// });

// class TableRowExpandedNotifier extends StateNotifier<Map<String, bool>> {
//   TableRowExpandedNotifier(this.ref) : super({});

//   Ref ref;

//   bool getCurrentExpandedson(int index) {
//     try {
//       String k = state.keys.toList()[index];
//       return state[k] ?? true;
//     } catch (e) {
//       return true;
//     }
//   }

//   void changeCurrentExpandedson(int index, bool v) {
//     String k = state.keys.toList()[index];
//     state[k] = v;
//   }

//   void setCurrentExpandedson(String k) {
//     state[k] = !(state[k] ?? true);
//     log('dtata a' + state[k].toString());
//   }

//   void removeAt(int index) {
//     state = Map.fromEntries(state.entries.toList()..removeAt(index));
//   }

//   int getIndexofListItems(String data) {
//     return state.keys.toList().indexOf(data);
//   }

//   void addCurrentExpanded(String k, bool v) {
//     state.addAll({
//       k: v,
//     });
//   }
// }
