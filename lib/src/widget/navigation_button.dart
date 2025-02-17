import 'package:flutter/material.dart';

///Form elevated button for submit, update and save only operations
class NavigationButton extends StatelessWidget {
  const NavigationButton(
      {super.key,
      required this.onComplete,
      required this.buttonText,
      this.isAutoSave = false});

  ///Function to be called on button press
  final VoidCallback onComplete;

  ///Value for button text
  final String buttonText;
  final bool isAutoSave;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: onComplete,
        style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(
                  color:
                      isAutoSave ? const Color(0xff233759) : Colors.transparent,
                ),
              ),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(
              isAutoSave ? Colors.white : Theme.of(context).primaryColor,
            )),
        child: Text(
          buttonText.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
    // return FilledButton(
    //   onPressed: onComplete,
    //   child: Text(
    //     buttonText.toUpperCase(),
    //     style: Theme.of(context)
    //         .textTheme
    //         .bodyMedium
    //         ?.copyWith(fontWeight: FontWeight.w600),
    //   ),
    // );
  }
}

///Form button to save response
///
///this button will ony save the form
class SaveOnlyButton extends StatelessWidget {
  const SaveOnlyButton({
    super.key,
    required this.onComplete,
    this.buttonText = 'Save Only',
  });

  ///Function to be called on button press
  final VoidCallback onComplete;

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onComplete,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            Colors.white,
          ),
          side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.orange),
          ),
        ),
        child: Text(
          buttonText.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
    // return FilledButton(
    //   onPressed: onComplete,
    //   child: Text(
    //     buttonText.toUpperCase(),
    //     style: Theme.of(context)
    //         .textTheme
    //         .bodyMedium
    //         ?.copyWith(fontWeight: FontWeight.w600),
    //   ),
    // );
  }
}
