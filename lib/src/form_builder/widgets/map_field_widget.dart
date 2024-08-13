import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_location.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

///Map field text form  widget
///
///Accepts forMapField and position params
class MapFieldWidget extends StatefulWidget {
  const MapFieldWidget({
    super.key,
    required this.forMapField,
    this.position,
    required this.fieldKey,
    required this.isRequired,
    required this.formValue,
    this.field,
  });

  final bool forMapField;
  final bool isRequired;

  ///Map location position value
  final Position? position;

  ///Map value form key
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

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
    mapFieldController.text =
        '${address.first.subThoroughfare!.isEmpty ? '' : '${address.first.subThoroughfare}'} ${address.first.thoroughfare!.isEmpty ? '' : '${address.first.thoroughfare}, '}${address.first.locality} ${address.first.administrativeArea} ${address.first.postalCode} ${address.first.country}';
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      autocorrect: false,
      onSaved: (newValue) {
        widget.formValue.saveString(
          widget.field?.id ?? '',
          newValue.toString().trim(),
        );
      },
      validator: (value) {
        return textValidator(
          value: value,
          inputType: "text",
          isRequired: widget.isRequired,
          requiredErrorText: 'Address is Required',
        );
      },
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


}
