import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/theme_search_field.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

class CustomMultiBottomsheet extends StatefulWidget {
  const CustomMultiBottomsheet({
    super.key,
    required this.apiCall,
    required this.onCheckboxClicked,
    required this.answer,
    required this.linkedQuery,
  });
  final Future<List<dynamic>> Function(Map<String, dynamic>) apiCall;
  final Function(List<String> data, List<String> nameList) onCheckboxClicked;
  final String linkedQuery;
  final String answer;

  @override
  State<CustomMultiBottomsheet> createState() => _CustomMultiBottomsheetState();
}

class _CustomMultiBottomsheetState extends State<CustomMultiBottomsheet> {
  TextEditingController searchCon = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  int page = 1;
  List<ValueText> searcgedChoices = [];
  List<String> selectedIds = [];

  bool _showLoadMore = false;
  bool startSearch = true;
  bool isLoading = true;

  Future hitApi(
    String? q,
  ) async {
    final data = await widget.apiCall({
      'choice_id': widget.linkedQuery,
      'page': page.toString(),
      'q': q ?? ''
    });
    setState(() {
      final retrievedData =
          (data.map((e) => const ValueTextConverter().fromJson(e)).toList());
      if (retrievedData.isEmpty) {
        startSearch = false;
      }
      isLoading = false;
      searcgedChoices = [...searcgedChoices, ...retrievedData];

      page = page + 1;
    });
  }

  void _loadMoreData() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list
      // Load more data or trigger pagination in flutter
      setState(() {
        _showLoadMore = true;
      });
      if (startSearch) {
        await hitApi(searchCon.text).then((value) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _showLoadMore = false;
            });
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    hitApi('');
    _scrollController.addListener(_loadMoreData);
    final List<String> initialValue = widget.answer.split(',');
    setState(() {
      if ((widget.answer).isNotEmpty) {
        selectedIds = initialValue;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              page = 1;
              isLoading = true;
              searcgedChoices = [];
            });
            hitApi(value);
          },
          controllerText: searchCon,
        ),
        isLoading
            ? const CircularProgressIndicator.adaptive()
            : Expanded(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(widget.linkedQuery.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: const Color(0xff98A5B9))),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  onTap: () {
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
                                  title: Text(
                                    searcgedChoices[i].text.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                        if (selectedIds
                                            .contains(element.value)) {
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
                                );
                              },
                              itemCount: searcgedChoices.length,
                            ),
                          ),
                        ],
                      ),
              ),
        AppSpacing.sizedBoxH_16(),
        _showLoadMore
            ? Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    AppSpacing.sizedBoxH_06(),
                    Text(
                      'Loading more data...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
