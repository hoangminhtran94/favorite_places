import 'dart:io';

import "package:favorite_places/models/place.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database> _getDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbpath, 'places.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, image TEXT, lat REAL, lng REAL, address TEXT )');
  }, version: 1);

  return db;
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query(
      'user_places',
    );
    final places = data
        .map((row) => Place(
            image: File(row['image'] as String),
            id: row['id'] as String,
            name: row['name'] as String,
            location: PlaceLocation(
                address: row['address'] as String,
                latitude: row['lat'] as double,
                longtitude: row['lng'] as double)))
        .toList();
    state = places;
  }

  void setPlaces(List<Place> places) {
    state = places;
  }

  void addAPlace(Place place) async {
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': place.id,
      'name': place.name,
      'image': place.image.path,
      'lat': place.location.latitude,
      'lng': place.location.longtitude,
      'address': place.location.address,
    });
    state = [...state, place];
  }
}

final placeProvider = StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
