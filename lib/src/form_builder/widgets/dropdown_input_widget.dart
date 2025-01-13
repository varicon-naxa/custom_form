import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_bottomsheet.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_paginated_bs.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/primary_bottomsheet.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import '../../../varicon_form_builder.dart';

///Dropdown form widget
///
///Accepts field type with dropdown input
class DropdownInputWidget extends StatefulWidget {
  const DropdownInputWidget(
      {super.key,
      required this.field,
      required this.formValue,
      required this.fieldKey,
      required this.labelText,
      this.apiCall});

  ///Dropdown input field model
  final DropdownInputField field;

  ///Field form value
  final FormValue formValue;

  ///Field form unique key
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

  ///Label text for dropdown
  final String? labelText;

  ///API call function to handle dropdown data/response
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  State<DropdownInputWidget> createState() => _DropdownInputWidgetState();
}

class _DropdownInputWidgetState extends State<DropdownInputWidget> {
  String? value;
  TextEditingController formCon = TextEditingController();
  TextEditingController searchCon = TextEditingController();
  bool showMessage = false;

  late final List<ValueText> choices;
  List<ValueText> searchedChoice = [];
  late final String otherFieldKey;

  @override
  void initState() {
    super.initState();

    ///Initiliaze dropdown choices with none and other options
    choices = [
      ...widget.field.choices,
      if (widget.field.showNoneItem)
        ValueText.none(text: widget.field.noneText ?? 'None'),
      if (widget.field.showOtherItem)
        ValueText.other(text: widget.field.otherText ?? 'Other (describe)'),
    ];
    searchedChoice = choices;

    otherFieldKey = '${widget.field.id}-Comment';
    setState(() {
      value = (widget.field.answer != null)
          ? ((widget.field.answer ?? '').isNotEmpty)
              ? (widget.field.answer ?? widget.formValue.getStringValue(''))
              : null
          : null;
      widget.formValue.saveString(
        widget.field.id,
        value,
      );

      if (value != null && value != '') {
        bool containsId = choices.any((obj) => obj.value == value);

        if (containsId) {
          ValueText? foundObject = choices.firstWhere(
            (obj) => obj.value == value,
          );
          formCon.text = foundObject.text;
          showMessage = foundObject.action ?? false;
        } else {
          formCon.text = (widget.field.answerList ?? '');
        }
      } else {
        formCon.text = 'Select the item from list';
      }
    });
  }

  ///Check if dropdown value is selected and show message if required
  checkValue() {
    if (value != null && value != '') {
      bool containsId = choices.any((obj) => obj.value == value);

      if (containsId) {
        ValueText? foundObject = choices.firstWhere(
          (obj) => obj.value == value,
        );
        setState(() {
          showMessage = foundObject.action ?? false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return !(widget.field.fromManualList)
        ? TextFormField(
            readOnly: true,
            controller: formCon,
            key: widget.fieldKey,
            validator: (values) => textValidator(
              value: values,
              inputType: "text",
              isRequired: widget.field.isRequired,
              requiredErrorText: widget.field.requiredErrorText,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              suffixIcon: Icon(
                Icons.arrow_drop_down,
              ),
            ),
            onTap: () {
              primaryBottomSheet(
                context,
                child: CustomPaginatedBottomsheet(
                  apiCall: widget.apiCall!,
                  linkedQuery: widget.field.linkedQuery ?? '',
                  onClicked: (ValueText data) {
                    widget.formValue.saveString(
                      widget.field.id.substring(5, widget.field.id.length),
                      data.text,
                    );
                    widget.formValue.saveString(
                      widget.field.id,
                      data.value,
                    );

                    setState(() {
                      formCon.text = data.text;
                    });
                  },
                ),
              );
            },
          )
        : Column(
            children: [
              TextFormField(
                readOnly: true,
                controller: formCon,
                key: widget.fieldKey,
                validator: (values) => textValidator(
                  value: values,
                  inputType: "text",
                  isRequired: widget.field.isRequired,
                  requiredErrorText: widget.field.requiredErrorText,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8.0),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                  ),
                ),
                onTap: () {
                  primaryCustomBottomSheet(
                    hasSpace: false,
                    context,
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          ...choices.map(
                            (e) => SizedBox(
                              width: double.infinity,
                              child: InkWell(
                                onTap: () {
                                  // widget.formValue.saveString(
                                  //   widget.field.id,
                                  //   e.value,
                                  // );
                                  // widget.formValue.saveString(
                                  //   widget.field.id
                                  //       .substring(5, widget.field.id.length),
                                  //   e.text,
                                  // );
                                  // setState(() {
                                  //   formCon.text = e.text;
                                  // });
                                  // Navigator.pop(context);

                                  // remove text saved in other text field if dropdown value in not
                                  // other
                                  if (e.value != 'other') {
                                    widget.formValue.remove(otherFieldKey);
                                  }
                                  widget.formValue.saveString(
                                    widget.field.id,
                                    e.value,
                                  );

                                  bool containsId = choices
                                      .any((obj) => obj.value == e.value);

                                  if (containsId) {
                                    ValueText? foundObject = choices.firstWhere(
                                      (obj) => obj.value == e.value,
                                    );

                                    widget.formValue.saveString(
                                      widget.field.id
                                          .substring(5, widget.field.id.length),
                                      foundObject.text,
                                    );
                                  }
                                  setState(() => formCon.text = e.text);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    e.text,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // DropdownButtonFormField<String>(
              //   value: value,
              //   key: widget.formKey,
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   validator: (values) => textValidator(
              //     value: values,
              //     inputType: "text",
              //     isRequired: widget.field.isRequired,
              //     requiredErrorText: widget.field.requiredErrorText,
              //   ),
              //   decoration: InputDecoration(
              //     hintText: widget.field.hintText,
              //     suffixIcon: value != null
              //         ? IconButton(
              //             onPressed: () {
              //               setState(() {
              //                 value = null;
              //                 showMessage = false;
              //               });
              //             },
              //             icon: const Icon(
              //               Icons.close,
              //               color: Colors.orange,
              //             ),
              //           )
              //         : null,
              //   ),
              //   items: () {
              //     final items = choices.map((e) {
              //       return DropdownMenuItem(
              //         value: e.value,
              //         child: Text(
              //           e.text,
              //           style: Theme.of(context).textTheme.bodyMedium,
              //         ),
              //       );
              //     }).toList();
              //     return items;
              //   }(),
              //   onChanged: (value) {
              //     setState(() {
              //       this.value = value;
              //     });
              //     checkValue();
              //   },
              //   onSaved: (newValue) {
              //     // remove text saved in other text field if dropdown value in not
              //     // other
              //     if (newValue != 'other') {
              //       widget.formValue.remove(otherFieldKey);
              //     }
              //     widget.formValue.saveString(
              //       widget.field.id,
              //       newValue,
              //     );

              //     bool containsId = choices.any((obj) => obj.value == newValue);

              //     if (containsId) {
              //       ValueText? foundObject = choices.firstWhere(
              //         (obj) => obj.value == newValue,
              //       );

              //       widget.formValue.saveString(
              //         widget.field.id.substring(5, widget.field.id.length),
              //         foundObject.text,
              //       );
              //       // answerText = foundObject.text;
              //     }
              //   },
              // ),
              if (showMessage && (widget.field.actionMessage ?? '').isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(top: 8.0),
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
              if (widget.field.showOtherItem && value == 'other') ...[
                const SizedBox(
                  height: 12,
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
