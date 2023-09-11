import 'package:favorite_places/provider/place_provider.dart';
import 'package:favorite_places/widgets/place_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceList extends ConsumerWidget {
  const PlaceList({super.key});

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
    return body;
  }
}
