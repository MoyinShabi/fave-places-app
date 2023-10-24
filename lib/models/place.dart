import 'dart:io';

import 'package:uuid/uuid.dart';

import 'place_location.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({
    required this.title,
    required this.image,
    required this.location,
  }) : id = uuid.v4();
}
