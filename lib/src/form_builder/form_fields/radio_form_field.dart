import 'package:flutter/material.dart';

///Form field for radio button that extends FormField
///
///Accepts key, items, onChanged, hasMessage, onSaved, validator, autovalidateMode, value and actionMessage
class RadioFormField<T> extends FormField<T> {
  RadioFormField({
    super.key,
    required List<RadioMenuItem<T>> items,
    required BuildContext context,
    this.onChanged,
    this.hasMessage,
    super.onSaved,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    T? value,
    String? actionMessage,
  }) : super(
          initialValue: value,
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
                children: items.map((e) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        color: (e.hasCondition && state.value == e.value)
                            ? e.hasAction != null
                                ? (e.hasAction!)
                                    ? const Color(0xffFDD9D7)
                                    : const Color(0xffDBEFDC)
                                : Colors.white
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: (e.hasCondition && state.value == e.value)
                              ? e.hasAction != null
                                  ? (e.hasAction!)
                                      ? Colors.red
                                      : Colors.green
                                  : Colors.grey.shade500
                              : state.value == e.value
                                  ? Colors.grey.shade500
                                  : Colors.white,
                        )),
                    child: RadioListTile<T>(
                      groupValue: state.value,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: e.value,
                      onChanged: (value) {
                        final focus = FocusNode();

                        FocusScope.of(context).requestFocus(focus);
                        state.didChange(value);
                        // finally call onChanged for each item.
                        if (hasMessage != null) {
                          if (e.hasAction ?? false) {
                            hasMessage(true);
                          } else {
                            hasMessage(false);
                          }
                        }
                        if (value != null) e.onSelected?.call(value);
                      },
                      title: e.title,
                      isThreeLine: false,
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );

  final ValueChanged<T?>? onChanged;
  final Function(bool)? hasMessage;

  @override
  FormFieldState<T> createState() => _RadioFormFieldState();
}

class _RadioFormFieldState<T> extends FormFieldState<T> {
  @override
  void didChange(T? value) {
    super.didChange(value);
    final RadioFormField<T> radioFormField = widget as RadioFormField<T>;
    assert(radioFormField.onChanged != null);
    radioFormField.onChanged!(value);
  }

  @override
  void didUpdateWidget(RadioFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}

///Radio menu item class
///
///Used to create radio menu item
class RadioMenuItem<T> {
  const RadioMenuItem({
    required this.value,
    required this.title,
    this.enabled = true,
    this.hasCondition = false,
    this.hasAction,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.isThreeLine = false,
    this.visualDensity,
    this.clearOthersOnSelect = false,
    this.onSelected,
  });

  ///Radio menu item value boolean
  final bool enabled;

  ///Radio menu item title widget
  final Widget title;

  ///Radio menu item has action boolean
  final bool? hasAction;

  ///Radio menu item has condition boolean
  final bool hasCondition;

  ///Radio menu item on selected function
  final ValueChanged<T>? onSelected;

  ///Radio menu item dynamic value
  final T value;

  ///Radio menu item control affinity
  ///
  ///[controlAffinity] is used to set the position of the control relative to the text.
  final ListTileControlAffinity controlAffinity;
  final bool isThreeLine;
  final VisualDensity? visualDensity;
  final bool clearOthersOnSelect;
}
