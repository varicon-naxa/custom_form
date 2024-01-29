import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/theme_search_field.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_bottomsheet.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_paginated_bs.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import '../../../varicon_form_builder.dart';

class DropdownInputWidget extends StatefulWidget {
  const DropdownInputWidget(
      {super.key,
      required this.field,
      required this.formValue,
      required this.formKey,
      required this.labelText,
      this.apiCall});

  final DropdownInputField field;
  final FormValue formValue;
  final Key formKey;
  final String? labelText;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  State<DropdownInputWidget> createState() => _DropdownInputWidgetState();
}

class _DropdownInputWidgetState extends State<DropdownInputWidget> {
  String? value;
  TextEditingController formCon = TextEditingController();
  TextEditingController searchCon = TextEditingController();

  late final List<ValueText> choices;
  List<ValueText> searchedChoice = [];
  late final String otherFieldKey;

  @override
  void initState() {
    super.initState();

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
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !(widget.field.fromManualList)
        ? TextField(
            readOnly: true,
            controller: formCon,
            key: widget.formKey,
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.arrow_drop_down,
              ),
            ),
            onTap: () {
              if (widget.field.islinked ?? false) {
                primaryBottomSheet(
                  context,
                  child: CustomPaginatedBottomsheet(
                    apiCall: widget.apiCall!,
                    linkedQuery: widget.field.linkedQuery ?? '',
                    onClicked: (ValueText data) {
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
              } else {
                primaryBottomSheet(
                  context,
                  child: StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        ThemeSearchField(
                          name: '',
                          hintText: 'Search ...',
                          onChange: (value) {
                            setState(() {
                              searchedChoice = choices
                                  .where((obj) => obj.text.contains(value))
                                  .toList();
                            });
                          },
                          controllerText: searchCon,
                        ),
                        Expanded(
                          child: searchedChoice.isEmpty
                              ? Center(
                                  child: Text(
                                    'Empty List',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return ListTile(
                                      onTap: () {
                                        widget.formValue.saveString(
                                          widget.field.id,
                                          searchedChoice[i].value,
                                        );
                                        setState(() {
                                          formCon.text = searchedChoice[i].text;
                                        });
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        searchedChoice[i].text.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    );
                                  },
                                  itemCount: searchedChoice.length,
                                ),
                        ),
                      ],
                    );
                  }),
                );
              }
            },
          )
        : Column(
            children: [
              DropdownButtonFormField<String>(
                value: value,
                key: widget.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (values) => textValidator(
                  value: values,
                  inputType: "text",
                  isRequired: widget.field.isRequired,
                  requiredErrorText: widget.field.requiredErrorText,
                ),
                decoration: InputDecoration(
                  hintText: widget.field.hintText,
                  suffixIcon: value != null
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              value = null;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.orange,
                          ),
                        )
                      : null,
                ),
                items: () {
                  final items = choices.map((e) {
                    return DropdownMenuItem(
                      value: e.value,
                      child: Text(
                        e.text,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }).toList();
                  return items;
                }(),
                onChanged: (value) {
                  setState(() {
                    this.value = value;
                  });
                },
                onSaved: (newValue) {
                  // remove text saved in other text field if dropdown value in not
                  // other
                  if (newValue != 'other') {
                    widget.formValue.remove(otherFieldKey);
                  }
                  widget.formValue.saveString(
                    widget.field.id,
                    newValue,
                  );
                },
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
