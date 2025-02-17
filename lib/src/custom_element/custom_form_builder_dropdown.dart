import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';

class CustomFormBuilderDropdown extends StatefulWidget {
  const CustomFormBuilderDropdown(
      {super.key, required this.choices, this.onChanged, this.actionMessage});
  final List<ValueText> choices;
  final Function(ValueText?)? onChanged;
  final String? actionMessage;

  @override
  State<CustomFormBuilderDropdown> createState() =>
      _CustomFormBuilderDropdownState();
}

class _CustomFormBuilderDropdownState extends State<CustomFormBuilderDropdown> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...widget.choices
              .map((lang) => singleItem(lang))
              .toList(growable: false),
        ],
      ),
    );
  }

  Widget singleItem(ValueText item) {
    return ListTile(
      onTap: () {
        widget.onChanged!(item);
      },
      title: Text(item.text),
      subtitle: (item.action == true && (widget.actionMessage ?? '').isNotEmpty)
          ? Text(
              widget.actionMessage ?? '',
              style: const TextStyle(
                color: Colors.red,
              ),
            )
          : null,
    );
  }
}
