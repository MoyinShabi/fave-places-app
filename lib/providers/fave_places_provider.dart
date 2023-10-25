import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../models/place.dart';
import '../models/place_location.dart';
import 'image_provider.dart';
import 'location_provider.dart';

final favePlacesProvider =
    NotifierProvider.autoDispose<FavePlacesNotifier, List<Place>>(
        FavePlacesNotifier.new);

class FavePlacesNotifier extends AutoDisposeNotifier<List<Place>> {
  @override
  List<Place> build() {
    return [];
  }

  // Load places on app start from sql database
  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();

    state = places;
  }

  Future<void> addPlace(String title) async {
    final selectedImage = ref.read(imageProvider);
    final pickedLocation = ref.read(locationProvider);

    // Store selected image in app directory
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(selectedImage.path);
    final copiedImage = await selectedImage.copy('${appDir.path}/$fileName');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: pickedLocation,
    );

    final db = await _getDatabase();
    // Store new place in sql database
    await db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      },
    );

    state = [newPlace, ...state];
  }
}

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)'); // Database table
    },
    version: 1,
  );
  return db;
}

final placesFutureProvider = FutureProvider.autoDispose<void>((ref) async {
  await ref.watch(favePlacesProvider.notifier).loadPlaces();
});
