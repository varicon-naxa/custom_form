import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:signature/signature.dart';

/// Field with drawing pad on which user can doodle
class FormBuilderSignaturePad extends FormBuilderFieldDecoration<Uint8List> {
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
  final Widget? initialWidget;

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
  final bool hasAction;

  /// Callback when the save button is clicked with Function(Uint8List) as the parameter
  final void Function(Uint8List?) onSavedClicked;
  final void Function() onDeletedPressed;

  /// Creates field with drawing pad on which user can doodle
  FormBuilderSignaturePad(
      {super.key,
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
      this.initialWidget,
      this.width,
      this.height = 200,
      this.controller,
      this.border,
      required this.onDeletedPressed,
      required this.hasAction,
      required this.onSavedClicked})
      : super(
          builder: (FormFieldState<Uint8List?> field) {
            final state = field as FormBuilderSignaturePadState;
            final theme = Theme.of(state.context);
            bool isEditable = state.isEditable;
            final localizations = MaterialLocalizations.of(state.context);
            final cancelButtonColor =
                state.enabled ? theme.colorScheme.error : theme.disabledColor;

            return InputDecorator(
              decoration: state.decoration,
              child: Column(
                children: <Widget>[
                  IgnorePointer(
                    ignoring: isEditable,
                    child: Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        border: border,
                        image: null != initialValue &&
                                initialValue == state.value
                            ? DecorationImage(image: MemoryImage(state.value!))
                            : null,
                      ),
                      child: null != state.initialSignatureWidget
                          ? state.initialSignatureWidget!
                          : state.enabled
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
                  ),
                  const SizedBox(height: 8),
                  if (hasAction)
                    Text(
                      'By signing above, I certify that this signature is authentic and represents my genuine consent and agreement.',
                      style: Theme.of(state.context).textTheme.bodySmall,
                    ),
                  if (hasAction)
                    Row(
                      children: <Widget>[
                        const Expanded(child: SizedBox()),
                        if (state.effectiveController.isNotEmpty &&
                            isEditable == false)
                          TextButton.icon(
                            onPressed: state.enabled
                                ? () {
                                    state.changeState(true);
                                    onSavedClicked(state.value);
                                  }
                                : null,
                            label: Text(
                              'Save',
                              style:
                                  TextStyle(color: theme.colorScheme.primary),
                            ),
                            icon: Icon(Icons.save,
                                color: theme.colorScheme.primary),
                          ),
                        TextButton.icon(
                          onPressed: state.enabled
                              ? () {
                                  if (state.initialSignatureWidget != null) {
                                    onDeletedPressed();
                                    state.removeInitialWidget();
                                  } else {
                                    state.effectiveController.clear();
                                    state.changeState(false);
                                  }
                                  field.didChange(null);
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
                ],
              ),
            );
          },
        );

  @override
  FormBuilderSignaturePadState createState() => FormBuilderSignaturePadState();
}

class FormBuilderSignaturePadState extends FormBuilderFieldDecorationState<
    FormBuilderSignaturePad, Uint8List> {
  late SignatureController _controller;
  bool isEditable = false;
  late Widget? initialWidget;

  SignatureController get effectiveController => _controller;
  Widget? get initialSignatureWidget => initialWidget;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? SignatureController();
    initialWidget = widget.initialWidget;
    if (initialWidget != null) {
      changeState(true);
    }

    final onDrawEnd = _controller.onDrawEnd;

    _controller.onDrawEnd = () async {
      onDrawEnd?.call();
      focus();
      final val = await _getControllerValue();
      didChange(val);
    };

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) async {
      // Get initialValue or if points are set, use the  points
      didChange(initialValue ?? await _getControllerValue());
    });
  }

  Future<Uint8List?> _getControllerValue() async {
    return await _controller.toPngBytes();
  }

  void removeInitialWidget() {
    initialWidget = null;
    changeState(false);
  }

  void changeState(bool state) {
    setState(() {
      isEditable = state;
    });
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
