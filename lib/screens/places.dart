import 'package:favorite_places/provider/place_provider.dart';
import 'package:favorite_places/screens/new_places.dart';
import 'package:favorite_places/screens/place_details.dart';
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
        itemBuilder: (ctx, index) => InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => PlaceDetailsScreen(place: places[index])));
          },
          child: Dismissible(
            key: Key(places[index].id),
            onDismissed: (direction) {},
            child: ListTile(
                title: Text(
              places[index].name,
              style: Theme.of(context).textTheme.titleMedium,
            )),
          ),
        ),
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
