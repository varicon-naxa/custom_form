import '../../varicon_form_builder.dart';

class CustomTableModel {
  String? id;
  List<CustomRowModel>? rowList;
  CustomTableModel({this.id, this.rowList});

  CustomTableModel copyWith({
    String? id,
    List<CustomRowModel>? rowList,
  }) {
    return CustomTableModel(
      id: id ?? this.id,
      rowList: rowList ?? this.rowList,
    );
  }
}

class CustomRowModel {
  String? id;
  List<InputField>? inputFields;
  bool? isExpanded;

  CustomRowModel({this.id, this.isExpanded, this.inputFields});

  CustomRowModel copyWith({
    String? id,
    bool? isExpanded,
    List<InputField>? inputFields,
  }) {
    return CustomRowModel(
      id: id ?? this.id,
      isExpanded: isExpanded ?? this.isExpanded,
      inputFields: inputFields ?? this.inputFields,
    );
  }
}
