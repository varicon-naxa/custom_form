import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../varicon_form_builder.dart';

class VariconInstructionField extends ConsumerWidget {
  const VariconInstructionField({
    super.key,
    required this.field,
    required this.labelText,
    required this.onTap,
    required this.imageBuild,
  });

  final InstructionInputField field;
  final String labelText;

  ///Function to build image
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to call on tap o field
  final Function(String) onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HtmlWidget(field.description ?? field.instruction ?? ''),
          if ((field.description ?? field.instruction ?? '').isNotEmpty)
            const SizedBox(
              height: 8.0,
            ),
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
                      const SizedBox(
                        width: 8.0,
                      ),
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
          })
        ],
      ),
    );
  }
}
