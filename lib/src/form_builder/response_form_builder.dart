import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:varicon_form_builder/src/ext/color_extension.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_location.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import 'response_widget.dart';
import 'widgets/labeled_widget.dart';

///Main container for the respose form builder
class ResponseFormBuilder extends StatefulWidget {
  const ResponseFormBuilder({
    super.key,
    required this.surveyForm,
    required this.hasGeolocation,
    required this.imageBuild,
    required this.fileClick,
    required this.timesheetClick,
  });

  ///Survey page form model
  ///
  ///Contains forms metadata
  ///
  ///Contains forms various input fields
  final SurveyPageForm surveyForm;

  ///Check if a form has geolocation
  ///
  ///If true, it will capture the approximate location from where the form is being submitted
  final bool hasGeolocation;

  ///Used to store image paths and file paths
  ///
  ///With height and width
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to handle file click
  ///
  ///Returns the file path for form contents like images, files, instructions
  final Function(Map<String, dynamic> url) fileClick;

  /// Function to handle Timesheet id click
  ///
  ///  Redirect to timesheet detail page
  final Function(String) timesheetClick;

  @override
  State<ResponseFormBuilder> createState() => _ResponseFormBuilderState();
}

class _ResponseFormBuilderState extends State<ResponseFormBuilder> {
  ///Values to be submitted via forms
  final formValue = FormValue();

  ///initializing the state
  @override
  void initState() {
    super.initState();
  }

  ///Dispose resources
  @override
  void dispose() {
    super.dispose();
  }

  ///method to get device screen type
  bool get isTablet {
    final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalShortestSide =
        firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
    return logicalShortestSide > 600;
  }

  @override
  Widget build(BuildContext context) {
    ///Track total form question counts

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              16.0,
              16.0,
              0.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Submission ID:',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(widget.surveyForm.submissionNumber ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.black)),
                    const VerticalDivider(),
                    Text('Form ID:',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(widget.surveyForm.formNumber ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.black)),
                  ],
                ),
                Text(
                  widget.surveyForm.title.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        height: 1.2,
                      ),
                ),
                AppSpacing.sizedBoxH_08(),
                Text(
                  widget.surveyForm.description.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xff6A737B),
                      ),
                ),
                AppSpacing.sizedBoxH_08(),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: const Color(0xffF3F6FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((widget.surveyForm.submittedBy ?? '').isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Submitted by',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                        ),
                      ),
                      Text(
                        widget.surveyForm.submittedBy ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xff6A737B),
                            ),
                      ),
                    ],
                  ),
                if (widget.surveyForm.createdAt != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Submitted on',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy, h:mm a').format(
                          (widget.surveyForm.createdAt ?? DateTime.now()),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xff6A737B),
                            ),
                      ),
                    ],
                  ),
                if (widget.surveyForm.timesheet != null)
                  InkWell(
                    onTap: () {
                      widget.timesheetClick(widget.surveyForm.timesheet ?? '');
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Timesheet ID',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: const Color(0xff212529),
                                ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.end,
                            widget.surveyForm.timesheetNumber ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.orange,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.surveyForm.equipment != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Equipment',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                        ),
                      ),
                      Text(
                        widget.surveyForm.equipmentName ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xff6A737B),
                            ),
                      ),
                    ],
                  ),
                if (widget.surveyForm.project != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Project',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.surveyForm.jobNumber ??
                              widget.surveyForm.project ??
                              '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xff6A737B),
                                  ),
                        ),
                      ),
                    ],
                  ),
                if (widget.surveyForm.updatedBy != null) ...[
                  const Divider(),
                  RichText(
                    text: TextSpan(
                      text: 'Last Edited ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                            text: 'by ${widget.surveyForm.updatedBy} ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'on ${DateFormat('dd/MM/yyyy, h:mm a').format(
                          widget.surveyForm.updatedAt ?? DateTime.now(),
                        )}.'),
                      ],
                    ),
                  ),
                ],
                AppSpacing.sizedBoxH_08(),
                if (widget.surveyForm.status != null &&
                    widget.surveyForm.status?['id'] != null)
                  Container(
                    padding: const EdgeInsets.all(4),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: HexColor.fromHex(
                            widget.surveyForm.status!['color'] ?? ''),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      widget.surveyForm.status!['label'].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ResponseWidget(
              inputFields: widget.surveyForm.inputFields,
              imageBuild: widget.imageBuild,
              hasGeolocation: widget.hasGeolocation,
              isTablet: isTablet,
              fileClick: widget.fileClick,
              formValue: formValue,
            ),
          ),
          if (widget.hasGeolocation &&
              widget.surveyForm.setting?['location'] != null)
            LabeledWidget(
              labelText: 'Geolocation',
              isRequired: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.location_on_outlined),
                      label: Text(
                        widget.surveyForm.setting?['location']['address'],
                        style: const TextStyle(fontSize: 16),
                      )),
                  CustomLocation(
                    postition: Position(
                        longitude: widget.surveyForm.setting?['location']
                            ['long'],
                        latitude: widget.surveyForm.setting?['location']['lat'],
                        timestamp: DateTime.timestamp(),
                        accuracy: 50.0,
                        altitude: 0.0,
                        altitudeAccuracy: 50.0,
                        heading: 50.0,
                        headingAccuracy: 50.0,
                        speed: 2.0,
                        speedAccuracy: 50.0),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

///Widget that represents forms answer design
///
///soley for singular form items like text, titles, single image,files
// ignore: must_be_immutable
class AnswerDesign extends StatelessWidget {
  AnswerDesign({
    super.key,
    required this.answer,
    this.isImage = false,
    this.isSignature = false,
    this.imageBuild,
    this.fileClick,
    this.isFile = false,
  });

  ///String values for text, image urls, files content
  final String answer;

  ///Function for image/signature builder
  final Widget Function(Map<String, dynamic>)? imageBuild;

  ///Function to handle file cliks action
  final Function? fileClick;

  ///Checking for image
  bool isImage;

  ///Checking for file
  bool isFile;

  ///Checking for signature
  bool isSignature;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isImage
            ? imageBuild != null
                ? imageBuild!({
                    'image': answer,
                    'height': 120.0,
                    'width': isSignature ? 200.0 : 120,
                  })
                : CachedNetworkImage(
                    imageUrl: answer,
                    height: isSignature ? 150 : 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholderFadeInDuration: const Duration(seconds: 1),
                    placeholder: (context, url) => const Icon(Icons.image),
                    errorWidget: (context, error, stackTrace) => const SizedBox(
                      height: 75,
                      child: Icon(
                        Icons.image,
                        size: 40,
                      ),
                    ),
                  )
            : isFile
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      fileClick!();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                answer,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          const Icon(Icons.download)
                        ],
                      ),
                    ),
                  )
                : Text(
                    answer.isEmpty ? 'No Response' : answer,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: answer.isEmpty ? Colors.grey : Colors.black),
                  ),
        // if (containsLine)
        //   const DottedLine(
        //     direction: Axis.horizontal,
        //     alignment: WrapAlignment.center,
        //     lineLength: double.infinity,
        //     lineThickness: 1.0,
        //     dashLength: 4.0,
        //     dashColor: Colors.grey,
        //     dashRadius: 0.0,
        //     dashGapLength: 4.0,
        //     dashGapColor: Colors.white,
        //     dashGapRadius: 0.0,
        //   )
      ],
    );
  }
}

/// Widget that represent map field answer design

class AnswerMapDesign extends StatelessWidget {
  const AnswerMapDesign({
    super.key,
    required this.answer,
  });

  ///String values for text, image urls, files content
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                (answer).isEmpty ? 'No Response' : answer,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: answer.isEmpty ? Colors.grey : Colors.black),
              ),
            ),
            // if (answer.containsKey('lat') &&
            //     answer.containsKey('long') &&
            //     answer['lat'] != 0.0 &&
            //     answer['long'] != 0.0)
            IconButton(
              onPressed: () {
                ///Navigate to Simple Map Page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute<void>(
                //     builder: (BuildContext context) {
                //       return SimpleMap(
                //         lat: answer['lat'],
                //         long: answer['long'],
                //       );
                //     },
                //   ),
                // );
              },
              icon: const Icon(
                Icons.directions,
              ),
            )
          ],
        ),
        const DottedLine(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          lineLength: double.infinity,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: Colors.grey,
          dashRadius: 0.0,
          dashGapLength: 4.0,
          dashGapColor: Colors.white,
          dashGapRadius: 0.0,
        )
      ],
    );
  }
}

///Widget that represents multi-forms answer design
///
///soley for multiple form items like text, titles,image,files
class MultiAnswerDesign extends StatelessWidget {
  const MultiAnswerDesign({
    super.key,
    required this.answer,
  });

  ///Multiple string,titles,urls list
  final List<ValueText> answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: answer.map((e) {
            return Text(
              e.text.toString(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: answer.isEmpty ? Colors.grey : Colors.black,
                  ),
            );
          }).toList(),
        ),
        const DottedLine(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          lineLength: double.infinity,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: Colors.grey,
          dashRadius: 0.0,
          dashGapLength: 4.0,
          dashGapColor: Colors.white,
          dashGapRadius: 0.0,
        )
      ],
    );
  }
}

///Widget that represents forms signature answer design
///
///soley for multi form items signatures,images,texts
class MultiSignatureAnswerDesign extends StatelessWidget {
  const MultiSignatureAnswerDesign({
    super.key,
    required this.answer,
    this.imageBuild,
  });

  ///Multiple signature item list
  final List<SingleSignature> answer;

  ///Multiple signature image builder
  ///to view signs in image format
  final Widget Function(Map<String, dynamic>)? imageBuild;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: answer.map((e) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageBuild != null
                    ? imageBuild!({
                        'image': e.file ?? '',
                        'height': 200.0,
                        'width': 200.0,
                      })
                    : CachedNetworkImage(
                        imageUrl: e.file ?? '',
                        height: 150,
                        width: double.infinity,
                        placeholderFadeInDuration: const Duration(seconds: 1),
                        placeholder: (context, url) => const Icon(Icons.image),
                        fit: BoxFit.fill,
                        errorWidget: (context, error, stackTrace) =>
                            const SizedBox(
                          height: 75,
                          child: Icon(
                            Icons.image,
                            size: 40,
                          ),
                        ),
                      ),
                Text(
                  e.signatoryName ?? e.name ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: answer.isEmpty ? Colors.grey : Colors.black,
                      ),
                ),
              ],
            );
          }).toList(),
        ),
        const DottedLine(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          lineLength: double.infinity,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: Colors.grey,
          dashRadius: 0.0,
          dashGapLength: 4.0,
          dashGapColor: Colors.white,
          dashGapRadius: 0.0,
        )
      ],
    );
  }
}
