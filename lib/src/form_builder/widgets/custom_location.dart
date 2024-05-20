// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Maps widget to show location
///
///Accepts position to show on map
class CustomLocation extends StatelessWidget {
  const CustomLocation({super.key, required this.postition});
  final Position postition;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng((postition.latitude), (postition.longitude)),
          zoom: 10,
        ),
        markers: {
          Marker(
              markerId: const MarkerId('1'),
              position: LatLng((postition.latitude), (postition.longitude)),
              icon: BitmapDescriptor.defaultMarker),
        },
        onTap: (LatLng curentLatlng) {},
        onMapCreated: (GoogleMapController controller) {},
        onCameraMove: (position) {},
      ),
    );
  }
}

///Widget for custom map field widget
///
///Accepts forMapField and position
///
///Can select location on map
class MapPicker extends StatefulWidget {
  LatLng? value;
  final bool? forMapField;

  ///Map location position value
  final Position? postition;

  ///Map value form key
  final Key formKey;

  MapPicker({
    Key? key,
    this.forMapField = false,
    this.postition,
    required this.formKey,
  }) : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final Completer<GoogleMapController> _controller = Completer();

  final markers = Set<Marker>();
  MarkerId markerId = MarkerId("1");
  LatLng latLng = LatLng(-33.865143, 151.209900);

  @override
  initState() {
    super.initState();
    markers.add(
      Marker(
        markerId: markerId,
        position: latLng,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              width: 400,
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
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                widget.postition?.latitude ?? -33.865143,
                                widget.postition?.longitude ?? 151.209900),
                            zoom: 12,
                          ),
                          onMapCreated: widget.forMapField == true
                              ? (GoogleMapController controller) {
                                  _controller.complete(controller);
                                }
                              : null,
                          onCameraMove: widget.forMapField == true
                              ? (CameraPosition newPosition) {
                                  widget.value = newPosition.target;
                                  setState(() {
                                    markers.add(Marker(
                                        markerId: markerId,
                                        position: newPosition.target));
                                  });
                                }
                              : null,
                          mapType: MapType.normal,
                          zoomGesturesEnabled: true,
                          padding: const EdgeInsets.all(0),
                          cameraTargetBounds: CameraTargetBounds.unbounded,
                          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                          // markers:
                          //     // widget.forMapField == true
                          //     //     ? {}
                          //     //     :
                          //     {
                          //   Marker(
                          //     draggable: true,
                          //     markerId: const MarkerId('1'),
                          //     position: LatLng(
                          //         (-4.326029675459877), (15.321166142821314)),
                          //     icon: BitmapDescriptor.defaultMarker,
                          //   ),
                          // },
                          markers: markers,
                          // markers: Set<Marker>.of(
                          //   <Marker>[
                          //     Marker(
                          //       draggable: true,
                          //       markerId: MarkerId("1"),
                          //       onDragEnd: ((newPosition) {
                          //         print(newPosition.latitude);
                          //         print(newPosition.longitude);
                          //       }),
                          //       position: LatLng((-33.865143), (151.209900)),
                          //       icon: BitmapDescriptor.defaultMarker,
                          //       infoWindow: const InfoWindow(
                          //         title: 'Usted está aquí',
                          //       ),
                          //     )
                          //   ],
                          // ),
                          onTap: (LatLng curentLatlng) {},
                        ),
                      ),
                      // if (widget.forMapField == true)
                      //   Positioned(
                      //     bottom: maxHeight / 2,
                      //     right: (maxWidth - 30) / 2,
                      //     child: const Icon(
                      //       Icons.location_pin,
                      //       size: 32,
                      //       color: Colors.green,
                      //     ),
                      //   ),
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
                    if (context.mounted) {
                      Navigator.pop(context, widget.value);
                    }
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
