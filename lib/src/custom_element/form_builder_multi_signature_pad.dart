import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';

/// Field with drawing pad on which user can doodle
class FormBuilderMultiSignaturePad
    extends FormBuilderFieldDecoration<MultiSignature> {
  /// Controls the value of the signature pad.
  ///
  /// If null, this widget will create its own [SignatureController].
  ///
  /// If your controller has the "onDrawEnd" method, your method will be executed first and then the values will be saved in the form field
  ///  _controller.onDrawEnd = () async {
  ///       onDrawEnd?.call();
  ///       requestFocus();
  ///       final val = await _getControllerValue();
  ///       didChange(val);
  ///     };
  final SignatureController? controller;
  final TextEditingController? nameController;

  /// Width of the canvas
  final double? width;

  /// Height of the canvas
  final double height;

  /// Color of the canvas
  final Color backgroundColor;

  /// Text to be displayed on the clear button which clears user input from the canvas
  final String? clearButtonText;

  /// Styles the canvas border
  final Border? border;

  /// Creates field with drawing pad on which user can doodle
  FormBuilderMultiSignaturePad({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.decoration,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode,
    super.onReset,
    super.focusNode,
    this.backgroundColor = Colors.transparent,
    this.clearButtonText,
    this.width,
    this.height = 200,
    this.controller,
    this.nameController,
    this.border,
  }) : super(
          builder: (FormFieldState<MultiSignature> field) {
            final state = field as FormBuilderMultiSignaturePadState;
            final theme = Theme.of(state.context);
            final localizations = MaterialLocalizations.of(state.context);
            final cancelButtonColor =
                state.enabled ? theme.colorScheme.error : theme.disabledColor;

            return InputDecorator(
              decoration: state.decoration,
              child: Column(
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      border: border,
                      image: null != initialValue && initialValue == state.value
                          ? DecorationImage(
                              image: MemoryImage(state.value!.image!))
                          : null,
                    ),
                    child: state.enabled
                        ? GestureDetector(
                            onHorizontalDragUpdate: (_) {},
                            onVerticalDragUpdate: (_) {},
                            child: Signature(
                              controller: state.effectiveController,
                              width: width,
                              height: height,
                              backgroundColor: backgroundColor,
                            ),
                          )
                        : null,
                  ),
                  Row(
                    children: <Widget>[
                      const Expanded(child: SizedBox()),
                      TextButton.icon(
                        style: const ButtonStyle().copyWith(
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                                    const EdgeInsets.all(8.0)),
                            visualDensity: VisualDensity.compact),
                        onPressed: state.enabled
                            ? () {
                                if (state.value?.image != null) {
                                  state.effectiveController.clear();
                                  state.value!.image = null;

                                  field.didChange(state.value);
                                }
                              }
                            : null,
                        label: Text(
                          clearButtonText ?? localizations.cancelButtonLabel,
                          style: TextStyle(color: cancelButtonColor),
                        ),
                        icon: Icon(Icons.clear, color: cancelButtonColor),
                      ),
                    ],
                  ),
                  Text(
                    'By signing above, I certify that this signature is authentic and represents my genuine consent and agreement.',
                    style: Theme.of(state.context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'signatoryName_${const Uuid().v4()}',
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: state.signatoryNameController,
                    decoration: const InputDecoration(
                      labelText: 'Signatory Name',
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                    onChanged: (value) {
                      state.value?.name = (value ?? '').trim();
                      state.didChange(state.value);
                    },
                  ),
                ],
              ),
            );
          },
        );

  @override
  FormBuilderMultiSignaturePadState createState() =>
      FormBuilderMultiSignaturePadState();
}

class FormBuilderMultiSignaturePadState extends FormBuilderFieldDecorationState<
    FormBuilderMultiSignaturePad, MultiSignature> {
  late SignatureController _controller;
  late TextEditingController _nameController;

  SignatureController get effectiveController => _controller;
  TextEditingController get signatoryNameController => _nameController;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? SignatureController();
    _nameController = widget.nameController ?? TextEditingController();

    final onDrawEnd = _controller.onDrawEnd;

    _controller.onDrawEnd = () async {
      onDrawEnd?.call();
      focus();
      final val = await _getControllerValue();
      didChange(val);
    };

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) async {
      // Get initialValue or if points are set, use the points
      didChange(initialValue ?? await _getControllerValue());
    });
  }

  Future<MultiSignature?> _getControllerValue() async {
    final image = await _controller.toPngBytes();
    return image != null
        ? MultiSignature(image: image, name: signatoryNameController.text)
        : null;
  }

  @override
  void reset() {
    _controller.clear();
    super.reset();
  }

  @override
  void dispose() {
    // Dispose the _controller when initState created it
    if (null == widget.controller) {
      _controller.dispose();
    }
    super.dispose();
  }
}

class MultiSignature {
  Uint8List? image;
  String? name;

  MultiSignature({this.image, this.name});

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
    };
  }
}
