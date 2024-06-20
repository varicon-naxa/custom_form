import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/constants/string_constant.dart';

///Users signatory consent checkbox list tile widget
class SignConsentWidget extends StatefulWidget {
  const SignConsentWidget({super.key});

  @override
  State<SignConsentWidget> createState() => _SignConsentWidgetState();
}

class _SignConsentWidgetState extends State<SignConsentWidget> {
  bool signConsent = false;

  @override
  Widget build(BuildContext context) {
    return Text(
      StringConstant.signatureConsent,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
