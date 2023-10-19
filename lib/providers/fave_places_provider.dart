import 'package:fave_places_app/providers/image_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/place.dart';

final favePlacesProvider =
    NotifierProvider<FavePlacesNotifier, List<Place>>(FavePlacesNotifier.new);

class FavePlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return [];
  }

  void addPlace(String title) {
    final selectedImage = ref.read(imageProvider);
    final newPlace = Place(
      title: title,
      image: selectedImage,
    );
    state = [newPlace, ...state];
  }
}
