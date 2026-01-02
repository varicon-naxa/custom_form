import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/src/state/attachment_loading_provider.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/custom_form_builder_query_dropdown.dart';
import '../custom_element/form_builder_image_picker.dart';
import '../helpers/image_quality.dart';
import '../helpers/utils.dart';
import '../helpers/validators.dart';
import '../state/current_form_provider.dart';
import '../state/link_label_provider.dart';
import '../widget/scroll_bottomsheet.dart';

/// Equipment dropdown field widget
///
/// A single-select dropdown field for selecting equipment from an API-driven list.
/// Supports:
/// - Required validation
/// - Meter reading text field (when collectMeterReading is true)
/// - Evidence image picker (when collectEvidence is true)
class VariconEquipmentDropdownField extends StatefulHookConsumerWidget {
  const VariconEquipmentDropdownField({
    super.key,
    required this.field,
    required this.labelText,
    required this.apiCall,
    required this.attachmentSave,
    required this.imageBuild,
    this.customPainter,
    this.locationData = '',
    this.formId,
  });

  /// Equipment field model containing field configuration
  final EquipmentValueInputField field;

  /// Label text for the field
  final String labelText;

  /// API call function to fetch equipment list
  final Future<List<dynamic>> Function(Map<String, dynamic>) apiCall;

  /// Function to save attachments (for evidence images)
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  /// Function to build image widget
  final Widget Function(Map<String, dynamic>) imageBuild;

  /// Custom painter for image overlay (optional)
  final Widget? Function(File imageFile)? customPainter;

  /// Location data for image metadata
  final String locationData;

  /// Form ID to pass to the API call
  final String? formId;

  @override
  ConsumerState<VariconEquipmentDropdownField> createState() =>
      _VariconEquipmentDropdownFieldState();
}

class _VariconEquipmentDropdownFieldState
    extends ConsumerState<VariconEquipmentDropdownField> {
  TextEditingController dropdownController = TextEditingController();
  TextEditingController meterReadingController = TextEditingController();
  ValueText? selectedValue;

  // For evidence images
  List<Map<String, dynamic>> initialAttachments = [];
  List<Map<String, dynamic>> currentAttachments = [];
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isError = ValueNotifier(false);

  /// Check if an equipment is selected
  bool get isEquipmentSelected =>
      dropdownController.text.isNotEmpty &&
      dropdownController.text != 'Select equipment';

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  /// Initialize values from existing answer
  void _initializeValues() {
    // Initialize dropdown value
    if (widget.field.answer != null && widget.field.answer!.isNotEmpty) {
      final selectedLabel = widget.field.answerList ?? '';
      dropdownController.text = selectedLabel;

      ref.read(linklabelProvider.notifier).saveString(
            widget.field.id,
            selectedLabel,
          );
    }

    // Initialize meter reading value
    if (widget.field.subAnswer != null && widget.field.subAnswer!.isNotEmpty) {
      meterReadingController.text = widget.field.subAnswer!;
    }

    // Initialize attachments
    if (widget.field.attachments != null) {
      initialAttachments.addAll(widget.field.attachments!);
    }
  }

  @override
  void didUpdateWidget(VariconEquipmentDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync dropdown controller
    if (widget.field.answer != null &&
        widget.field.answer != '' &&
        oldWidget.field.answer != widget.field.answer) {
      final newAnswerList = widget.field.answerList ?? '';
      if (dropdownController.text != newAnswerList) {
        dropdownController.text = newAnswerList;
      }
    }

    // Sync meter reading controller
    if (widget.field.subAnswer != oldWidget.field.subAnswer) {
      meterReadingController.text = widget.field.subAnswer ?? '';
    }

    // Sync attachments
    if (widget.field.attachments != oldWidget.field.attachments) {
      initialAttachments.clear();
      initialAttachments.addAll(widget.field.attachments ?? []);
      setState(() {});
    }
  }

  @override
  void dispose() {
    dropdownController.dispose();
    meterReadingController.dispose();
    super.dispose();
  }

  /// Opens the equipment selection bottomsheet
  void _openEquipmentSelector() {
    scrollBottomSheet(
      context,
      child: CustomFormBuilderQueryDropdown(
        apiCall: widget.apiCall,
        linkedQuery: 'equipment',
        formId: widget.formId,
        onChanged: (ValueText data) {
          setState(() {
            selectedValue = data;
          });

          dropdownController.text = data.text;
          // Save the selected value (equipment ID)
          ref
              .read(currentStateNotifierProvider.notifier)
              .saveString(widget.field.id, data.value);

          // Save the selected label (equipment name)
          ref
              .read(linklabelProvider.notifier)
              .saveString(widget.field.id, data.text);

          // Save the engine type as meter reading unit
          if (data.engineType != null && data.engineType!.isNotEmpty) {
            ref
                .read(currentStateNotifierProvider.notifier)
                .saveEquipmentMeterReadingUnit(
                    widget.field.id, data.engineType);
          }

          Navigator.pop(context);
        },
      ),
    );
  }

  /// Save meter reading value
  void _saveMeterReading(String value) {
    ref
        .read(currentStateNotifierProvider.notifier)
        .saveEquipmentSubAnswer(widget.field.id, value.trim());
  }

  /// Remove attachment from server list
  void _removeAttachment(Map<String, dynamic> file) {
    initialAttachments.removeWhere((element) => element['id'] == file['id']);
    _saveAllAttachments();
    setState(() {});
  }

  /// Save images to server
  Future<void> _saveImagesToServer(List<Map<String, dynamic>> files) async {
    final loadingIds = files.map((_) => const Uuid().v4()).toList();
    isLoading.value = true;

    try {
      isError.value = false;
      for (var id in loadingIds) {
        ref.read(attachmentLoadingProvider.notifier).addLoading(id);
      }

      List<String> filePaths = await Future.wait(files.map((element) async {
        final e = element['data'];
        if (e is XFile) {
          return e.path;
        } else if (e is Uint8List) {
          File data = await Utils.getConvertToFile(e);
          return data.path;
        } else {
          return e.toString();
        }
      }).toList());

      final data = await widget.attachmentSave(filePaths);

      if (data.isEmpty) {
        isError.value = true;
        return;
      }

      currentAttachments = data;
      _saveAllAttachments();
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
      for (var id in loadingIds) {
        ref.read(attachmentLoadingProvider.notifier).removeLoading(id);
      }
    }
  }

  /// Save all attachments to state
  void _saveAllAttachments() {
    List<Map<String, dynamic>> allAttachments = [
      ...initialAttachments,
      ...currentAttachments,
    ];

    ref
        .read(currentStateNotifierProvider.notifier)
        .saveEquipmentAttachments(widget.field.id, allAttachments);
  }

  @override
  Widget build(BuildContext context) {
    final showMeterReading =
        (widget.field.collectMeterReading ?? false) && isEquipmentSelected;
    final showEvidence =
        (widget.field.collectEvidence ?? false) && isEquipmentSelected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Equipment Dropdown
        FormBuilderTextField(
          controller: dropdownController,
          validator: (values) => textValidator(
            value: values == 'Select equipment' ? '' : values,
            inputType: "text",
            isRequired: widget.field.isRequired,
            requiredErrorText: 'Please select an equipment',
          ),
          onTap: _openEquipmentSelector,
          readOnly: true,
          name: widget.field.id,
          onChanged: (value) {},
          decoration: const InputDecoration(
            hintText: 'Select equipment',
            suffixIcon: Icon(Icons.arrow_drop_down),
            contentPadding: EdgeInsets.all(8.0),
          ),
        ),

        // Meter Reading Text Field
        if (showMeterReading) ...[
          const SizedBox(height: 16),
          Builder(builder: (context) {
            // Use engineType from selected equipment, fallback to initial meterReadingUnit
            final meterReadingUnit = selectedValue?.engineType ??
                widget.field.meterReadingUnit ??
                '';
            final hasUnit = meterReadingUnit.isNotEmpty;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meter Reading',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: meterReadingController,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Enter meter reading',
                    contentPadding: const EdgeInsets.all(8.0),
                    suffixText: hasUnit ? meterReadingUnit : null,
                    suffixStyle:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final text = newValue.text;
                      return text.trim().isEmpty
                          ? newValue
                          : double.tryParse(text) == null
                              ? oldValue
                              : newValue;
                    }),
                  ],
                  validator: (value) {
                    // Meter reading is required when collectMeterReading is true
                    if ((widget.field.collectMeterReading ?? false) &&
                        isEquipmentSelected) {
                      return numberValidator(
                        value: (value?.trim().isNotEmpty ?? false)
                            ? num.tryParse(value.toString())
                            : null,
                        isRequired: true,
                        requiredErrorText: 'Please enter meter reading',
                      );
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _saveMeterReading(value);
                  },
                ),
              ],
            );
          }),
        ],

        // Evidence Image Picker
        if (showEvidence) ...[
          const SizedBox(height: 16),
          Text(
            'Evidence',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          FormBuilderImagePicker(
            key: Key('evidence_${widget.field.id}'),
            customPainter: widget.customPainter ?? (_) => null,
            isLoading: isLoading,
            isError: isError,
            locationData: widget.locationData,
            preventPop: true,
            name: 'evidence_${widget.field.id}',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            imageQuality: kImageCompressionQuality,
            availableImageSources: const [
              ImageSourceOption.gallery,
              ImageSourceOption.camera,
            ],
            initialWidget: _buildInitialAttachments(),
            onChanged: (value) async {
              await _saveImagesToServer(value ?? []);
              isLoading.value = false;
            },
            validator: (value) {
              // Evidence is required when collectEvidence is true
              if ((widget.field.collectEvidence ?? false) &&
                  isEquipmentSelected) {
                if ((value == null || value.isEmpty) &&
                    initialAttachments.isEmpty) {
                  return "Please add evidence image";
                }
              }
              return null;
            },
            maxImages: 10,
          ),
        ],
      ],
    );
  }

  /// Build initial attachments widget
  Widget _buildInitialAttachments() {
    return Wrap(
      children: initialAttachments.map((e) {
        return Stack(
          key: ObjectKey(e),
          children: <Widget>[
            Container(
              height: 75,
              margin: const EdgeInsets.only(right: 8.0),
              width: 75,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: widget.imageBuild({
                'image': e['file'],
                'height': 75.0,
                'width': 75.0,
                'id': e['id'],
              }),
            ),
            PositionedDirectional(
              top: 0,
              end: 12,
              child: InkWell(
                onTap: () => _removeAttachment(e),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  height: 18,
                  width: 18,
                  child: const Icon(
                    Icons.close,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
