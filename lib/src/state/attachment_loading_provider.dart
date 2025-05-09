import 'package:hooks_riverpod/hooks_riverpod.dart';

class AttachmentLoadingNotifier extends StateNotifier<Set<String>> {
  AttachmentLoadingNotifier() : super({});

  void addLoading(String id) {
    state = {...state, id};
  }

  void removeLoading(String id) {
    state = {...state}..remove(id);
  }

  bool hasLoading() {
    return state.isNotEmpty;
  }
}

final attachmentLoadingProvider =
    StateNotifierProvider.autoDispose<AttachmentLoadingNotifier, Set<String>>(
        (ref) {
  return AttachmentLoadingNotifier();
});
