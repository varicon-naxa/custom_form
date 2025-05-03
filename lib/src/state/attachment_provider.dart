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

  void removeLocalImage(Attachment image) {
    state = state.where((i) => i.localId != image.localId).toList();
  }

  void updateImage(Attachment image) {
    final index = state.indexWhere((i) => i.localId == image.localId);
    if (index != -1) {
      state[index] = image;
    }
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
final simpleFilePickerProvider = StateNotifierProvider.family<
    SimpleFilePickerNotifier, List<Attachment>, String>(
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

  /// Adds all files to the state
  void addAll(List<Attachment> files) {
    state = files;
  }

  /// Updates a file in the state
  void updateFile(Attachment file) {
    state = state.map((f) => f.localId == file.localId ? file : f).toList();
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
