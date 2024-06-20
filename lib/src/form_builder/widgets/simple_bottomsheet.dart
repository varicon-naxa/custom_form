import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/theme_search_field.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

///Custom bottom sheet widget
///
///Bottom sheet for form with multi options
///
///Can list and search items with checkbox
class SimpleBottomSheet extends StatefulWidget {
  const SimpleBottomSheet(
      {super.key,
      required this.onCheckboxClicked,
      required this.answer,
      required this.choices});

  ///Checkbox clicked function
  ///
  ///Accepts list of data and list of name
  final Function(List<String> data, List<String> nameList) onCheckboxClicked;
  final String answer;

  ///Store choices option values
  final List<ValueText> choices;

  @override
  State<SimpleBottomSheet> createState() => _SimpleBottomSheetState();
}

class _SimpleBottomSheetState extends State<SimpleBottomSheet> {
  TextEditingController searchCon = TextEditingController();
  List<ValueText> searcgedChoices = [];
  List<String> selectedIds = [];

  @override
  void initState() {
    ///Initializing values
    super.initState();
    final List<String> initialValue = widget.answer.split(',');
    setState(() {
      searcgedChoices = widget.choices;
      if ((widget.answer).isNotEmpty) {
        selectedIds = initialValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemeSearchField(
          name: '',
          hintText: 'Search ...',
          onChange: (value) {
            setState(() {
              searcgedChoices = widget.choices
                  .where((element) =>
                      element.text.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          },
          controllerText: searchCon,
        ),
        Expanded(
          child: searcgedChoices.isEmpty
              ? Center(
                  child: Text(
                    'Empty List',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.sizedBoxH_16(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('List of Items'.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: const Color(0xff98A5B9))),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemBuilder: (context, i) {
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              child: ListTile(
                                onTap: () {
                                  if (selectedIds
                                      .contains(searcgedChoices[i].value)) {
                                    setState(() {
                                      selectedIds
                                          .remove(searcgedChoices[i].value);
                                    });
                                  } else {
                                    setState(() {
                                      selectedIds.add(searcgedChoices[i].value);
                                    });
                                  }
                                  List<ValueText> selectedNamelist =
                                      searcgedChoices.fold([],
                                          (previousValue, element) {
                                    if (selectedIds.contains(element.value)) {
                                      previousValue.add(element);
                                    }
                                    return previousValue;
                                  });
                                  widget.onCheckboxClicked(
                                      selectedIds,
                                      selectedNamelist
                                          .map((obj) => obj.text)
                                          .toList());
                                },
                                title: Text(
                                  searcgedChoices[i].text.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                trailing: Checkbox(
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  value: selectedIds
                                      .contains(searcgedChoices[i].value),
                                  onChanged: (value) {
                                    if (selectedIds
                                        .contains(searcgedChoices[i].value)) {
                                      setState(() {
                                        selectedIds
                                            .remove(searcgedChoices[i].value);
                                      });
                                    } else {
                                      setState(() {
                                        selectedIds
                                            .add(searcgedChoices[i].value);
                                      });
                                    }
                                    List<ValueText> selectedNamelist =
                                        searcgedChoices.fold([],
                                            (previousValue, element) {
                                      if (selectedIds.contains(element.value)) {
                                        previousValue.add(element);
                                      }
                                      return previousValue;
                                    });
                                    widget.onCheckboxClicked(
                                        selectedIds,
                                        selectedNamelist
                                            .map((obj) => obj.text)
                                            .toList());
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: searcgedChoices.length,
                      ),
                    ),
                  ],
                ),
        ),
        AppSpacing.sizedBoxH_16(),
      ],
    );
  }
}
