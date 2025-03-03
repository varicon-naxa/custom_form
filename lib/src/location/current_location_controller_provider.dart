import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:varicon_form_builder/src/ext/cache_for.dart';
import 'location_provider.dart';

class CurrentLocationController extends StateNotifier<AsyncValue<Position>> {
  CurrentLocationController(this.ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref ref;

  Future<void> _init() async {
    try {
      final locationService = ref.watch(locationsRepositoryProvider);
      final location = await locationService.getCurrentLocation();
      ref.cacheFor(const Duration(seconds: 10));
      state = AsyncValue.data(location);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateLocation(Position location) => state = AsyncValue.data(location);
}

final currentLocationControllerProvider = StateNotifierProvider.autoDispose<
    CurrentLocationController, AsyncValue<Position>>((ref) {
  return CurrentLocationController(ref);
});
