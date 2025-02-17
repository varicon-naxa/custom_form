import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/helpers/utils.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/form_builder_signature_pad.dart';
import '../state/current_form_provider.dart';

class VariconSignatureField extends StatefulHookConsumerWidget {
  const VariconSignatureField({
    super.key,
    required this.field,
    required this.labelText,
    this.isNested = false,
    required this.imageBuild,
    required this.attachmentSave,
  });

  final SignatureInputField field;
  final String labelText;
  final bool isNested;

  ///Function to build image values
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to save attachment
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  ConsumerState<VariconSignatureField> createState() =>
      _VariconSignatureFieldState();
}

class _VariconSignatureFieldState extends ConsumerState<VariconSignatureField> {
  Map<String, dynamic> _signature = {};

  @override
  void initState() {
    super.initState();
    _signature = (widget.field.answer ?? {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future modifyAnswer(Uint8List data) async {
      File singleFile = await Utils.getConvertToFile(data);

      List<Map<String, dynamic>> attachments = await widget.attachmentSave(
        [singleFile.path],
      );

      ref
          .read(currentStateNotifierProvider.notifier)
          .saveMap(widget.field.id, attachments.first);
    }

    deleteAnswer() {
      ref.read(currentStateNotifierProvider.notifier).remove(widget.field.id);
    }

    return FormBuilderSignaturePad(
      decoration: const InputDecoration(
        labelText: 'Signature Pad',
      ),
      width: double.infinity,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialWidget: widget.field.answer != null
          ? widget.imageBuild({
              'image': widget.field.answer?['file'],
              'height': 200.0,
              'width': double.infinity
            })
          : null,
      name: 'signature',
      onSavedClicked: (data) {
        _signature = {'value': data};
        modifyAnswer(data!);
      },
      onDeletedPressed: () {
        _signature = {};
        deleteAnswer();
      },
      onChanged: (value) {},
      validator: (data) {
        if (widget.field.isRequired) {
          if ((widget.field.answer ?? {}).isNotEmpty) {
            String? answer;
            if (_signature.isEmpty && data == null) {
              answer = 'This field is required';
            } else if (_signature.isEmpty && data != null) {
              answer = 'Please Save the Signature';
            } else if (_signature.isNotEmpty && data == null) {
              answer = null;
            } else if (_signature.isNotEmpty && data != null) {
              answer = null;
            }
            return answer;
          } else {
            if (data == null) {
              return 'This field is required';
            }
          }
          // if (data == null || _signature.isEmpty) {
          //   return 'This field is required';
          // }
        }
        return null;
      },
      border: Border.all(color: Colors.green),
    );
  }
}
