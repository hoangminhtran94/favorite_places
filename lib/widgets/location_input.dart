import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onGetLocation});
  final void Function(PlaceLocation locationData) onGetLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;
  String get _staticMapImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final long = _pickedLocation!.longtitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyA3k5JPBdg6gPEOEuhM2uSrnnC_pjZtE2w';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;
    if (lat == null || long == null) {
      return;
    }
    _savePlace(lat, long);
  }

  void _savePlace(double latitude, double longtitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longtitude&key=AIzaSyA3k5JPBdg6gPEOEuhM2uSrnnC_pjZtE2w');
    final response = await http.get(url);
    final resData = jsonDecode(response.body);
    final address = resData['results'][0]['formatted_address'];
    final PlaceLocation placeLocation = PlaceLocation(
        address: address, latitude: latitude, longtitude: longtitude);
    widget.onGetLocation(placeLocation);
    setState(() {
      _pickedLocation = placeLocation;
      _isGettingLocation = false;
    });
  }

  void _selectOnMap() async {
    final pickedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
            builder: (ctx) => const MapScreen(
                  isSelecting: true,
                )));
    if (pickedLocation == null) {
      return;
    }
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    if (_pickedLocation != null) {
      previewContent = Image.network(
        _staticMapImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return Column(
      children: [
        Container(
            height: 170,
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.2))),
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.location_on),
                label: const Text("Get current location")),
            TextButton.icon(
                onPressed: _selectOnMap,
                icon: const Icon(Icons.map),
                label: const Text("Select on map")),
          ],
        ),
      ],
    );
  }
}
