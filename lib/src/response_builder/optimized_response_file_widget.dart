import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/models/attachment.dart';

/// Configuration constants for the optimized response file widget
class OptimizedResponseFileConfig {
  static const double previewFileHeight = 40.0;
  static const double previewFileBorderRadius = 8.0;
  static const int initialFileCount = 5; // Show only 5 files initially
}

/// A widget that displays files in read-only mode with optimization for performance.
///
/// This widget:
/// - Shows only 5 files initially to prevent performance issues
/// - Provides a "See More" button to expand and show all files
/// - Handles file loading errors gracefully
/// - Supports both local files and network files
class OptimizedResponseFileWidget extends StatefulWidget {
  const OptimizedResponseFileWidget({
    super.key,
    required this.files,
    required this.fileBuild,
    this.onFileTap,
  });

  /// List of files to display
  final List<Attachment> files;

  /// Widget builder for displaying files
  final Widget Function(Map<String, dynamic>) fileBuild;

  /// Optional callback when a file is tapped
  final Function(Attachment)? onFileTap;

  @override
  State<OptimizedResponseFileWidget> createState() =>
      _OptimizedResponseFileWidgetState();
}

class _OptimizedResponseFileWidgetState
    extends State<OptimizedResponseFileWidget> {
  bool _showAllFiles = false;

  @override
  Widget build(BuildContext context) {
    if (widget.files.isEmpty) {
      return const SizedBox.shrink();
    }

    // Determine which files to show
    final filesToShow = _showAllFiles
        ? widget.files
        : widget.files
            .take(OptimizedResponseFileConfig.initialFileCount)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...filesToShow.map((file) => _buildFilePreview(file)),
        // Show "See More" or "See Less" button if needed
        if (widget.files.length > OptimizedResponseFileConfig.initialFileCount)
          _buildSeeMoreButton(widget.files.length),
      ],
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
                    : 'See More (${totalFiles - OptimizedResponseFileConfig.initialFileCount} more)',
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

  /// Builds a single file preview
  Widget _buildFilePreview(Attachment file) {
    return GestureDetector(
      onTap: () => widget.onFileTap?.call(file),
      child: Container(
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
          ],
        ),
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
}
