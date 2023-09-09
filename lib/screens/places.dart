import 'package:favorite_places/provider/place_provider.dart';
import 'package:favorite_places/screens/new_place.dart';
import 'package:favorite_places/widgets/place_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placeProvider);
    Widget body = const Center(
      child: Text(
        "There are no places, please add new place first",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
    if (places.isNotEmpty) {
      body = ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, index) => PlaceItem(place: places[index]),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Places"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const NewPlaceScreen()));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: body);
  }
}
