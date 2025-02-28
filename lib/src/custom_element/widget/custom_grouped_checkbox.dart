import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';

class CustomGroupedCheckbox<T> extends StatefulWidget {
  /// A list of string that describes each checkbox. Each item must be distinct.
  final List<FormBuilderFieldOption<T>> options;

  /// A list of string which specifies automatically checked checkboxes.
  /// Every element must match an item from itemList.
  final List<T>? value;

  /// Specifies which checkbox option values should be disabled.
  /// If this is null, then no checkbox options will be disabled.
  final List<T>? disabled;

  /// Specifies the orientation of the elements in itemList.
  final OptionsOrientation orientation;

  /// Called when the value of the checkbox group changes.
  final ValueChanged<List<T>> onChanged;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ColorScheme.secondary].
  final Color? activeColor;
  final VisualDensity? visualDensity;

  /// The color to use for the check icon when this checkbox is checked.
  ///
  /// Defaults to Color(0xFFFFFFFF)
  final Color? checkColor;

  /// If true the checkbox's value can be true, false, or null.
  final bool tristate;

  /// Configures the minimum size of the tap target.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// The color for the checkbox's Material when it has the input focus.
  final Color? focusColor;

  /// The color for the checkbox's Material when a pointer is hovering over it.
  final Color? hoverColor;

  //.......................WRAP ORIENTATION.....................................

  /// The direction to use as the main axis.
  ///
  /// For example, if [wrapDirection] is [Axis.horizontal], the default, the
  /// children are placed adjacent to one another in a horizontal run until the
  /// available horizontal space is consumed, at which point a subsequent
  /// children are placed in a new run vertically adjacent to the previous run.
  final Axis wrapDirection;

  /// How the children within a run should be placed in the main axis.
  ///
  /// For example, if [wrapAlignment] is [WrapAlignment.center], the children in
  /// each run are grouped together in the center of their run in the main axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapRunAlignment], which controls how the runs are placed relative to each
  ///    other in the cross axis.
  ///  * [wrapCrossAxisAlignment], which controls how the children within each run
  ///    are placed relative to each other in the cross axis.
  final WrapAlignment wrapAlignment;

  /// How much space to place between children in a run in the main axis.
  ///
  /// For example, if [wrapSpacing] is 10.0, the children will be spaced at least
  /// 10.0 logical pixels apart in the main axis.
  ///
  /// If there is additional free space in a run (e.g., because the wrap has a
  /// minimum size that is not filled or because some runs are longer than
  /// others), the additional free space will be allocated according to the
  /// [wrapAlignment].
  ///
  /// Defaults to 0.0.
  final double wrapSpacing;

  /// How the runs themselves should be placed in the cross axis.
  ///
  /// For example, if [wrapRunAlignment] is [WrapAlignment.center], the runs are
  /// grouped together in the center of the overall [Wrap] in the cross axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapAlignment], which controls how the children within each run are placed
  ///    relative to each other in the main axis.
  ///  * [wrapCrossAxisAlignment], which controls how the children within each run
  ///    are placed relative to each other in the cross axis.
  final WrapAlignment wrapRunAlignment;

  /// How much space to place between the runs themselves in the cross axis.
  ///
  /// For example, if [wrapRunSpacing] is 10.0, the runs will be spaced at least
  /// 10.0 logical pixels apart in the cross axis.
  ///
  /// If there is additional free space in the overall [Wrap] (e.g., because
  /// the wrap has a minimum size that is not filled), the additional free space
  /// will be allocated according to the [wrapRunAlignment].
  ///
  /// Defaults to 0.0.
  final double wrapRunSpacing;

  /// How the children within a run should be aligned relative to each other in
  /// the cross axis.
  ///
  /// For example, if this is set to [WrapCrossAlignment.end], and the
  /// [wrapDirection] is [Axis.horizontal], then the children within each
  /// run will have their bottom edges aligned to the bottom edge of the run.
  ///
  /// Defaults to [WrapCrossAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapAlignment], which controls how the children within each run are placed
  ///    relative to each other in the main axis.
  ///  * [wrapRunAlignment], which controls how the runs are placed relative to each
  ///    other in the cross axis.
  final WrapCrossAlignment wrapCrossAxisAlignment;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If the [wrapDirection] is [Axis.horizontal], this controls order in which the
  /// children are positioned (left-to-right or right-to-left), and the meaning
  /// of the [wrapAlignment] property's [WrapAlignment.start] and
  /// [WrapAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.horizontal], and either the
  /// [wrapAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], or
  /// there's more than one child, then the [wrapTextDirection] (or the ambient
  /// [Directionality]) must not be null.
  ///
  /// If the [wrapDirection] is [Axis.vertical], this controls the order in which
  /// runs are positioned, the meaning of the [wrapRunAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values, as well as the
  /// [wrapCrossAxisAlignment] property's [WrapCrossAlignment.start] and
  /// [WrapCrossAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.vertical], and either the
  /// [wrapRunAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], the
  /// [wrapCrossAxisAlignment] is either [WrapCrossAlignment.start] or
  /// [WrapCrossAlignment.end], or there's more than one child, then the
  /// [wrapTextDirection] (or the ambient [Directionality]) must not be null.
  final TextDirection? wrapTextDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// If the [wrapDirection] is [Axis.vertical], this controls which order children
  /// are painted in (down or up), the meaning of the [wrapAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.vertical], and either the [wrapAlignment]
  /// is either [WrapAlignment.start] or [WrapAlignment.end], or there's
  /// more than one child, then the [wrapVerticalDirection] must not be null.
  ///
  /// If the [wrapDirection] is [Axis.horizontal], this controls the order in which
  /// runs are positioned, the meaning of the [wrapRunAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values, as well as the
  /// [wrapCrossAxisAlignment] property's [WrapCrossAlignment.start] and
  /// [WrapCrossAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.horizontal], and either the
  /// [wrapRunAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], the
  /// [wrapCrossAxisAlignment] is either [WrapCrossAlignment.start] or
  /// [WrapCrossAlignment.end], or there's more than one child, then the
  /// [wrapVerticalDirection] must not be null.
  final VerticalDirection wrapVerticalDirection;

  final Widget? separator;
  final String? actionMessage;

  final ControlAffinity controlAffinity;

  /// Applied to a [Container] wrapping each item if provided
  ///
  /// If the [orientation] is set to [OptionsOrientation.vertical] then
  /// [wrapSpacing] is used as inter-item bottom margin
  ///
  /// If the [orientation] is set to [OptionsOrientation.horizontal] then
  /// [wrapSpacing] is used as inter-item right margin
  final BoxDecoration? itemDecoration;
  final Function(bool isSelected, String text)? onOtherSelectedValue;

  const CustomGroupedCheckbox({
    super.key,
    required this.options,
    required this.orientation,
    required this.onChanged,
    this.actionMessage,
    this.value,
    this.disabled,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.tristate = false,
    this.wrapDirection = Axis.horizontal,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapSpacing = 0.0,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 0.0,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapTextDirection,
    this.wrapVerticalDirection = VerticalDirection.down,
    this.separator,
    this.controlAffinity = ControlAffinity.leading,
    this.visualDensity,
    this.itemDecoration,
    this.onOtherSelectedValue,
  });

  @override
  State<CustomGroupedCheckbox<T>> createState() =>
      _CustomGroupedCheckboxState<T>();
}

class _CustomGroupedCheckboxState<T> extends State<CustomGroupedCheckbox<T>> {
  TextEditingController otherFieldController = TextEditingController();
  FocusNode otherFieldFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    for (var i = 0; i < widget.options.length; i++) {
      widgetList.add(buildItem(i, otherFieldController, otherFieldFocusNode));
    }
    Widget finalWidget;
    if (widget.orientation == OptionsOrientation.auto) {
      finalWidget = OverflowBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: widgetList,
      );
    } else if (widget.orientation == OptionsOrientation.vertical) {
      finalWidget = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widgetList,
            Visibility(
              visible: ((widget.value ?? []) as List<ValueText>)
                      .where((element) => element.action == true)
                      .isNotEmpty &&
                  (widget.actionMessage ?? '').isNotEmpty,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade500,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.actionMessage ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Visibility(
              visible: ((widget.value ?? []) as List<ValueText>)
                  .where((element) => element.isOtherField == true)
                  .isNotEmpty,
              child: FormBuilderTextField(
                name: const Uuid().v4(),
                autofocus: true,
                onTapOutside: (val) {
                  otherFieldFocusNode.unfocus();
                },
                controller: otherFieldController,
                focusNode: otherFieldFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Other (please specify)',
                  contentPadding: EdgeInsets.all(8.0),
                ),
                onChanged: (data) {
                  widget.onOtherSelectedValue!(true, data ?? '');
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
            ),
          ],
        ),
      );
    } else if (widget.orientation == OptionsOrientation.horizontal) {
      finalWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widgetList.map((item) {
            return Column(children: <Widget>[item]);
          }).toList(),
        ),
      );
    } else {
      finalWidget = SingleChildScrollView(
        child: Wrap(
          spacing: widget.wrapSpacing,
          runSpacing: widget.wrapRunSpacing,
          textDirection: widget.wrapTextDirection,
          crossAxisAlignment: widget.wrapCrossAxisAlignment,
          verticalDirection: widget.wrapVerticalDirection,
          alignment: widget.wrapAlignment,
          direction: Axis.horizontal,
          runAlignment: widget.wrapRunAlignment,
          children: widgetList,
        ),
      );
    }
    return finalWidget;
  }

  /// the composite of all the components for the option at index
  Widget buildItem(int index, TextEditingController otherFieldController,
      FocusNode otherFieldFocusNode) {
    final option = widget.options[index];
    final optionValue = option.value;
    final isOptionDisabled = true == widget.disabled?.contains(optionValue);
    final control = Checkbox(
      visualDensity: widget.visualDensity,
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      materialTapTargetSize: widget.materialTapTargetSize,
      value: widget.tristate
          ? widget.value?.contains(optionValue)
          : true == widget.value?.contains(optionValue),
      tristate: widget.tristate,
      onChanged: isOptionDisabled
          ? null
          : (selected) {
              List<T> selectedListItems =
                  widget.value == null ? [] : List.of(widget.value!);
              selected!
                  ? selectedListItems.add(optionValue)
                  : selectedListItems.remove(optionValue);

              ValueText valueText = optionValue as ValueText;
              if (valueText.isOtherField == true && selected == true) {
                widget.onOtherSelectedValue!(true, '');
              }
              List<ValueText> valueTextList =
                  selectedListItems as List<ValueText>;
              if (valueTextList
                  .where((element) => element.isOtherField == true)
                  .isEmpty) {
                widget.onOtherSelectedValue!(false, '');
                otherFieldController.clear();
              } else {
                otherFieldFocusNode.requestFocus();
              }
              widget.onChanged(selectedListItems);
            },
    );
    final label = GestureDetector(
      onTap: isOptionDisabled
          ? null
          : () {
              List<T> selectedListItems =
                  widget.value == null ? [] : List.of(widget.value!);
              selectedListItems.contains(optionValue)
                  ? selectedListItems.remove(optionValue)
                  : selectedListItems.add(optionValue);
              ValueText valueText = optionValue as ValueText;
              if (valueText.isOtherField == true &&
                  selectedListItems.contains(optionValue) == false) {
                widget.onOtherSelectedValue!(true, '');
              }
              List<ValueText> valueTextList =
                  selectedListItems as List<ValueText>;

              if (valueTextList
                  .where((element) => element.isOtherField == true)
                  .isEmpty) {
                widget.onOtherSelectedValue!(false, '');
                otherFieldController.clear();
              } else {
                otherFieldFocusNode.requestFocus();
              }
              widget.onChanged(selectedListItems);
            },
      child: option,
    );

    ValueText? valueText = optionValue as ValueText?;
    Widget compositeItem = Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.value?.contains(optionValue) == true
              ? valueText?.action == true
                  ? Colors.red
                  : Colors.grey.shade600
              : Colors.transparent,
          width: 1.0,
        ),
        color: (widget.value?.contains(optionValue) == true &&
                valueText?.action == true)
            ? Colors.red.shade100
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.controlAffinity == ControlAffinity.leading) control,
              Flexible(flex: 1, child: label),
              if (widget.controlAffinity == ControlAffinity.trailing) control,
              if (widget.orientation != OptionsOrientation.vertical &&
                  widget.separator != null &&
                  index != widget.options.length - 1)
                widget.separator!,
            ],
          ),
          if (widget.orientation == OptionsOrientation.vertical &&
              widget.separator != null &&
              index != widget.options.length - 1)
            widget.separator!,
        ],
      ),
    );

    if (widget.itemDecoration != null) {
      compositeItem = Container(
        decoration: widget.itemDecoration,
        margin: EdgeInsets.only(
          bottom: widget.orientation == OptionsOrientation.vertical
              ? widget.wrapSpacing
              : 0.0,
          right: widget.orientation == OptionsOrientation.horizontal
              ? widget.wrapSpacing
              : 0.0,
        ),
        child: compositeItem,
      );
    }

    return compositeItem;
  }
}
