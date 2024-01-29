import 'package:flutter/material.dart';

///Primary bottom sheet main template
 primaryBottomSheet(BuildContext context,
    {required Widget child,
    bool hasBack = true,
    String closeText = 'Back',
    bool hasSpace = true}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height - 100,
      child: child,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
    ),
  );
}
