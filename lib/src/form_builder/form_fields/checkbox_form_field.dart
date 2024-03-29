import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<List<bool?>> {
  CheckboxFormField({
    super.key,
    required List<CheckboxMenuItem> items,
    super.onSaved,
    super.validator,
    required List<bool?> initialList,
    required List<bool> actionList,
    this.onChanged,
    this.hasMessage,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
  })  : assert(items.length == (initialList.length),
            'Length if initial value and items must be same.'),
        super(
          initialValue: initialList,
          builder: (state) {
            return InputDecorator(
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                errorText: state.errorText,
              ),
              child: Column(
                children: items.indexed.map((e) {
                  final (index, item) = e;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                        color: item.hasAction != null
                            ? (item.hasAction!)
                                ? const Color(0xffFDD9D7)
                                : const Color(0xffDBEFDC)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: item.hasAction != null
                                ? (item.hasAction!)
                                    ? Colors.red
                                    : Colors.green
                                : Colors.white)),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      value: state.value?[index] ?? false,
                      enabled: item.enabled,
                      onChanged: (value) {
                        if (value == null) return;
                        late List<bool?> newState;

                        if (item.clearOthersOnSelect && value) {
                          // clear all checkbox if checkbox with
                          // clearOthersOnSelect is checked.
                          // if value is true it means it is checked
                          newState = List.filled(items.length, null);
                        } else {
                          newState = List.from(state.value!);
                        }
                        newState[index] = value;

                        state.didChange(newState);

                        if (hasMessage != null) {
                          List<bool> result = [];

                          /// Action list is the list of choices action
                          /// Comparing the current checkbox value with the initial list action
                          /// storing those result in variable result
                          /// [true, false false, true] - [false, false, false, true]
                          /// if same index in both list consists true then action is true
                          if (actionList.length == newState.length) {
                            actionList.asMap().forEach((index, value) {
                              if (value && (newState[index] ?? false)) {
                                result.add(true);
                              } else {
                                result.add(false);
                              }
                            });
                          } else {
                            return;
                          }
                          hasMessage(result.contains(true));
                        }

                        // finally call onChanged for each item.
                        item.onChanged?.call(value);
                      },
                      title: item.title,
                      isThreeLine: false,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );

  final ValueChanged<List<bool?>?>? onChanged;
  final Function(bool)? hasMessage;

  @override
  FormFieldState<List<bool?>> createState() => _CheckboxFormFieldState();
}

class _CheckboxFormFieldState extends FormFieldState<List<bool?>> {
  @override
  void didChange(List<bool?>? value) {
    super.didChange(value);
    final CheckboxFormField dropdownButtonFormField =
        widget as CheckboxFormField;
    assert(dropdownButtonFormField.onChanged != null);
    dropdownButtonFormField.onChanged!(value);
  }

  @override
  void didUpdateWidget(CheckboxFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}

class CheckboxMenuItem<T> {
  const CheckboxMenuItem({
    required this.value,
    required this.title,
    this.enabled = true,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.isThreeLine = false,
    this.hasAction,
    this.visualDensity,
    this.clearOthersOnSelect = false,
    this.onChanged,
  });

  final bool enabled;
  final Widget title;

  final ValueChanged<bool>? onChanged;

  final T value;
  final ListTileControlAffinity controlAffinity;
  final bool isThreeLine;
  final VisualDensity? visualDensity;
  final bool clearOthersOnSelect;
  final bool? hasAction;
}
