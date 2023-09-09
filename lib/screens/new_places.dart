import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/provider/place_provider.dart';
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
  var _currentName = "";
  void _addNewPlace() {
    _formKey.currentState!.save();
    ref
        .read(placeProvider.notifier)
        .addAPlace(Place(id: uuid.v4(), name: _currentName));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new place"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
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
                        _currentName = newValue;
                      });
                    }
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
    );
  }
}
