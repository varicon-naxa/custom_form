import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/constants/string_constant.dart';

///Users signatory consent checkbox list tile widget
class SignConsentCheckBoxWidget extends StatefulWidget {
  const SignConsentCheckBoxWidget({super.key});

  @override
  State<SignConsentCheckBoxWidget> createState() =>
      _SignConsentCheckBoxWidgetState();
}

class _SignConsentCheckBoxWidgetState extends State<SignConsentCheckBoxWidget> {
  bool signConsent = false;

  @override
  Widget build(BuildContext context) {
    return Text(
      StringConstant.signatureConsent,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
