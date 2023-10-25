import 'package:fave_places_app/screens/add_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/fave_places_provider.dart';
import '../widgets/places_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    ref.read(placesFutureProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favePlaces = ref.watch(favePlacesProvider);
    final placesFuture = ref.watch(placesFutureProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fave Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: placesFuture.when(
          data: (_) => PlacesList(places: favePlaces),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
        ),
      ),
    );
  }
}
