import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Signature of a function to build a custom file viewer [Widget] for
/// [FormBuilderFilePicker].
///
/// The specified [files] are the [PlatformFile] objects currently picked
/// by the [FormBuilderFilePicker].
///
/// [filesSetter] can be used to update the value of [FormBuilderFilePicker].
typedef FileViewerBuilder = Widget Function(
  List<PlatformFile>? files,
  FormFieldSetter<List<PlatformFile>> filesSetter,
);

class TypeSelector {
  final FileType type;
  final Widget selector;

  const TypeSelector({required this.type, required this.selector});
}

/// Field for image(s) from user device storage
class FormBuilderFilePicker
    extends FormBuilderFieldDecoration<List<PlatformFile>> {
  /// Maximum number of files needed for this field
  final int? maxFiles;

  /// Allows picking of multiple files
  final bool allowMultiple;

  /// If set to true, a thumbnail of image files will be shown; else the default
  /// icon will be displayed depending on file type
  final bool previewImages;

  /// Create a list of type of document that you can pick
  ///
  /// Useful if you want to be able to pick documents and images in the same form field and
  /// need to define different file types and different selectors.
  ///
  /// By default use `[TypeSelector(type: FileType.any, selector: Icon(Icons.add_circle))]`
  final List<TypeSelector> typeSelectors;

  /// Allowed file extensions for files to be selected
  final List<String>? allowedExtensions;

  /// If you want to track picking status, for example, because some files may take some time to be
  /// cached (particularly those picked from cloud providers), you may want to set [onFileLoading] handler
  /// that will give you the current status of picking.
  final void Function(FilePickerStatus)? onFileLoading;

  /// Whether to allow file compression
  final bool allowCompression;

  final int compressionQuality;

  /// If [withData] is set, picked files will have its byte data immediately available on memory as [Uint8List]
  /// which can be useful if you are picking it for server upload or similar.
  final bool withData;

  /// If [withReadStream] is set, picked files will have its byte data available as a [Stream<List<int>>]
  /// which can be useful for uploading and processing large files.
  final bool withReadStream;

  /// If specified, the return value of this callback will be used to render the file viewer for the picked files.
  /// Specifying this callback can be useful to customize the look and feel of the file viewer, as well as
  /// to support user interactions with the picked files.
  final FileViewerBuilder? customFileViewerBuilder;

  /// Allow to customise the view of the pickers.
  final Widget Function(List<Widget> types)? customTypeViewerBuilder;
  final Widget? previousImage;
  final Widget Function(File imageFile) customPainter;
  final ValueNotifier<bool> isLoading;

  /// Creates field for image(s) from user device storage
  FormBuilderFilePicker(
      {
      //From Super
      super.key,
      required super.name,
      required this.customPainter,
      required this.isLoading,
      super.validator,
      super.initialValue,
      super.decoration,
      super.onChanged,
      super.valueTransformer,
      super.enabled,
      super.onSaved,
      super.autovalidateMode = AutovalidateMode.disabled,
      super.onReset,
      super.focusNode,
      this.maxFiles,
      this.withData = kIsWeb,
      this.withReadStream = false,
      this.allowMultiple = false,
      this.previewImages = true,
      this.typeSelectors = const [
        TypeSelector(type: FileType.any, selector: Icon(Icons.add_circle))
      ],
      this.allowedExtensions,
      this.onFileLoading,
      this.allowCompression = true,
      this.compressionQuality = 30,
      this.customFileViewerBuilder,
      this.customTypeViewerBuilder,
      this.previousImage})
      : super(
          builder: (FormFieldState<List<PlatformFile>?> field) {
            final state = field as _FormBuilderFilePickerState;

            return InputDecorator(
              decoration: state.decoration.copyWith(
                  counterText: maxFiles != null
                      ? '${state._files.length} / $maxFiles'
                      : null),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        state.getTypeSelectorActions(typeSelectors, field),
                  ),
                  const SizedBox(height: 8.0),
                  previousImage ?? const SizedBox.shrink(),
                  customFileViewerBuilder != null
                      ? customFileViewerBuilder.call(state._files,
                          (files) => state._setFiles(files ?? [], field))
                      : state.defaultFileViewer(state._files,
                          (files) => state._setFiles(files ?? [], field)),
                ],
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<FormBuilderFilePicker, List<PlatformFile>>
      createState() => _FormBuilderFilePickerState();
}

class _FormBuilderFilePickerState extends FormBuilderFieldDecorationState<
    FormBuilderFilePicker, List<PlatformFile>> {
  /// Image File Extensions.
  ///
  /// Note that images may be previewed.
  ///
  /// This list is inspired by [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)
  /// and [instantiateImageCodec](https://api.flutter.dev/flutter/dart-ui/instantiateImageCodec.html):
  /// "The following image formats are supported: JPEG, PNG, GIF,
  /// Animated GIF, WebP, Animated WebP, BMP, and WBMP."
  static const imageFileExts = [
    'gif',
    'jpg',
    'jpeg',
    'png',
    'webp',
    'bmp',
    'dib',
    'wbmp',
  ];

  List<PlatformFile> _files = [];

  int? get _remainingItemCount =>
      widget.maxFiles == null ? null : widget.maxFiles! - _files.length;

  @override
  void initState() {
    super.initState();
    _files = initialValue ?? [];
  }

  Future<void> pickFiles(
      FormFieldState<List<PlatformFile>?> field, FileType fileType) async {
    FilePickerResult? resultList;

    try {
      resultList = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: widget.allowedExtensions,
        allowCompression: widget.allowCompression,
        compressionQuality: widget.compressionQuality,
        onFileLoading: widget.onFileLoading,
        allowMultiple: widget.allowMultiple,
        withData: widget.withData,
        withReadStream: widget.withReadStream,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (resultList != null) {
      setState(() => _files = [..._files, ...resultList!.files]);
      field.didChange(_files);
    }
  }

  void _setFiles(
      List<PlatformFile> files, FormFieldState<List<PlatformFile>?> field) {
    setState(() => _files = files);
    field.didChange(_files);
  }

  void removeFileAtIndex(int index, FormFieldState<List<PlatformFile>> field) {
    setState(() => _files.removeAt(index));
    field.didChange(_files);
  }

  Widget defaultFileViewer(
      List<PlatformFile> files, FormFieldSetter<List<PlatformFile>> setter) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          runSpacing: 10,
          spacing: 10,
          children: List.generate(
            files.length,
            (index) {
              return Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          getIconData(files[index].extension!),
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            files[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            files.removeAt(index);
                            setter.call([...files]);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: .7),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            height: 18,
                            width: 18,
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: widget.isLoading,
                    builder: (context, value, child) {
                      return value
                          ? const LinearProgressIndicator()
                          : const SizedBox();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  List<Widget> getTypeSelectorActions(List<TypeSelector> typeSelectors,
      FormFieldState<List<PlatformFile>?> field) {
    return <Widget>[
      ...typeSelectors.map(
        (typeSelector) => InkWell(
          onTap: enabled &&
                  (null == _remainingItemCount || _remainingItemCount! > 0)
              ? () => pickFiles(field, typeSelector.type)
              : null,
          child: typeSelector.selector,
        ),
      ),
    ];
  }

  IconData getIconData(String fileExtension) {
    final lowerCaseFileExt = fileExtension.toLowerCase();
    if (imageFileExts.contains(lowerCaseFileExt)) return Icons.image;
    // Check if the file is an image first (because there is a shared variable
    // with preview logic), and then fallback to non-image file ext lookup.
    switch (lowerCaseFileExt) {
      case 'doc':
      case 'docx':
        return Icons.edit_document;
      case 'log':
        return Icons.text_snippet_outlined;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'txt':
        return Icons.text_snippet_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.edit_document;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.photo;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  void reset() {
    super.reset();
    setState(() => _files = widget.initialValue ?? []);
  }
}
