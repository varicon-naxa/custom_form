import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/checkbox_form_field.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_bottomsheet.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_multi_bottomsheet.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import '../../../varicon_form_builder.dart';
import '../../models/form_value.dart';

class MultipleInputWidget extends StatefulWidget {
  const MultipleInputWidget({
    super.key,
    required this.field,
    required this.formValue,
    required this.formKey,
    this.apiCall,
    this.labelText,
  });

  final MultipleInputField field;
  final FormValue formValue;
  final Key formKey;
  final String? labelText;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  State<MultipleInputWidget> createState() => _MultipleInputWidgetState();
}

class _MultipleInputWidgetState extends State<MultipleInputWidget> {
  late List<bool?> selectedChoices;
  late final List<ValueText> choices;
  List<ValueText> searchedChoice = [];

  late final String otherFieldKey;

  late final bool showSelectAllOption;
  bool showMessage = false;
  TextEditingController formCon = TextEditingController();
  TextEditingController searchCon = TextEditingController();
  List<String> selectedIds = [];

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
      if (widget.field.showOtherItem)
        ValueText.other(text: widget.field.otherText ?? 'Other (describe)'),
    ];
    setState(() {
      searchedChoice = choices;
    });

    otherFieldKey = '${widget.field.id}-Comment';

    // Get initial values from saved data.
    final List<String>? initialValue = widget.field.answer?.split(',');

    if ((widget.field.answer ?? '').isEmpty) {
      selectedIds = [];
      selectedChoices = List.filled(choices.length, null);
    } else if (initialValue != null && initialValue.isNotEmpty) {
      selectedChoices = choices.map(
        (e) {
          if (initialValue.contains(e.value)) {
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
            key: widget.formKey,
            controller: formCon,
            validator: (value) {
              return textValidator(
                value: '',
                inputType: "text",
                isRequired: (widget.field.isRequired && selectedIds.isEmpty),
                requiredErrorText: widget.field.requiredErrorText ??
                    'No any Selection in required field  ',
              );
            },
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.arrow_drop_down,
              ),
            ),
            onTap: () {
              // if (!(widget.field.fromManualList)) {
              primaryBottomSheet(context,
                  child: CustomMultiBottomsheet(
                    apiCall: widget.apiCall!,
                    answer: (widget.field.answer ?? '').isEmpty
                        ? selectedIds.join(',')
                        : widget.field.answer ?? selectedIds.join(','),
                    linkedQuery: widget.field.linkedQuery ?? '',
                    onCheckboxClicked:
                        (List<String> data, List<String> nameList) {
                      widget.formValue.saveString(
                        widget.field.id,
                        data.join(','),
                      );
                      widget.formValue.saveString(
                        widget.field.id.substring(5, widget.field.id.length),
                        nameList.join(','),
                      );
                      setState(() {
                        selectedIds = data;
                        if ((data).isEmpty) {
                          formCon.text = 'Select the item from list';
                        } else {
                          formCon.text =
                              '${(selectedIds).length} item selected';
                        }
                      });
                    },
                  ));
              // }
              // else {
              //   primaryBottomSheet(
              //     context,
              //     child: StatefulBuilder(builder: (context, setState) {
              //       return Column(
              //         children: [
              //           ThemeSearchField(
              //             name: '',
              //             hintText: 'Search ...',
              //             onChange: (value) {
              //               setState(() {
              //                 searchedChoice = choices
              //                     .where((obj) => obj.text
              //                         .toLowerCase()
              //                         .contains(value.toLowerCase()))
              //                     .toList();
              //               });
              //             },
              //             controllerText: searchCon,
              //           ),
              //           Expanded(
              //             child: searchedChoice.isEmpty
              //                 ? Center(
              //                     child: Text(
              //                       'Empty List',
              //                       style:
              //                           Theme.of(context).textTheme.bodyLarge,
              //                     ),
              //                   )
              //                 : ListView.builder(
              //                     shrinkWrap: true,
              //                     keyboardDismissBehavior:
              //                         ScrollViewKeyboardDismissBehavior.onDrag,
              //                     itemBuilder: (context, i) {
              //                       return ListTile(
              //                         onTap: () {
              //                           if (selectedIds.contains(
              //                               searchedChoice[i].value)) {
              //                             setState(() {
              //                               selectedIds.remove(
              //                                   searchedChoice[i].value);
              //                             });
              //                           } else {
              //                             setState(() {
              //                               selectedIds
              //                                   .add(searchedChoice[i].value);
              //                             });
              //                           }
              //                           widget.formValue.saveString(
              //                             widget.field.id,
              //                             selectedIds.join(','),
              //                           );
              //                           setState(() {
              //                             if ((selectedIds).isEmpty) {
              //                               formCon.text =
              //                                   'Select the item from list';
              //                             } else {
              //                               formCon.text =
              //                                   '${(selectedIds).length} item selected';
              //                             }
              //                           });
              //                         },
              //                         title: Text(
              //                           searchedChoice[i].text.toString(),
              //                           style: Theme.of(context)
              //                               .textTheme
              //                               .bodyMedium,
              //                         ),
              //                         trailing: Checkbox(
              //                           materialTapTargetSize:
              //                               MaterialTapTargetSize.shrinkWrap,
              //                           visualDensity: const VisualDensity(
              //                               horizontal:
              //                                   VisualDensity.minimumDensity,
              //                               vertical:
              //                                   VisualDensity.minimumDensity),
              //                           value: selectedIds
              //                               .contains(searchedChoice[i].value),
              //                           onChanged: (value) {
              //                             if (selectedIds.contains(
              //                                 searchedChoice[i].value)) {
              //                               setState(() {
              //                                 selectedIds.remove(
              //                                     searchedChoice[i].value);
              //                               });
              //                             } else {
              //                               setState(() {
              //                                 selectedIds
              //                                     .add(searchedChoice[i].value);
              //                               });
              //                             }
              //                             widget.formValue.saveString(
              //                               widget.field.id,
              //                               selectedIds.join(','),
              //                             );
              //                             setState(() {
              //                               if ((selectedIds).isEmpty) {
              //                                 formCon.text =
              //                                     'Select the item from list';
              //                               } else {
              //                                 formCon.text =
              //                                     '${(selectedIds).length} item selected';
              //                               }
              //                             });
              //                           },
              //                         ),
              //                       );
              //                     },
              //                     itemCount: searchedChoice.length,
              //                   ),
              //           ),
              //         ],
              //       );
              //     }),
              //   );
              // }
            },
          )
        : Column(
            children: [
              CheckboxFormField(
                initialList: selectedChoices,
                key: widget.formKey,
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
                },
                onSaved: (newValue) {
                  final keys = newValue!.indexed
                      .map((e) {
                        final (i, v) = e;
                        if (v ?? false) {
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

                  widget.formValue.saveString(
                    widget.field.id,
                    keys.join(','),
                  );
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
                    hasAction: ((widget.field.isConditional) ? v.action : null),
                    enabled: enabled(),
                    title: Text(
                      v.text,
                      style: Theme.of(context).textTheme.bodyMedium,
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

              if (widget.field.showOtherItem && isOtherSelected()) ...[
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  initialValue: widget.formValue.getStringValue(otherFieldKey),
                  maxLength: 80,
                  maxLines: 4,
                  onSaved: (newValue) => widget.formValue.saveString(
                    otherFieldKey,
                    newValue,
                  ),
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
