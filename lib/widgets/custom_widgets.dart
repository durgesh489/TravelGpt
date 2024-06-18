import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

LinearGradient AppLinearGradient() {
  return LinearGradient(colors: [
    Color.fromARGB(255, 47, 139, 214),
    Color.fromARGB(255, 23, 107, 175),
    Color.fromARGB(255, 17, 71, 151)
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
}

BoxDecoration boxDecoration(Color color) {
  return BoxDecoration(
    color: color,
    border: Border.all(width: 1, color: grey),
    borderRadius: BorderRadius.circular(10),
  );
}

BoxDecoration boxDecoration1(Color? color, double radius) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
  );
}

BoxDecoration gboxDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
        colors: [Colors.grey, Colors.green],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter),
  );
}

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
      borderSide: BorderSide(width: 1.8, color: Colors.black),
      borderRadius: BorderRadius.circular(10));
}

TextStyle ntextStyle(double size, Color color) {
  return TextStyle(
    color: color,
    fontSize: size,
  );
}

TextStyle bTextStyle(double size, Color color) {
  return TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold);
}

goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen));
}

goOff(BuildContext context, Widget nextScreen) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => nextScreen), (route) => false);
}

gotoc(BuildContext context, Widget nextScreen) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => nextScreen));
}

goToWithoutBack(BuildContext context, Widget nextScreen) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => nextScreen));
}

goBack(BuildContext context) {
  Navigator.of(context).pop();
}

Widget BackButtonW(BuildContext context) {
  return InkWell(
    onTap: () {
      goBack(context);
    },
    child: Icon(
      Icons.arrow_back,
      size: 20,
      color: black,
    ),
  );
}

Widget NormalText(String text, double size) {
  return Text(
    text,
    style: TextStyle(
      fontSize: size,
    ),
  );
}

Widget BoldText(String text, double size) {
  return Text(
    text,
    style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget VeryBoldText(String text, double size) {
  return Text(
    text,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.w900),
    textAlign: TextAlign.center,
  );
}

Widget NAppText(String text, double size, Color? color) {
  return Text(
    text,
    style: TextStyle(color: color, fontSize: size),
    textAlign: TextAlign.center,
  );
}

Widget BAppText(String text, double size, Color? color) {
  return Text(
    text,
    style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w900),
  );
}

Widget PrimaryOutlineButton(
  Function fun,
  String buttonText,
) {
  return SizedBox(
    width: 130,
    height: 35,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: black),
      ),
      onPressed: () {
        fun();
      },
      child: NAppText(buttonText, 12, black),
    ),
  );
}

// showToast(String msg) {
//   Fluttertoast.showToast(msg: msg, backgroundColor: white, textColor: black);
// }

Widget DrawerItems(IconData icon, String title, Function fun) {
  return ListTile(
    onTap: () {
      fun();
    },
    leading: Icon(icon),
    title: Text(title,style: TextStyle(),textAlign: TextAlign.left,),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: 15,
      color: Colors.brown,
    ),
  );
}

Widget VGap(double h) {
  return SizedBox(
    height: h,
  );
}

Widget HGap(double w) {
  return SizedBox(
    width: w,
  );
}

double fullWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Widget VerticalListTile(String title, String content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      BoldText(title, 16),
      VGap(5),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: NormalText(content, 17),
        ),
      )
    ],
  );
}

Widget DefaultImage(double w, double h) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: grey3,
    ),
    width: w,
    height: h,
  );
}

Widget AppName(double size, bool isDark) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        backgroundColor: mc,
        radius: size - 5,
        child: NAppText("AI", size, white),
      ),
      NAppText("haram", size, isDark ? white : black)
    ],
  );
}



Widget ContainerWithBorder(String text, Color color) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: NAppText(text, 15, color),
    ),
  );
}
