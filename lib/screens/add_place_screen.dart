import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';

import '../providers/great_places.dart';

import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add_place_screen';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;
  var _isLoading = false;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) async {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    // final address = await LocationHelper.getPlaceAddress(
    //     _pickedLocation.latitude, _pickedLocation.longitude);
    // print(address);
    // print(_pickedLocation.latitude);
  }

  void _savePlace() async {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    await Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: 'Title'),
                            controller: _titleController,
                          ),
                          SizedBox(height: 10),
                          ImageInput(_selectImage),
                          SizedBox(height: 10),
                          LocationInput(_selectPlace),
                        ],
                      ),
                    ),
                  ),
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Place'),
                  onPressed: _savePlace,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
    );
  }
}
