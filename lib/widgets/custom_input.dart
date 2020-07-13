import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function validator;
  final TextInputType keyboardType;
  final bool enabled;
  final int maxLength;
  final bool obscureText;

  CustomInput(
      {@required this.controller,
      @required this.hintText,
      this.validator,
      this.keyboardType,
      this.enabled,
      this.maxLength,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 1,
                spreadRadius: 0,
                offset: Offset(0, 2))
          ]),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLength: maxLength,
          decoration: InputDecoration(
              hintText: hintText,
              counterText: "",
              border: UnderlineInputBorder(borderSide: BorderSide.none)),
          validator: validator,
        ),
      ),
    );
  }
}
