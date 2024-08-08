import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Cache image builder for image preview section
class CacheImageBuilder extends StatelessWidget {
  const CacheImageBuilder({
    required this.url,
    required this.clickUrl,
    this.size = 42,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.floatingWidget,
    this.imageBuilder,
    this.onLoadComplete,
    super.key,
  });

  final String url;
  final String clickUrl;
  final double? size;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Widget? floatingWidget;
  final VoidCallback? onLoadComplete;

  /// Box shape of image widget if you want to change it to circle then apply [BoxShape.circle]
  final BoxShape shape;
  final Widget? imageBuilder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: clickUrl.isEmpty ? url : clickUrl,
      height: height ?? 50,
      width: width ?? 50,
      fit: fit,
      imageBuilder: (context, imageProvider) {
        // Notify that the image is loaded
        if (onLoadComplete != null) {
          onLoadComplete!();
        }
        return Container(
          height: height ?? 50,
          width: width ?? 50,
          decoration: BoxDecoration(
            shape: shape,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
          child: floatingWidget,
        );
      },
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
