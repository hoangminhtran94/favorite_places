import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter/material.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({super.key, required this.place});
  final Place place;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => PlaceDetailsScreen(place: place)));
      },
      child: Dismissible(
        key: Key(place.id),
        onDismissed: (direction) {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
              leading: CircleAvatar(
                  radius: 26, backgroundImage: FileImage(place.image)),
              title: Text(
                place.name,
                style: Theme.of(context).textTheme.titleMedium,
              )),
        ),
      ),
    );
  }
}
