import 'package:flutter/material.dart';

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
        'By signing above, I certify that this signature is authentic and represents my genuine consent and agreement',
        style: Theme.of(context).textTheme.bodyMedium,
      );
  }
}
