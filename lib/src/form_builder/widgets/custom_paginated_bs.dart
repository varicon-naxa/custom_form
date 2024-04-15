import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/theme_search_field.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

///Custom paginated bottomsheet
///
///Accepts api call, on clicked and linked query
class CustomPaginatedBottomsheet extends StatefulWidget {
  const CustomPaginatedBottomsheet({
    super.key,
    required this.apiCall,
    required this.onClicked,
    required this.linkedQuery,
  });

  ///Api call function to get data
  final Future<List<dynamic>> Function(Map<String, dynamic>) apiCall;

  ///Function to call on clicked item
  final Function(ValueText data) onClicked;

  ///Linked query to get data
  final String linkedQuery;

  @override
  State<CustomPaginatedBottomsheet> createState() =>
      _CustomPaginatedBottomsheetState();
}

class _CustomPaginatedBottomsheetState
    extends State<CustomPaginatedBottomsheet> {
  TextEditingController searchCon = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  int page = 1;
  List<ValueText> searchedChoice = [];

  bool _showLoadMore = false;
  bool startSearch = true;
  bool isLoading = true;

  ///Method to call paginated api
  ///
  ///Accepts query string to search
  Future hitApi(
    String? q,
  ) async {
    final data = await widget.apiCall({
      'choice_id': widget.linkedQuery,
      'page': page.toString(),
      'q': q ?? ''
    });
    Future.microtask(() {
      setState(() {
        final retrievedData =
            (data.map((e) => const ValueTextConverter().fromJson(e)).toList());
        if (retrievedData.isEmpty) {
          startSearch = false;
        }
        isLoading = false;
        searchedChoice = [...searchedChoice, ...retrievedData];

        page = page + 1;
      });
    });
  }

  ///Method to load more data
  ///
  ///Hit api to get more data for pagination
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
    ///Initial api call
    ///
    ///Hit api to get data on page scroll end
    super.initState();
    hitApi('');
    _scrollController.addListener(_loadMoreData);
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
              searchedChoice = [];
            });
            hitApi(value);
          },
          controllerText: searchCon,
        ),
        isLoading
            ? const CircularProgressIndicator.adaptive()
            : Expanded(
                child: searchedChoice.isEmpty
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
                            child: Text('Equipment'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: const Color(0xff98A5B9))),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  onTap: () {
                                    widget.onClicked(searchedChoice[i]);
                                    Navigator.pop(context);
                                  },
                                  title: Text(
                                    searchedChoice[i].text.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                );
                              },
                              itemCount: searchedChoice.length,
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
