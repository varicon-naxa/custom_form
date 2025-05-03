import 'dart:developer';

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
    log('index: ${image.toJson()}');
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
