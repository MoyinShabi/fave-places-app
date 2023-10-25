// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  String toString() =>
      'PlaceLocation(latitude: $latitude, longitude: $longitude, address: $address)';
}
