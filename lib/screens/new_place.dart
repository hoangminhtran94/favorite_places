import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/provider/place_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() {
    return _NewPlaceScreenState();
  }
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = "";
  PlaceLocation? _pickedLocation;
  File? _takenImage;
  void _addNewPlace() {
    _formKey.currentState!.save();
    if (_enteredName.isEmpty ||
        _takenImage == null ||
        _pickedLocation == null) {
      return;
    }
    ref.read(placeProvider.notifier).addAPlace(Place(
        id: uuid.v4(),
        name: _enteredName,
        image: _takenImage!,
        location: _pickedLocation!));
    Navigator.of(context).pop();
  }

  void _takeImage(File image) {
    _takenImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new place"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: Theme.of(context).textTheme.titleSmall,
                    decoration: const InputDecoration(
                        label: Text("Title"), fillColor: Colors.white),
                    onSaved: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _enteredName = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ImageInput(
                    onPickImage: _takeImage,
                  ),
                  const SizedBox(height: 16),
                  LocationInput(
                    onGetLocation: (PlaceLocation locationData) {
                      _pickedLocation = locationData;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                      onPressed: _addNewPlace,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Place"))
                ],
              )),
        ),
      ),
    );
  }
}
