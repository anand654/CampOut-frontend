import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

class CustomTextFieldSearch extends StatelessWidget {
  CustomTextFieldSearch({
    @required this.controller,
    @required this.prefixicon,
    @required this.fillColor,
    @required this.iconSize,
    @required this.hint,
    @required this.onchanged,
  });
  final TextEditingController controller;
  final IconData prefixicon;
  final Color fillColor;
  final double iconSize;
  final String hint;
  final Function(String) onchanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.headline3,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixicon,
            color: Theme.of(context).primaryColor,
            size: iconSize,
          ),
          filled: true,
          fillColor: fillColor,
          isDense: true,
          hintText: hint,
          hintStyle:
              Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
        onChanged: onchanged,
      ),
    );
  }
}
