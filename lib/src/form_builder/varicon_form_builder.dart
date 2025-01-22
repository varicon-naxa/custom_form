// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads, unrelated_type_equality_checks

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:varicon_form_builder/scroll/scroll_to_id.dart';
import 'package:varicon_form_builder/src/form_builder/form_elements.dart';
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
  const VariconFormBuilder({
    super.key,
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
    required this.autoSave,
    required this.customPainter,
    required this.locationData,
    this.apiCall,
    this.padding,
    this.hasSave = false,
    this.hasAutoSave = false,
  });

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

  ///Widget for custom image painter
  final Widget Function(File imageFile) customPainter;

  ///Current Location
  final String locationData;

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

  ///Used to store image paths and file paths
  ///With height and width
  final void Function(Map<String, dynamic>) autoSave;

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

  ///Check if a form has save button
  ///
  ///Shows the save button on the form
  final bool hasAutoSave;

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

  ///Global key list to make each field unique

  ///Track total form question counts
  final GlobalKey<FormInputWidgetsState> formInputWidgetsKey =
      GlobalKey<FormInputWidgetsState>();

  bool isScrolled = false;

  ///Values to be submitted via forms
  final formValue = FormValue();

  @override
  void initState() {
    super.initState();
    formValue.setOnSaveCallback(widget.autoSave);

    formKey = GlobalKey<FormState>();
    signKey = GlobalKey<SignatureState>();
    // scrollControllerId.addListener(() => detectScroll());

    _getCurrentPosition();
  }

  @override
  void dispose() {
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

  void clearEmptyListsAndMaps(Map<String, dynamic> map) {
    map.removeWhere((key, value) =>
        (value is List && value.isEmpty) || (value is Map && value.isEmpty));
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
    clearEmptyListsAndMaps(initialResult);

    Map<String, dynamic> fulldata = {};
    fulldata.addAll(formValue.value);
    clearEmptyListsAndMaps(fulldata);

    bool areEqual = compareMaps(initialResult, fulldata);

    return areEqual;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SubmitUpdateButtonWidget(
        formInputWidgetsKey: formInputWidgetsKey,
        formKey: formKey,
        formValue: formValue,
        hasGeolocation: widget.hasGeolocation,
        surveyForm: widget.surveyForm,
        currentPosition: _currentPosition,
        buttonText: widget.buttonText,
        onSubmit: widget.onSubmit,
        hasAutoSave: widget.hasAutoSave,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Expanded(
                child: FormInputWidgets(
                  key: formInputWidgetsKey,
                  surveyForm: widget.surveyForm,
                  formValue: formValue,
                  currentPosition: _currentPosition,
                  attachmentSave: widget.attachmentSave,
                  imageBuild: widget.imageBuild,
                  onFileClicked: widget.onFileClicked,
                  hasGeolocation: widget.hasGeolocation,
                  apiCall: widget.apiCall,
                  locationData: widget.locationData,
                  customPainter: widget.customPainter,
                ),
              ),
              if (widget.hasSave) ...[
                ScrollContent(id: 'spacing', child: AppSpacing.sizedBoxH_08()),
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
                // ScrollContent(
                //     id: 'spacing_2', child: AppSpacing.sizedBoxH_12()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
