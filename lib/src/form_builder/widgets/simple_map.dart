import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Map field text form  widget
///
///Accepts forMapField and position params
class SimpleMap extends StatefulWidget {
  const SimpleMap({
    super.key,
    required this.lat,
    required this.long,
  });

  ///Map location position value
  final double long;

  ///Map value form key
  final double lat;

  @override
  State<SimpleMap> createState() => _MapFieldWidgetState();
}

class _MapFieldWidgetState extends State<SimpleMap> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  ///Method to load initial position
  loadInitialPosition() async {
    //setting the currently selected position
    currentlySelelectedPosition = Position(
      latitude: widget.lat,
      longitude: widget.long,
      timestamp: DateTime.timestamp(),
      accuracy: 50.0,
      altitude: 0.0,
      altitudeAccuracy: 50.0,
      heading: 50.0,
      headingAccuracy: 50.0,
      speed: 2.0,
      speedAccuracy: 50.0,
    );

    final marker1 = Marker(
      markerId: const MarkerId('answer'),
      position: LatLng(
        widget.lat,
        widget.long,
      ),
    );

    setState(() {
      markers[const MarkerId('answer')] = marker1;
    });
  }

  Position? currentlySelelectedPosition;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      loadInitialPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.long),
          zoom: 12,
        ),
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        padding: const EdgeInsets.all(0),
        markers: markers.values.toSet(),
        cameraTargetBounds: CameraTargetBounds.unbounded,
        minMaxZoomPreference: MinMaxZoomPreference.unbounded,
        onTap: (LatLng curentLatlng) {},
      ),
    );
  }
}
