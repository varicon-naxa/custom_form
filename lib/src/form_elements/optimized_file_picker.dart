import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/state/attachment_provider.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import '../models/attachment.dart';
import 'package:file_picker/file_picker.dart';

/// Configuration constants for the optimized file picker
class OptimizedFilePickerConfig {
  static const double maxFileSizeMB = 25.0;
  static const double previewFileSize = 100.0;
  static const double previewFileIconSize = 32.0;
  static const double previewFileCloseIconSize = 16.0;
  static const double previewFileHeight = 40.0;
  static const double previewFileBorderRadius = 8.0;
  static const int maxFileCount = 5;
  static const int maxTotalFileLimit = 15;
  static const int initialFileCount = 5; // Show only 5 files initially
}

/// A widget that provides optimized file picking functionality with lazy loading.
///
/// This widget allows users to:
/// - Pick files from device storage
/// - Preview selected files (initially shows only 5)
/// - Expand to see all files with "See More" button
/// - Remove selected files
/// - Upload files to a server
class OptimizedFilePicker extends StatefulHookConsumerWidget {
  const OptimizedFilePicker({
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
  ConsumerState<OptimizedFilePicker> createState() =>
      _OptimizedFilePickerState();
}

class _OptimizedFilePickerState extends ConsumerState<OptimizedFilePicker> {
  bool _showAllFiles = false;

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
        height: OptimizedFilePickerConfig.previewFileHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(
              OptimizedFilePickerConfig.previewFileBorderRadius),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.file_upload_outlined),
            SizedBox(width: 8),
            Text('Upload Files'),
          ],
        ),
      ),
    );
  }

  /// Builds the list of file previews with optimization
  Widget _buildFilePreviews() {
    return Consumer(
      builder: (context, ref, child) {
        final files = ref.watch(simpleFilePickerProvider(widget.fieldId));

        if (files.isEmpty) {
          return const SizedBox.shrink();
        }

        // Determine which files to show
        final filesToShow = _showAllFiles
            ? files
            : files.take(OptimizedFilePickerConfig.initialFileCount).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...filesToShow.map((file) => _buildFilePreview(file)),
            // Show "See More" or "See Less" button if needed
            if (files.length > OptimizedFilePickerConfig.initialFileCount)
              _buildSeeMoreButton(files.length),
          ],
        );
      },
    );
  }

  /// Builds the "See More" or "See Less" button
  Widget _buildSeeMoreButton(int totalFiles) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showAllFiles = !_showAllFiles;
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
                _showAllFiles
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.blue,
              ),
              const SizedBox(width: 4),
              Text(
                _showAllFiles
                    ? 'See Less'
                    : 'See More (${totalFiles - OptimizedFilePickerConfig.initialFileCount} more)',
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

  /// Builds a single file preview with remove functionality
  Widget _buildFilePreview(Attachment file) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(bottom: 10.0),
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
            _getFileIcon(file.mime ?? ''),
            color: Colors.grey,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              file.name ?? 'Unknown File',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (file.isUploaded ?? false)
            InkWell(
              onTap: () => _removeFile(file),
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
    );
  }

  /// Gets the appropriate icon for a file type
  IconData _getFileIcon(String mimeType) {
    if (mimeType.startsWith('image/')) return Icons.image;
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
    if (mimeType.contains('word') || mimeType.contains('document'))
      return Icons.edit_document;
    if (mimeType.contains('excel') || mimeType.contains('spreadsheet'))
      return Icons.table_chart;
    if (mimeType.contains('text')) return Icons.text_snippet_outlined;
    return Icons.insert_drive_file;
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
    try {
      // Check if user has reached maximum total file limit
      final currentFiles = ref.read(simpleFilePickerProvider(widget.fieldId));
      if (currentFiles.length >= OptimizedFilePickerConfig.maxTotalFileLimit) {
        _showErrorToast(
            'You can only have a maximum of ${OptimizedFilePickerConfig.maxTotalFileLimit} files in total.');
        return;
      }

      // Calculate remaining slots
      final remainingSlots = OptimizedFilePickerConfig.maxFileCount -
          (currentFiles.length % OptimizedFilePickerConfig.maxFileCount);

      if (remainingSlots <= 0) {
        _showErrorToast(
            'Maximum files per selection reached. Please select fewer files.');
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowedExtensions: widget.allowedExtensions.isNotEmpty
            ? widget.allowedExtensions
            : null,
        allowMultiple: true,
        withData: false,
      );

      if (result != null && result.files.isNotEmpty) {
        List<PlatformFile> selectedFiles = result.files;

        // Limit the number of files that can be picked
        if (selectedFiles.length > remainingSlots) {
          selectedFiles = selectedFiles.take(remainingSlots).toList();
          _showErrorToast(
              'Only the first $remainingSlots files will be added.');
        }

        await _processAndAddFiles(selectedFiles);
      }
    } catch (e) {
      _showErrorToast('Error picking files: $e');
    }
  }

  /// Processes and adds files to the list
  Future<void> _processAndAddFiles(List<PlatformFile> pickedFiles) async {
    try {
      List<Attachment> processedFiles = [];

      for (PlatformFile file in pickedFiles) {
        // Check file size
        if (file.size > OptimizedFilePickerConfig.maxFileSizeMB * 1024 * 1024) {
          _showErrorToast(
              'File ${file.name} is too large. Maximum size is ${OptimizedFilePickerConfig.maxFileSizeMB}MB.');
          continue;
        }

        // Create attachment
        final attachment = Attachment(
          localId: const Uuid().v4(),
          file: file.path,
          name: file.name,
          mime: file.extension != null ? 'application/${file.extension}' : null,
          isUploaded: false,
        );

        processedFiles.add(attachment);
      }

      if (processedFiles.isNotEmpty) {
        // Add to state at the beginning (most recent first)
        ref
            .read(simpleFilePickerProvider(widget.fieldId).notifier)
            .addMultiFileAtBeginning(processedFiles);

        // Update form state
        _updateFileList();

        // Upload files
        await widget.onFilesSelected(processedFiles);
      }
    } catch (e) {
      _showErrorToast('Error processing files: $e');
    }
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
