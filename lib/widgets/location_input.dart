import 'package:GreatPlaces/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong/latlong.dart';

import '../helpers/location_helper.dart';

import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // bool isMapSelected = false;
  // double latitude;
  // double longitude;
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
      // isMapSelected = true;
      // latitude = lat;
      // longitude = lng;
      widget.onSelectPlace(lat, lng);
    });
    // setState(() {
    //   isMapSelected = true;
    //   latitude = lat;
    //   longitude = lng;
    //   widget.onSelectPlace(latitude, longitude);
    // });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    double lat;
    double lng;

    final locData = await Location().getLocation();
    if (locData == null) {
      lat = 37.422;
      lng = -122.084;
    } else {
      lat = locData.latitude;
      lng = locData.longitude;
    }

    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          initialLocation: PlaceLocation(latitude: lat, longitude: lng),
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    // final address = await LocationHelper.getPlaceAddress(
    //   selectedLocation.latitude,
    //   selectedLocation.longitude,
    // );
    // print(address);
    // print(selectedLocation.latitude);
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
  }

  // Future<void> _getCurrentUserLocation() async {
  //   final locData = await Location().getLocation();
  //   final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
  //     latitude: locData.latitude,
  //     longitude: locData.longitude,
  //   );
  //   setState(() {
  //     _previewImageUrl = staticMapImageUrl;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          // child: !isMapSelected
          //     ? Text(
          //         'No Location Chosen',
          //         textAlign: TextAlign.center,
          //       )
          //     : GoogleMap(
          //         markers: {
          //           Marker(
          //             markerId: MarkerId('m1'),
          //             position: LatLng(
          //               latitude,
          //               longitude,
          //             ),
          //           )
          //         },
          //         initialCameraPosition: CameraPosition(
          //           target: LatLng(
          //             latitude,
          //             longitude,
          //           ),
          //           zoom: 16,
          //         ),
          //       ),
          // child: isMapSelected
          //     ? FlutterMap(
          //         options: MapOptions(
          //           center: LatLng(latitude, longitude),
          //           zoom: 16.0,
          //         ),
          //         layers: [
          //           TileLayerOptions(
          //               urlTemplate:
          //                   "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          //               subdomains: ['a', 'b', 'c']),
          //           MarkerLayerOptions(
          //             markers: [
          //               Marker(
          //                 width: 80.0,
          //                 height: 80.0,
          //                 point: LatLng(latitude, longitude),
          //                 builder: (ctx) => Container(
          //                   child: Icon(
          //                     Icons.location_on,
          //                     color: Colors.red,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       )
          //     : Text('No Location Chosen'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              icon: Icon(
                Icons.location_on,
              ),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.map,
              ),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
