import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/models/attachment.dart';

class SimpleImagePickerProvider extends StateNotifier<List<Attachment>> {
  SimpleImagePickerProvider() : super([]);

  void addAll(List<Attachment> images) {
    state = [...images];
  }

  void addImage(Attachment image) {
    state = [...state, image];
  }

  void addMultiImage(List<Attachment> images) {
    state = [...state, ...images];
  }

  /// Adds multiple images to the beginning of the state (most recent first)
  void addMultiImageAtBeginning(List<Attachment> images) {
    state = [...images, ...state];
  }

  void removeLocalImage(Attachment image) {
    state = state.where((i) => i.localId != image.localId).toList();
  }

  void updateImage(Attachment image) {
    final index = state.indexWhere((i) => i.localId == image.localId);
    if (index != -1) {
      state[index] = image;
    }
  }

  /// Updates multiple images with new upload status
  void updateImagesWithUploadStatus(
      List<Attachment> originalImages, List<Attachment> updatedImages) {
    final updatedState = state.map((img) {
      final originalIndex = originalImages
          .indexWhere((original) => original.localId == img.localId);
      if (originalIndex != -1) {
        return updatedImages[originalIndex];
      }
      return img;
    }).toList();
    state = updatedState;
  }

  void removeImage(Attachment image) {
    state = state.where((i) => i.id != image.id).toList();
  }

  void clearImages() {
    state = [];
  }
}

final simpleImagePickerProvider = StateNotifierProvider.family<
    SimpleImagePickerProvider, List<Attachment>, String>((ref, fieldId) {
  return SimpleImagePickerProvider();
});

/// Provider for managing file picker state
final simpleFilePickerProvider = StateNotifierProvider.family
    .autoDispose<SimpleFilePickerNotifier, List<Attachment>, String>(
  (ref, fieldId) => SimpleFilePickerNotifier(),
);

/// Notifier for managing file picker state
class SimpleFilePickerNotifier extends StateNotifier<List<Attachment>> {
  SimpleFilePickerNotifier() : super([]);

  /// Adds a single file to the state
  void addFile(Attachment file) {
    state = [...state, file];
  }

  /// Adds multiple files to the state
  void addMultiFile(List<Attachment> files) {
    state = [...state, ...files];
  }

  /// Adds multiple files to the beginning of the state (most recent first)
  void addMultiFileAtBeginning(List<Attachment> files) {
    state = [...files, ...state];
  }

  /// Adds all files to the state
  void addAll(List<Attachment> files) {
    state = files;
  }

  /// Updates a file in the state
  void updateFile(Attachment file) {
    state = state.map((f) => f.localId == file.localId ? file : f).toList();
  }

  /// Updates multiple files with new upload status
  void updateFilesWithUploadStatus(
      List<Attachment> originalFiles, List<Attachment> updatedFiles) {
    final updatedState = state.map((file) {
      final originalIndex = originalFiles
          .indexWhere((original) => original.localId == file.localId);
      if (originalIndex != -1) {
        return updatedFiles[originalIndex];
      }
      return file;
    }).toList();
    state = updatedState;
  }

  /// Removes a file from the state
  void removeFile(Attachment file) {
    state = state.where((f) => f.localId != file.localId).toList();
  }

  /// Removes a local file from the state
  void removeLocalFile(Attachment file) {
    state = state.where((f) => f.localId != file.localId).toList();
  }
}
