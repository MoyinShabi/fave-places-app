import 'package:fave_places_app/providers/image_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/place.dart';
import 'location_provider.dart';

final favePlacesProvider =
    NotifierProvider.autoDispose<FavePlacesNotifier, List<Place>>(
        FavePlacesNotifier.new);

class FavePlacesNotifier extends AutoDisposeNotifier<List<Place>> {
  @override
  List<Place> build() {
    return [];
  }

  void addPlace(String title) {
    final selectedImage = ref.read(imageProvider);
    final pickedLocation = ref.read(locationProvider);

    final newPlace = Place(
      title: title,
      image: selectedImage,
      location: pickedLocation,
    );
    state = [newPlace, ...state];
  }
}
