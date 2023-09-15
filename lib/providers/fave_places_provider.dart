import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/place.dart';

final favePlacesProvider = NotifierProvider<FavePlacesNotifier, List<Place>>(
  () => FavePlacesNotifier(),
);

class FavePlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return [];
  }

  void addPlace(String title) {
    final newPlace = Place(title: title);
    state = [newPlace, ...state];
  }
}
