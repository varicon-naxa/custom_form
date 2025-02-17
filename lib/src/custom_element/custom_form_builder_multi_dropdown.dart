import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';

class CustomFormBuilderMultiDropdown extends StatefulWidget {
  const CustomFormBuilderMultiDropdown(
      {super.key,
      required this.choices,
      required this.onChanged,
     required  this.initialValue,
      this.actionMessage});
  final List<ValueText> choices;
  final List<ValueText> initialValue;
  final Function(List<ValueText>) onChanged;
  final String? actionMessage;

  @override
  State<CustomFormBuilderMultiDropdown> createState() =>
      _CustomFormBuilderMultiDropdownState();
}

class _CustomFormBuilderMultiDropdownState
    extends State<CustomFormBuilderMultiDropdown> {
  List<ValueText> selectedItems = [];

  @override
  void initState() {
    super.initState();

        if ((widget.initialValue).isNotEmpty) {
      setState(() {
        selectedItems.addAll(widget.initialValue);
      });
    }
  }

  void onItemTap(ValueText item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
    widget.onChanged(selectedItems);
    setState(() {});
  }

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
    return CheckboxListTile.adaptive(
      value: selectedItems.contains(item),
      onChanged: (val) {
        onItemTap(item);
      },
      controlAffinity: ListTileControlAffinity.leading,
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
