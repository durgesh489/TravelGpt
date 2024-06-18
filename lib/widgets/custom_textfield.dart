import 'package:flutter/material.dart';

import 'package:form_field_validator/form_field_validator.dart';

import '../constants/colors.dart';
import 'custom_widgets.dart';

class CustomTextField extends StatefulWidget {
  String title = "";
  String hintText = "";
  TextEditingController controller;
  List<FieldValidator> validators;
  bool isPassword = false;
  int maxLines;

  int maxLength = 1000;
  Color color;
  bool enabled = true;
  InputBorder inputBorder;

  TextInputType keyboardType;
  CustomTextField(
      {Key? key,
      this.title = "",
      required this.controller,
      required this.validators,
      this.hintText = "",
      this.isPassword = false,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text,
      this.maxLength = 1000,
      this.color = Colors.black,
      this.enabled = true,
      this.inputBorder = const UnderlineInputBorder()})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHide = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          style: TextStyle(color: widget.color),
          keyboardType: widget.keyboardType,
          validator: MultiValidator(widget.validators),
          controller: widget.controller,
          maxLines: widget.maxLines,
          obscureText: widget.isPassword
              ? isHide
                  ? true
                  : false
              : false,
          decoration: InputDecoration(
              label: Text(widget.title),
              // border: widget.inputBorder,
              enabled: widget.enabled,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: grey),
              errorStyle: TextStyle(color: widget.color),
              counterText: "",
              suffix: widget.isPassword
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          isHide = !isHide;
                        });
                      },
                      child: Icon(
                        isHide ? Icons.visibility_off : Icons.visibility,
                        color: grey,
                      ),
                    )
                  : null),
        ),
        VGap(15),
      ],
    );
  }
}
