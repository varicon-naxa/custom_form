import 'package:flutter/material.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

/// {@template FormValue}
/// Represents value of the form to submit.
/// {@endtemplate}
class FormValue {
  /// {@macro FormValue}
  FormValue();

  final Map<String, dynamic> _value = {};
  void Function(Map<String, dynamic>)? _onSaveCallback;

  void setOnSaveCallback(void Function(Map<String, dynamic>) callback) {
    _onSaveCallback = callback;
  }

  Map<String, dynamic> get value => _value;

  void remove(String k) => _value.remove(k);

  void saveNum(String k, num? v) {
    if (v == null) {
      _value.remove(k);
    } else {
      _value[k] = v;
    }
  }

  void saveString(String k, String? v) {
    if (v == null || v.isEmpty) {
      _value.remove(k);
    } else {
      _value[k] = v;
      _onSaveCallback?.call(_value);
    }
  }

  void saveMap(String k, Map<String, dynamic> v) {
    if (v.isEmpty) {
      _value.remove(k);
    } else {
      _value[k] = v;
      _onSaveCallback?.call(_value);
    }
  }

  void saveStringAsNum(String k, String? v) {
    if (v == null || v.isEmpty) {
      _value.remove(k);
    } else {
      _value[k] = num.parse(v);
      _onSaveCallback?.call(_value);
    }
  }

  void saveList(String k, List? v) {
    try {
      if (v == null || v.isEmpty) {
        _value[k] = [];
      } else {
        _value[k] = v;
        _onSaveCallback?.call(_value);
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

  void saveTableField(String id, TableField table) {
    _value[id] = table.inputFields?.map((row) {
      return row.map((e) => e.toJson()).toList();
    }).toList();
    _onSaveCallback?.call(_value);
  }
}
