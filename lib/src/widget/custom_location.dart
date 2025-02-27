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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 250,
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
      ),
    );
  }
}
