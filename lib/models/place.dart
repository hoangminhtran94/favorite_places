import 'dart:io';

class Place {
  const Place({required this.image, required this.id, required this.name});

  final String id;
  final String name;
  final File image;
}
