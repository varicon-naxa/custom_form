import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';


class SubmitUpdateButtonWidget extends StatefulWidget {
  const SubmitUpdateButtonWidget({super.key, required this.buttonText, required this.formKey, required this.formValue, required this.onSubmit, required this.scrollToFirstInvalidField, required this.hasGeolocation, required this.surveyForm, required this.currentPosition, required this.scrollController});

  final String buttonText;
  final GlobalKey<FormState> formKey;
  final FormValue formValue;
  final Function onSubmit;
  final Function scrollToFirstInvalidField;
  final bool hasGeolocation;
  final SurveyPageForm surveyForm;
  final Position? currentPosition;
  final ScrollController scrollController;



  @override
  State<SubmitUpdateButtonWidget> createState() =>
      _SubmitUpdateButtonWidgetState();
}

class _SubmitUpdateButtonWidgetState extends State<SubmitUpdateButtonWidget> {
  bool isScrolled = false;


  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() => detectScroll());
  }

    ///detect screen scroll to hide and show bottom nav bar
  void detectScroll() {
    widget.scrollController.addListener(() {
      if ((widget.scrollController.position.pixels > 10 &&
          widget.scrollController.position.userScrollDirection ==
              ScrollDirection.reverse)) {
        setState(() => isScrolled = true);
      } else {
        setState(() => isScrolled = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      duration: const Duration(milliseconds: 200),
      height: isScrolled ? 0 : 75,
      child: NavigationButton(
        buttonText: widget.buttonText,
        onComplete: () async {
          // return if form state is null.
          if (widget.formKey.currentState == null) return;
          // return if form is not valid.
          if (!widget.formKey.currentState!.validate()) {
            widget.scrollToFirstInvalidField();
            return;
          }

          widget.formKey.currentState?.save();
          Map<String, dynamic> fulldata = widget.formValue.value;

          if (widget.hasGeolocation) {
            fulldata.addAll({
              'location': widget.surveyForm.setting?['location']['lat'] == null
                  ? {
                      'lat': widget.currentPosition?.latitude,
                      'long': widget.currentPosition?.longitude,
                    }
                  : widget.surveyForm.setting?['location']
            });
          }
          widget.onSubmit(widget.formValue.value);
        },
      ),
    );
  }
}
