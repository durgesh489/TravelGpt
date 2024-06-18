import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'custom_widgets.dart';


Widget PrimaryMaterialButton(
    BuildContext context, String buttonText, Function fun) {
  return MaterialButton(
    minWidth: fullWidth(context),
    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    height: 45,
    color: mc,
    onPressed: () {
      fun();
    },
    child: Text(
      buttonText,
      style: TextStyle(fontSize: 16, color: white),
    ),
  );
}

Widget PrimaryMaterialButtonWithIcon(BuildContext context, Color? color,
    String buttonText, Color textColor, IconData icon, Function fun) {
  return MaterialButton(
    minWidth: fullWidth(context),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    height: 45,
    color: color,
    onPressed: () {
      fun();
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Icon(icon,color: textColor,),
        HGap(10),
        Text(
          buttonText,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ],
    ),
  );
}

Widget SecondaryButton(Function fun, String buttonText, Color? color,
    Color? textColor, double height, double width) {
  return MaterialButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    minWidth: width,
    height: height,
    color: color,
    onPressed: () {
      fun();
    },
    child: Text(
      buttonText,
      style: TextStyle(fontSize: 15, color: textColor),
    ),
  );
}

Widget kPrimaryOutlineButton(BuildContext context, String text, Function fun) {
  return SizedBox(
    width: fullWidth(context),
    height: 45,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: Colors.black),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: () {
        fun();
      },
      child: NAppText(text, 16, black),
    ),
  );
}
