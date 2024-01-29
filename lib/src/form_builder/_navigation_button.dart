part of 'varicon_form_builder.dart';

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.onComplete,
    required this.buttonText,
  });

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
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).primaryColor,
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

class _SaveOnlyButton extends StatelessWidget {
  const _SaveOnlyButton({
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onComplete,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
          side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.orange),
          ),
        ),
        child: Text(
          'Save Only'.toUpperCase(),
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
