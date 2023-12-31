import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceDetailsScreen extends ConsumerWidget {
  const PlaceDetailsScreen({super.key, required this.place});
  final Place place;
  String get _staticMapImage {
    final lat = place.location.latitude;
    final long = place.location.longtitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyA3k5JPBdg6gPEOEuhM2uSrnnC_pjZtE2w';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Stack(children: [
        Image.file(
          place.image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MapScreen(
                              location: place.location,
                              isSelecting: false,
                            )));
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(_staticMapImage),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  alignment: Alignment.center,
                  child: Text(place.location.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground)),
                )
              ],
            ))
      ]),
    );
  }
}
