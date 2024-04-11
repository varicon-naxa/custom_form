import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:varicon_form_builder/src/form_builder/varicon_form_builder.dart';
import 'package:varicon_form_builder/src/models/input_field.dart';

class InstructionWidget extends StatelessWidget {
  const InstructionWidget({
    super.key,
    required this.field,
    required this.onTap,
    required this.imageBuild,
    this.labelText,
  });

  final InstructionInputField field;
  final String? labelText;
  final Function(String) onTap;
  final Widget Function(Map<String, dynamic>) imageBuild;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Html(data: field.description ?? ''),
        if ((field.description ?? '').isNotEmpty) AppSpacing.sizedBoxH_06(),
        Wrap(
          children: (field.attachments ?? []).map((e) {
            if (e['mime_type'] == 'png' ||
                e['mime_type'] == 'jpg' ||
                e['mime_type'] == 'jpeg' ||
                e['mime_type'] == 'gif') {
              return GestureDetector(
                  onTap: () {
                    onTap(e['file'].toString());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12.0,
                    ),
                    child: imageBuild({
                      'image': e['file'],
                      'height': 200.0,
                      'width': double.infinity
                    }),
                  ));
            } else {
              return const SizedBox.shrink();
            }
          }).toList(),
        ),
        ...(field.attachments ?? []).map((e) {
          if (e['mime_type'] != 'png' &&
              e['mime_type'] != 'jpg' &&
              e['mime_type'] != 'jpeg' &&
              e['mime_type'] != 'gif') {
            return GestureDetector(
              onTap: () {
                onTap(e['file'].toString());
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 12.0,
                ),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xffE6E9EE),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.file_copy),
                    AppSpacing.sizedBoxW_08(),
                    Expanded(
                      child: Text(
                        e['name'].toString(),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList()
      ],
    );
  }
}
