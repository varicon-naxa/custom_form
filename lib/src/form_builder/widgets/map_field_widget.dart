import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_location.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/src/models/models.dart';

///Map field text form  widget
///
///Accepts forMapField and position params
class MapFieldWidget extends StatefulWidget {
  const MapFieldWidget({
    super.key,
    required this.forMapField,
    this.position,
    required this.formKey,
    required this.formValue,
    this.field,
  });

  final bool forMapField;

  ///Map location position value
  final Position? position;

  ///Map value form key
  final Key formKey;

  ///Form value for map values
  final FormValue formValue;

  ///Map form field
  final TextInputField? field;

  @override
  State<MapFieldWidget> createState() => _MapFieldWidgetState();
}

class _MapFieldWidgetState extends State<MapFieldWidget> {
  late List<Placemark> address;
  bool isLoading = false;

  ///Method to load initial position
  // loadInitialPosition() async {
  //   Position? currentPosition;
  //   if (widget.position == null) {
  //     setState(() => isLoading = true);
  //     currentPosition = await _determinePosition();
  //     setState(() => isLoading = false);

  //     //setting the currently selected position
  //     currentlySelelectedPosition = Position(
  //       latitude: currentPosition.latitude,
  //       longitude: currentPosition.longitude,
  //       timestamp: DateTime.timestamp(),
  //       accuracy: 50.0,
  //       altitude: 0.0,
  //       altitudeAccuracy: 50.0,
  //       heading: 50.0,
  //       headingAccuracy: 50.0,
  //       speed: 2.0,
  //       speedAccuracy: 50.0,
  //     );
  //   } else {
  //     currentPosition = widget.position;
  //   }

  //   address = await placemarkFromCoordinates(
  //     currentPosition!.latitude,
  //     currentPosition.longitude,
  //   );

  //   mapFieldController.text =
  //       '${address.first.name!}, ${address.first.country!}, ${address.first.locality!}';
  // }

  TextEditingController mapFieldController = TextEditingController();

  Position? currentlySelelectedPosition;

  @override
  void initState() {
    super.initState();
    mapFieldController.text = widget.field?.answer ?? '';

    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     await loadInitialPosition();
    //   });
  }

  ///Method to set up the user position selected via map
  ///
  ///Accepts latLng
  userPositionSetUp(LatLng latLng) async {
    //setting the currently selected position
    currentlySelelectedPosition = Position(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      timestamp: DateTime.timestamp(),
      accuracy: 50.0,
      altitude: 0.0,
      altitudeAccuracy: 50.0,
      heading: 50.0,
      headingAccuracy: 50.0,
      speed: 2.0,
      speedAccuracy: 50.0,
    );

    //getting the address from the latlng
    List<Placemark> address = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    //setting the address value to the map field controller
    print(address);
    mapFieldController.text =
        '${address.first.subThoroughfare!.isEmpty ? '' : '${address.first.subThoroughfare}'} ${address.first.thoroughfare!.isEmpty ? '' : '${address.first.thoroughfare}, '}${address.first.locality} ${address.first.administrativeArea} ${address.first.postalCode} ${address.first.country}';
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.formKey,
      autocorrect: false,
      onSaved: (newValue) {
        widget.formValue.saveString(
          widget.field?.id ?? '',
          newValue.toString().trim(),
        );
      },
      textInputAction: TextInputAction.done,
      controller: mapFieldController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        isDense: true,
        suffixIcon: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                )
              : const Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey,
                  size: 24,
                ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => MapPicker(
                forMapField: true,
                formKey: widget.formKey,
                postition: currentlySelelectedPosition ?? widget.position,
              ),
            ).then((value) async {
              LatLng? latLng = value;

              if (value != null) {
                widget.formValue.saveString(
                  widget.field?.id ?? '',
                  latLng.toString(),
                );
                await userPositionSetUp(latLng!);
              }
            });
          },
        ),
      ),
      maxLines: null,
    );
  }

  ///method to determine the current position with permission handle
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

///TODO: uncomment below code in future if map field as a separate widget is required

// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:varicon_form_builder/src/form_builder/widgets/custom_location.dart';
// import 'package:varicon_form_builder/src/models/form_value.dart';
// import 'package:varicon_form_builder/src/models/models.dart';

// ///Map field text form  widget
// ///
// ///Accepts forMapField and position params
// class MapFieldWidget extends StatefulWidget {
//   const MapFieldWidget({
//     super.key,
//     required this.forMapField,
//     this.position,
//     required this.formKey,
//     required this.formValue,
//     required this.field,
//   });

//   final bool forMapField;

//   ///Map location position value
//   final Position? position;

//   ///Map value form key
//   final Key formKey;

//   ///Form value for map values
//   final FormValue formValue;

//   ///Map form field
//   final MapField field;

//   @override
//   State<MapFieldWidget> createState() => _MapFieldWidgetState();
// }

// class _MapFieldWidgetState extends State<MapFieldWidget> {
//   late List<Placemark> address;
//   bool isLoading = false;

//   ///Method to load initial position
//   loadInitialPosition() async {
//     Position? currentPosition;
//     if (widget.position == null) {
//       setState(() => isLoading = true);
//       currentPosition = await _determinePosition();
//       setState(() => isLoading = false);

//       //setting the currently selected position
//       currentlySelelectedPosition = Position(
//         latitude: currentPosition.latitude,
//         longitude: currentPosition.longitude,
//         timestamp: DateTime.timestamp(),
//         accuracy: 50.0,
//         altitude: 0.0,
//         altitudeAccuracy: 50.0,
//         heading: 50.0,
//         headingAccuracy: 50.0,
//         speed: 2.0,
//         speedAccuracy: 50.0,
//       );
//     } else {
//       currentPosition = widget.position;
//     }

//     address = await placemarkFromCoordinates(
//       currentPosition!.latitude,
//       currentPosition.longitude,
//     );

//     mapFieldController.text =
//         '${address.first.name!}, ${address.first.country!}, ${address.first.locality!}';
//   }

//   TextEditingController mapFieldController = TextEditingController();

//   Position? currentlySelelectedPosition;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await loadInitialPosition();
//     });
//   }

//   ///Method to set up the user position selected via map
//   ///
//   ///Accepts latLng
//   userPositionSetUp(LatLng latLng) async {
//     //setting the currently selected position
//     currentlySelelectedPosition = Position(
//       latitude: latLng.latitude,
//       longitude: latLng.longitude,
//       timestamp: DateTime.timestamp(),
//       accuracy: 50.0,
//       altitude: 0.0,
//       altitudeAccuracy: 50.0,
//       heading: 50.0,
//       headingAccuracy: 50.0,
//       speed: 2.0,
//       speedAccuracy: 50.0,
//     );

//     //getting the address from the latlng
//     List<Placemark> address = await placemarkFromCoordinates(
//       latLng.latitude,
//       latLng.longitude,
//     );

//     //setting the address value to the map field controller
//     mapFieldController.text =
//         '${address.first.subThoroughfare} ${address.first.thoroughfare}, ${address.first.locality} ${address.first.administrativeArea} ${address.first.postalCode} ${address.first.country}';

//     //saving the new location value to the form value
//     widget.formValue.saveMap(widget.field.id, {
//       'lat': latLng.latitude,
//       'long': latLng.longitude,
//       'addressLine':
//           '${address.first.subThoroughfare} ${address.first.thoroughfare}, ${address.first.locality} ${address.first.administrativeArea} ${address.first.postalCode} ${address.first.country}'
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       key: widget.formKey,
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (context) => MapPicker(
//             forMapField: true,
//             formKey: widget.formKey,
//             postition: currentlySelelectedPosition ?? widget.position,
//           ),
//         ).then((value) async {
//           LatLng? latLng = value;

//           if (value != null) {
//             await userPositionSetUp(latLng!);
//           }
//         });
//       },
//       autocorrect: false,
//       readOnly: true,
//       controller: mapFieldController,
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.all(8),
//         isDense: true,
//         suffixIcon: IconButton(
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//           icon: isLoading
//               ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(),
//                 )
//               : const Icon(
//                   Icons.location_on_outlined,
//                   color: Colors.grey,
//                   size: 24,
//                 ),
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (context) => MapPicker(
//                 forMapField: true,
//                 formKey: widget.formKey,
//                 postition: currentlySelelectedPosition ?? widget.position,
//               ),
//             ).then((value) async {
//               LatLng? latLng = value;

//               if (value != null) {
//                 await userPositionSetUp(latLng!);
//               }
//             });
//           },
//         ),
//       ),
//       maxLines: null,
//     );
//   }

//   ///method to determine the current position with permission handle
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }
// }
