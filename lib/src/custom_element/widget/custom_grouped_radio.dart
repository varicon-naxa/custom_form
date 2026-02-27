import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';

class CustomGroupedRadio<T> extends StatefulWidget {
  /// A list of string that describes each checkbox. Each item must be distinct.
  final List<FormBuilderFieldOption<T>> options;

  /// A list of string which specifies automatically checked checkboxes.
  /// Every element must match an item from itemList.
  final T? value;

  /// Specifies which radio option values should be disabled.
  /// If this is null, then no radio options will be disabled.
  final List<T>? disabled;

  /// Specifies the orientation of the elements in itemList.
  final OptionsOrientation orientation;

  /// Called when the value of the checkbox group changes.
  final ValueChanged<T?> onChanged;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ColorScheme.secondary].
  final Color? activeColor;

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

  final ControlAffinity controlAffinity;

  final String? actionMessage;
  final bool? isResponse;

  /// Applied to a [Container] wrapping each item if provided
  ///
  /// If the [orientation] is set to [OptionsOrientation.vertical] then
  /// [wrapSpacing] is used as inter-item bottom margin
  ///
  /// If the [orientation] is set to [OptionsOrientation.horizontal] then
  /// [wrapSpacing] is used as inter-item right margin
  final BoxDecoration? itemDecoration;
  final String? otherText;

  final Function(bool isSelected, String text)? onOtherSelectedValue;

  /// Number of columns in the grid when orientation is horizontal
  final int? crossAxisCount;

  /// Aspect ratio of each grid item when orientation is horizontal
  final double? childAspectRatio;

  final Widget Function(Map<String, dynamic>) imageBuild;

  const CustomGroupedRadio(
      {super.key,
      required this.options,
      required this.orientation,
      required this.onChanged,
      required this.imageBuild,
      this.value,
      this.isResponse,
      this.disabled,
      this.activeColor,
      this.focusColor,
      this.hoverColor,
      this.otherText,
      this.actionMessage,
      this.materialTapTargetSize,
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
      this.itemDecoration,
      this.onOtherSelectedValue,
      this.crossAxisCount,
      this.childAspectRatio});

  @override
  State<CustomGroupedRadio<T?>> createState() => _CustomGroupedRadioState<T>();
}

class _CustomGroupedRadioState<T> extends State<CustomGroupedRadio<T?>> {
  TextEditingController otherFieldController = TextEditingController();
  FocusNode otherFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    ValueText? text = widget.value as ValueText?;
    if (text != null && text.isOtherField == true) {
      otherFieldController.text = widget.otherText ?? '';
      otherFieldFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    for (int i = 0; i < widget.options.length; i++) {
      widgetList.add(buildItem(i));
    }

    switch (widget.orientation) {
      case OptionsOrientation.auto:
        return OverflowBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: widgetList,
        );
      case OptionsOrientation.vertical:
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widgetList,
              Visibility(
                visible: (widget.value as ValueText?)?.action == true &&
                    (widget.actionMessage ?? '').isNotEmpty,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
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
              Visibility(
                visible: (widget.value as ValueText?)?.isOtherField == true,
                child: FormBuilderTextField(
                  name: const Uuid().v4(),
                  autofocus: widget.isResponse == false, // Changed this line
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
      case OptionsOrientation.horizontal:
        final content =
            widget.crossAxisCount != null && widget.childAspectRatio != null
                ? GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.crossAxisCount!,
                      childAspectRatio: widget.childAspectRatio!,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    itemCount: widgetList.length,
                    itemBuilder: (context, index) => widgetList[index],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < widgetList.length; i++) ...[
                          widgetList[i],
                          if (i < widgetList.length - 1)
                            SizedBox(
                              width: widget.wrapSpacing > 0
                                  ? widget.wrapSpacing
                                  : 8.0,
                            ),
                        ],
                      ],
                    ),
                  );
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            Visibility(
              visible: (widget.value as ValueText?)?.action == true &&
                  (widget.actionMessage ?? '').isNotEmpty,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                margin: const EdgeInsets.only(top: 8.0),
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
          ],
        );

      case OptionsOrientation.wrap:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
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
            ),
            Visibility(
              visible: (widget.value as ValueText?)?.action == true &&
                  (widget.actionMessage ?? '').isNotEmpty,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                margin: const EdgeInsets.only(top: 8.0),
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
          ],
        );
    }
  }

  /// the composite of all the components for the option at index
  Widget buildItem(int index) {
    final option = widget.options[index];
    final optionValue = option.value;
    final isSelected = widget.value == optionValue;
    ValueText? currentOption = optionValue as ValueText?;
    final isOptionDisabled = true == widget.disabled?.contains(optionValue);
    final control = SizedBox(
      width: widget.crossAxisCount != null && widget.childAspectRatio != null
          ? 20
          : 35,
      height: 20,
      child: Radio<T?>(
        groupValue: widget.value,
        activeColor: widget.activeColor,
        focusColor: widget.focusColor,
        hoverColor: widget.hoverColor,
        materialTapTargetSize: widget.materialTapTargetSize,
        value: optionValue,
        onChanged: isOptionDisabled
            ? null
            : (T? selected) {
                ValueText? selectedOption = selected as ValueText?;
                if (selectedOption?.isOtherField == true) {
                  widget.onOtherSelectedValue!(true, '');
                } else {
                  otherFieldController.clear();
                  widget.onOtherSelectedValue!(false, '');
                }
                widget.onChanged(selected);
              },
      ),
    );

    final label = option;
    final hasAction = currentOption?.action == true;

    // Check if the option has an image
    ValueText? currentValueText = option.value as ValueText?;
    bool hasImage = currentValueText?.image != null;

    // Create the content widget (text or image + text)
    Widget contentWidget;
    if (hasImage) {
      // Image with overlay (radio only), text below
      final showRed = isSelected && hasAction;
      contentWidget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: widget.imageBuild({
                  'image': currentValueText?.image?['file'],
                  'height': 100.0,
                  'width': double.infinity,
                }),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: control,
              ),
            ],
          ),
          const SizedBox(height: 8),
          DefaultTextStyle(
            style: TextStyle(
              color: showRed ? Colors.red : Colors.black87,
              fontSize: 14,
              height: 1.2,
            ),
            child: label,
          ),
        ],
      );
    } else {
      contentWidget = label;
    }

    Widget compositeItem = Container(
      width: widget.orientation == OptionsOrientation.horizontal
          ? (hasImage ? 240 : 200)
          : double.infinity,
      height: widget.orientation == OptionsOrientation.horizontal
          ? (hasImage ? 380 : 120)
          : null,
      margin: EdgeInsets.only(
        bottom: widget.orientation == OptionsOrientation.horizontal ? 0.0 : 8.0,
        right: widget.orientation == OptionsOrientation.horizontal ? 8.0 : 0.0,
      ),
      padding: widget.orientation == OptionsOrientation.horizontal
          ? const EdgeInsets.all(8.0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: (isSelected && hasAction)
              ? Colors.red
              : hasImage
                  ? (isSelected ? Colors.orange : Colors.grey.shade300)
                  : (isSelected ? Colors.grey.shade600 : Colors.grey.shade300),
          width: (hasImage && isSelected) ? 2.0 : 1.0,
        ),
        color: (isSelected && hasAction)
            ? Colors.red.shade50
            : widget.orientation == OptionsOrientation.horizontal
                ? Colors.white
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: widget.orientation == OptionsOrientation.horizontal
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: isOptionDisabled
            ? null
            : () {
                ValueText? selectedOption = optionValue as ValueText?;
                if (selectedOption?.isOtherField == true) {
                  widget.onOtherSelectedValue!(true, '');
                } else {
                  otherFieldController.clear();
                  widget.onOtherSelectedValue!(false, '');
                }
                widget.onChanged(optionValue);
              },
        child: widget.orientation == OptionsOrientation.horizontal
            ? // Horizontal layout - image first, then radio with text below
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image first (if available)
                  if (hasImage) ...[
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate image height based on grid aspect ratio
                        double imageHeight;
                        if (widget.childAspectRatio != null) {
                          // Reserve ~90px for radio + text (5 lines at 14px * 1.2)
                          double availableHeight = (constraints.maxWidth /
                                  widget.childAspectRatio!) -
                              90;
                          imageHeight =
                              availableHeight > 80 ? availableHeight : 80;
                        } else {
                          imageHeight = 80; // increased fallback height
                        }

                        return SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: widget.imageBuild({
                                  'image': currentValueText?.image?['file'],
                                  'height': imageHeight,
                                  'width': double.infinity,
                                }),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: control,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (hasImage)
                    Expanded(
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          height: 1.2,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        child: label,
                      ),
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        control,
                        const SizedBox(width: 8),
                        Expanded(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              height: 1.2,
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            child: label,
                          ),
                        ),
                      ],
                    ),
                ],
              )
            : // Vertical layout
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: hasImage
                    ? contentWidget
                    : IntrinsicHeight(
                        child: Row(
                          children: [
                            control,
                            const SizedBox(width: 8),
                            Expanded(child: contentWidget),
                          ],
                        ),
                      ),
              ),
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
