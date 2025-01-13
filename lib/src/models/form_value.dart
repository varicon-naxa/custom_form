import 'dart:convert';
import 'dart:developer';

import 'package:varicon_form_builder/varicon_form_builder.dart';

/// {@template FormValue}
/// Represents value of the form to submit.
/// {@endtemplate}
class FormValue {
  /// {@macro FormValue}
  FormValue();

  final Map<String, dynamic> _value = {};
  final Map<String, dynamic> _savedValue = {};
  void Function(Map<String, dynamic>)? _onSaveCallback;

  void setOnSaveCallback(void Function(Map<String, dynamic>) callback) {
    _onSaveCallback = callback;
  }

  Map<String, dynamic> get value => _value;
  Map<String, dynamic> get savedValue => _value;

  void remove(String k) => _value.remove(k);
  void autoremove(String k) => _savedValue.remove(k);

  void saveNum(String k, num? v) {
    if (v == null) {
      _value.remove(k);
      _savedValue.remove(k);
    } else {
      _value[k] = v;
      _savedValue[k] = v;
      _onSaveCallback?.call(_savedValue);
    }
  }

  void saveString(String k, String? v) {
    if (v == null || v.isEmpty) {
      _value.remove(k);
      _savedValue.remove(k);
    } else {
      _value[k] = v;
      _savedValue[k] = v;
      _onSaveCallback?.call(_savedValue);
    }
  }

  void autosaveString(String k, String? v) {
    if (v == null || v.isEmpty) {
      _savedValue.remove(k);
    } else {
      _savedValue[k] = v;
      _onSaveCallback?.call(_savedValue);
    }
  }

  void saveMap(String k, Map<String, dynamic> v) {
    if (v.isEmpty) {
      _value.remove(k);
      _savedValue.remove(k);
    } else {
      _value[k] = v;
      _savedValue[k] = v;
      _onSaveCallback?.call(_savedValue);
    }
  }

  void saveStringAsNum(String k, String? v) {
    if (v == null || v.isEmpty) {
      _value.remove(k);
      _savedValue.remove(k);
    } else {
      _value[k] = num.parse(v);
      _savedValue[k] = num.parse(v);
      _onSaveCallback?.call(_savedValue);
    }
  }

  void saveList(String k, List? v) {
    try {
      if (v == null || v.isEmpty) {
        _value[k] = [];
        _savedValue[k] = [];
      } else {
        _value[k] = v;
        _savedValue[k] = v;
        _onSaveCallback?.call(_savedValue);
      }
    } catch (e) {
      print('Error: $e');
    }
    print('IMAGE VALUES:  $_value\n\n KEy=$k');
  }

  /// Used for image portion
  List<Map<String, dynamic>> getMappedList(String k) {
    final v = _value[k];

    if (v == null) {
      return List<Map<String, dynamic>>.from([]);
    } else {
      if (v is List && v.isNotEmpty) {
        return v as List<Map<String, dynamic>>;
      } else {
        return List<Map<String, dynamic>>.from([]);
      }
    }
  }

  /// Get value as String when value is either String or num type.
  String? getStringValue(String k) {
    final v = _value[k];
    if (v == null) return null;

    if (v is String) {
      return v;
    }
    if (v is num) {
      return v.toString();
    }
    throw const FormatException('Value is not neither String nor num.');
  }

  double? getNumberValue(String k) {
    final v = _value[k];
    if (v == null) return null;

    if (v is num) {
      return v.toDouble();
    }
    if (v is num) {
      return v.toDouble();
    }
    throw const FormatException('Value is not neither String nor num.');
  }

  List<List<InputField>> getTableData(String tableId) {
    // Retrieve existing rows from _savedValue
    final existingRows =
        _savedValue[tableId] as List<List<Map<String, dynamic>>>;

    // Convert existing rows to List<List<InputField>>
    List<List<InputField>> inputFields = existingRows.map((row) {
      return row.map((e) => InputField.fromJson(e)).toList();
    }).toList();
    return inputFields;
  }

  void saveTableFieldWithNewRow(List<InputField> newRow, TableField table) {
    String tableId = table.id;
    // Retrieve existing rows from _savedValue
    final existingRows =
        _savedValue[tableId] as List<List<Map<String, dynamic>>>;

    // Convert existing rows to List<List<InputField>>
    List<List<InputField>> inputFields = existingRows.map((row) {
      return row.map((e) => InputField.fromJson(e)).toList();
    }).toList();

    // Add the new row to the existing rows
    final updatedInputFields = [...inputFields, newRow];

    _value[tableId] = updatedInputFields.map((row) {
      return row.map((e) => e.toJson()).toList();
    }).toList();

    _savedValue[tableId] = updatedInputFields.map((row) {
      return row.map((e) => e.toJson()).toList();
    }).toList();

    _onSaveCallback?.call(_savedValue);
  }

  void saveTableField(String id, TableField table) {
    _value[id] = table.inputFields?.map((row) {
      return row.map((e) => e.toJson()).toList();
    }).toList();
    _savedValue[id] = table.inputFields?.map((row) {
      return row.map((e) => e.toJson()).toList();
    }).toList();
    _onSaveCallback?.call(_savedValue);
  }

  void saveAdvTableField(String id, AdvTableField table) {
    _value[id] = table.inputFields?.map((row) {
      return row.map((e) => e.toJson()).toList();
    }).toList();
    _savedValue[id] = table.inputFields?.map((row) {
      return row.map((e) => e.toJson()).toList();
    }).toList();
    _onSaveCallback?.call(_savedValue);
  }
}
