import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'widget/image_source_sheet.dart';

/// Field for picking image(s) from Gallery or Camera.
///
/// Field value is a list of objects.
///
/// the widget can internally handle displaying objects of type [XFile],[Uint8List],[String] (for an image url),[ImageProvider] (for any flutter image), [Widget] (for any widget)
/// and appends [XFile] to the list for picked images.
///
/// if you want to use a different object (e.g. a class from the backend that has imageId and imageUrl)
/// you need to implement [displayCustomType]
class FormBuilderImagePicker
    extends FormBuilderFieldDecoration<List<Map<String, dynamic>>> {
  /// set to true to insert an [InputDecorator] which displays labels, borders, etc...

  /// May be supplied for a fully custom display of the image preview
  final Widget Function(
    BuildContext,
    List<Widget> children,
    Widget? addButton,
  )? previewBuilder;

  /// Callback when an image is added
  final void Function(List<Map<String, dynamic>> newImages)? onAdd;

  /// Callback when an image is deleted
  final void Function(Map<String, dynamic> deletedImage,
      List<Map<String, dynamic>> remainingImages)? onDelete;

  /// Optional maximum height of image; see [ImagePicker].
  final double? maxHeight;

  /// Optional maximum width of image; see [ImagePicker].
  final double? maxWidth;

  /// The imageQuality argument modifies the quality of the image, ranging from
  /// 0-100 where 100 is the original/max quality. If imageQuality is null, the
  /// image with the original quality will be returned. See [ImagePicker].
  final int? imageQuality;

  /// use this to get an image from a custom object to either [Uint8List] or [XFile] or [String] (url) or [ImageProvider]
  ///
  /// ```dart
  /// (obj) => obj is MyApiFileClass ? obj.imageUrl : obj;
  /// ```
  final dynamic Function(dynamic obj)? displayCustomType;

  final void Function(Image)? onImage;

  /// maximum images to pick
  ///
  /// also see [showDecoration],[previewAutoSizeWidth]
  final int? maxImages;

  /// Icon for camera option on bottom sheet
  final Widget cameraIcon;

  /// Icon for gallery option on bottom sheet
  final Widget galleryIcon;

  /// Label for camera option on bottom sheet
  final Widget cameraLabel;

  /// Label for gallery option on bottom sheet
  final Widget galleryLabel;
  final EdgeInsets bottomSheetPadding;
  final bool preventPop;

  /// fit for each image
  final BoxFit fit;

  /// The sources available to pick from.
  /// Either [ImageSourceOption.gallery], [ImageSourceOption.camera] or both.
  final List<ImageSourceOption> availableImageSources;

  ///A callback that returns a  pickup options
  ///ListTile(inside Wrap) by Default
  ///use optionsBuilder to return a widget of your choice
  final ValueChanged<ImageSourceBottomSheet>? onTap;

  /// use this callback if you want custom view for options
  /// call cameraPicker() to picks image from camera
  /// call galleryPicker() to picks image from gallery
  final Widget Function(
          FutureVoidCallBack cameraPicker, FutureVoidCallBack galleryPicker)?
      optionsBuilder;

  final WidgetBuilder? loadingWidget;
  final Widget? initialWidget;
  final String locationData;
  final Widget Function(File imageFile) customPainter;

  FormBuilderImagePicker(
      {super.key,
      required super.name,
      required this.customPainter,
      super.validator,
      super.initialValue,
      super.decoration = const InputDecoration(),
      super.onChanged,
      this.onAdd,
      this.onDelete,
      super.valueTransformer,
      super.enabled = true,
      super.onSaved,
      super.autovalidateMode = AutovalidateMode.disabled,
      super.onReset,
      super.focusNode,
      this.loadingWidget,
      this.previewBuilder,
      this.fit = BoxFit.cover,
      this.preventPop = false,
      this.displayCustomType,
      this.maxHeight,
      this.maxWidth,
      this.imageQuality,
      this.onImage,
      this.maxImages,
      this.cameraIcon = const Icon(Icons.camera_enhance),
      this.galleryIcon = const Icon(Icons.image),
      this.cameraLabel = const Text('Camera'),
      this.galleryLabel = const Text('Gallery'),
      this.bottomSheetPadding = EdgeInsets.zero,
      this.onTap,
      this.optionsBuilder,
      required this.locationData,
      this.availableImageSources = const [
        ImageSourceOption.camera,
        ImageSourceOption.gallery,
      ],
      this.initialWidget})
      : assert(maxImages == null || maxImages >= 0),
        super(
          builder: (FormFieldState<List<Map<String, dynamic>>?> field) {
            final state = field as FormBuilderImagePickerState;
            double height = 75.0;
            double width = 75.0;
            // final theme = Theme.of(state.context);
            // final disabledColor = theme.disabledColor;
            // final primaryColor = theme.primaryColor;
            final value = state.effectiveValue;
            final canUpload = state.enabled && !state.hasMaxImages;

            Widget addButtonBuilder(
              BuildContext context,
            ) =>
                GestureDetector(
                  key: UniqueKey(),
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade500,
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.grey.shade500,
                      size: 28,
                    ),
                  ),
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    FocusScope.of(context).unfocus();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    final remainingImages =
                        maxImages == null ? null : maxImages - value.length;

                    final imageSourceSheet = ImageSourceBottomSheet(
                      customPainter: customPainter,
                      locationData: locationData,
                      maxHeight: maxHeight,
                      maxWidth: maxWidth,
                      preventPop: preventPop,
                      remainingImages: remainingImages,
                      imageQuality: imageQuality,
                      preferredCameraDevice: CameraDevice.rear,
                      bottomSheetPadding: bottomSheetPadding,
                      cameraIcon: cameraIcon,
                      cameraLabel: cameraLabel,
                      galleryIcon: galleryIcon,
                      galleryLabel: galleryLabel,
                      optionsBuilder: optionsBuilder,
                      availableImageSources: availableImageSources,
                      onImageSelected: (image) {
                        state.focus();
                        final newImages =
                            image.map((img) => createImageMap(img)).toList();
                        final newValue = [...value, ...newImages];
                        field.didChange(newValue);
                        onAdd?.call(newImages);
                        Navigator.pop(state.context);
                      },
                    );
                    onTap != null
                        ? onTap(imageSourceSheet)
                        : await showModalBottomSheet<void>(
                            context: state.context,
                            builder: (_) {
                              return imageSourceSheet;
                            },
                          );
                  },
                );

            Widget itemBuilder(
              BuildContext context,
              dynamic item,
              int index,
            ) {
              bool checkIfItemIsCustomType(dynamic e) => !(e is XFile ||
                  e is String ||
                  e is Uint8List ||
                  e is ImageProvider ||
                  e is Widget);

              final itemData =
                  item is Map<String, dynamic> ? item['data'] : item;
              final itemCustomType = checkIfItemIsCustomType(itemData);
              var displayItem = itemData;
              if (itemCustomType && displayCustomType != null) {
                displayItem = displayCustomType(itemData);
              }
              assert(
                !checkIfItemIsCustomType(displayItem),
                'Display item must be of type [Uint8List], [XFile], [String] (url), [ImageProvider] or [Widget]. '
                'Consider using displayCustomType to handle the type: ${displayItem.runtimeType}',
              );

              final displayWidget = displayItem is Widget
                  ? displayItem
                  : displayItem is ImageProvider
                      ? Image(
                          image: displayItem,
                          fit: fit,
                        )
                      : displayItem is Uint8List
                          ? Image.memory(
                              displayItem,
                              fit: fit,
                            )
                          : displayItem is String
                              ? Image.network(
                                  displayItem,
                                  fit: fit,
                                )
                              : XFileImage(
                                  file: displayItem,
                                  fit: fit,
                                  loadingWidget: loadingWidget,
                                );
              return Stack(
                key: ObjectKey(item),
                children: <Widget>[
                  Container(
                    height: height,
                    margin: const EdgeInsets.only(
                      right: 8.0,
                      // bottom: 8.0,
                    ),
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: displayWidget,
                  ),
                  if (state.enabled)
                    PositionedDirectional(
                      top: 0,
                      end: 12,
                      child: InkWell(
                        onTap: () {
                          state.focus();
                          final deletedImage = value[index];
                          final newValue = value.toList()..removeAt(index);
                          field.didChange(newValue);
                          onDelete?.call(deletedImage, newValue);
                        },
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
            }

            if (previewBuilder != null) {
              return Builder(builder: (context) {
                final widgets = value
                    .mapIndexed((i, v) => itemBuilder(context, v, i))
                    .toList();

                return previewBuilder(
                  context,
                  widgets,
                  canUpload ? addButtonBuilder(context) : null,
                );
              });
            }

            final child = Wrap(
              runSpacing: 8,
              children: [
                canUpload ? addButtonBuilder(state.context) : const SizedBox(),
                SizedBox(
                  width: canUpload ? 12.0 : 0,
                ),
                initialWidget ?? const SizedBox.shrink(),
                ...value.map(
                  (e) => itemBuilder(
                    state.context,
                    e,
                    value.indexOf(e),
                  ),
                ),
              ],
            );
            return InputDecorator(
              decoration:
                  state.decoration.copyWith(contentPadding: const EdgeInsets.all(10)),
              child: child,
            );
          },
        );

  @override
  FormBuilderImagePickerState createState() => FormBuilderImagePickerState();
}

class FormBuilderImagePickerState extends FormBuilderFieldDecorationState<
    FormBuilderImagePicker, List<Map<String, dynamic>>> {
  List<Map<String, dynamic>> get effectiveValue =>
      value?.where((element) => element != null).toList() ?? [];

  bool get hasMaxImages {
    final ev = effectiveValue;
    return widget.maxImages != null && ev.length >= widget.maxImages!;
  }
}

class XFileImage extends StatefulWidget {
  const XFileImage({
    super.key,
    required this.file,
    this.fit,
    this.loadingWidget,
  });
  final XFile file;
  final BoxFit? fit;
  final WidgetBuilder? loadingWidget;

  @override
  State<XFileImage> createState() => _XFileImageState();
}

class _XFileImageState extends State<XFileImage> {
  final _memoizer = AsyncMemoizer<Uint8List>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _memoizer.runOnce(widget.file.readAsBytes),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return widget.loadingWidget?.call(context) ??
              const Center(child: CircularProgressIndicator());
        }
        return Image.memory(data, fit: widget.fit);
      },
    );
  }
}

extension _ListExtension<E> on List<E> {
  Iterable<R> mapIndexed<R>(R Function(int index, E element) convert) sync* {
    for (var index = 0; index < length; index++) {
      yield convert(index, this[index]);
    }
  }
}

/// Helper function to create a map with image data and unique ID
Map<String, dynamic> createImageMap(dynamic imageData) {
  return {
    'id': const Uuid().v4(),
    'data': imageData,
  };
}

/// Options where a user can pick images from
enum ImageSourceOption {
  /// From the device camera
  /// (via [ImageSource.camera])
  camera,

  /// From the gallery (or local files on the web)
  /// (via [ImageSource.gallery])
  gallery
}
