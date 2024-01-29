import 'package:flutter/material.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

// ignore: must_be_immutable
class LabeledWidget extends StatelessWidget {
  LabeledWidget(
      {super.key,
      required this.labelText,
      required this.child,
      required this.isRequired,});
  String? labelText;
  final bool isRequired;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      width: double.infinity,
      child: Card(
        elevation: 1,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: labelText,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.black),
                    ),
                    if (isRequired)
                      const TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
              AppSpacing.sizedBoxH_06(),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
