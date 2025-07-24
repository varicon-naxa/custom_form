import 'dart:io';
import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/models/attachment.dart';

/// Configuration constants for the optimized response image widget
class OptimizedResponseImageConfig {
  static const double previewImageSize = 100.0;
  static const double previewImageBorderRadius = 8.0;
  static const int initialImageCount = 5; // Show only 5 images initially
}

/// A widget that displays images in read-only mode with optimization for performance.
///
/// This widget:
/// - Shows only 5 images initially to prevent performance issues
/// - Provides a "See More" button to expand and show all images
/// - Handles image loading errors gracefully
/// - Supports both local files and network images
class OptimizedResponseImageWidget extends StatefulWidget {
  const OptimizedResponseImageWidget({
    super.key,
    required this.images,
    required this.imageBuild,
    this.onImageTap,
  });

  /// List of images to display
  final List<Attachment> images;

  /// Widget builder for displaying images
  final Widget Function(Map<String, dynamic>) imageBuild;

  /// Optional callback when an image is tapped
  final Function(Attachment)? onImageTap;

  @override
  State<OptimizedResponseImageWidget> createState() => _OptimizedResponseImageWidgetState();
}

class _OptimizedResponseImageWidgetState extends State<OptimizedResponseImageWidget> {
  bool _showAllImages = false;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }

    // Determine which images to show
    final imagesToShow = _showAllImages 
        ? widget.images 
        : widget.images.take(OptimizedResponseImageConfig.initialImageCount).toList();

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
        if (widget.images.length > OptimizedResponseImageConfig.initialImageCount)
          _buildSeeMoreButton(widget.images.length),
      ],
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
                _showAllImages ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.blue,
              ),
              const SizedBox(width: 4),
              Text(
                _showAllImages 
                    ? 'See Less' 
                    : 'See More (${totalImages - OptimizedResponseImageConfig.initialImageCount} more)',
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

  /// Builds a single image preview
  Widget _buildImagePreview(Attachment image) {
    return GestureDetector(
      onTap: () => widget.onImageTap?.call(image),
      child: Container(
        height: OptimizedResponseImageConfig.previewImageSize,
        width: OptimizedResponseImageConfig.previewImageSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius:
              BorderRadius.circular(OptimizedResponseImageConfig.previewImageBorderRadius),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(OptimizedResponseImageConfig.previewImageBorderRadius),
          child: _buildImageContent(image),
        ),
      ),
    );
  }

  /// Builds the image content
  Widget _buildImageContent(Attachment image) {
    // Use the custom image builder if available
    if (image.file != null) {
      return widget.imageBuild({
        'image': image.file,
        'id': image.id,
        'height': OptimizedResponseImageConfig.previewImageSize,
        'width': OptimizedResponseImageConfig.previewImageSize,
      });
    }

    // Fallback to default image display
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
        ),
      ),
    );
  }
} 