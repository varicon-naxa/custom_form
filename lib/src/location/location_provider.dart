import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/location/location_repo.dart';

final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  return const LocationsRepository();
});
