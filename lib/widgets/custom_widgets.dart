import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

BoxDecoration boxDecoration(double borderWidth, double borderRadius) {
  return BoxDecoration(
    color: white,
    border: Border.all(width: borderWidth),
    borderRadius: BorderRadius.circular(borderRadius),
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

goto(BuildContext context, Widget nextScreen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen));
}

goOff(BuildContext context, Widget nextScreen) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => nextScreen), (route) => false);
}

gotoc(BuildContext context, Widget nextScreen) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => nextScreen));
}

gotoWithoutBack(BuildContext context, Widget nextScreen) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => nextScreen));
}

goBack(BuildContext context) {
  Navigator.of(context).pop();
}

Widget normalText(String text, double size) {
  return Text(
    text,
    style: TextStyle(fontSize: size,color: black),
  );
}

Widget boldText(String text, double size) {
  return Text(
    text,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.bold,color: black),
  );
}

Widget veryBoldText(String text, double size) {
  return Text(
    text,
    style: TextStyle(fontSize: size, fontWeight: FontWeight.w900,color: black),
    textAlign: TextAlign.center,
  );
}

Widget nAppText(String text, double size, Color? color) {
  return Text(
    text,
    style: TextStyle(color: color, fontSize: size),
  );
}

Widget bAppText(String text, double size, Color? color) {
  return Text(
    text,
    style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold),
  );
}

showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor:grey2,
    margin: EdgeInsets.all(15),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    content: nAppText(content, 15, Colors.black),
  ));
}

Widget PrimaryMaterialButton(
    BuildContext context, Function fun, String buttonText) {
  return MaterialButton(
    minWidth: fullWidth(context),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    height: 45,
    color: green,
    onPressed: () {
      fun();
    },
    child: Text(
      buttonText,
      style: TextStyle(color: Colors.white, fontSize: 17),
    ),
  );
}

Widget SecondaryMaterialButton(Function fun, String buttonText,
    double width) {
  return MaterialButton(
    minWidth: width,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    height: 45,
    color: green,
    onPressed: () {
      fun();
    },
    child: Text(
      buttonText,
      style: TextStyle(color: white, fontSize: 18),
    ),
  );
}

Widget PrimaryOutlineButton(Function fun, String buttonText, double width) {
  return SizedBox(
    width: width,
    height: 30,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        fun();
      },
      child: nAppText(buttonText, 16, black),
    ),
  );
}

// showToast(String msg) {
//   Fluttertoast.showToast(msg: msg, backgroundColor: white, textColor: black);
// }

showWarningDialog(BuildContext context, String content) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  goBack(context);
                },
                child: Text("Ok"))
          ],
        );
      });
}
Widget BackButtonW(BuildContext context,IconData icon) {
  return IconButton(
      onPressed: () {
        goBack(context);
      },
      icon: Icon(
        icon,
        size: 18,
        color: black,
        
      ));
}
Widget DrawerItems(IconData icon, String title, Function fun) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: black,
                size: 25,
              ),
              HSpace(10),
              boldText(title, 17),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color:black,
          ),
        ],
      ),
    ),
  );
}

Widget VSpace(double h) {
  return SizedBox(
    height: h,
  );
}

Widget HSpace(double w) {
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
      boldText(title, 16),
      VSpace(5),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: normalText(content, 17),
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

Widget BestSellerItem(
    BuildContext context, String name, int price, Color color) {
  return InkWell(
    onTap: () {
      // goto(context, ProductDetailScreen2(name: name, price: price));
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 150,
              height: 170,
              color: white,
            ),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  // bottomLeft: Radius.circular(20),
                  // topRight: Radius.circular(10),
                ),
                color: color,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: nAppText("\$" + price.toString(), 14, white),
                ),
              ),
            )
          ],
        ),
        VSpace(10),
        normalText(name, 17)
      ],
    ),
  );
}

Widget AppName(double size, bool isDark) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        backgroundColor: mc,
        radius: size - 5,
        child: bAppText("E", size, white),
      ),
      bAppText("state", size, isDark ? white : black)
    ],
  );
}

void showSuccessAlertDialog(
    BuildContext context, String title, String btnText) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: mc,
                  radius: 40,
                  child: Icon(
                    Icons.done,
                    size: 50,
                    color: white,
                  ),
                ),
                VSpace(25),
                Text(
                  title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                VSpace(25),
                PrimaryMaterialButton(context, () {
                  goBack(context);
                }, btnText)
              ],
            ),
          ),
        );
      });
}
