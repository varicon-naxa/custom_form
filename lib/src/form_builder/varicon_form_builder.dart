// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads, unrelated_type_equality_checks

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:varicon_form_builder/scroll/scroll_to_id.dart';
import 'package:varicon_form_builder/src/form_builder/input_field_body.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/bottom_nav_btn_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/form_title_info_widget.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/src/models/models.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:geolocator/geolocator.dart';
part '_helpers.dart';
part '_navigation_button.dart';
part '_validators.dart';

///Main container for the form builder
class VariconFormBuilder extends StatefulWidget {
  const VariconFormBuilder(
      {super.key,
      required this.surveyForm,
      required this.buttonText,
      this.separatorBuilder,
      required this.onSave,
      required this.onSubmit,
      required this.attachmentSave,
      required this.imageBuild,
      required this.isCarousel,
      required this.hasGeolocation,
      required this.onFileClicked,
      this.apiCall,
      this.padding,
      this.hasSave = false});

  ///Survey page form model
  ///
  ///Contains forms metadata
  ///
  ///Contains forms various input fields
  final SurveyPageForm surveyForm;

  ///Button text title
  ///
  ///Required to be displayed on the form button
  final String buttonText;

  ///Form save callback
  ///
  ///Required to save the form data
  final void Function(Map<String, dynamic> formValue) onSave;

  ///Form submit callback
  ///
  ///Submit data with filled values
  final void Function(Map<String, dynamic> formValue) onSubmit;

  ///function to save attachments
  ///
  ///Contains function with list of attachments
  ///
  ///Used for images and files like signature
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  ///Used to store image paths and file paths
  ///With height and width
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///API call function
  ///
  ///Handles various api calls required for dropdowns
  ///
  ///Returns list of dynamic values
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  ///Check the condition if a form item should be displayed as a carousel
  final bool isCarousel;

  ///Padding for the whole form
  final EdgeInsetsGeometry? padding;

  ///Check if a form has geolocation
  ///
  ///If true, it will capture the approximate location from where the form is being submitted
  final bool hasGeolocation;

  ///Check if a form has save button
  ///
  ///Shows the save button on the form
  final bool hasSave;

  ///Function to handle file click
  ///
  ///Returns the file path for form contents like images, files, instructions
  final void Function(String stringURl) onFileClicked;

  @override
  State<VariconFormBuilder> createState() => VariconFormBuilderState();

  final Widget Function()? separatorBuilder;
}

class VariconFormBuilderState extends State<VariconFormBuilder> {
  ///Global key to be inizialized for custom forms
  late final GlobalKey<FormState> formKey;

  ///Global key to be inizialized for signature
  late final GlobalKey<SignatureState> signKey;

  ScrollToId? scrollToId;
  final ScrollController scrollControllerId = ScrollController();

  ///Global key list to make each field unique

  ///Track total form question counts
  final Map<String, GlobalKey<FormFieldState<dynamic>>> _formFieldKeys = {};
  final Map<GlobalKey<FormFieldState<dynamic>>, String> _fieldKeyToIdMap = {};
  bool isScrolled = false;

  ///Values to be submitted via forms
  final formValue = FormValue();

  // Initialize the keys and mapping
  void _initializeKeys(List<InputField> inputFields) {
    for (var field in inputFields) {
      final key = GlobalKey<FormFieldState<dynamic>>();
      _formFieldKeys[field.id] = key;
      _fieldKeyToIdMap[key] = field.id;
    }
  }

  @override
  void initState() {
    super.initState();

    ///Initializing custom form state
    ///
    ///Sets input fields and global keys
    _initializeKeys(widget.surveyForm.inputFields);

    formKey = GlobalKey<FormState>();
    signKey = GlobalKey<SignatureState>();

    /// Create ScrollToId instance
    scrollToId = ScrollToId(scrollController: scrollControllerId);

    // scrollControllerId.addListener(() => detectScroll());

    _getCurrentPosition();
  }

  @override
  void dispose() {
    scrollControllerId.dispose();
    super.dispose();
  }

  ///Position variable to store current postion for form
  Position? _currentPosition;

  ///Method to handle location
  ///
  ///Checks and ask for user location permission
  Future<bool> _handleLocationPermission() async {
    if (widget.hasGeolocation) {
      bool serviceEnabled;
      LocationPermission permission;

      ///Asks for user location status
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
        return false;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
          return false;
        }
      }

      ///If location permission denied forever user should turn it from from app settings
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.'),
          ),
        );
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  ///Method to handle user location
  ///
  ///Check for location permission and fetch position
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // /Method to handle error/empty on submit
  // /
  // /Locates user to the form field with issue
  void scrollToFirstInvalidField() {
    // Form is invalid, find the first invalid field and scroll to it
    FocusScope.of(context).requestFocus(FocusNode()); // Unfocus current field

    for (var entry in _fieldKeyToIdMap.entries) {
      var fieldKey = entry.key;
      var fieldId = entry.value;

      if (fieldKey.currentState != null) {
        if (!fieldKey.currentState!.validate()) {
          scrollToId?.animateTo(fieldId,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
          break;
        }
      }
    }
  }

  ///Method to compare difference between two map values
  bool compareMaps(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    // Check if both maps have the same keys
    if (!map1.keys.toSet().containsAll(map2.keys.toSet()) ||
        !map2.keys.toSet().containsAll(map1.keys.toSet())) {
      return false;
    }

    // Check if values for each key are equal
    for (var key in map1.keys) {
      if (map1[key] != map2[key]) {
        return false;
      }
    }

    return true;
  }

  bool popInvoke() {
    Map<String, dynamic> initialResult = {};
    for (var field in widget.surveyForm.inputFields) {
      if (field.answer != null && field.answer != '') {
        if (field.answer is List) {
          if (((field.answer ?? []) as List).isNotEmpty) {
            initialResult[field.id] = field.answer;
          }
        } else {
          initialResult[field.id] = field.answer;
        }
      }
    }
    formKey.currentState?.save();
    Map<String, dynamic> fulldata = formValue.value;
    bool areEqual = compareMaps(initialResult, fulldata);

    return areEqual;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SubmitUpdateButtonWidget(
        formKey: formKey,
        formValue: formValue,
        scrollController: scrollControllerId,
        hasGeolocation: widget.hasGeolocation,
        surveyForm: widget.surveyForm,
        currentPosition: _currentPosition,
        buttonText: widget.buttonText,
        onSubmit: widget.onSubmit,
        scrollToFirstInvalidField: scrollToFirstInvalidField,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: InteractiveScrollViewer(
              scrollToId: scrollToId,
              scrollDirection: Axis.vertical,
              children: [
                ScrollContent(
                  id: 'form_title',
                  child: FormTitleInfoWidget(
                    hasGeolocation: widget.hasGeolocation,
                    surveyForm: widget.surveyForm,
                    currentPosition: _currentPosition,
                    scrollController: scrollControllerId,
                  ),
                ),
                ScrollContent(
                  id: 'separate',
                  child: InputFieldsBody(
                      inputfields: widget.surveyForm.inputFields,
                      formFieldKeys: _formFieldKeys,
                      fieldKeyToIdMap: _fieldKeyToIdMap,
                      scrollToId: scrollToId,
                      formValue: formValue,
                      onFileClicked: widget.onFileClicked,
                      imageBuild: widget.imageBuild,
                      hasGeolocation: widget.hasGeolocation,
                      currentPosition: _currentPosition,
                      apiCall: widget.apiCall,
                      attachmentSave: widget.attachmentSave),
                ),
                if (widget.hasSave) ...[
                  ScrollContent(
                      id: 'spacing', child: AppSpacing.sizedBoxH_08()),
                  ScrollContent(
                    id: 'save_button',
                    child: _SaveOnlyButton(onComplete: () {
                      formKey.currentState?.save();
                      Map<String, dynamic> fulldata = formValue.value;

                      if (widget.hasGeolocation) {
                        fulldata.addAll({
                          'location': widget.surveyForm.setting?['location']
                                      ['lat'] ==
                                  null
                              ? {
                                  'lat': _currentPosition?.latitude,
                                  'long': _currentPosition?.longitude,
                                }
                              : widget.surveyForm.setting?['location']
                        });
                      }
                      widget.onSave(formValue.value);
                    }),
                  ),
                  ScrollContent(
                      id: 'spacing_2', child: AppSpacing.sizedBoxH_12()),
                ],
              ]),
        ),
      ),
    );
  }
}

///HTML editor widget class
class HtmlEditorWidget extends StatefulWidget {
  final TextInputField field;
  final HtmlEditorController htmlEditorController;
  final HtmlEditorOptions editorOptions;
  final FormValue formValue;
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;
  final TextEditingController formCon;

  const HtmlEditorWidget({
    super.key,
    required this.field,
    required this.htmlEditorController,
    required this.editorOptions,
    required this.formValue,
    this.fieldKey,
    required this.formCon,
  });

  @override
  State<HtmlEditorWidget> createState() => _HtmlEditorWidgetState();
}

class _HtmlEditorWidgetState extends State<HtmlEditorWidget> {
  bool empty = false;
  final _debouncer = Debouncer(milliseconds: 300);

  void saveLongText() {
    widget.formValue.saveString(
      widget.field.id,
      widget.formCon.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(4.0)),
            child: HtmlEditor(
              callbacks: Callbacks(
                onFocus: () {
                  saveLongText();
                },
                onBlur: () {
                  saveLongText();
                },
                onChangeContent: (code) {
                  if (code.toString().trim().isNotEmpty) {
                    _debouncer.run(() {
                      Future.microtask(() {
                        widget.formCon.text = code.toString().trim();
                        saveLongText();
                      });
                    });
                  }
                },
              ),
              controller: widget.htmlEditorController, //required
              plugins: const [],
              htmlEditorOptions: widget.editorOptions,
              htmlToolbarOptions: const HtmlToolbarOptions(
                defaultToolbarButtons: [
                  FontButtons(
                    clearAll: false,
                    strikethrough: false,
                    subscript: false,
                    superscript: false,
                  ),
                  ListButtons(listStyles: false),
                  ParagraphButtons(
                    caseConverter: false,
                    lineHeight: false,
                    textDirection: false,
                    increaseIndent: false,
                    decreaseIndent: false,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          child: Visibility(
            visible: true,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                enabled: false,
                // errorText: empty == true ? 'Long text is required' : '',
                labelStyle: const TextStyle(color: Colors.white),
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              controller: widget.formCon,
              key: widget.fieldKey,
              readOnly: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // onChanged: (value) {
              //   setState(() {
              //     empty = false;
              //   });
              // },
              validator: (value) {
                // setState(() {
                //   empty = true;
                // });
                return textValidator(
                  value: value.toString().trim(),
                  inputType: "text",
                  isRequired: (widget.field.isRequired),
                  requiredErrorText: 'Long text is required',
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

///Debouncer class for search feature
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 1000});

  ///checks the timer with durations
  run(VoidCallback action) {
    if (_timer != null || (_timer?.isActive ?? false)) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
