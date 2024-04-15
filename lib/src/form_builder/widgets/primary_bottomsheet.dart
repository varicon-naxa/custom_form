import 'package:flutter/material.dart';

///Primary bottom sheet main template
///
///Accepts context, child, hasBack, closeText and hasSpace
Future primaryCustomBottomSheet(BuildContext context,
    {required Widget child,
    bool hasBack = true,
    String closeText = 'Back',
    bool hasSpace = true}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Wrap(
        children: [
          hasSpace
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    right: 28,
                    left: 28,
                    bottom: 10,
                  ),
                  child: child)
              : child,
        ],
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
  );
}
