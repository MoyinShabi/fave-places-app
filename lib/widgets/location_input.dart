import 'dart:convert';

import 'package:fave_places_app/models/place_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../providers/location_provider.dart';
import '../screens/map_screen.dart';

class LocationInput extends ConsumerStatefulWidget {
  const LocationInput({super.key});

  @override
  ConsumerState<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends ConsumerState<LocationInput> {
  bool isGettingLocation = false;

  String get locationImage {
    final location = ref.watch(locationProvider);
    final lat = location.latitude;
    final lng = location.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyAvuYRCg_tD1XMHlfkmYnABQvaooHvLZvQ';
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) return;

    try {
      _savePlace(lat, lng);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not get location. Please try again later.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    debugPrint('locationDataLatitude: ${locationData.latitude}');
    debugPrint('locationDataLongitude: ${locationData.longitude}');
  }

  Future<void> _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyAvuYRCg_tD1XMHlfkmYnABQvaooHvLZvQ');
    final response = await http.get(url);
    final data = json.decode(response.body);
    final formattedAddress = data['results'][0]['formatted_address'];
    ref.read(locationProvider.notifier).setLocation(
          PlaceLocation(
            latitude: lat,
            longitude: lng,
            address: formattedAddress,
          ),
        );

    setState(() {
      isGettingLocation = false;
    });
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    Widget previewContent = Text(
      'No location chosen',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    if (location !=
        const PlaceLocation(
          latitude: 0,
          longitude: 0,
          address: '',
        )) {
      previewContent = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          locationImage,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }

    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
