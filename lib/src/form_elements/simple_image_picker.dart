// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'package:collection/collection.dart';
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

/// Configuration constants for the image picker
class ImagePickerConfig {
  static const double maxImageSizeMB = 25.0;
  static const int imageQuality = 80;
  static const int maxMultiImageLimit = 10;
  static const int maxTotalImageLimit = 25;
  static const double previewImageSize = 100.0;
  static const double previewImageIconSize = 32.0;
  static const double previewImageCloseIconSize = 16.0;
  static const double previewImageBorderRadius = 8.0;
}

/// A widget that provides image picking functionality with editing capabilities.
///
/// This widget allows users to:
/// - Pick images from camera or gallery
/// - Edit images with timestamp and location data
/// - Preview selected images
/// - Remove selected images
/// - Upload images to a server
class SimpleImagePicker extends StatefulHookConsumerWidget {
  const SimpleImagePicker({
    super.key,
    required this.savedCurrentImages,
    required this.onImagesSelected,
    required this.fieldId,
    this.initialImages = const [],
    required this.imageBuild,
    required this.customPainter,
    required this.hasCustomPainter,
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

  /// to handle the use of custom painter
  final bool hasCustomPainter;

  @override
  ConsumerState<SimpleImagePicker> createState() => _SimpleImagePickerState();
}

class _SimpleImagePickerState extends ConsumerState<SimpleImagePicker> {
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
        height: ImagePickerConfig.previewImageSize,
        width: ImagePickerConfig.previewImageSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius:
              BorderRadius.circular(ImagePickerConfig.previewImageBorderRadius),
        ),
        child: const Icon(
          Icons.add_photo_alternate_outlined,
          size: ImagePickerConfig.previewImageIconSize,
        ),
      ),
    );
  }

  /// Builds the list of image previews
  Widget _buildImagePreviews() {
    return Consumer(
      builder: (context, ref, child) {
        final isUploaded = ref.watch(simpleImagePickerProvider(widget.fieldId));

        // Add "See More" functionality
        final initialImageCount = 5;
        final showSeeMore = isUploaded.length > initialImageCount;
        final imagesToShow = showSeeMore
            ? isUploaded.take(initialImageCount).toList()
            : isUploaded;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final currentImages =
                    ref.watch(simpleImagePickerProvider(widget.fieldId));
                final showSeeMore = currentImages.length > initialImageCount;
                final imagesToShow = showSeeMore
                    ? currentImages.take(initialImageCount).toList()
                    : currentImages;

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...imagesToShow.map((image) => _buildImagePreview(image)),
                  ],
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final currentImages =
                    ref.watch(simpleImagePickerProvider(widget.fieldId));
                final showSeeMore = currentImages.length > initialImageCount;

                if (!showSeeMore) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => _buildPaginatedImageDialog(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.keyboard_arrow_down,
                              size: 16, color: Colors.black),
                          const SizedBox(width: 4),
                          Consumer(
                            builder: (context, ref, child) {
                              final currentImages = ref.watch(
                                  simpleImagePickerProvider(widget.fieldId));
                              final remainingCount =
                                  currentImages.length - initialImageCount;
                              return Text(
                                'See More ($remainingCount more)',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
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
      height: ImagePickerConfig.previewImageSize,
      width: ImagePickerConfig.previewImageSize,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius:
            BorderRadius.circular(ImagePickerConfig.previewImageBorderRadius),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(ImagePickerConfig.previewImageBorderRadius),
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
        'height': 75.0,
        'width': 75.0,
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
            size: ImagePickerConfig.previewImageCloseIconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Builds the paginated image dialog
  Widget _buildPaginatedImageDialog() {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All Images',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final currentImages =
                      ref.watch(simpleImagePickerProvider(widget.fieldId));
                  // Show all images in the dialog (including the first 5 from main view)
                  return _PaginatedImageGrid(
                    key: ValueKey('paginated_grid_${currentImages.length}'),
                    images: currentImages,
                    onImageTap: (image) => _buildImagePreview(image),
                  );
                },
              ),
            ),
          ],
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

    // Force a rebuild of the dialog if it's open
    if (mounted) {
      setState(() {});
    }
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
    if (currentImages.length >= ImagePickerConfig.maxTotalImageLimit) {
      _showErrorToast(
          'You can only have a maximum of ${ImagePickerConfig.maxTotalImageLimit} images in total.');
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

  static bool isImage({required String path}) {
    final mimeType = lookupMimeType(path) ?? '';

    return mimeType.startsWith('image/');
  }

  static Future<File> compressImage(String path, {int quality = 80}) async {
    try {
      var dir = await getApplicationSupportDirectory();
      final target =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpeg';
      XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
          path, target,
          quality: quality, keepExif: true);
      File? compressedFile =
          compressedXFile == null ? null : File(compressedXFile.path);

      return compressedFile ?? File(path);
    } catch (_) {
      return File(path);
    }
  }

  Future<File?> compressMaxImage(String path) async {
    File file = File(path);
    if (await file.length() > 25000 * 1000) {
      Fluttertoast.showToast(
        msg: 'The file may not be greater than 25 MB.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
      );
      return null;
    } else {
      if (isImage(path: path)) {
        final heicFormat = path.split('.').last.toLowerCase();

        if (heicFormat == 'heic' || heicFormat == 'hevc') {
          File compressedFile = await compressImage(path);
          return compressedFile;
        } else {
          return File(path);
        }
      } else {
        return File(path);
      }
    }
  }

  /// Handles camera image selection
  Future<void> _handleCameraSelection() async {
    Navigator.pop(context);
    try {
      // Check if user has reached maximum total image limit
      final currentImages = ref.read(simpleImagePickerProvider(widget.fieldId));
      if (currentImages.length >= ImagePickerConfig.maxTotalImageLimit) {
        _showErrorToast(
            'You have reached the maximum limit of ${ImagePickerConfig.maxTotalImageLimit} images.');
        return;
      }

      final XFile? image = await _pickImage();

      if (image != null) {
        final compressedFile = await compressMaxImage(image.path);
        if (compressedFile != null) {
          await _processSingleImageWithEditor(XFile(compressedFile.path));
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  /// Handles gallery image selection
  Future<void> _handleGallerySelection() async {
    Navigator.pop(context);
    final List<XFile>? images = await _pickMultiImage();
    if (images != null) {
      // Check total image limit and trim if necessary
      final currentImages = ref.read(simpleImagePickerProvider(widget.fieldId));
      final remainingSlots =
          ImagePickerConfig.maxTotalImageLimit - currentImages.length;

      if (remainingSlots <= 0) {
        _showErrorToast(
            'You have reached the maximum limit of ${ImagePickerConfig.maxTotalImageLimit} images.');
        return;
      }

      List<XFile> imagesToProcess = images;
      if (images.length > remainingSlots) {
        imagesToProcess = images.sublist(0, remainingSlots);
        _showErrorToast(
            'You can only add ${remainingSlots} more images to reach the total limit of ${ImagePickerConfig.maxTotalImageLimit}.');
      }

      await _processMultipleImages(imagesToProcess);
    }
  }

  /// Processes a single image from camera with image editor
  Future<void> _processSingleImageWithEditor(XFile image) async {
    if (await _validateImageSize(image)) {
      final File imageFile = File(image.path);
      if (widget.hasCustomPainter) {
        // Navigate to image editor for camera images
        final editedImage = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.customPainter(imageFile)!,
          ),
        );

        if (editedImage != null) {
          // Add timestamp and location to the edited image
          final File? finalImage = await _editImage(
            editedImage, // editedImage is already Uint8List
            widget.locationData,
          );
          if (finalImage != null) {
            await _uploadSingleImage(finalImage);
          }
        }
      } else {
        //_convertUint8ListToFile
        final finalImage = await _convertUint8ListToFile(
          await image.readAsBytes(),
        );
        await _uploadSingleImage(finalImage);
      }
    }
  }

  /// Processes a single image from camera (for gallery images)
  Future<void> _processSingleImage(XFile image) async {
    if (await _validateImageSize(image)) {
      final File? editedImage = await _editImage(
        await image.readAsBytes(),
        widget.locationData,
      );
      if (editedImage != null) {
        await _uploadSingleImage(editedImage);
      }
    }
  }

  /// Processes multiple images from gallery
  Future<void> _processMultipleImages(List<XFile> images) async {
    List<File> compressedImages = [];

    for (var image in images) {
      final compressedFile = await compressMaxImage(image.path);
      if (compressedFile != null) {
        compressedImages.add(compressedFile);
      }
    }

    final attachments = compressedImages
        .map((e) => Attachment(
              file: e.path,
              isUploaded: false,
              localId: const Uuid().v4(),
            ))
        .toList();

    ref
        .read(simpleImagePickerProvider(widget.fieldId).notifier)
        .addMultiImage(attachments);
    _updateImageList();

    try {
      final result = await widget.onImagesSelected(attachments);
      if (result.isNotEmpty) {
        await _updateMultipleImages(attachments, result);
      } else {
        _removeMultipleImages(attachments);
      }
    } catch (e) {
      _removeMultipleImages(attachments);
    } finally {
      _updateImageList();
    }
  }

  /// Validates image size
  Future<bool> _validateImageSize(XFile image) async {
    final file = File(image.path);
    if (await file.length() > ImagePickerConfig.maxImageSizeMB * 1024 * 1024) {
      _showErrorToast(
          "The file may not be greater than ${ImagePickerConfig.maxImageSizeMB} MB.");
      return false;
    }
    return true;
  }

  /// Shows error toast message
  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Edits an image with timestamp and location data
  Future<File?> _editImage(Uint8List currentImage, String? address) async {
    final timestamp = DateTime.now();
    final timeZone = await _getCurrentTimezone();
    final formattedDate = DateFormat('dd MMM, yyyy hh:mm aa').format(timestamp);
    final lines = address != null
        ? '$formattedDate $timeZone \n$address'
        : '$formattedDate $timeZone';

    final option = Editor.ImageEditorOption();
    final textOption = Editor.AddTextOption();

    textOption.addText(
      Editor.EditorText(
        offset: const Offset(10, 10),
        text: lines,
        fontSizePx: Platform.isIOS ? 40 : 75,
        textColor: Colors.red,
        textAlign: TextAlign.left,
      ),
    );

    option.addOption(textOption);
    option.outputFormat = Editor.OutputFormat.jpeg(Platform.isIOS ? 40 : 20);

    final editedImage = await Editor.ImageEditor.editImage(
      image: currentImage,
      imageEditorOption: option,
    );

    if (editedImage == null) return null;
    return _convertUint8ListToFile(editedImage);
  }

  /// Gets current timezone
  Future<String> _getCurrentTimezone() async {
    try {
      return await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      return '';
    }
  }

  /// Converts Uint8List to File
  Future<File> _convertUint8ListToFile(Uint8List uint8List) async {
    final directory = await getApplicationSupportDirectory();
    final newImagePath =
        '${directory.path}/IMG_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(newImagePath);
    return await file.writeAsBytes(uint8List);
  }

  /// Uploads a single image
  Future<void> _uploadSingleImage(File imageFile) async {
    final attachment = Attachment(
      file: imageFile.path,
      isUploaded: false,
      localId: const Uuid().v4(),
    );

    ref
        .read(simpleImagePickerProvider(widget.fieldId).notifier)
        .addImage(attachment);
    _updateImageList();

    try {
      final result = await widget.onImagesSelected([attachment]);
      if (result.isNotEmpty) {
        _updateSingleImage(attachment, result[0]);
      } else {
        _removeSingleImage(attachment);
      }
    } catch (e) {
      _removeSingleImage(attachment);
    } finally {
      _updateImageList();
    }
  }

  /// Updates a single image after upload
  void _updateSingleImage(Attachment attachment, Map<String, dynamic> result) {
    ref.read(simpleImagePickerProvider(widget.fieldId).notifier).updateImage(
          Attachment(
            id: result['id'],
            file: result['file'],
            thumbnail: result['thumbnail'],
            name: result['name'],
            localId: attachment.localId,
            mime: result['mime_type'],
            isUploaded: true,
          ),
        );
    _updateImageList();
  }

  /// Removes a single image
  void _removeSingleImage(Attachment attachment) {
    ref
        .read(simpleImagePickerProvider(widget.fieldId).notifier)
        .removeLocalImage(attachment);
  }

  /// Updates multiple images after upload
  Future<void> _updateMultipleImages(
      List<Attachment> attachments, List<Map<String, dynamic>> results) async {
    for (int i = 0; i < results.length; i++) {
      ref.read(simpleImagePickerProvider(widget.fieldId).notifier).updateImage(
            Attachment(
              id: results[i]['id'],
              file: results[i]['file'],
              thumbnail: results[i]['thumbnail'],
              name: results[i]['name'],
              localId: attachments[i].localId,
              mime: results[0]['mime_type'],
              isUploaded: true,
            ),
          );
    }
    _updateImageList();
  }

  /// Removes multiple images
  void _removeMultipleImages(List<Attachment> attachments) {
    for (var attachment in attachments) {
      ref
          .read(simpleImagePickerProvider(widget.fieldId).notifier)
          .removeLocalImage(attachment);
    }
  }

  /// Picks a single image from camera
  Future<XFile?> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      return await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: ImagePickerConfig.imageQuality,
      );
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Picks multiple images from gallery
  Future<List<XFile>?> _pickMultiImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final result = await picker.pickMultiImage(
        imageQuality: ImagePickerConfig.imageQuality,
        limit: ImagePickerConfig.maxMultiImageLimit,
      );
      if (result.isNotEmpty && result.length > 10) {
        _showErrorToast('You can only select up to 10 images.');

        /// return first 5 images here
        return result.sublist(0, 10);
      }
      return result;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }
}

/// A widget that displays images in a paginated grid with lazy loading
class _PaginatedImageGrid extends StatefulWidget {
  final List<Attachment> images;
  final Widget Function(Attachment) onImageTap;

  const _PaginatedImageGrid({
    super.key,
    required this.images,
    required this.onImageTap,
  });

  @override
  State<_PaginatedImageGrid> createState() => _PaginatedImageGridState();
}

class _PaginatedImageGridState extends State<_PaginatedImageGrid> {
  static const int _imagesPerPage = 10;
  static const int _batchSize = 3; // Load 3 images at a time
  int _currentPage = 0;
  int _loadedImagesCount = 0;
  final List<Attachment> _loadedImages = [];
  List<Attachment> _previousImages = [];

  @override
  void initState() {
    super.initState();
    _previousImages = List.from(widget.images);
    _loadNextBatch();
  }

  @override
  void didUpdateWidget(_PaginatedImageGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if images list has changed (e.g., due to deletion)
    if (_previousImages.length != widget.images.length ||
        !const DeepCollectionEquality()
            .equals(_previousImages, widget.images)) {
      _previousImages = List.from(widget.images);
      _refreshLoadedImages();
    }
  }

  void _refreshLoadedImages() {
    setState(() {
      // Remove any images that are no longer in the widget.images list
      _loadedImages.removeWhere((loadedImage) => !widget.images.any(
          (widgetImage) =>
              widgetImage.localId == loadedImage.localId ||
              widgetImage.id == loadedImage.id));
      _loadedImagesCount = _loadedImages.length;
    });
  }

  void _loadNextBatch() {
    if (_loadedImagesCount >= widget.images.length) return;

    final startIndex = _currentPage * _imagesPerPage;
    final endIndex =
        (startIndex + _imagesPerPage).clamp(0, widget.images.length);
    final currentPageImages = widget.images.sublist(startIndex, endIndex);

    final remainingToLoad = currentPageImages.length - _loadedImages.length;
    final batchSize =
        remainingToLoad > _batchSize ? _batchSize : remainingToLoad;

    if (batchSize > 0) {
      final nextBatch = currentPageImages.sublist(
          _loadedImages.length, _loadedImages.length + batchSize);
      _loadedImages.addAll(nextBatch);
      _loadedImagesCount += batchSize;

      if (mounted) {
        setState(() {});
      }

      // Load next batch after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _loadNextBatch();
        }
      });
    }
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
      _loadedImages.clear();
      _loadedImagesCount = 0;
    });
    _loadNextBatch();
  }

  @override
  Widget build(BuildContext context) {
    // Handle empty images list
    if (widget.images.isEmpty) {
      return const Center(
        child: Text('No images to display'),
      );
    }

    final totalPages = (widget.images.length / _imagesPerPage).ceil();
    final startIndex = _currentPage * _imagesPerPage;
    final endIndex =
        (startIndex + _imagesPerPage).clamp(0, widget.images.length);

    // Ensure we don't go out of bounds
    if (startIndex >= widget.images.length) {
      _currentPage = 0;
      return build(context);
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._loadedImages.map((image) => widget.onImageTap(image)),
                if (_loadedImages.length < (endIndex - startIndex))
                  ...List.generate(
                    (endIndex - startIndex) - _loadedImages.length,
                    (index) => Container(
                      height: ImagePickerConfig.previewImageSize,
                      width: ImagePickerConfig.previewImageSize,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(
                            ImagePickerConfig.previewImageBorderRadius),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (totalPages > 1) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _currentPage > 0
                      ? () => _onPageChanged(_currentPage - 1)
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Page ${_currentPage + 1} of $totalPages',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: _currentPage < totalPages - 1
                      ? () => _onPageChanged(_currentPage + 1)
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
