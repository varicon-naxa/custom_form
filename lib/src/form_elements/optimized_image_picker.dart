import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_editor/image_editor.dart' as Editor;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/state/attachment_provider.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import '../models/attachment.dart';
import 'package:mime/mime.dart';

/// Configuration constants for the optimized image picker
class OptimizedImagePickerConfig {
  static const double maxImageSizeMB = 25.0;
  static const int imageQuality = 80;
  static const int maxMultiImageLimit = 5;
  static const int maxTotalImageLimit = 15;
  static const double previewImageSize = 100.0;
  static const double previewImageIconSize = 32.0;
  static const double previewImageCloseIconSize = 16.0;
  static const double previewImageBorderRadius = 8.0;
  static const int initialImageCount = 5; // Show only 5 images initially
}

/// A widget that provides optimized image picking functionality with lazy loading.
///
/// This widget allows users to:
/// - Pick images from camera or gallery
/// - Edit images with timestamp and location data
/// - Preview selected images (initially shows only 5)
/// - Expand to see all images with "See More" button
/// - Remove selected images
/// - Upload images to a server
class OptimizedImagePicker extends StatefulHookConsumerWidget {
  const OptimizedImagePicker({
    super.key,
    required this.savedCurrentImages,
    required this.onImagesSelected,
    required this.fieldId,
    this.initialImages = const [],
    required this.imageBuild,
    required this.customPainter,
    required this.locationData,
  });

  /// Unique identifier for the form field
  final String fieldId;

  /// Callback function to save current images
  final Function(List<Attachment>) savedCurrentImages;

  /// Initial images to display
  final List<Attachment> initialImages;

  /// Callback function to handle image selection
  final Future<List<Map<String, dynamic>>> Function(List<Attachment>)
      onImagesSelected;

  /// Widget builder for displaying images
  final Widget Function(Map<String, dynamic>) imageBuild;

  /// Custom painter for image editing
  final Widget Function(File imageFile) customPainter;

  /// Location data to be added to images
  final String locationData;

  @override
  ConsumerState<OptimizedImagePicker> createState() =>
      _OptimizedImagePickerState();
}

class _OptimizedImagePickerState extends ConsumerState<OptimizedImagePicker> {
  bool _showAllImages = false;

  @override
  void initState() {
    super.initState();
    _initializeImages();
  }

  /// Initializes the widget with any provided initial images
  void _initializeImages() {
    Future.microtask(() {
      ref.invalidate(simpleImagePickerProvider(widget.fieldId));
      if (widget.initialImages.isNotEmpty) {
        ref
            .read(simpleImagePickerProvider(widget.fieldId).notifier)
            .addAll(widget.initialImages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAddImageButton(),
              _buildImagePreviews(),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the add image button
  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () => _showImageSourcePicker(context),
      child: Container(
        height: OptimizedImagePickerConfig.previewImageSize,
        width: OptimizedImagePickerConfig.previewImageSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(
              OptimizedImagePickerConfig.previewImageBorderRadius),
        ),
        child: const Icon(
          Icons.add_photo_alternate_outlined,
          size: OptimizedImagePickerConfig.previewImageIconSize,
        ),
      ),
    );
  }

  /// Builds the list of image previews with optimization
  Widget _buildImagePreviews() {
    return Consumer(
      builder: (context, ref, child) {
        final images = ref.watch(simpleImagePickerProvider(widget.fieldId));

        if (images.isEmpty) {
          return const SizedBox.shrink();
        }

        // Determine which images to show
        final imagesToShow = _showAllImages
            ? images
            : images
                .take(OptimizedImagePickerConfig.initialImageCount)
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...imagesToShow.map((image) => _buildImagePreview(image)),
              ],
            ),
            // Show "See More" or "See Less" button if needed
            if (images.length > OptimizedImagePickerConfig.initialImageCount)
              _buildSeeMoreButton(images.length),
          ],
        );
      },
    );
  }

  /// Builds the "See More" or "See Less" button
  Widget _buildSeeMoreButton(int totalImages) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showAllImages = !_showAllImages;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _showAllImages
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.blue,
              ),
              const SizedBox(width: 4),
              Text(
                _showAllImages
                    ? 'See Less'
                    : 'See More (${totalImages - OptimizedImagePickerConfig.initialImageCount} more)',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a single image preview with remove functionality
  Widget _buildImagePreview(Attachment image) {
    return Stack(
      children: [
        _buildImageContainer(image),
        if (image.isUploaded ?? false) _buildRemoveButton(image),
      ],
    );
  }

  /// Builds the container for displaying the image
  Widget _buildImageContainer(Attachment image) {
    return Container(
      height: OptimizedImagePickerConfig.previewImageSize,
      width: OptimizedImagePickerConfig.previewImageSize,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(
            OptimizedImagePickerConfig.previewImageBorderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            OptimizedImagePickerConfig.previewImageBorderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageContent(image),
            if (image.isUploaded == false) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  /// Builds the image content based on upload status
  Widget _buildImageContent(Attachment image) {
    if (image.isUploaded == true) {
      return widget.imageBuild({
        'image': image.file,
        'id': image.id,
        'height': OptimizedImagePickerConfig.previewImageSize,
        'width': OptimizedImagePickerConfig.previewImageSize,
      });
    }
    return Image.file(
      File(image.file!),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.broken_image));
      },
    );
  }

  /// Builds the loading overlay for uploading images
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  /// Builds the remove button for uploaded images
  Widget _buildRemoveButton(Attachment image) {
    return Positioned(
      top: 4,
      right: 4,
      child: GestureDetector(
        onTap: () => _removeImage(image),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            size: OptimizedImagePickerConfig.previewImageCloseIconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Removes an image from the list
  void _removeImage(Attachment image) {
    ref
        .read(simpleImagePickerProvider(widget.fieldId).notifier)
        .removeImage(image);
    _updateImageList();
  }

  /// Updates the image list in the state
  void _updateImageList() {
    final currentImages =
        ref.read(simpleImagePickerProvider(widget.fieldId).notifier).state;
    widget.savedCurrentImages(currentImages);
    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.fieldId,
          currentImages.map((e) => e.toJson()).toList(),
        );
  }

  /// Shows the image source picker bottom sheet
  void _showImageSourcePicker(BuildContext context) {
    // Check if user has reached maximum total image limit
    final currentImages = ref.read(simpleImagePickerProvider(widget.fieldId));
    if (currentImages.length >= OptimizedImagePickerConfig.maxTotalImageLimit) {
      _showErrorToast(
          'You can only have a maximum of ${OptimizedImagePickerConfig.maxTotalImageLimit} images in total.');
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            _buildCameraOption(),
            _buildGalleryOption(),
          ],
        ),
      ),
    );
  }

  /// Builds the camera option tile
  Widget _buildCameraOption() {
    return ListTile(
      leading: const Icon(Icons.camera_alt),
      title: const Text('Camera'),
      onTap: () => _handleCameraSelection(),
    );
  }

  /// Builds the gallery option tile
  Widget _buildGalleryOption() {
    return ListTile(
      leading: const Icon(Icons.photo_library),
      title: const Text('Gallery'),
      onTap: () => _handleGallerySelection(),
    );
  }

  /// Handles camera selection
  void _handleCameraSelection() {
    Navigator.pop(context);
    _pickImages(ImageSource.camera);
  }

  /// Handles gallery selection
  void _handleGallerySelection() {
    Navigator.pop(context);
    _pickImages(ImageSource.gallery);
  }

  /// Picks images from the specified source
  Future<void> _pickImages(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      List<XFile> pickedFiles = [];

      if (source == ImageSource.camera) {
        final pickedFile = await imagePicker.pickImage(
          source: source,
          maxHeight: 1920,
          maxWidth: 1920,
          imageQuality: OptimizedImagePickerConfig.imageQuality,
        );
        if (pickedFile != null) {
          pickedFiles.add(pickedFile);
        }
      } else {
        // Check remaining slots for gallery
        final currentImages =
            ref.read(simpleImagePickerProvider(widget.fieldId));
        final remainingSlots = OptimizedImagePickerConfig.maxMultiImageLimit -
            (currentImages.length %
                OptimizedImagePickerConfig.maxMultiImageLimit);

        if (remainingSlots <= 0) {
          _showErrorToast(
              'Maximum images per selection reached. Please select fewer images.');
          return;
        }

        pickedFiles = await imagePicker.pickMultiImage(
          maxHeight: 1920,
          maxWidth: 1920,
          imageQuality: OptimizedImagePickerConfig.imageQuality,
        );

        // Limit the number of images that can be picked
        if (pickedFiles.length > remainingSlots) {
          pickedFiles = pickedFiles.take(remainingSlots).toList();
          _showErrorToast(
              'Only the first $remainingSlots images will be added.');
        }
      }

      if (pickedFiles.isNotEmpty) {
        await _processAndAddImages(pickedFiles);
      }
    } catch (e) {
      _showErrorToast('Error picking images: $e');
    }
  }

  /// Processes and adds images to the list
  Future<void> _processAndAddImages(List<XFile> pickedFiles) async {
    try {
      List<Attachment> processedImages = [];

      for (XFile file in pickedFiles) {
        // Check file size
        final fileSize = await file.length();
        if (fileSize >
            OptimizedImagePickerConfig.maxImageSizeMB * 1024 * 1024) {
          _showErrorToast(
              'File ${file.name} is too large. Maximum size is ${OptimizedImagePickerConfig.maxImageSizeMB}MB.');
          continue;
        }

        // Process image with custom painter if needed
        File processedFile = File(file.path);
        if (widget.customPainter != null) {
          final editedImage = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.customPainter(processedFile),
            ),
          );

          if (editedImage != null) {
            processedFile = await _addTimestampAndLocation(editedImage);
          }
        }

        // Create attachment
        final attachment = Attachment(
          localId: const Uuid().v4(),
          file: processedFile.path,
          name: file.name,
          mime: lookupMimeType(file.path),
          isUploaded: false,
        );

        processedImages.add(attachment);
      }

      if (processedImages.isNotEmpty) {
        // Add to state at the beginning (most recent first)
        ref
            .read(simpleImagePickerProvider(widget.fieldId).notifier)
            .addMultiImageAtBeginning(processedImages);

        // Update form state
        _updateImageList();

        // Upload images
        await widget.onImagesSelected(processedImages);
      }
    } catch (e) {
      _showErrorToast('Error processing images: $e');
    }
  }

  /// Adds timestamp and location to image
  Future<File> _addTimestampAndLocation(Uint8List imageData) async {
    try {
      final timestamp = DateTime.now();
      String firstLine = DateFormat('dd MMM, yyyy hh:mm aa').format(timestamp);
      String timeZone = await FlutterTimezone.getLocalTimezone();
      String lines = '$firstLine $timeZone';

      if (widget.locationData.isNotEmpty) {
        lines = '$firstLine $timeZone \n${widget.locationData}';
      }

      final Editor.ImageEditorOption option = Editor.ImageEditorOption();
      final Editor.AddTextOption textOption = Editor.AddTextOption();

      textOption.addText(
        Editor.EditorText(
          offset: const Offset(10, 10),
          text: lines,
          fontSizePx: 75,
          textColor: Colors.red,
          textAlign: TextAlign.left,
        ),
      );

      option.addOption(textOption);
      option.outputFormat = Editor.OutputFormat.jpeg(20);

      final editedImage = await Editor.ImageEditor.editImage(
        image: imageData,
        imageEditorOption: option,
      );

      if (editedImage != null) {
        final directory = await getApplicationSupportDirectory();
        final newImagePath =
            '${directory.path}/IMG_${DateTime.now().millisecondsSinceEpoch}.png';
        File file = File(newImagePath);
        return await file.writeAsBytes(editedImage);
      }
    } catch (e) {
      print('Error adding timestamp: $e');
    }

    // Fallback to original image
    final directory = await getApplicationSupportDirectory();
    final newImagePath =
        '${directory.path}/IMG_${DateTime.now().millisecondsSinceEpoch}.png';
    File file = File(newImagePath);
    return await file.writeAsBytes(imageData);
  }

  /// Shows error toast message
  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
