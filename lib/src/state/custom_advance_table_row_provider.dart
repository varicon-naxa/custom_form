import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/models/custom_table_model.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

final customAdvanceRowProvider = StateNotifierProvider<
    CustomAdvanceTableRowProvider, List<CustomTableModel>>((ref) {
  return CustomAdvanceTableRowProvider(ref);
});

class CustomAdvanceTableRowProvider
    extends StateNotifier<List<CustomTableModel>> {
  CustomAdvanceTableRowProvider(this.ref) : super([]);
  Ref ref;
  void initState() {
    state = [];
  }

  void addNewField(String elementId, CustomRowModel newElement) {
    if (state.isNotEmpty) {
      List<CustomTableModel> newList = state.map((tableModel) {
        if (tableModel.id == elementId) {
          List<CustomRowModel>? updatedRowList = [];
          updatedRowList.addAll(tableModel.rowList ?? []);
          updatedRowList.add(newElement);
          return tableModel.copyWith(rowList: updatedRowList);
        }
        return tableModel;
      }).toList();
      state = newList;
    } else {
      state = [
        CustomTableModel(id: elementId, rowList: [newElement])
      ];
    }
  }

  void addInitialTableList(AdvTableField field) {
    state = [];
    for (List<InputField> element in (field.inputFields ?? [])) {
      CustomRowModel model = CustomRowModel(
        id: const Uuid().v4(),
        inputFields: element,
        isExpanded: true,
      );
      addNewField(field.id, model);
    }
  }

  void changeExpansion(String tableId, String rowId, bool value) {
    List<CustomTableModel> newList = state.map((tableModel) {
      if (tableModel.id == tableId) {
        List<CustomRowModel>? updatedRowList = [];
        updatedRowList.addAll(tableModel.rowList ?? []);

        List<CustomRowModel> newRowList = (updatedRowList).map((singleRow) {
          if (singleRow.id == rowId) {
            singleRow.isExpanded = value;
          }
          return singleRow;
        }).toList();

        return tableModel.copyWith(rowList: newRowList);
      }
      return tableModel;
    }).toList();
    state = newList;
  }

  List<List<InputField>> convertIntoRowList(List<CustomRowModel> list) {
    List<List<InputField>> newList = [];
    for (CustomRowModel singleRow in list) {
      newList.add(singleRow.inputFields ?? []);
    }
    return newList;
  }

  (String?, String?, bool) findTableAndRowId(String inputFieldId) {
    for (var table in state) {
      for (CustomRowModel row in table.rowList ?? []) {
        for (var field in row.inputFields ?? []) {
          if (field.id == inputFieldId) {
            return (
              table.id,
              row.id,
              row.isExpanded ?? true,
            );
          }
        }
      }
    }
    return (null, null, true);
  }

  AdvTableField convertIdinTableField(AdvTableField currentTable) {
    AdvTableField newTableField = currentTable;
    List<CustomTableModel> tableModel = state;
    for (var singleTable in tableModel) {
      if (singleTable.id == currentTable.id) {
        newTableField = newTableField.copyWith(
          inputFields: convertIntoRowList(singleTable.rowList ?? []),
        );
      }
    }
    return newTableField;
  }
}
