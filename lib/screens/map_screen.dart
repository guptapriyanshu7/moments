import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:latlong/latlong.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation,
    //  =
    //     const PlaceLocation(latitude: 37.422, longitude: -122.084),
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  initState() {
    super.initState();
    _pickedLocation = LatLng(
        widget.initialLocation.latitude, widget.initialLocation.longitude);
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      // body: Center(
      //   child: FlutterMap(
      //     options: MapOptions(
      //       center: _pickedLocation,
      //       zoom: 16.0,
      //     ),
      //     layers: [
      //       TileLayerOptions(
      //         urlTemplate:
      //             "https://api.mapbox.com/styles/v1/guptapriyanshu71/ckhu3fpjg393y1aog45938ds8/tiles/256/{z}/{x}/{y}@2x?access_token=mapbox-access-token",
      //         additionalOptions: {
      //           'accessToken':
      //               'mapbox-access-token',
      //           'id': 'mapbox.mapbox-streets-v8',
      //         },
      //       ),
      //       MarkerLayerOptions(
      //         markers: [
      //           Marker(
      //             width: 50.0,
      //             height: 50.0,
      //             point: _pickedLocation,
      //             builder: (ctx) => Container(
      //               child: Icon(
      //                 Icons.location_on,
      //                 color: Colors.red,
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //     ],
      //   ),
      // )
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pickedLocation,
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers:
            // _pickedLocation == null ? null:
            {
          Marker(
            markerId: MarkerId('m1'),
            position: _pickedLocation,
          ),
        },
      ),
    );
  }
}
