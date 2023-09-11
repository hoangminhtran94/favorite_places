import 'dart:io';

class PlaceLocation {
  const PlaceLocation(
      {required this.address,
      required this.latitude,
      required this.longtitude});
  final double latitude;
  final double longtitude;
  final String address;
}

class Place {
  const Place(
      {required this.image,
      required this.id,
      required this.name,
      required this.location});

  final String id;
  final PlaceLocation location;
  final String name;
  final File image;
}
