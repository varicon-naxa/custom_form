import 'package:flutter/material.dart';

///Primary bottom sheet main template
///
///Accepts context, child, hasBack, closeText and hasSpace
scrollBottomSheet(BuildContext context,
    {required Widget child,
    bool hasBack = true,
    String closeText = 'Back',
    bool hasSpace = true}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    constraints: const BoxConstraints(
      maxWidth: double.infinity,
    ),
    builder: (context) => Container(
      color: Colors.white,
      width: double.infinity,
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