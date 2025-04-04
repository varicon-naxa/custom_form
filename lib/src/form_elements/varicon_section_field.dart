import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../varicon_form_builder.dart';

class VariconSectionField extends ConsumerWidget {
  const VariconSectionField({
    super.key,
    required this.field,
    required this.labelText,
  });

  final SectionInputField field;
  final String labelText;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label ?? '',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: const Color(0xff233759), height: 1.2),
          ),
          const SizedBox(
            height: 8.0,
          ),
          (field.description ?? '').trim().isEmpty
              ? const SizedBox.shrink()
              : Text(
                  field.description ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xff6A737B),
                      ),
                ),
          const SizedBox(
            height: 8.0,
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
