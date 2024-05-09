import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as webGM;

class MapPicker extends StatefulWidget {
  LatLng? value;
  final bool? forMapField;
  final Position? postition;

  MapPicker({
    Key? key,
    this.forMapField = false,
    this.postition,
  }) : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // width: 400,
              height: widget.forMapField == true ? 550 : 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  widget.forMapField == true ? 0 : 10.0,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var maxWidth = constraints.biggest.width;
                  var maxHeight = constraints.biggest.height;

                  return Stack(
                    children: <Widget>[
                      Container(
                        height: maxHeight,
                        width: maxWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            widget.forMapField == true ? 0 : 10.0,
                          ),
                        ),
                        child: GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(
                                (-4.326029675459877), (15.321166142821314)),
                            zoom: 12,
                          ),
                          onMapCreated: widget.forMapField == true
                              ? (GoogleMapController controller) {
                                  _controller.complete(controller);
                                }
                              : null,
                          onCameraMove: widget.forMapField == true
                              ? (CameraPosition newPosition) {
                                  // print(newPosition.target.toJson());
                                  widget.value = newPosition.target;
                                }
                              : null,
                          mapType: MapType.normal,
                          // myLocationButtonEnabled: true,
                          // myLocationEnabled: false,
                          zoomGesturesEnabled: true,
                          padding: const EdgeInsets.all(0),
                          // buildingsEnabled: true,
                          cameraTargetBounds: CameraTargetBounds.unbounded,
                          // compassEnabled: true,
                          // indoorViewEnabled: false,
                          // mapToolbarEnabled: true,
                          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                          // rotateGesturesEnabled: true,
                          // scrollGesturesEnabled: true,
                          // tiltGesturesEnabled: true,
                          // trafficEnabled: false,
                          markers: widget.forMapField == true
                              ? {}
                              : {
                                  const Marker(
                                    markerId: MarkerId('1'),
                                    position: LatLng((-4.326029675459877),
                                        (15.321166142821314)),
                                    icon: BitmapDescriptor.defaultMarker,
                                  ),
                                },
                          onTap: (LatLng curentLatlng) {},
                          // onMapCreated: (GoogleMapController controller) {},
                          // onCameraMove: (position) {},
                        ),
                      ),
                      if (widget.forMapField == true)
                        Positioned(
                          bottom: maxHeight / 2,
                          right: (maxWidth - 30) / 2,
                          child: const Icon(
                            Icons.location_pin,
                            size: 32,
                            color: Colors.green,
                          ),
                        ),
                      Positioned(
                        bottom: 30,
                        left: 30,
                        child: Container(
                          color: Colors.white,
                          child: IconButton(
                            onPressed: () async {
                              var position = await _determinePosition();
                              final GoogleMapController controller =
                                  await _controller.future;
                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                        position.latitude, position.longitude),
                                    zoom: 12,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.my_location),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (widget.forMapField == true)
              Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, widget.value);
                  },
                  child: const Text('Select Location'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
