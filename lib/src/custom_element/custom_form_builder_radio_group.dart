import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'widget/custom_grouped_radio.dart';

/// Field to select one value from a list of Radio Widgets
class CustomFromBuilderRadioGroup<T> extends FormBuilderFieldDecoration<T> {
  final Axis wrapDirection;
  final Color? activeColor;
  final Color? focusColor;
  final Color? hoverColor;
  final ControlAffinity controlAffinity;
  final double wrapRunSpacing;
  final double wrapSpacing;
  final List<FormBuilderFieldOption<T>> options;
  final List<T>? disabled;
  final MaterialTapTargetSize? materialTapTargetSize;
  final OptionsOrientation orientation;
  final TextDirection? wrapTextDirection;
  final VerticalDirection wrapVerticalDirection;
  final Widget? separator;
  final WrapAlignment wrapAlignment;
  final WrapAlignment wrapRunAlignment;
  final WrapCrossAlignment wrapCrossAxisAlignment;
  final String? actionMessage;
  final String? otherText;
  final bool? isResponse;

  /// Added to each item if provided.
  /// [GroupedRadio] applies the [itemDecorator] to each Radio
  final BoxDecoration? itemDecoration;

  final Function(bool isSelected, String text)? onOtherSelectedValue;



  /// Creates field to select one value from a list of Radio Widgets
  CustomFromBuilderRadioGroup(
      {super.autovalidateMode = AutovalidateMode.disabled,
      super.enabled,
      super.focusNode,
      super.onSaved,
      super.validator,
      super.decoration,
      super.key,
      required super.name,
      required this.options,
      super.initialValue,
      this.actionMessage,
      this.activeColor,
      this.controlAffinity = ControlAffinity.leading,
      this.disabled,
      this.focusColor,
      this.hoverColor,
      this.materialTapTargetSize,
      this.isResponse,
      this.orientation = OptionsOrientation.wrap,
      this.separator,
      this.wrapAlignment = WrapAlignment.start,
      this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
      this.wrapDirection = Axis.horizontal,
      this.wrapRunAlignment = WrapAlignment.start,
      this.wrapRunSpacing = 0.0,
      this.wrapSpacing = 0.0,
      this.wrapTextDirection,
      this.wrapVerticalDirection = VerticalDirection.down,
      super.onChanged,
      super.valueTransformer,
      super.onReset,
      super.restorationId,
      this.itemDecoration,
      this.otherText,
      this.onOtherSelectedValue})
      : super(
          builder: (FormFieldState<T?> field) {
            final state = field as _CustomFromBuilderRadioGroupState<T>;

            return InputDecorator(
              decoration: state.decoration,
              child: CustomGroupedRadio<T>(
                activeColor: activeColor,
                actionMessage: actionMessage,
                isResponse: isResponse,
                controlAffinity: controlAffinity,
                otherText: otherText,
                disabled: state.enabled
                    ? disabled
                    : options.map((option) => option.value).toList(),
                focusColor: focusColor,
                hoverColor: hoverColor,
                materialTapTargetSize: materialTapTargetSize,
                onChanged: (value) {
                  state.didChange(value);
                },
                options: options,
                orientation: orientation,
                separator: separator,
                value: state.value,
                wrapAlignment: wrapAlignment,
                wrapCrossAxisAlignment: wrapCrossAxisAlignment,
                wrapDirection: wrapDirection,
                wrapRunAlignment: wrapRunAlignment,
                wrapRunSpacing: wrapRunSpacing,
                wrapSpacing: wrapSpacing,
                wrapTextDirection: wrapTextDirection,
                wrapVerticalDirection: wrapVerticalDirection,
                itemDecoration: itemDecoration,
                onOtherSelectedValue: onOtherSelectedValue,
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<CustomFromBuilderRadioGroup<T>, T>
      createState() => _CustomFromBuilderRadioGroupState<T>();
}

class _CustomFromBuilderRadioGroupState<T>
    extends FormBuilderFieldDecorationState<CustomFromBuilderRadioGroup<T>,
        T> {}
