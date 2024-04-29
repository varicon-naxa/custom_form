import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_location.dart';

class MapFieldWidget extends StatelessWidget {
  const MapFieldWidget({
    super.key,
    required this.forMapField,
    this.postition,
  });

  final bool forMapField;
  final Position? postition;

  @override
  Widget build(BuildContext context) {
    TextEditingController mapFieldController = TextEditingController();

    return TextFormField(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SizedBox(
            height: 500,
            width: 500,
            child: MapPicker(
              forMapField: true,
            ),
          ),
        ).then((value) {
          if (value != null) {
            mapFieldController.text =
                value.name + ', ' + value.country + ', ' + value.locality;
          }
        });
      },
      autocorrect: false,
      readOnly: true,
      controller: mapFieldController,
      decoration: InputDecoration(
        // enabled: false,
        contentPadding: const EdgeInsets.all(8),
        isDense: true,
        suffixIcon: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
            size: 24,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SizedBox(
                height: 500,
                width: 500,
                child: MapPicker(
                  forMapField: true,
                ),
              ),
            ).then((value) {
              if (value != null) {
                mapFieldController.text =
                    value.name + ', ' + value.country + ', ' + value.locality;
              }
            });
          },
        ),
      ),
      // controller: _controller1,
      maxLines: null,
    );
  }
}
