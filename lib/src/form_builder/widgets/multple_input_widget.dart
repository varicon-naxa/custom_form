import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_bottomsheet.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_multi_bottomsheet.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/simple_bottomsheet.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import '../../../varicon_form_builder.dart';
import '../../models/form_value.dart';

///Custom form multiple input form component
///
///Accepts field type with multiple input
///
///Allows to select multiple options
class MultipleInputWidget extends StatefulWidget {
  const MultipleInputWidget({
    super.key,
    required this.field,
    required this.formValue,
    required this.formKey,
    this.apiCall,
    this.labelText,
  });

  ///Multiple input field model
  final MultipleInputField field;

  ///Form value to be used for multiple input
  final FormValue formValue;

  ///Form key for unique form field
  final Key formKey;

  ///Field label text
  final String? labelText;

  ///Api call function for multi input options
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  State<MultipleInputWidget> createState() => _MultipleInputWidgetState();
}

class _MultipleInputWidgetState extends State<MultipleInputWidget> {
  //Late initialization of variables/keys
  late List<bool?> selectedChoices;
  late final List<ValueText> choices;
  late final String otherFieldKey;
  late final bool showSelectAllOption;

  ///Local variables for answer, searched choice, message and controllers
  String? answer;
  List<ValueText> searchedChoice = [];
  bool showMessage = false;
  TextEditingController formCon = TextEditingController();
  TextEditingController searchCon = TextEditingController();
  List<String> selectedIds = [];

  @override
  void initState() {
    super.initState();
    answer = (widget.field.answer ?? '').isEmpty ? null : widget.field.answer;

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
    final List<String>? initialValue = answer?.split(',');

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
      if ((initialValue ?? []).isEmpty) {
        formCon.text = 'Select the item from list';
      } else {
        formCon.text = '${(initialValue ?? []).length} item selected';
      }
    });
  }

  ///Method to check for matching actions
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

  ///Method to check selected options
  bool isNoneSelected() => _isSelected((v) => v is NoneValueText);
  bool isOtherSelected() => _isSelected((v) => v is OtherValueText);

  bool _isSelected(bool Function(ValueText v) fun) {
    final index = choices.indexWhere(fun);
    if (index == -1) return false;
    return selectedChoices.elementAtOrNull(index) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // List<bool> actionList = choices.map((e) => e.action ?? false).toList();
    return Column(children: [
      TextFormField(
        readOnly: true,
        key: widget.formKey,
        controller: formCon,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if ((answer?.split(',') ?? []).isEmpty) {
            return textValidator(
              value: '',
              inputType: "text",
              isRequired: (widget.field.isRequired &&
                  formCon.text == 'Select the item from list'),
              requiredErrorText: widget.field.requiredErrorText ??
                  'No any Selection in required field  ',
            );
          }
          return null;
        },
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: const InputDecoration(
          suffixIcon: Icon(
            Icons.arrow_drop_down,
          ),
        ),
        onTap: () {
          if (!(widget.field.fromManualList)) {
            primaryBottomSheet(context,
                child: CustomMultiBottomsheet(
                  apiCall: widget.apiCall!,
                  answer: (widget.field.answer ?? '').isEmpty
                      ? selectedIds.join(',')
                      : widget.field.answer ?? selectedIds.join(','),
                  linkedQuery: widget.field.linkedQuery ?? '',
                  onCheckboxClicked:
                      (List<String> data, List<String> nameList) {
                    var a = data;
                    data.sort();
                    widget.formValue.saveString(
                      widget.field.id,
                      data.join(','),
                    );
                    nameList.sort();
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
              child: SimpleBottomSheet(
                onCheckboxClicked: (List<String> data, List<String> nameList) {
                  data.sort();
                  widget.formValue.saveString(
                    widget.field.id,
                    data.join(','),
                  );
                  nameList.sort();
                  widget.formValue.saveString(
                    widget.field.id.substring(5, widget.field.id.length),
                    nameList.join(','),
                  );
                  setState(() {
                    selectedIds = data;
                    selectedChoices = choices.map(
                      (e) {
                        if (data.join(',').contains(e.value)) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                    ).toList();
                    showMessage = checkMatchingActions();

                    if ((data).isEmpty) {
                      formCon.text = 'Select the item from list';
                    } else {
                      formCon.text = '${(selectedIds).length} item selected';
                    }
                  });
                },
                answer: selectedIds.join(','),
                choices: widget.field.choices,
              ),
            );
          }
        },
      ),

      /// Alert message if action is selected
      if (showMessage && (widget.field.actionMessage ?? '').isNotEmpty) ...[
        AppSpacing.sizedBoxH_06(),
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
      ],

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
    ]);
  }
}
