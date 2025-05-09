import 'package:flutter/material.dart';

extension HexColor on Color {
  /// Creates a [Color] from a hex string.
  /// Supports both `#RRGGBB` and `#AARRGGBB` formats.
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    String cleanHex = hexString.replaceFirst('#', '');

    if (cleanHex.length == 6) {
      buffer.write('ff$cleanHex'); // Assume full opacity if not provided
    } else {
      buffer.write(cleanHex);
    }

    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Converts the [Color] to a hex string.
  /// If [leadingHashSign] is `true`, prefixes the output with "#".
  String toHex({bool leadingHashSign = true}) {
    final r = (this as dynamic).red as int;
    final g = (this as dynamic).green as int;
    final b = (this as dynamic).blue as int;
    final a = (this as dynamic).alpha as int;

    return '${leadingHashSign ? '#' : ''}'
        '${a.toRadixString(16).padLeft(2, '0')}'
        '${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }
}
