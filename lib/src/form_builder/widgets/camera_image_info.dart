import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;

/// Class to view image with metadata and return updated image data
class CameraImageInfoPage extends StatefulWidget {
  final File imageFile;
  final List<String> imageInfo;

  const CameraImageInfoPage({
    required this.imageFile,
    required this.imageInfo,
    super.key,
  });

  @override
  State<CameraImageInfoPage> createState() => _CameraImageInfoPageState();
}

class _CameraImageInfoPageState extends State<CameraImageInfoPage> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  double _imageHeight = 0.0;

  bool isImageProcessing = false;
  Uint8List? _processedImage;

  //load captured image on screen
  Future<File> _loadImage(File imageFile) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return imageFile;
  }

  //capture image with text metadata
  void _captureImage() async {
    Uint8List _fileBytes = await widget.imageFile.readAsBytes();
    screenshotController
        .capture(
      delay: const Duration(milliseconds: 20),
    )
        .then((capturedImage) async {
      _processedImage = capturedImage;
    }).catchError((onError) {
      Fluttertoast.showToast(
          msg: "Something went wrong! Couldn't add timestamp.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }).whenComplete(() {
      // Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        //returns image with metadata else returns original image
        _processedImage != null
            ? Navigator.of(context).pop(_processedImage)
            : Navigator.of(context).pop(_fileBytes);
      }
      // });
    });
  }

  calculateImageHeight() async {
    final imageBytes = await widget.imageFile.readAsBytes();
    final img.Image originalImage = img.decodeImage(imageBytes)!;
    setState(() {
      _imageHeight = originalImage.height.toDouble();
    });
  }

  @override
  initState() {
    super.initState();
    Future.microtask(() {
      calculateImageHeight();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _loadImage(widget.imageFile),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            isImageProcessing == false) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading image'),
          );
        } else {
          // Image is loaded, trigger _captureImage after a delay
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() => isImageProcessing = true);
              _captureImage();
            }
          });
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isImageProcessing) const LinearProgressIndicator(),
              Screenshot(
                controller: screenshotController,
                child: Stack(
                  children: [
                    Image.file(
                      snapshot.data!,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        color: Colors.black26,
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...widget.imageInfo.map(
                              (e) => Text(
                                e,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
