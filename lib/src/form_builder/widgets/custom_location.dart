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

  final markers = <Marker>{};
  MarkerId markerId = const MarkerId("1");
  LatLng latLng = const LatLng(-33.865143, 151.209900);

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
    return Material(
      child: Column(
        children: [
          Expanded(
            child: Container(
              // width: 400,
              height: widget.forMapField == true
                  ? MediaQuery.of(context).size.height
                  : 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  widget.forMapField == true ? 0 : 10.0,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.postition?.latitude ?? -33.865143,
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
                    markers: markers,
                    onTap: (LatLng curentLatlng) {},
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
                  Positioned(
                    top: 15,
                    left: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.forMapField == true)
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButtonWidget(
                      text: 'Cancel',
                      bgColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: ElevatedButtonWidget(
                      text: 'Submit',
                      onPressed: () {
                        if (context.mounted) {
                          Navigator.pop(context, widget.value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
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

///Elevated button widget
///
///with custom text and function
class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.bgColor,
  });

  final Function onPressed;
  final String text;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () => onPressed(),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                bgColor ?? Theme.of(context).primaryColor,
              )),
          child: Text(
            (text).toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
