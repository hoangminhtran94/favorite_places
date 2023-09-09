import "package:favorite_places/models/place.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void setPlaces(List<Place> places) {
    state = places;
  }

  void addAPlace(Place place) {
    state = [...state, place];
  }
}

final placeProvider = StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
