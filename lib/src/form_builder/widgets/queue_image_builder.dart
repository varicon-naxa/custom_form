
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_image_builder.dart';

class ImageLoaderQueue extends StatefulWidget {
  final List<String> imageUrls; // List of image URLs to load

  const ImageLoaderQueue({super.key, required this.imageUrls});

  @override
  _ImageLoaderQueueState createState() => _ImageLoaderQueueState();
}

class _ImageLoaderQueueState extends State<ImageLoaderQueue> {
  int _currentIndex = 0; // Current image index being loaded

  @override
  void initState() {
    super.initState();
    _loadNextImage();
  }

  void _loadNextImage() {
    if (_currentIndex < widget.imageUrls.length) {
      setState(() {
        // Trigger the build method to display the next image
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < _currentIndex; i++)
          CacheImageBuilder(
            url: widget.imageUrls[i],
            clickUrl: widget.imageUrls[i],
            onLoadComplete: _loadNextImage, // Callback when an image is loaded
          ),
      ],
    );
  }
}