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
      final imageUrl = widget.imageUrls[_currentIndex];

      // Create an ImageProvider and resolve it
      final image = NetworkImage(imageUrl);
      final imageStream = image.resolve(ImageConfiguration.empty);

      // Declare the listener variable before using it
      late ImageStreamListener listener;
      listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
        // When the image is fully loaded, remove the listener and update the state
        imageStream.removeListener(listener);
        setState(() {
          _currentIndex++;
        });
        _loadNextImage(); // Load the next image
      });

      imageStream.addListener(listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (int i = 0; i < _currentIndex; i++)
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              bottom: 8.0,
            ),
            child: CacheImageBuilder(
              height: 75,
              width: 75,
              url: widget.imageUrls[i],
              clickUrl: widget.imageUrls[i],
              onLoadComplete:
                  _loadNextImage, // Callback when an image is loaded
            ),
          ),
      ],
    );
  }
}
