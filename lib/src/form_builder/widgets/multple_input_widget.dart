import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/theme_search_field.dart';
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
    } else if (initialValue != null &&
        initialValue.isNotEmpty &&
        !(widget.field.islinked ?? false)) {
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
    } else if (widget.field.islinked ?? false) {
      setState(() {
        selectedIds = initialValue ?? [];
      });
    } else {
      selectedChoices = List.filled(choices.length, null);
    }
    setState(() {
      if ((selectedIds).isEmpty) {
        formCon.text = 'Select items from the list';
      } else {
        formCon.text = '${(selectedIds).length} item selected';
      }
    });
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
    return TextFormField(
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
        if (widget.field.islinked ?? false) {
          primaryBottomSheet(context,
              child: CustomMultiBottomsheet(
                apiCall: widget.apiCall!,
                answer: (widget.field.answer ?? '').isEmpty
                    ? selectedIds.join(',')
                    : widget.field.answer ?? selectedIds.join(','),
                linkedQuery: widget.field.linkedQuery ?? '',
                onCheckboxClicked: (List<String> data, List<String> nameList) {
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
                      formCon.text = '${(selectedIds).length} item selected';
                    }
                  });
                },
              ));
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
                            .where((obj) => obj.text
                                .toLowerCase()
                                .contains(value.toLowerCase()))
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
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {
                                  if (selectedIds
                                      .contains(searchedChoice[i].value)) {
                                    setState(() {
                                      selectedIds
                                          .remove(searchedChoice[i].value);
                                    });
                                  } else {
                                    setState(() {
                                      selectedIds.add(searchedChoice[i].value);
                                    });
                                  }
                                  widget.formValue.saveString(
                                    widget.field.id,
                                    selectedIds.join(','),
                                  );
                                  setState(() {
                                    if ((selectedIds).isEmpty) {
                                      formCon.text =
                                          'Select the item from list';
                                    } else {
                                      formCon.text =
                                          '${(selectedIds).length} item selected';
                                    }
                                  });
                                },
                                title: Text(
                                  searchedChoice[i].text.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                trailing: Checkbox(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  value: selectedIds
                                      .contains(searchedChoice[i].value),
                                  onChanged: (value) {
                                    if (selectedIds
                                        .contains(searchedChoice[i].value)) {
                                      setState(() {
                                        selectedIds
                                            .remove(searchedChoice[i].value);
                                      });
                                    } else {
                                      setState(() {
                                        selectedIds
                                            .add(searchedChoice[i].value);
                                      });
                                    }
                                    widget.formValue.saveString(
                                      widget.field.id,
                                      selectedIds.join(','),
                                    );
                                    setState(() {
                                      if ((selectedIds).isEmpty) {
                                        formCon.text =
                                            'Select the item from list';
                                      } else {
                                        formCon.text =
                                            '${(selectedIds).length} item selected';
                                      }
                                    });
                                  },
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
    );
  }
}
