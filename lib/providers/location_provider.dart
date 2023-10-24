import 'package:fave_places_app/models/place_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationProvider =
    NotifierProvider<LocationNotifier, PlaceLocation>(LocationNotifier.new);

class LocationNotifier extends Notifier<PlaceLocation> {
  @override
  build() {
    return const PlaceLocation(
      latitude: 0,
      longitude: 0,
      address: '',
    );
  }

  void setLocation(PlaceLocation location) {
    state = location;
  }
}
