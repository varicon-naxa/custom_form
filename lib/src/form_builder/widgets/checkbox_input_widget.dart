import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/checkbox_form_field.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_bottomsheet.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_multi_bottomsheet.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';

///Form builder checkbox input widget
///
///Accepts field, formValue, formKey, labelText and apiCall
class CheckboxInputWidget extends StatefulWidget {
  const CheckboxInputWidget(
      {super.key,
      required this.field,
      required this.formValue,
      required this.fieldKey,
      this.labelText,
      this.apiCall});

  ///Checkbox input field model
  final CheckboxInputField field;

  ///Form value to save data as per requirement
  final FormValue formValue;

  ///Form key to save form data
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

  ///Label text to show on form
  final String? labelText;

  ///Api call to get data
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  State<CheckboxInputWidget> createState() => _CheckboxInputWidgetState();
}

class _CheckboxInputWidgetState extends State<CheckboxInputWidget> {
  ///Varibale to be later used to show alert message
  late List<bool?> selectedChoices;
  late final List<ValueText> choices;
  late final String otherFieldKey;
  late final bool showSelectAllOption;
  bool showTextField = false;

  bool showMessage = false;
  TextEditingController formCon = TextEditingController();
  TextEditingController searchCon = TextEditingController();
  TextEditingController otherFieldController = TextEditingController();
  List<String> selectedIds = [];
  List<ValueText> searchedChoices = [];

  List<ValueText> getSelectedChoicesFromIndices() {
    List<ValueText> selectedValueTexts = [];
    for (int i = 0; i < selectedChoices.length; i++) {
      if (selectedChoices[i] == true) {
        selectedValueTexts.add(choices[i]);
      }
    }
    return selectedValueTexts;
  }

  bool checkIfAnyOtherFieldSelected() {
    List<ValueText> selectedChoices = getSelectedChoicesFromIndices();
    bool isOtherFieldSelected = selectedChoices.any(
      (choice) => ((choice.isOtherField ?? false) == true),
    );
    return isOtherFieldSelected;
  }

  checkListField({bool fromInit = false}) {
    if (checkIfAnyOtherFieldSelected()) {
      // Handle the case where an "other" field is selected
      showTextField = true;
      if (fromInit) {
        otherFieldController.text = widget.field.answerList ?? '';
      }
    } else {
      showTextField = false;
      widget.formValue.remove(
        widget.field.id.substring(5, widget.field.id.toString().length),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    showSelectAllOption = widget.field.showSelectAllItem &&
        widget.field.maxSelectedChoices == null;

    choices = [
      // only allow select all item if max selected choice is not available
      if (showSelectAllOption)
        const ValueText(value: 'selectAll', text: 'Select all'),
      ...widget.field.choices,
      if (widget.field.showNoneItem)
        ValueText.none(text: widget.field.noneText ?? 'None'),
      // if (widget.field.showOtherItem)
      //   ValueText.other(text: widget.field.otherText ?? 'Other (describe)'),
    ];
    setState(() {
      searchedChoices = choices;
    });

    otherFieldKey = '${widget.field.id}-Comment';

    // Get initial values from saved data.
    final List<String>? initialValue = widget.field.answer?.split(',');

    if ((widget.field.answer ?? '').isEmpty) {
      selectedIds = [];
      selectedChoices = List.filled(choices.length, null);
    }
    if (initialValue != null && initialValue.isNotEmpty) {
      selectedChoices = choices.map(
        (e) {
          if (initialValue.contains(e.value)) {
            setState(() {
              selectedIds.add(e.value);
            });
            return true;
          } else if (e.value == 'other') {
            List<String> filteredValues = initialValue
                .where((value) => !value.contains("item-"))
                .toList();
            otherFieldController.text = filteredValues.first;
            setState(() {
              selectedIds.add(e.value);
            });
            return true;
          } else {
            return false;
          }
        },
      ).toList();
    } else {
      selectedChoices = List.filled(choices.length, null);
    }
    setState(() {
      showMessage = checkMatchingActions();
      if (!widget.field.fromManualList) {
        if ((initialValue ?? []).isEmpty) {
          formCon.text = 'Select items from the list';
        } else {
          formCon.text = '${(initialValue ?? []).length} item selected';
        }
      }
    });

    checkListField(fromInit: true);
  }

  bool checkMatchingActions() {
    if (selectedChoices.length != choices.length) {
      throw ArgumentError("Lists must have the same length");
    }
    for (int i = 0; i < selectedChoices.length; i++) {
      if ((selectedChoices[i] == true) && (choices[i].action == true)) {
        return true;
      }
    }
    return false;
  }

  bool isNoneSelected() => _isSelected((v) => v is NoneValueText);
  bool isOtherSelected() => _isSelected((v) => v is OtherValueText);

  bool _isSelected(bool Function(ValueText v) fun) {
    final index = choices.indexWhere(fun);
    if (index == -1) return false;
    return selectedChoices.elementAtOrNull(index) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    List<bool> actionList = choices.map((e) => e.action ?? false).toList();
    return !(widget.field.fromManualList)
        ? TextFormField(
            readOnly: true,
            controller: formCon,
            key: widget.fieldKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (selectedIds.isEmpty && widget.field.isRequired) {
                return widget.field.requiredErrorText ?? 'Response required.';
              }
              return null;
            },
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.arrow_drop_down,
              ),
            ),
            onTap: () {
              // if (widget.field.islinked ?? false) {
              primaryBottomSheet(context,
                  child: CustomMultiBottomsheet(
                    apiCall: widget.apiCall!,
                    answer: (widget.field.answer ?? '').isEmpty
                        ? selectedIds.join(',')
                        : widget.field.answer ?? selectedIds.join(','),
                    linkedQuery: widget.field.linkedQuery ?? '',
                    onCheckboxClicked:
                        (List<String> data, List<String> labelist) {
                      data.sort();
                      widget.formValue.saveString(
                        widget.field.id,
                        data.join(','),
                      );
                      labelist.sort();
                      widget.formValue.saveString(
                        widget.field.id.substring(5, widget.field.id.length),
                        labelist.join(','),
                      );
                      setState(() {
                        selectedIds = data;
                        if ((data).isEmpty) {
                          formCon.text = 'Select the item from list';
                        } else {
                          formCon.text = '${selectedIds.length} item selected';
                        }
                      });
                    },
                  ));
            },
          )
        : Column(
            children: [
              CheckboxFormField(
                initialList: selectedChoices,
                key: widget.fieldKey,
                context: context,
                actionList: actionList,
                validator: (value) {
                  if (value == null) return null;
                  if (!widget.field.isRequired) return null;
                  final atLeastOne = value.whereType<bool>().firstWhere(
                        (e) => e,
                        orElse: () => false,
                      );
                  if (!atLeastOne) {
                    return widget.field.requiredErrorText ??
                        'Response required.';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedChoices = value;
                  });
                  final keys = value.indexed
                      .map((e) {
                        final (i, v) = e;
                        if (v ?? false) {
                          if (choices[i].value == 'other') {
                            widget.formValue.autosaveString(
                              widget.field.id,
                              otherFieldController.text,
                            );

                            return otherFieldController.text;
                          }
                          return choices[i].value;
                        } else {
                          return null;
                        }
                      })
                      .whereType<String>()
                      .where((e) => e != 'selectAll') // remove selectAll if any
                      .toList();
                  // remove text saved in other text field if dropdown value in not
                  // other
                  if (!isOtherSelected()) {
                    widget.formValue.autoremove(otherFieldKey);
                  }
                  keys.sort();
                  widget.formValue.autosaveString(
                    widget.field.id,
                    keys.join(','),
                  );

                  checkListField();
                },
                onSaved: (newValue) {
                  final keys = newValue!.indexed
                      .map((e) {
                        final (i, v) = e;
                        if (v ?? false) {
                          if (choices[i].value == 'other') {
                            widget.formValue.saveString(
                              widget.field.id,
                              otherFieldController.text,
                            );

                            return otherFieldController.text;
                          }
                          return choices[i].value;
                        } else {
                          return null;
                        }
                      })
                      .whereType<String>()
                      .where((e) => e != 'selectAll') // remove selectAll if any
                      .toList();
                  // remove text saved in other text field if dropdown value in not
                  // other
                  if (!isOtherSelected()) {
                    widget.formValue.remove(otherFieldKey);
                  }
                  keys.sort();
                  widget.formValue.saveString(
                    widget.field.id,
                    keys.join(','),
                  );
                  checkListField();
                },
                hasMessage: (value) {
                  setState(() {
                    showMessage = value;
                  });
                },
                items: choices.indexed.map((kv) {
                  final (i, v) = kv;

                  bool enabled() {
                    // none should be checked before max choice. if none is
                    // selected disable all other fields.
                    // if (isNoneSelected() && v != 'none') return false;

                    // if no max choice count available all are enabled.
                    if (widget.field.maxSelectedChoices == null) return true;

                    final maxChoiceReached = widget.field.maxSelectedChoices! <=
                        selectedChoices.where((e) => e == true).length;

                    final isChecked =
                        selectedChoices.elementAtOrNull(i) ?? false;

                    // none is always enabled.
                    if (!maxChoiceReached || v is NoneValueText) return true;

                    if (isChecked) {
                      // choice only enabled for selected options. so that user
                      // can uncheck
                      return true;
                    }
                    return false;
                  }

                  /// Alert message if action is selected

                  // if none is selected or is none is already selected clear all
                  // other checkbox while updating new checkbox
                  final clearOther = (v is NoneValueText) || (isNoneSelected());
                  return CheckboxMenuItem(
                    value: v.value,
                    hasAction: widget.field.fromManualList ? v.action : null,
                    enabled: enabled(),
                    title: Text(
                      v.text,
                    ),
                    isThreeLine: false,
                    visualDensity: VisualDensity.compact,
                    clearOthersOnSelect: clearOther,
                    onChanged: (value) {
                      if (v.value == 'selectAll' && value) {
                        setState(() {
                          selectedChoices = choices.indexed.map((e) {
                            if (e.$2 is NoneValueText ||
                                e.$2 is OtherValueText) {
                              return selectedChoices[e.$1];
                            }
                            return true;
                          }).toList();
                        });
                        return;
                      }
                      if (showSelectAllOption && v.value != 'selectAll') {
                        // remove selectAll check if it is shown when any checkbox
                        // updates.
                        selectedChoices.first = false;
                      }
                    },
                  );
                }).toList(),
              ),

              /// Alert message if action is selected
              if (showMessage && (widget.field.actionMessage ?? '').isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.white,
                      ),
                      AppSpacing.sizedBoxW_08(),
                      Expanded(
                        child: Text(
                          widget.field.actionMessage.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (showTextField) ...[
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: otherFieldController,
                  maxLength: 80,
                  maxLines: 4,
                  // initialValue: widget.formValue.getStringValue(otherFieldKey),
                  // onSaved: (newValue) => widget.formValue.saveString(
                  //   otherFieldKey,
                  //   newValue,
                  // ),

                  onChanged: (value) {
                    widget.formValue.saveString(
                      widget.field.id
                          .substring(5, widget.field.id.toString().length),
                      value,
                    );
                  },
                  validator: (value) => textValidator(
                    value: value,
                    inputType: "text",
                    isRequired: true,
                    requiredErrorText: widget.field.otherErrorText,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.field.otherPlaceholder,
                    labelText: widget.field.otherText,
                  ),
                ),
              ],
            ],
          );
  }
}
