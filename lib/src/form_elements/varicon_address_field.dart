import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/custom_element/widget/custom_map_picker.dart';
import 'package:varicon_form_builder/src/helpers/debouncer.dart';
import '../../varicon_form_builder.dart';
import '../helpers/validators.dart';
import '../state/current_form_provider.dart';

class VariconAddressField extends StatefulHookConsumerWidget {
  const VariconAddressField({
    super.key,
    required this.field,
    required this.labelText,
  });

  final TextInputField field;
  final String labelText;

  @override
  ConsumerState<VariconAddressField> createState() =>
      _VariconAddressFieldState();
}

class _VariconAddressFieldState extends ConsumerState<VariconAddressField> {
  late List<Placemark> address;
  bool isLoading = false;
  TextEditingController mapFieldController = TextEditingController();

  Position? currentlySelelectedPosition;

  @override
  void initState() {
    super.initState();
    mapFieldController.text = widget.field.answer ?? '';
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

    String addressText =
        '${address.first.subThoroughfare!.isEmpty ? '' : '${address.first.subThoroughfare}'} ${address.first.thoroughfare!.isEmpty ? '' : '${address.first.thoroughfare}, '}${address.first.locality} ${address.first.administrativeArea} ${address.first.postalCode} ${address.first.country}';

    //setting the address value to the map field controller
    mapFieldController.text = addressText;
    ref
        .read(currentStateNotifierProvider.notifier)
        .saveString(widget.field.id, addressText);
  }

  @override
  Widget build(BuildContext context) {
    Debouncer debouncer = Debouncer(milliseconds: 500);

    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style: Theme.of(context).textTheme.bodyLarge,
      controller: mapFieldController,
      keyboardType: (widget.field.name ?? '').toLowerCase().contains('long')
          ? TextInputType.multiline
          : TextInputType.text,
      textInputAction: (widget.field.name ?? '').toLowerCase().contains('long')
          ? TextInputAction.newline
          : TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.all(8.0),
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
              builder: (context) => CustomMapPicker(
                forMapField: true,
                postition: currentlySelelectedPosition,
              ),
            ).then((value) async {
              LatLng? latLng = value;
              if (value != null) {
                await userPositionSetUp(latLng!);
              }
            });
          },
        ),
      ),
      validator: (value) {
        return textValidator(
          value: value,
          inputType: "text",
          isRequired: widget.field.isRequired,
          requiredErrorText: widget.field.requiredErrorText,
        );
      },
      onChanged: (value) {
        debouncer.run(() {
          ref
              .read(currentStateNotifierProvider.notifier)
              .saveString(widget.field.id, value);
        });
      },
    );
  }
}
