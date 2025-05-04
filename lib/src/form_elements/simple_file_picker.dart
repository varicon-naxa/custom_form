import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/state/attachment_provider.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import '../models/attachment.dart';
import 'package:file_picker/file_picker.dart';

/// Configuration constants for the file picker
class FilePickerConfig {
  static const double maxFileSizeMB = 25.0;
  static const double previewFileSize = 100.0;
  static const double previewFileIconSize = 32.0;
  static const double previewFileCloseIconSize = 16.0;
  static const double previewFileHeight = 40.0;
  static const double previewFileBorderRadius = 8.0;
  static const int maxFileCount = 5;
}

/// A widget that provides file picking functionality.
///
/// This widget allows users to:
/// - Pick files from device storage
/// - Preview selected files
/// - Remove selected files
/// - Upload files to a server
class SimpleFilePicker extends StatefulHookConsumerWidget {
  const SimpleFilePicker({
    super.key,
    required this.savedCurrentFiles,
    required this.onFilesSelected,
    required this.fieldId,
    this.initialFiles = const [],
    required this.fileBuild,
    this.allowedExtensions = const [],
  });

  /// Unique identifier for the form field
  final String fieldId;

  /// Callback function to save current files
  final Function(List<Attachment>) savedCurrentFiles;

  /// Initial files to display
  final List<Attachment> initialFiles;

  /// Callback function to handle file selection
  final Future<List<Map<String, dynamic>>> Function(List<Attachment>)
      onFilesSelected;

  /// Widget builder for displaying files
  final Widget Function(Map<String, dynamic>) fileBuild;

  /// List of allowed file extensions (e.g., ['pdf', 'doc', 'docx'])
  final List<String> allowedExtensions;

  @override
  ConsumerState<SimpleFilePicker> createState() => _SimpleFilePickerState();
}

class _SimpleFilePickerState extends ConsumerState<SimpleFilePicker> {
  @override
  void initState() {
    super.initState();
    _initializeFiles();
  }

  /// Initializes the widget with any provided initial files
  void _initializeFiles() {
    Future.microtask(() {
      if (widget.initialFiles.isNotEmpty) {
        ref
            .read(simpleFilePickerProvider(widget.fieldId).notifier)
            .addAll(widget.initialFiles);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 12,
      children: [
        _buildAddFileButton(),
        _buildFilePreviews(),
      ],
    );
  }

  /// Builds the add file button
  Widget _buildAddFileButton() {
    return GestureDetector(
      onTap: () => _handleFileSelection(),
      child: Container(
        height: FilePickerConfig.previewFileSize,
        width: FilePickerConfig.previewFileSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius:
              BorderRadius.circular(FilePickerConfig.previewFileBorderRadius),
        ),
        child: const Icon(
          Icons.add_circle_outline,
          size: FilePickerConfig.previewFileIconSize,
        ),
      ),
    );
  }

  /// Builds the list of file previews
  Widget _buildFilePreviews() {
    return Consumer(
      builder: (context, ref, child) {
        final isUploaded = ref.watch(simpleFilePickerProvider(widget.fieldId));
        return Column(
          spacing: 12,
          children: [
            ...isUploaded.map((file) => _buildFileContainer(file)),
          ],
        );
      },
    );
  }

  /// Builds the container for displaying the file
  Widget _buildFileContainer(Attachment file) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius:
            BorderRadius.circular(FilePickerConfig.previewFileBorderRadius),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(FilePickerConfig.previewFileBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildFileContent(file),
            if (file.isUploaded == false) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  /// Builds the file content based on upload status
  Widget _buildFileContent(Attachment file) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                _getFileIcon(file.mime ?? ''),
                size: FilePickerConfig.previewFileIconSize,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  file.name ?? 'Unknown',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        if (file.isUploaded ?? false) _buildRemoveButton(file),
      ],
    );
  }

  /// Gets appropriate icon for file type
  IconData _getFileIcon(String mimeType) {
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
    if (mimeType.contains('word') || mimeType.contains('doc')) {
      return Icons.description;
    }
    if (mimeType.contains('excel') || mimeType.contains('sheet')) {
      return Icons.table_chart;
    }
    if (mimeType.contains('image')) {
      return Icons.image;
    }
    if (mimeType.contains('video')) {
      return Icons.video_file;
    }
    if (mimeType.contains('audio')) {
      return Icons.audio_file;
    }
    return Icons.insert_drive_file;
  }

  /// Builds the loading overlay for uploading files
  Widget _buildLoadingOverlay() {
    return const LinearProgressIndicator(
      color: Colors.amber,
      backgroundColor: Colors.white,
    );
  }

  /// Builds the remove button for uploaded files
  Widget _buildRemoveButton(Attachment file) {
    return GestureDetector(
      onTap: () => _removeFile(file),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          size: FilePickerConfig.previewFileCloseIconSize,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Removes a file from the list
  void _removeFile(Attachment file) {
    ref
        .read(simpleFilePickerProvider(widget.fieldId).notifier)
        .removeFile(file);
    _updateFileList();
  }

  /// Updates the file list in the state
  void _updateFileList() {
    final currentFiles =
        ref.read(simpleFilePickerProvider(widget.fieldId).notifier).state;
    widget.savedCurrentFiles(currentFiles);
    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.fieldId,
          currentFiles.map((e) => e.toJson()).toList(),
        );
  }

  /// Handles file selection
  Future<void> _handleFileSelection() async {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: widget.allowedExtensions,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      await _processFiles(result.files);
    }
  }

  /// Processes selected files
  Future<void> _processFiles(List<PlatformFile> files) async {
    if (files.length > FilePickerConfig.maxFileCount) {
      _showErrorToast(
          "You can only select up to ${FilePickerConfig.maxFileCount} files.");
      return;
    }

    final attachments = files
        .map((file) => Attachment(
              file: file.path!,
              name: file.name,
              mime: file.extension,
              isUploaded: false,
              localId: const Uuid().v4(),
            ))
        .toList();

    ref
        .read(simpleFilePickerProvider(widget.fieldId).notifier)
        .addMultiFile(attachments);
    _updateFileList();

    try {
      final result = await widget.onFilesSelected(attachments);
      if (result.isNotEmpty) {
        await _updateMultipleFiles(attachments, result);
      } else {
        _removeMultipleFiles(attachments);
      }
    } catch (e) {
      _removeMultipleFiles(attachments);
    } finally {
      _updateFileList();
    }
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

  /// Updates multiple files after upload
  Future<void> _updateMultipleFiles(
      List<Attachment> attachments, List<Map<String, dynamic>> results) async {
    for (int i = 0; i < results.length; i++) {
      ref.read(simpleFilePickerProvider(widget.fieldId).notifier).updateFile(
            Attachment(
              id: results[i]['id'],
              file: results[i]['file'],
              name: results[i]['name'],
              localId: attachments[i].localId,
              mime: results[i]['mime_type'],
              isUploaded: true,
            ),
          );
    }
    _updateFileList();
  }

  /// Removes multiple files
  void _removeMultipleFiles(List<Attachment> attachments) {
    for (var attachment in attachments) {
      ref
          .read(simpleFilePickerProvider(widget.fieldId).notifier)
          .removeLocalFile(attachment);
    }
  }
}
